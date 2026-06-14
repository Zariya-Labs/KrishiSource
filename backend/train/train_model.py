import os
import sys
import logging
import argparse
from pathlib import Path
import numpy as np

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - [%(filename)s:%(lineno)d] - %(message)s',
    handlers=[
        logging.StreamHandler(sys.stdout)
    ]
)
logger = logging.getLogger(__name__)

# Try importing TensorFlow
try:
    import tensorflow as tf
except ImportError:
    logger.error("TensorFlow is not installed in the current environment.")
    logger.error("Please run: pip install tensorflow")
    sys.exit(1)

# Import PIL for image checks
from PIL import Image

# Add current directory to path to import prepare_dataset if needed
sys.path.append(os.path.dirname(os.path.abspath(__file__)))
try:
    from prepare_dataset import prepare_data, TARGET_CLASSES
except ImportError:
    logger.warning("Could not import prepare_data from prepare_dataset.py. Automatic dataset setup will be disabled.")
    prepare_data = None
    TARGET_CLASSES = None

def load_datasets(dataset_path, image_size=(224, 224), batch_size=32):
    """
    Loads training and validation datasets from directories.
    Automatically generates a synthetic dataset if folders are missing.
    """
    dataset_path = Path(dataset_path)
    train_dir = dataset_path / 'train'
    val_dir = dataset_path / 'val'
    
    # Check if dataset directory exists and contains images
    dataset_exists = train_dir.exists() and val_dir.exists()
    if dataset_exists:
        # Check if directories actually contain classes
        train_classes = [d for d in train_dir.iterdir() if d.is_dir()]
        dataset_exists = len(train_classes) > 0
        
    if not dataset_exists:
        logger.warning(f"Dataset not found or empty at '{dataset_path}'.")
        if prepare_data is not None:
            logger.info("Automatically generating a quick synthetic dataset for training...")
            prepare_data(
                output_dir=dataset_path,
                quick_test=True,
                num_images_per_class=30  # Enough to train a few epochs for testing
            )
        else:
            logger.error("Dataset is missing and automatic generation is unavailable. Please run prepare_dataset.py first.")
            sys.exit(1)
            
    logger.info("Loading training dataset...")
    train_ds = tf.keras.utils.image_dataset_from_directory(
        train_dir,
        image_size=image_size,
        batch_size=batch_size,
        shuffle=True
    )
    
    logger.info("Loading validation dataset...")
    val_ds = tf.keras.utils.image_dataset_from_directory(
        val_dir,
        image_size=image_size,
        batch_size=batch_size,
        shuffle=False
    )
    
    return train_ds, val_ds

def build_model(num_classes, image_shape=(224, 224, 3)):
    """
    Constructs a transfer learning model using pre-trained MobileNetV3Small.
    """
    logger.info("Building MobileNetV3Small transfer learning model...")
    
    # Load the pre-trained MobileNetV3Small base model
    base_model = tf.keras.applications.MobileNetV3Small(
        input_shape=image_shape,
        include_top=False,
        weights='imagenet'
    )
    
    # Freeze the pre-trained base layers
    base_model.trainable = False
    
    # Construct the classification head
    inputs = tf.keras.Input(shape=image_shape)
    
    # Preprocess inputs - MobileNetV3 expects values in [-1, 1] or [0, 255] depending on config,
    # tf.keras.applications.mobilenet_v3.preprocess_input takes care of it correctly.
    x = tf.keras.applications.mobilenet_v3.preprocess_input(inputs)
    
    # Forward pass through frozen base model
    x = base_model(x, training=False)
    
    # Pool features
    x = tf.keras.layers.GlobalAveragePooling2D()(x)
    
    # Dropout to mitigate overfitting
    x = tf.keras.layers.Dropout(0.2)(x)
    
    # Dense classifier layer with softmax
    outputs = tf.keras.layers.Dense(num_classes, activation='softmax')(x)
    
    model = tf.keras.Model(inputs, outputs)
    return model

def train_and_quantize(dataset_dir, epochs=10, batch_size=32, output_tflite_path='crop_disease_model.tflite', output_labels_path='labels.txt'):
    """
    Loads data, trains the model, applies full integer post-training quantization,
    and writes outputs to assets/ml/ folder.
    """
    # 1. Load data
    train_ds, val_ds = load_datasets(dataset_dir, batch_size=batch_size)
    class_names = train_ds.class_names
    num_classes = len(class_names)
    
    logger.info(f"Detected {num_classes} classes: {class_names}")
    
    # 2. Build model
    model = build_model(num_classes=num_classes)
    model.summary(print_fn=logger.info)
    
    # 3. Compile
    model.compile(
        optimizer=tf.keras.optimizers.Adam(learning_rate=0.001),
        loss=tf.keras.losses.SparseCategoricalCrossentropy(from_logits=False),
        metrics=['accuracy']
    )
    
    # 4. Define training callbacks
    # Early stopping to prevent overfitting
    early_stopping = tf.keras.callbacks.EarlyStopping(
        monitor='val_loss',
        patience=3,
        restore_best_weights=True,
        verbose=1
    )
    
    # Best model checkpoint
    checkpoint_path = 'best_model.keras'
    checkpoint = tf.keras.callbacks.ModelCheckpoint(
        filepath=checkpoint_path,
        monitor='val_loss',
        save_best_only=True,
        verbose=1
    )
    
    # 5. Fit model
    logger.info(f"Starting training for {epochs} epochs...")
    history = model.fit(
        train_ds,
        validation_data=val_ds,
        epochs=epochs,
        callbacks=[early_stopping, checkpoint]
    )
    
    # Load best weights if checkpoint saved a model
    if os.path.exists(checkpoint_path):
        logger.info("Loading best model checkpoint for evaluation and TFLite conversion...")
        model = tf.keras.models.load_model(checkpoint_path)
        # Clean up temporary keras model file
        try:
            os.remove(checkpoint_path)
        except OSError:
            pass
            
    # 6. Evaluate on validation set
    val_loss, val_acc = model.evaluate(val_ds, verbose=0)
    logger.info(f"Final Validation Loss: {val_loss:.4f}")
    logger.info(f"Final Validation Accuracy: {val_acc:.4f}")
    
    # 7. Post-Training Full Integer Quantization
    logger.info("Converting model to TensorFlow Lite with full integer quantization...")
    
    converter = tf.lite.TFLiteConverter.from_keras_model(model)
    converter.optimizations = [tf.lite.Optimize.DEFAULT]
    
    # Representative dataset generator for calibration
    # Standard format yielding small samples from the train dataset
    def representative_dataset_gen():
        # Iterate over 10 batches of training data for calibration
        for images, _ in train_ds.take(10):
            for i in range(images.shape[0]):
                # Needs batch dimension of 1: (1, 224, 224, 3)
                input_tensor = images[i:i+1].numpy().astype(np.float32)
                yield [input_tensor]
                
    converter.representative_dataset = representative_dataset_gen
    
    # Enforce full integer quantization including inputs and outputs
    # This optimizes execution speed on mobile edge microcontrollers & NPUs
    converter.target_spec.supported_ops = [tf.lite.OpsSet.TFLITE_BUILTINS_INT8]
    converter.inference_input_type = tf.int8
    converter.inference_output_type = tf.int8
    
    try:
        tflite_quant_model = converter.convert()
        logger.info("TFLite quantization conversion successful.")
    except Exception as e:
        logger.warning(f"Full integer quantization conversion failed: {e}")
        logger.info("Retrying standard post-training float16/hybrid quantization fallback...")
        converter = tf.lite.TFLiteConverter.from_keras_model(model)
        converter.optimizations = [tf.lite.Optimize.DEFAULT]
        tflite_quant_model = converter.convert()
        logger.info("Standard TFLite quantization fallback successful.")
        
    # 8. Save output assets to Flutter pipeline
    output_tflite_path = Path(output_tflite_path)
    output_labels_path = Path(output_labels_path)
    
    output_tflite_path.parent.mkdir(parents=True, exist_ok=True)
    output_labels_path.parent.mkdir(parents=True, exist_ok=True)
    
    # Write optimized TFLite binary
    with open(output_tflite_path, 'wb') as f:
        f.write(tflite_quant_model)
    logger.info(f"Saved optimized TFLite model to: {output_tflite_path}")
    
    # Write labels in alphabetical order (matching index mapping)
    with open(output_labels_path, 'w', encoding='utf-8') as f:
        for class_name in class_names:
            f.write(f"{class_name}\n")
    logger.info(f"Saved label mapping file to: {output_labels_path}")
    logger.info("Model Training and Deployment Assets Generation Complete!")

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="Train crop disease classification model and quantize to TFLite.")
    parser.add_argument('--dataset-dir', type=str, default='dataset', help='Path to prepared dataset directory.')
    parser.add_argument('--epochs', type=int, default=10, help='Number of epochs to train.')
    parser.add_argument('--batch-size', type=int, default=32, help='Batch size for training.')
    
    # Root paths for Flutter asset pipeline
    project_root = Path(__file__).resolve().parents[2]
    default_tflite = project_root / 'assets' / 'ml' / 'crop_disease_model.tflite'
    default_labels = project_root / 'assets' / 'ml' / 'labels.txt'
    
    parser.add_argument('--tflite-path', type=str, default=str(default_tflite), help='Destination path for .tflite model file.')
    parser.add_argument('--labels-path', type=str, default=str(default_labels), help='Destination path for labels.txt file.')
    
    args = parser.parse_args()
    
    train_and_quantize(
        dataset_dir=args.dataset_dir,
        epochs=args.epochs,
        batch_size=args.batch_size,
        output_tflite_path=args.tflite_path,
        output_labels_path=args.labels_path
    )
