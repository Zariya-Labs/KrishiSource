import os
import random
import logging
import argparse
import urllib.request
import zipfile
import shutil
from PIL import Image, ImageDraw

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.StreamHandler()
    ]
)
logger = logging.getLogger(__name__)

# Target classes essential to Nepali agriculture
TARGET_CLASSES = {
    'tomato_healthy': {
        'patterns': ['Tomato___healthy', 'tomato_healthy'],
        'color': (34, 139, 34), # Forest Green
        'description': 'Healthy green tomato leaf'
    },
    'tomato_late_blight': {
        'patterns': ['Tomato___Late_blight', 'tomato_late_blight'],
        'color': (105, 105, 105), # Dark Gray/Brown spots
        'description': 'Tomato leaf with dark late blight lesions'
    },
    'potato_healthy': {
        'patterns': ['Potato___healthy', 'potato_healthy'],
        'color': (46, 139, 87), # Sea Green
        'description': 'Healthy potato leaf'
    },
    'potato_late_blight': {
        'patterns': ['Potato___Late_blight', 'potato_late_blight'],
        'color': (85, 107, 47), # Olive Drab (decaying)
        'description': 'Potato leaf with late blight patches'
    },
    'maize_healthy': {
        'patterns': ['Corn_(maize)___healthy', 'maize_healthy'],
        'color': (50, 205, 50), # Lime Green
        'description': 'Healthy corn/maize leaf'
    },
    'maize_leaf_blight_rust': {
        'patterns': ['Corn_(maize)___Common_rust_', 'Corn_(maize)___Northern_Leaf_Blight', 'maize_rust'],
        'color': (210, 105, 30), # Chocolate/Orange rust spots
        'description': 'Corn leaf with rust or blight pustules'
    },
    'rice_healthy': {
        'patterns': ['Rice___healthy', 'rice_healthy'],
        'color': (60, 179, 113), # Medium Sea Green
        'description': 'Healthy slender rice leaf'
    },
    'rice_bacterial_blight_blast': {
        'patterns': ['Rice___Bacterial_leaf_blight', 'Rice___Leaf_blast', 'rice_blast'],
        'color': (188, 143, 143), # Rosy Brown streak lesions
        'description': 'Rice leaf with brown blast or bacterial blight streaks'
    }
}

def generate_synthetic_leaf(class_name, target_size=(224, 224)):
    """
    Generates a synthetic leaf image representing the crop-disease class.
    Used for local quick-tests, fallback, or to represent classes (like Rice) 
    that might be missing from standard archives.
    """
    # Create base image
    img = Image.new('RGB', target_size, color=(200, 230, 201)) # Light green ground/background
    draw = ImageDraw.Draw(img)
    
    class_info = TARGET_CLASSES[class_name]
    base_color = class_info['color']
    
    # Draw leaf shape outline
    draw.polygon(
        [(112, 10), (190, 112), (112, 214), (34, 112)], 
        fill=base_color, 
        outline=(27, 94, 32)
    )
    
    # Add disease spots or patterns depending on the class
    random.seed(class_name) # Ensure reproducible patterns per class
    
    if 'late_blight' in class_name:
        # Dark brown/black rotting patches
        for _ in range(5):
            x = random.randint(60, 160)
            y = random.randint(60, 160)
            r = random.randint(15, 30)
            draw.ellipse([x-r, y-r, x+r, y+r], fill=(62, 39, 35)) # Brown/black decay
    elif 'rust' in class_name:
        # Many small orange-brown spots
        for _ in range(40):
            x = random.randint(70, 150)
            y = random.randint(50, 170)
            r = random.randint(2, 5)
            draw.ellipse([x-r, y-r, x+r, y+r], fill=(230, 81, 0)) # Rust orange
    elif 'blight_blast' in class_name:
        # Slender brown streaks
        for _ in range(8):
            x1 = random.randint(70, 140)
            y1 = random.randint(40, 150)
            x2 = x1 + random.randint(5, 20)
            y2 = y1 + random.randint(20, 50)
            draw.line([x1, y1, x2, y2], fill=(141, 110, 99), width=random.randint(3, 7)) # Streak lesions
            
    return img

def download_and_extract_dataset(url, dest_dir):
    """
    Downloads and extracts a zipped/tarred dataset archive from a public URL.
    """
    os.makedirs(dest_dir, exist_ok=True)
    zip_path = os.path.join(dest_dir, "dataset.zip")
    
    logger.info(f"Downloading dataset from {url}...")
    try:
        urllib.request.urlretrieve(url, zip_path)
        logger.info("Download completed. Extracting files...")
        
        with zipfile.ZipFile(zip_path, 'r') as zip_ref:
            zip_ref.extractall(dest_dir)
            
        logger.info("Extraction complete.")
        os.remove(zip_path) # Clean up zip file
        return True
    except Exception as e:
        logger.error(f"Failed to download/extract dataset: {e}")
        return False

def prepare_data(output_dir, source_dir=None, split_ratio=(0.7, 0.15, 0.15), quick_test=False, num_images_per_class=100):
    """
    Splits, resizes, and organizes images into train/val/test directories.
    """
    # 1. Initialize directory structures
    splits = ['train', 'val', 'test']
    for split in splits:
        for class_name in TARGET_CLASSES.keys():
            os.makedirs(os.path.join(output_dir, split, class_name), exist_ok=True)
            
    # Track statistics
    stats = {class_name: {'train': 0, 'val': 0, 'test': 0} for class_name in TARGET_CLASSES.keys()}
    
    # 2. Process classes
    for class_name, info in TARGET_CLASSES.items():
        images = []
        
        # If quick_test or no source directory is provided, generate synthetic images
        if quick_test or not source_dir or not os.path.exists(source_dir):
            logger.info(f"Generating {num_images_per_class} synthetic images for class: {class_name}")
            for idx in range(num_images_per_class):
                img = generate_synthetic_leaf(class_name)
                images.append((img, f"synth_{idx}.jpg"))
        else:
            # Look for matching directories in the extracted source path
            matched_dirs = []
            for root, dirs, _ in os.walk(source_dir):
                for d in dirs:
                    if any(pattern in d for pattern in info['patterns']):
                        matched_dirs.append(os.path.join(root, d))
            
            # Read real images
            if matched_dirs:
                logger.info(f"Found matched directories for {class_name}: {matched_dirs}")
                for m_dir in matched_dirs:
                    for filename in os.listdir(m_dir):
                        if filename.lower().endswith(('.jpg', '.jpeg', '.png')):
                            file_path = os.path.join(m_dir, filename)
                            images.append((file_path, filename))
            else:
                logger.warning(f"No source directories matched for {class_name}. Falling back to synthetic images.")
                for idx in range(num_images_per_class):
                    img = generate_synthetic_leaf(class_name)
                    images.append((img, f"synth_{idx}.jpg"))
                    
        # 3. Shuffle and split dataset
        random.shuffle(images)
        total_imgs = len(images)
        
        train_end = int(split_ratio[0] * total_imgs)
        val_end = train_end + int(split_ratio[1] * total_imgs)
        
        splits_map = {
            'train': images[:train_end],
            'val': images[train_end:val_end],
            'test': images[val_end:]
        }
        
        # 4. Save and resize
        for split, split_images in splits_map.items():
            for item, filename in split_images:
                dest_path = os.path.join(output_dir, split, class_name, filename)
                
                try:
                    # Open image
                    if isinstance(item, Image.Image):
                        img = item
                    else:
                        img = Image.open(item)
                        
                    # Resize to MobileNet standard size (224x224)
                    img_resized = img.resize((224, 224), Image.Resampling.LANCZOS)
                    
                    # Convert to RGB if saved as JPEG
                    if img_resized.mode != 'RGB':
                        img_resized = img_resized.convert('RGB')
                        
                    # Save
                    img_resized.save(dest_path, 'JPEG', quality=90)
                    stats[class_name][split] += 1
                except Exception as e:
                    logger.debug(f"Failed to process image {filename}: {e}")
                    
    # 5. Log statistics summary
    logger.info("=" * 60)
    logger.info(f"{'Class Name':<30} | {'Train':<7} | {'Val':<7} | {'Test':<7} | {'Total':<7}")
    logger.info("-" * 60)
    for class_name, splits_counts in stats.items():
        tr = splits_counts['train']
        va = splits_counts['val']
        te = splits_counts['test']
        tot = tr + va + te
        logger.info(f"{class_name:<30} | {tr:<7} | {va:<7} | {te:<7} | {tot:<7}")
    logger.info("=" * 60)
    
    logger.info(f"Dataset preparation successfully completed at {output_dir}!")

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="Download and prepare crop disease classification dataset.")
    parser.add_argument('--output-dir', type=str, default='dataset', help='Destination folder for the dataset.')
    parser.add_argument('--download-url', type=str, default=None, help='URL to download a zip file containing raw images.')
    parser.add_argument('--source-dir', type=str, default=None, help='Directory where raw images are stored (if already downloaded).')
    parser.add_argument('--split', type=str, default='0.7,0.15,0.15', help='Train, validation, test ratio (comma separated).')
    parser.add_argument('--quick-test', action='store_true', help='Generate synthetic leaf dataset for quick execution.')
    parser.add_argument('--images-per-class', type=int, default=100, help='Number of synthetic images to generate per class.')
    
    args = parser.parse_args()
    
    # Parse splits
    try:
        ratios = [float(r) for r in args.split.split(',')]
        if len(ratios) != 3 or abs(sum(ratios) - 1.0) > 0.01:
            raise ValueError()
    except Exception:
        logger.error("Invalid split ratios. Must be three floats summing to 1.0, e.g., 0.7,0.15,0.15")
        exit(1)
        
    temp_source = args.source_dir
    
    # Download if URL is specified
    if args.download_url:
        temp_source = 'temp_downloaded_raw'
        success = download_and_extract_dataset(args.download_url, temp_source)
        if not success:
            logger.warning("Falling back to synthetic data due to download failure.")
            args.quick_test = True
            
    # Run dataset creation
    prepare_data(
        output_dir=args.output_dir,
        source_dir=temp_source,
        split_ratio=ratios,
        quick_test=args.quick_test,
        num_images_per_class=args.images_per_class
    )
    
    # Cleanup temporary download folder if created
    if args.download_url and os.path.exists(temp_source):
        shutil.rmtree(temp_source)
