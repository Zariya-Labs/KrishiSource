import os
import sys
import argparse
import logging
import random
from pathlib import Path
import numpy as np

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[logging.StreamHandler(sys.stdout)]
)
logger = logging.getLogger(__name__)

# Try importing TensorFlow
try:
    import tensorflow as tf
except ImportError:
    logger.error("TensorFlow is not installed in this environment. Please run: pip install tensorflow")
    sys.exit(1)

def find_images_and_labels(dataset_dir, max_images_per_class=None):
    """
    Traverses the hierarchical dataset directory and collects all image paths and labels.
    Expected folder structure: dataset_dir/Plant/Disease/*.jpg
    """
    dataset_path = Path(dataset_dir)
    if not dataset_path.exists():
        logger.error(f"Hierarchical dataset directory '{dataset_path}' does not exist.")
        sys.exit(1)
        
    image_paths = []
    labels = []
    
    # We walk the directories to find images
    # Supported image extensions
    valid_extensions = {'.jpg', '.jpeg', '.png'}
    
    for plant_dir in sorted([d for d in dataset_path.iterdir() if d.is_dir()]):
        plant_name = plant_dir.name
        for disease_dir in sorted([d for d in plant_dir.iterdir() if d.is_dir()]):
            disease_name = disease_dir.name
            
            # The label is the combination of Plant and Disease
            class_name = f"{plant_name}___{disease_name}"
            
            class_paths = []
            for file_path in disease_dir.glob('**/*'):
                if file_path.is_file() and file_path.suffix.lower() in valid_extensions:
                    class_paths.append(str(file_path.resolve()))
            
            # Sub-sample if max_images_per_class is set
            if max_images_per_class is not None and len(class_paths) > max_images_per_class:
                random.seed(42)
                class_paths = random.sample(class_paths, max_images_per_class)
                
            for path in class_paths:
                image_paths.append(path)
                labels.append(class_name)
                    
    return image_paths, labels

def create_tf_dataset(image_paths, labels, class_to_index, batch_size=32, is_training=True):
    """
    Creates a tf.data.Dataset from image paths and class label indices.
    """
    # Map label strings to indices
    label_indices = [class_to_index[lbl] for lbl in labels]
    
    # Must convert image_paths to list so TF treats it as a sequence of elements
    # rather than a tuple of component tensors (which triggers rank errors).
    path_ds = tf.data.Dataset.from_tensor_slices(list(image_paths))
    label_ds = tf.data.Dataset.from_tensor_slices(list(label_indices))
    
    def load_and_preprocess_image(path):
        img_raw = tf.io.read_file(path)
        img = tf.image.decode_jpeg(img_raw, channels=3)
        img = tf.image.resize(img, [224, 224])
        return img
        
    img_ds = path_ds.map(load_and_preprocess_image, num_parallel_calls=tf.data.AUTOTUNE)
    dataset = tf.data.Dataset.zip((img_ds, label_ds))
    
    if is_training:
        dataset = dataset.shuffle(buffer_size=min(len(image_paths), 10000), seed=42)
        
    dataset = dataset.batch(batch_size)
    dataset = dataset.prefetch(buffer_size=tf.data.AUTOTUNE)
    return dataset

def build_mobilenet_v3_model(num_classes, image_shape=(224, 224, 3)):
    """
    Constructs a transfer learning model using MobileNetV3Small or MobileNetV3Large.
    We use MobileNetV3Small for mobile edge deployment.
    """
    logger.info("Initializing MobileNetV3Small model base...")
    
    # Load pretrained MobileNetV3Small base
    base_model = tf.keras.applications.MobileNetV3Small(
        input_shape=image_shape,
        include_top=False,
        weights='imagenet'
    )
    
    # Freeze the base model layers
    base_model.trainable = False
    
    inputs = tf.keras.Input(shape=image_shape)
    
    # 1. Aggressive Data Augmentation
    data_augmentation = tf.keras.Sequential([
        tf.keras.layers.RandomRotation(factor=0.2),      # Random rotations up to 20% (72 degrees)
        tf.keras.layers.RandomFlip("horizontal"),        # Random horizontal flips
        tf.keras.layers.RandomBrightness(factor=0.2),    # Random brightness jitter
        tf.keras.layers.RandomContrast(factor=0.2),      # Random contrast jitter
    ], name="aggressive_augmentation")
    
    x = data_augmentation(inputs)
    
    # 2. Input normalization/preprocessing for MobileNetV3
    x = tf.keras.applications.mobilenet_v3.preprocess_input(x)
    
    # 3. Base model forward pass
    x = base_model(x, training=False)
    
    # 4. Dense Head
    x = tf.keras.layers.GlobalAveragePooling2D()(x)
    x = tf.keras.layers.Dropout(0.3)(x)                  # Moderate dropout to prevent overfitting
    outputs = tf.keras.layers.Dense(num_classes, activation='softmax')(x)
    
    model = tf.keras.Model(inputs, outputs)
    return model, base_model

def main():
    parser = argparse.ArgumentParser(description="Train MobileNetV3 for multi-plant crop disease classification.")
    parser.add_argument('--dataset-dir', type=str, default='dataset_hierarchical', help='Hierarchical dataset path.')
    parser.add_argument('--epochs', type=int, default=8, help='Number of initial epochs for transfer learning.')
    parser.add_argument('--fine-tune-epochs', type=int, default=4, help='Number of epochs for fine-tuning.')
    parser.add_argument('--batch-size', type=int, default=32, help='Batch size.')
    parser.add_argument('--lr', type=float, default=0.001, help='Learning rate for transfer learning.')
    parser.add_argument('--tflite-path', type=str, default='assets/model_multi.tflite', help='Output TFLite model path.')
    parser.add_argument('--labels-path', type=str, default='assets/labels.txt', help='Output labels file path.')
    parser.add_argument('--max-images-per-class', type=int, default=None, help='Maximum images to load per class (sub-sampling).')
    
    args = parser.parse_args()
    
    # 1. Collect images and labels
    logger.info("Scanning dataset and gathering class info...")
    image_paths, labels = find_images_and_labels(args.dataset_dir, max_images_per_class=args.max_images_per_class)
    
    if not image_paths:
        logger.error("No valid images found in the dataset folder.")
        sys.exit(1)
        
    unique_classes = sorted(list(set(labels)))
    num_classes = len(unique_classes)
    logger.info(f"Found {len(image_paths)} images across {num_classes} unique crop-disease classes.")
    
    # Establish class to index mapping
    class_to_index = {cls_name: idx for idx, cls_name in enumerate(unique_classes)}
    
    # 2. Train-Validation Split (80% train, 20% validation)
    random.seed(42)
    combined = list(zip(image_paths, labels))
    random.shuffle(combined)
    image_paths, labels = zip(*combined)
    
    split_idx = int(0.8 * len(image_paths))
    train_paths, train_labels = image_paths[:split_idx], labels[:split_idx]
    val_paths, val_labels = image_paths[split_idx:], labels[split_idx:]
    
    logger.info(f"Split: {len(train_paths)} training samples, {len(val_paths)} validation samples.")
    
    # Create TF datasets
    train_ds = create_tf_dataset(train_paths, train_labels, class_to_index, batch_size=args.batch_size, is_training=True)
    val_ds = create_tf_dataset(val_paths, val_labels, class_to_index, batch_size=args.batch_size, is_training=False)
    
    # 3. Build Model
    model, base_model = build_mobilenet_v3_model(num_classes)
    model.summary(print_fn=logger.info)
    
    # Compile model
    model.compile(
        optimizer=tf.keras.optimizers.Adam(learning_rate=args.lr),
        loss=tf.keras.losses.SparseCategoricalCrossentropy(from_logits=False),
        metrics=['accuracy']
    )
    
    # Callbacks
    checkpoint_path = 'temp_best_model.keras'
    callbacks = [
        tf.keras.callbacks.ModelCheckpoint(
            filepath=checkpoint_path,
            monitor='val_accuracy',
            save_best_only=True,
            mode='max',
            verbose=1
        ),
        tf.keras.callbacks.EarlyStopping(
            monitor='val_loss',
            patience=3,
            restore_best_weights=True,
            verbose=1
        )
    ]
    
    # 4. Train - Step 1: Feature Extraction
    logger.info("Training classifier head (feature extraction)...")
    history = model.fit(
        train_ds,
        validation_data=val_ds,
        epochs=args.epochs,
        callbacks=callbacks
    )
    
    # Check if we need fine-tuning to reach 90%+ top-1 accuracy
    val_acc = max(history.history['val_accuracy'])
    logger.info(f"Best validation accuracy during feature extraction: {val_acc * 100:.2f}%")
    
    if val_acc < 0.90:
        logger.info("Validation accuracy is below 90%. Unfreezing top layers of MobileNetV3 for fine-tuning...")
        # Unfreeze base model and make the top layers trainable
        base_model.trainable = True
        
        # We unfreeze only the last few blocks of the base model
        # MobileNetV3Small has about 12-15 layers/blocks. We'll fine-tune the entire base but with a very small learning rate,
        # which is extremely standard and stable.
        model.compile(
            optimizer=tf.keras.optimizers.Adam(learning_rate=args.lr * 0.1), # 10x smaller learning rate
            loss=tf.keras.losses.SparseCategoricalCrossentropy(from_logits=False),
            metrics=['accuracy']
        )
        
        # Fine-tune
        history_ft = model.fit(
            train_ds,
            validation_data=val_ds,
            epochs=args.fine_tune_epochs,
            callbacks=callbacks
        )
        val_acc = max(history_ft.history['val_accuracy'])
        logger.info(f"Best validation accuracy after fine-tuning: {val_acc * 100:.2f}%")
    else:
        logger.info("Validation accuracy exceeds 90%. Skipping fine-tuning to avoid overfitting.")
        
    # 5. Load best overall model checkpoint
    if os.path.exists(checkpoint_path):
        logger.info("Loading best model weights from checkpoint...")
        model = tf.keras.models.load_model(checkpoint_path)
        try:
            os.remove(checkpoint_path)
        except OSError:
            pass
            
    # Final validation evaluation
    final_loss, final_acc = model.evaluate(val_ds, verbose=0)
    logger.info(f"Final Model Validation Loss: {final_loss:.4f}")
    logger.info(f"Final Model Validation Accuracy: {final_acc * 100:.2f}%")
    
    # Check that accuracy meets user threshold
    if final_acc < 0.90:
        logger.warning(f"Final accuracy ({final_acc*100:.2f}%) did not reach the requested 90% threshold.")
        
    # 6. Convert model to TensorFlow Lite (Float32 input/output, Float16 weights)
    logger.info("Converting model to TensorFlow Lite format with Float16 weight quantization...")
    converter = tf.lite.TFLiteConverter.from_keras_model(model)
    converter.optimizations = [tf.lite.Optimize.DEFAULT]
    converter.target_spec.supported_types = [tf.float16]
    
    tflite_model = converter.convert()
    
    # Save .tflite model
    tflite_path = Path(args.tflite_path)
    tflite_path.parent.mkdir(parents=True, exist_ok=True)
    with open(tflite_path, 'wb') as f:
        f.write(tflite_model)
    logger.info(f"Saved optimized TFLite model to: {tflite_path}")
    
    # 7. Write labels file
    labels_path = Path(args.labels_path)
    labels_path.parent.mkdir(parents=True, exist_ok=True)
    with open(labels_path, 'w', encoding='utf-8') as f:
        for cls_name in unique_classes:
            f.write(f"{cls_name}\n")
    logger.info(f"Saved inference labels list to: {labels_path}")
    logger.info("Pipeline training run completed successfully.")

if __name__ == '__main__':
    main()
