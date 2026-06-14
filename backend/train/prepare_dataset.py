import os
import sys
import random
import logging
import argparse
import tarfile
import zipfile
import shutil
import time
from pathlib import Path
from PIL import Image, ImageDraw

# Try importing requests, print a helpful message if not installed
try:
    import requests
except ImportError:
    print("Error: The 'requests' library is required to run this script.")
    print("Please install it using: pip install requests")
    sys.exit(1)

# Configure logging to console
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - [%(filename)s:%(lineno)d] - %(message)s',
    handlers=[
        logging.StreamHandler(sys.stdout)
    ]
)
logger = logging.getLogger(__name__)

# Target classes essential to Nepali agriculture
# Patterns are used to identify directories in extracted datasets (like PlantVillage)
TARGET_CLASSES = {
    'tomato_healthy': {
        'patterns': ['Tomato___healthy', 'tomato_healthy'],
        'color': (34, 139, 34),  # Forest Green
        'description': 'Healthy tomato leaf (टमाटरको स्वस्थ पात)'
    },
    'tomato_late_blight': {
        'patterns': ['Tomato___Late_blight', 'tomato_late_blight'],
        'color': (105, 105, 105),  # Dark Gray/Brown spots
        'description': 'Tomato leaf with late blight (डढुवा लागेको टमाटरको पात)'
    },
    'potato_healthy': {
        'patterns': ['Potato___healthy', 'potato_healthy'],
        'color': (46, 139, 87),  # Sea Green
        'description': 'Healthy potato leaf (आलुको स्वस्थ पात)'
    },
    'potato_late_blight': {
        'patterns': ['Potato___Late_blight', 'potato_late_blight'],
        'color': (85, 107, 47),  # Olive Drab
        'description': 'Potato leaf with late blight (डढुवा लागेको आलुको पात)'
    },
    'maize_healthy': {
        'patterns': ['Corn_(maize)___healthy', 'maize_healthy'],
        'color': (50, 205, 50),  # Lime Green
        'description': 'Healthy maize leaf (मकैको स्वस्थ पात)'
    },
    'maize_leaf_blight_rust': {
        'patterns': ['Corn_(maize)___Common_rust_', 'Corn_(maize)___Northern_Leaf_Blight', 'maize_rust', 'maize_blight'],
        'color': (210, 105, 30),  # Chocolate/Orange rust spots
        'description': 'Maize leaf with rust or blight (पातमा लाग्ने डढुवा / खैरो थोप्ले रोग)'
    },
    'rice_healthy': {
        'patterns': ['Rice___healthy', 'rice_healthy'],
        'color': (60, 179, 113),  # Medium Sea Green
        'description': 'Healthy rice leaf (धानको स्वस्थ पात)'
    },
    'rice_bacterial_blight_blast': {
        'patterns': ['Rice___Bacterial_leaf_blight', 'Rice___Leaf_blast', 'rice_blast', 'rice_blight'],
        'color': (188, 143, 143),  # Rosy Brown streak lesions
        'description': 'Rice leaf with bacterial blight or blast (धानको मरुवा रोग / ब्याक्टेरियल डढुवा)'
    }
}

# Standard, public datasets URLs that can be used.
# spMohanty's PlantVillage-Dataset repository is the most common open-source distribution.
DEFAULT_DATASET_URL = "https://github.com/spMohanty/PlantVillage-Dataset/archive/refs/heads/master.zip"

def download_file_with_retry(url, dest_path, max_retries=3, backoff_factor=2):
    """
    Downloads a file from a URL using the requests library with robust retry logic,
    exponential backoff, and visual download progress.
    """
    headers = {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3'
    }
    
    logger.info(f"Initiating download from: {url}")
    
    for attempt in range(1, max_retries + 1):
        try:
            # Send stream request to handle large file sizes efficiently
            response = requests.get(url, headers=headers, stream=True, timeout=30)
            response.raise_for_status()
            
            total_size = int(response.headers.get('content-length', 0))
            block_size = 1024 * 1024  # 1 MB chunk size
            
            downloaded = 0
            
            with open(dest_path, 'wb') as f:
                for chunk in response.iter_content(chunk_size=block_size):
                    if chunk:
                        f.write(chunk)
                        downloaded += len(chunk)
                        if total_size > 0:
                            percent = (downloaded / total_size) * 100
                            # Simple clean progress line
                            sys.stdout.write(f"\rDownloading: {percent:.1f}% ({downloaded / (1024*1024):.1f} MB / {total_size / (1024*1024):.1f} MB)")
                            sys.stdout.flush()
                        else:
                            sys.stdout.write(f"\rDownloading: {downloaded / (1024*1024):.1f} MB")
                            sys.stdout.flush()
            
            sys.stdout.write("\n")
            logger.info(f"Download complete: {dest_path}")
            return True
            
        except (requests.exceptions.RequestException, IOError) as e:
            sys.stdout.write("\n")
            logger.warning(f"Download attempt {attempt} failed: {e}")
            
            if attempt == max_retries:
                logger.error("All download attempts failed due to network issues.")
                return False
                
            sleep_time = backoff_factor ** attempt
            logger.info(f"Retrying in {sleep_time} seconds...")
            time.sleep(sleep_time)
            
    return False

def extract_archive(archive_path, extract_to):
    """
    Extracts zip or tar/gz archive files to a destination directory.
    """
    logger.info(f"Extracting archive {archive_path} to {extract_to}...")
    try:
        archive_path = Path(archive_path)
        extract_to = Path(extract_to)
        extract_to.mkdir(parents=True, exist_ok=True)
        
        # Check archive extension type
        if archive_path.suffix == '.zip':
            with zipfile.ZipFile(archive_path, 'r') as zip_ref:
                zip_ref.extractall(extract_to)
            logger.info("Zip extraction complete.")
            return True
        elif archive_path.suffix in ['.tar', '.gz', '.tgz']:
            # Handle tar/tar.gz files
            mode = 'r:gz' if archive_path.suffix in ['.gz', '.tgz'] else 'r'
            with tarfile.open(archive_path, mode) as tar_ref:
                # Use filter parameter if available in newer Python versions for safety
                if hasattr(tarfile, 'data_filter'):
                    tar_ref.extractall(extract_to, filter='data')
                else:
                    tar_ref.extractall(extract_to)
            logger.info("Tar extraction complete.")
            return True
        else:
            logger.error(f"Unsupported archive format: {archive_path.suffix}")
            return False
    except Exception as e:
        logger.error(f"Failed to extract archive: {e}")
        return False

def generate_synthetic_leaf(class_name, target_size=(224, 224)):
    """
    Generates a synthetic leaf image representing a crop-disease class.
    Used for local quick-tests, testing pipeline components, or as fallback
    when specific real dataset segments (such as Rice) are not found in the source.
    """
    # Create background image with standard light soil/green color
    img = Image.new('RGB', target_size, color=(210, 225, 205))
    draw = ImageDraw.Draw(img)
    
    class_info = TARGET_CLASSES[class_name]
    base_color = class_info['color']
    
    # Draw leaf shape using a polygon
    # Coordinates define a typical leaf structure
    draw.polygon(
        [(112, 15), (195, 112), (112, 209), (29, 112)], 
        fill=base_color, 
        outline=(20, 80, 25)
    )
    
    # Use deterministic random seed based on class name for reproducible images
    random.seed(class_name)
    
    if 'late_blight' in class_name:
        # Dark rotting lesions / spots representing blight
        for _ in range(6):
            x = random.randint(60, 160)
            y = random.randint(60, 160)
            r = random.randint(12, 28)
            # Draw blight spot
            draw.ellipse([x - r, y - r, x + r, y + r], fill=(54, 43, 40))
    elif 'rust' in class_name or 'blight_rust' in class_name:
        # Small rust pustules (orange/brown dots)
        for _ in range(45):
            x = random.randint(70, 150)
            y = random.randint(55, 165)
            r = random.randint(2, 4)
            draw.ellipse([x - r, y - r, x + r, y + r], fill=(215, 95, 20))
    elif 'bacterial_blight_blast' in class_name:
        # Long necrotic streaks/lesions
        for _ in range(8):
            x1 = random.randint(75, 135)
            y1 = random.randint(45, 145)
            x2 = x1 + random.randint(8, 25)
            y2 = y1 + random.randint(25, 55)
            draw.line([x1, y1, x2, y2], fill=(130, 95, 80), width=random.randint(3, 6))
            
    return img

def prepare_data(output_dir, source_dir=None, split_ratio=(0.7, 0.15, 0.15), quick_test=False, num_images_per_class=100):
    """
    Processes, resizes, and organizes images into structured train, val, and test splits.
    """
    output_dir = Path(output_dir)
    splits = ['train', 'val', 'test']
    
    # 1. Setup clean directory structure
    for split in splits:
        for class_name in TARGET_CLASSES.keys():
            (output_dir / split / class_name).mkdir(parents=True, exist_ok=True)
            
    # Track dataset composition and numbers
    stats = {class_name: {'train': 0, 'val': 0, 'test': 0, 'total': 0} for class_name in TARGET_CLASSES.keys()}
    
    # 2. Iterate through each required crop disease class
    for class_name, info in TARGET_CLASSES.items():
        images = []
        
        # Check if generating mock/synthetic data is required or fallback is active
        if quick_test or not source_dir or not os.path.exists(source_dir):
            reason = "quick-test flag is active" if quick_test else "source directory does not exist"
            logger.info(f"Generating {num_images_per_class} synthetic images for {class_name} ({reason})...")
            for idx in range(num_images_per_class):
                img = generate_synthetic_leaf(class_name)
                images.append((img, f"synthetic_{class_name}_{idx}.jpg"))
        else:
            # Check source directory for directories matching pattern definitions
            matched_dirs = []
            source_path = Path(source_dir)
            
            for folder in source_path.rglob('*'):
                if folder.is_dir():
                    # Match directory names based on specified pattern lists
                    if any(pattern.lower() in folder.name.lower() for pattern in info['patterns']):
                        matched_dirs.append(folder)
            
            # Extract image file paths from matched directories
            if matched_dirs:
                logger.info(f"Found matched folders for class '{class_name}': {[d.name for d in matched_dirs]}")
                for d in matched_dirs:
                    for ext in ('*.jpg', '*.jpeg', '*.png', '*.JPG', '*.JPEG', '*.PNG'):
                        for file_path in d.glob(ext):
                            images.append((file_path, file_path.name))
            
            # Fallback to synthetic if no real images are found for this class
            if not images:
                logger.warning(f"No source folders or images matched patterns for class '{class_name}'. Generating synthetic dataset instead.")
                for idx in range(num_images_per_class):
                    img = generate_synthetic_leaf(class_name)
                    images.append((img, f"synthetic_{class_name}_{idx}.jpg"))
        
        # 3. Shuffle and perform split operations
        random.seed(42)  # Maintain consistent splits
        random.shuffle(images)
        
        total_images = len(images)
        train_end = int(split_ratio[0] * total_images)
        val_end = train_end + int(split_ratio[1] * total_images)
        
        splits_mapping = {
            'train': images[:train_end],
            'val': images[train_end:val_end],
            'test': images[val_end:]
        }
        
        # 4. Save processed and resized images
        for split, split_items in splits_mapping.items():
            for item, filename in split_items:
                dest_path = output_dir / split / class_name / filename
                
                try:
                    # Load image depending on whether it is pre-loaded PIL Image or path
                    if isinstance(item, Image.Image):
                        img = item
                    else:
                        img = Image.open(item)
                    
                    # Resize uniformly to 224x224 (best for MobileNetV2/V3 transfer learning)
                    img_resized = img.resize((224, 224), Image.Resampling.LANCZOS)
                    
                    # Convert to RGB mode (avoid JPEG save errors with RGBA/Greyscale)
                    if img_resized.mode != 'RGB':
                        img_resized = img_resized.convert('RGB')
                        
                    # Save image as JPEG
                    img_resized.save(dest_path, 'JPEG', quality=90)
                    stats[class_name][split] += 1
                    stats[class_name]['total'] += 1
                except Exception as e:
                    logger.error(f"Error processing image {filename}: {e}")
                    
    # 5. Display detailed logging of the final dataset distribution
    logger.info("\n" + "=" * 80)
    logger.info(f"{'Crop-Disease Class':<35} | {'Train':<8} | {'Val':<8} | {'Test':<8} | {'Total':<8}")
    logger.info("-" * 80)
    for class_name, split_counts in stats.items():
        logger.info(
            f"{class_name:<35} | "
            f"{split_counts['train']:<8} | "
            f"{split_counts['val']:<8} | "
            f"{split_counts['test']:<8} | "
            f"{split_counts['total']:<8}"
        )
    logger.info("=" * 80)
    logger.info(f"Dataset preparation successfully completed and organized in '{output_dir}'")

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="Download and organize agricultural crop disease datasets.")
    parser.add_argument('--output-dir', type=str, default='dataset', help='Destination folder for the prepared dataset.')
    parser.add_argument('--download-url', type=str, default=None, help='URL to download zip/tar file containing raw dataset.')
    parser.add_argument('--source-dir', type=str, default=None, help='Local folder path where raw images are already stored.')
    parser.add_argument('--split', type=str, default='0.7,0.15,0.15', help='Dataset train, validation, test ratio (comma separated).')
    parser.add_argument('--quick-test', action='store_true', help='Immediately generate synthetic leaf images (skips downloads).')
    parser.add_argument('--images-per-class', type=int, default=100, help='Number of synthetic images to generate per class.')
    parser.add_argument('--download-default', action='store_true', help='Download the default PlantVillage repository from GitHub.')
    
    args = parser.parse_args()
    
    # Parse dataset split ratios
    try:
        ratios = [float(r) for r in args.split.split(',')]
        if len(ratios) != 3 or abs(sum(ratios) - 1.0) > 0.01:
            raise ValueError()
    except Exception:
        logger.error("Split ratios must be 3 comma-separated floats summing to 1.0 (e.g. 0.7,0.15,0.15).")
        sys.exit(1)
        
    temp_download_dir = Path('temp_raw_data')
    source_path = args.source_dir
    
    # Determine if downloading is required
    download_url = None
    if args.download_default:
        download_url = DEFAULT_DATASET_URL
    elif args.download_url:
        download_url = args.download_url
        
    if download_url and not args.quick_test:
        temp_download_dir.mkdir(exist_ok=True)
        archive_name = 'raw_archive.zip' if '.zip' in download_url or not any(ext in download_url for ext in ['.tar', '.gz', '.tgz']) else 'raw_archive.tar.gz'
        archive_file = temp_download_dir / archive_name
        
        # Download with requests and retries
        download_success = download_file_with_retry(download_url, archive_file)
        
        if download_success:
            # Extract zip or tar
            extract_dir = temp_download_dir / 'extracted'
            extract_success = extract_archive(archive_file, extract_dir)
            if extract_success:
                source_path = extract_dir
            else:
                logger.warning("Extraction failed. Falling back to synthetic images.")
                args.quick_test = True
        else:
            logger.warning("Download failed. Falling back to synthetic images.")
            args.quick_test = True

    # Run dataset split, resize and organize workflow
    try:
        prepare_data(
            output_dir=args.output_dir,
            source_dir=source_path,
            split_ratio=ratios,
            quick_test=args.quick_test,
            num_images_per_class=args.images_per_class
        )
    finally:
        # Cleanup temporary files
        if temp_download_dir.exists():
            logger.info("Cleaning up temporary download folders...")
            shutil.rmtree(temp_download_dir)
