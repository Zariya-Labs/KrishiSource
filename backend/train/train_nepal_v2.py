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

# Rich bilingual and scientific label metadata for all 42 classes
NEPALI_LABELS_METADATA = {
    'Apple___Apple_scab': 'Apple___Apple_scab (Malus domestica) - स्याउको दाद रोग (Apple Scab)',
    'Apple___Black_rot': 'Apple___Black_rot (Malus domestica) - स्याउको कालो सडन (Black Rot)',
    'Apple___Cedar_apple_rust': 'Apple___Cedar_apple_rust (Malus domestica) - स्याउको खैरो खिया (Cedar Apple Rust)',
    'Apple___healthy': 'Apple___healthy (Malus domestica) - स्याउको स्वस्थ पात (Healthy Apple)',
    'Blueberry___healthy': 'Blueberry___healthy (Vaccinium corymbosum) - निलबेरीको स्वस्थ पात (Healthy Blueberry)',
    'Cherry_(including_sour)___Powdery_mildew': 'Cherry_(including_sour)___Powdery_mildew (Prunus avium) - चेरीको सेतो धुलै रोग (Powdery Mildew)',
    'Cherry_(including_sour)___healthy': 'Cherry_(including_sour)___healthy (Prunus avium) - चेरीको स्वस्थ पात (Healthy Cherry)',
    'Corn_(maize)___Cercospora_leaf_spot Gray_leaf_spot': 'Corn_(maize)___Cercospora_leaf_spot Gray_leaf_spot (Zea mays) - मकैको खैरो थोप्ले रोग (Gray Leaf Spot)',
    'Corn_(maize)___Common_rust_': 'Corn_(maize)___Common_rust_ (Zea mays) - मकैको खिया रोग (Common Rust)',
    'Corn_(maize)___Northern_Leaf_Blight': 'Corn_(maize)___Northern_Leaf_Blight (Zea mays) - मकैको उत्तरी डढुवा (Northern Leaf Blight)',
    'Corn_(maize)___healthy': 'Corn_(maize)___healthy (Zea mays) - मकैको स्वस्थ पात (Healthy Maize)',
    'Grape___Black_rot': 'Grape___Black_rot (Vitis vinifera) - अंगूरको कालो सडन (Black Rot)',
    'Grape___Esca_(Black_Measles)': 'Grape___Esca_(Black_Measles) (Vitis vinifera) - अंगूरको एस्का रोग (Esca)',
    'Grape___Leaf_blight_(Isariopsis_Leaf_Spot)': 'Grape___Leaf_blight_(Isariopsis_Leaf_Spot) (Vitis vinifera) - अंगूरको पात डढुवा (Leaf Blight)',
    'Grape___healthy': 'Grape___healthy (Vitis vinifera) - अंगूरको स्वस्थ पात (Healthy Grape)',
    'Orange___Haunglongbing_(Citrus_greening)': 'Orange___Haunglongbing_(Citrus_greening) (Citrus sinensis) - सुन्तलाको पहेंलोपन रोग / सिट्रस ग्रिनिङ (HLB)',
    'Peach___Bacterial_spot': 'Peach___Bacterial_spot (Prunus persica) - आरुको ब्याक्टेरियल थोप्ले (Bacterial Spot)',
    'Peach___healthy': 'Peach___healthy (Prunus persica) - आरुको स्वस्थ पात (Healthy Peach)',
    'Pepper,_bell___Bacterial_spot': 'Pepper,_bell___Bacterial_spot (Capsicum annuum) - भेडे खुर्सानीको ब्याक्टेरियल थोप्ले रोग',
    'Pepper,_bell___healthy': 'Pepper,_bell___healthy (Capsicum annuum) - भेडे खुर्सानीको स्वस्थ पात (Healthy Pepper)',
    'Potato___Early_blight': 'Potato___Early_blight (Solanum tuberosum) - आलुको अगौटे डढुवा रोग (Early Blight)',
    'Potato___Late_blight': 'Potato___Late_blight (Solanum tuberosum) - आलुको पछौटे डढुवा रोग (Late Blight)',
    'Potato___healthy': 'Potato___healthy (Solanum tuberosum) - आलुको स्वस्थ पात (Healthy Potato)',
    'Raspberry___healthy': 'Raspberry___healthy (Rubus idaeus) - ऐंसेलुको स्वस्थ पात (Healthy Raspberry)',
    'Soybean___healthy': 'Soybean___healthy (Glycine max) - भटमासको स्वस्थ पात (Healthy Soybean)',
    'Squash___Powdery_mildew': 'Squash___Powdery_mildew (Cucurbita pepo) - फर्सीको सेतो धुलै रोग (Powdery Mildew)',
    'Strawberry___Leaf_scorch': 'Strawberry___Leaf_scorch (Fragaria ananassa) - भुइँ ऐंसेलुको पात डढ्ने रोग (Leaf Scorch)',
    'Strawberry___healthy': 'Strawberry___healthy (Fragaria ananassa) - भुइँ ऐंसेलुको स्वस्थ पात (Healthy Strawberry)',
    'Tomato___Bacterial_spot': 'Tomato___Bacterial_spot (Solanum lycopersicum) - टमाटरको ब्याक्टेरियल थोप्ले (Bacterial Spot)',
    'Tomato___Early_blight': 'Tomato___Early_blight (Solanum lycopersicum) - टमाटरको अगौटे डढुवा (Early Blight)',
    'Tomato___Late_blight': 'Tomato___Late_blight (Solanum lycopersicum) - टमाटरको पछौटे डढुवा (Late Blight)',
    'Tomato___Leaf_Mold': 'Tomato___Leaf_Mold (Solanum lycopersicum) - टमाटरको पातको ढुसी रोग (Leaf Mold)',
    'Tomato___Septoria_leaf_spot': 'Tomato___Septoria_leaf_spot (Solanum lycopersicum) - टमाटरको सेप्टोरिया पात थोप्ले रोग',
    'Tomato___Spider_mites Two-spotted_spider_mite': 'Tomato___Spider_mites Two-spotted_spider_mite (Solanum lycopersicum) - टमाटरको माकुरो सुलसुले',
    'Tomato___Target_Spot': 'Tomato___Target_Spot (Solanum lycopersicum) - टमाटरको लक्षित थोप्ले रोग (Target Spot)',
    'Tomato___Tomato_Yellow_Leaf_Curl_Virus': 'Tomato___Tomato_Yellow_Leaf_Curl_Virus (Solanum lycopersicum) - टमाटरको पहेंलो पात खुम्चिने भाइरस',
    'Tomato___Tomato_mosaic_virus': 'Tomato___Tomato_mosaic_virus (Solanum lycopersicum) - टमाटरको मोजाइक भाइरस (Mosaic Virus)',
    'Tomato___healthy': 'Tomato___healthy (Solanum lycopersicum) - टमाटरको स्वस्थ पात (Healthy Tomato)',
    'Rice___healthy': 'Rice___healthy (Oryza sativa) - धानको स्वस्थ पात (Healthy Rice)',
    'Rice___Bacterial_leaf_blight_blast': 'Rice___Bacterial_leaf_blight_blast (Oryza sativa) - धानको ब्याक्टेरियल डढुवा / मरुवा रोग (Blight/Blast)',
    'Cardamom___healthy': 'Cardamom___healthy (Amomum subulatum) - अलैंचीको स्वस्थ पात (Healthy Cardamom)',
    'Cardamom___Blight': 'Cardamom___Blight (Amomum subulatum) - अलैंचीको डढुवा रोग (Cardamom Blight)',
}

def find_images_and_labels(dataset_dir):
    dataset_path = Path(dataset_dir)
    if not dataset_path.exists():
        logger.error(f"Hierarchical dataset directory '{dataset_path}' does not exist.")
        sys.exit(1)
        
    image_paths = []
    labels = []
    valid_extensions = {'.jpg', '.jpeg', '.png'}
    
    for plant_dir in sorted([d for d in dataset_path.iterdir() if d.is_dir()]):
        plant_name = plant_dir.name
        for disease_dir in sorted([d for d in plant_dir.iterdir() if d.is_dir()]):
            disease_name = disease_dir.name
            
            # The label is the combination of Plant and Disease
            class_name = f"{plant_name}___{disease_name}"
            
            for file_path in disease_dir.glob('**/*'):
                if file_path.is_file() and file_path.suffix.lower() in valid_extensions:
                    image_paths.append(str(file_path.resolve()))
                    labels.append(class_name)
                    
    return image_paths, labels

def create_tf_dataset(image_paths, labels, class_to_index, batch_size=32, is_training=True):
    label_indices = [class_to_index[lbl] for lbl in labels]
    
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
    logger.info("Initializing MobileNetV3Small model base...")
    base_model = tf.keras.applications.MobileNetV3Small(
        input_shape=image_shape,
        include_top=False,
        weights='imagenet'
    )
    base_model.trainable = False
    
    inputs = tf.keras.Input(shape=image_shape)
    
    # Preprocessing and Aggressive Augmentation: resize to 224, rot up to 30 deg, flip, brightness, contrast
    data_augmentation = tf.keras.Sequential([
        tf.keras.layers.RandomRotation(factor=30.0 / 360.0), # up to 30 deg rotation
        tf.keras.layers.RandomFlip("horizontal"),            # horizontal flip
        tf.keras.layers.RandomBrightness(factor=0.25),       # color jitter brightness
        tf.keras.layers.RandomContrast(factor=0.25),         # color jitter contrast
    ], name="nepal_augmentation")
    
    x = data_augmentation(inputs)
    x = tf.keras.applications.mobilenet_v3.preprocess_input(x)
    x = base_model(x, training=False)
    x = tf.keras.layers.GlobalAveragePooling2D()(x)
    x = tf.keras.layers.Dropout(0.3)(x)
    outputs = tf.keras.layers.Dense(num_classes, activation='softmax')(x)
    
    model = tf.keras.Model(inputs, outputs)
    return model, base_model

def calculate_class_weights(labels, class_to_index, num_classes):
    logger.info("Calculating class weights to balance global vs local crops...")
    class_counts = {idx: 0 for idx in range(num_classes)}
    for lbl in labels:
        idx = class_to_index[lbl]
        class_counts[idx] += 1
        
    total_samples = len(labels)
    class_weights = {}
    for idx, count in class_counts.items():
        if count > 0:
            class_weights[idx] = total_samples / (num_classes * count)
        else:
            class_weights[idx] = 1.0
            
    return class_weights

def main():
    parser = argparse.ArgumentParser(description="Train MobileNetV3 model for Nepali agricultural multi-crop disease classification.")
    parser.add_argument('--dataset-dir', type=str, default='dataset/nepal_custom', help='Nepali Custom dataset path.')
    parser.add_argument('--epochs', type=int, default=10, help='Number of epochs for training.')
    parser.add_argument('--batch-size', type=int, default=32, help='Batch size.')
    parser.add_argument('--lr', type=float, default=0.001, help='Learning rate.')
    parser.add_argument('--tflite-path', type=str, default='assets/model_nepal_v2.tflite', help='Output TFLite model path.')
    parser.add_argument('--labels-path', type=str, default='assets/labels.txt', help='Output labels path.')
    
    args = parser.parse_args()
    
    # 1. Collect images and labels
    logger.info("Scanning Nepali Custom dataset...")
    image_paths, labels = find_images_and_labels(args.dataset_dir)
    
    if not image_paths:
        logger.error("No valid images found in the dataset folder.")
        sys.exit(1)
        
    unique_classes = sorted(list(set(labels)))
    num_classes = len(unique_classes)
    logger.info(f"Found {len(image_paths)} images across {num_classes} classes.")
    
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
    
    # Create TF datasets
    train_ds = create_tf_dataset(train_paths, train_labels, class_to_index, batch_size=args.batch_size, is_training=True)
    val_ds = create_tf_dataset(val_paths, val_labels, class_to_index, batch_size=args.batch_size, is_training=False)
    
    # Compute class weights
    class_weights = calculate_class_weights(train_labels, class_to_index, num_classes)
    
    # 3. Build Model
    model, base_model = build_mobilenet_v3_model(num_classes)
    model.compile(
        optimizer=tf.keras.optimizers.Adam(learning_rate=args.lr),
        loss=tf.keras.losses.SparseCategoricalCrossentropy(from_logits=False),
        metrics=['accuracy']
    )
    
    # Callbacks
    checkpoint_path = 'temp_best_nepal_model.keras'
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
    
    # 4. Train with Class Weights
    logger.info("Starting model training pipeline with class-weight balancing...")
    history = model.fit(
        train_ds,
        validation_data=val_ds,
        epochs=args.epochs,
        class_weight=class_weights,
        callbacks=callbacks
    )
    
    # 5. Load Best weights
    if os.path.exists(checkpoint_path):
        logger.info("Loading best model weights from checkpoint...")
        model = tf.keras.models.load_model(checkpoint_path)
        try:
            os.remove(checkpoint_path)
        except OSError:
            pass
            
    # Final evaluation
    final_loss, final_acc = model.evaluate(val_ds, verbose=0)
    logger.info(f"Final Model Validation Loss: {final_loss:.4f}")
    logger.info(f"Final Model Validation Accuracy: {final_acc * 100:.2f}%")
    
    if final_acc < 0.90:
        logger.warning("Accuracy did not meet the 90%+ requirement. Unfreezing top blocks for 3 epochs of fine-tuning...")
        base_model.trainable = True
        model.compile(
            optimizer=tf.keras.optimizers.Adam(learning_rate=args.lr * 0.1),
            loss=tf.keras.losses.SparseCategoricalCrossentropy(from_logits=False),
            metrics=['accuracy']
        )
        
        history_ft = model.fit(
            train_ds,
            validation_data=val_ds,
            epochs=3,
            class_weight=class_weights,
            callbacks=callbacks
        )
        
        if os.path.exists(checkpoint_path):
            model = tf.keras.models.load_model(checkpoint_path)
            try:
                os.remove(checkpoint_path)
            except OSError:
                pass
        final_loss, final_acc = model.evaluate(val_ds, verbose=0)
        logger.info(f"Final Model Validation Accuracy after fine-tuning: {final_acc * 100:.2f}%")
        
    # 6. Convert model to TensorFlow Lite (Float32 inputs/outputs, Float16 weights)
    logger.info("Converting model to TensorFlow Lite format (model_nepal_v2.tflite)...")
    converter = tf.lite.TFLiteConverter.from_keras_model(model)
    converter.optimizations = [tf.lite.Optimize.DEFAULT]
    converter.target_spec.supported_types = [tf.float16]
    
    tflite_model = converter.convert()
    
    tflite_path = Path(args.tflite_path)
    tflite_path.parent.mkdir(parents=True, exist_ok=True)
    with open(tflite_path, 'wb') as f:
        f.write(tflite_model)
    logger.info(f"Saved optimized TFLite model to: {tflite_path}")
    
    # 7. Write rich bilingual labels
    labels_path = Path(args.labels_path)
    labels_path.parent.mkdir(parents=True, exist_ok=True)
    with open(labels_path, 'w', encoding='utf-8') as f:
        for cls_name in unique_classes:
            rich_label = NEPALI_LABELS_METADATA.get(cls_name, f"{cls_name} - Unknown Crop - अज्ञात बाली")
            f.write(f"{rich_label}\n")
            
    logger.info(f"Saved inference labels list to: {labels_path}")
    logger.info("Pipeline training completed successfully.")

if __name__ == '__main__':
    main()
