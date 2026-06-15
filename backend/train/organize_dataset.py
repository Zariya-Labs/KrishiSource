import os
import sys
import shutil
import zipfile
import logging
from pathlib import Path

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[logging.StreamHandler(sys.stdout)]
)
logger = logging.getLogger(__name__)

DEFAULT_DATASET_URL = "https://github.com/spMohanty/PlantVillage-Dataset/archive/refs/heads/master.zip"

def download_file(url, dest_path):
    try:
        import requests
    except ImportError:
        logger.error("The 'requests' library is required to download files. Please install it with: pip install requests")
        return False
        
    logger.info(f"Downloading dataset from: {url}")
    headers = {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3'
    }
    try:
        response = requests.get(url, headers=headers, stream=True, timeout=60)
        response.raise_for_status()
        total_size = int(response.headers.get('content-length', 0))
        block_size = 1024 * 1024
        downloaded = 0
        
        with open(dest_path, 'wb') as f:
            for chunk in response.iter_content(chunk_size=block_size):
                if chunk:
                    f.write(chunk)
                    downloaded += len(chunk)
                    if total_size > 0:
                        percent = (downloaded / total_size) * 100
                        sys.stdout.write(f"\rDownloading: {percent:.1f}% ({downloaded / (1024*1024):.1f} MB / {total_size / (1024*1024):.1f} MB)")
                    else:
                        sys.stdout.write(f"\rDownloading: {downloaded / (1024*1024):.1f} MB")
                    sys.stdout.flush()
        sys.stdout.write("\n")
        logger.info("Download completed.")
        return True
    except Exception as e:
        logger.error(f"Download failed: {e}")
        return False

def extract_zip(zip_path, extract_to):
    logger.info(f"Extracting zip {zip_path} to {extract_to}...")
    try:
        extract_to.mkdir(parents=True, exist_ok=True)
        with zipfile.ZipFile(zip_path, 'r') as zip_ref:
            zip_ref.extractall(extract_to)
        logger.info("Extraction completed.")
        return True
    except Exception as e:
        logger.error(f"Extraction failed: {e}")
        return False

def main():
    project_root = Path(__file__).resolve().parents[2]
    temp_dir = project_root / 'temp_raw_data'
    extracted_dir = temp_dir / 'extracted'
    raw_color_dir = extracted_dir / 'PlantVillage-Dataset-master' / 'raw' / 'color'
    output_dir = project_root / 'dataset_hierarchical'
    
    # 1. Locate raw color images
    if not raw_color_dir.exists():
        logger.info(f"Raw dataset folder {raw_color_dir} not found.")
        zip_path = temp_dir / 'raw_archive.zip'
        
        if not zip_path.exists():
            logger.info(f"Local archive {zip_path} not found. Proceeding to download...")
            temp_dir.mkdir(parents=True, exist_ok=True)
            success = download_file(DEFAULT_DATASET_URL, zip_path)
            if not success:
                logger.error("Failed to download dataset.")
                sys.exit(1)
        
        success = extract_zip(zip_path, extracted_dir)
        if not success or not raw_color_dir.exists():
            logger.error(f"Failed to find raw directory after extraction: {raw_color_dir}")
            sys.exit(1)
    
    logger.info(f"Found raw dataset directory: {raw_color_dir}")
    
    # 2. Reorganize into dataset_hierarchical/Plant/Disease
    logger.info(f"Organizing dataset into hierarchical structure at: {output_dir}")
    output_dir.mkdir(parents=True, exist_ok=True)
    
    stats = {}
    
    # Iterate through each folder in the raw color directory
    subdirs = sorted([d for d in raw_color_dir.iterdir() if d.is_dir()])
    
    for subdir in subdirs:
        folder_name = subdir.name
        if '___' not in folder_name:
            logger.warning(f"Skipping folder {folder_name} (does not contain '___')")
            continue
            
        parts = folder_name.split('___')
        plant = parts[0].strip()
        disease = parts[1].strip()
        
        target_dir = output_dir / plant / disease
        target_dir.mkdir(parents=True, exist_ok=True)
        
        # Get list of images in source folder
        images = [f for f in subdir.iterdir() if f.is_file() and f.suffix.lower() in ['.jpg', '.jpeg', '.png']]
        
        logger.info(f"Copying {len(images)} images for {plant} -> {disease}...")
        
        for img in images:
            shutil.copy(img, target_dir / img.name)
            
        if plant not in stats:
            stats[plant] = {}
        stats[plant][disease] = len(images)
        
    # 3. Print final report
    logger.info("\n" + "=" * 60)
    logger.info(f"{'Plant':<25} | {'Disease':<30} | {'Count':<6}")
    logger.info("-" * 60)
    total_images = 0
    for plant, diseases in sorted(stats.items()):
        for disease, count in sorted(diseases.items()):
            logger.info(f"{plant:<25} | {disease:<30} | {count:<6}")
            total_images += count
    logger.info("=" * 60)
    logger.info(f"Total organized images: {total_images}")
    logger.info("Dataset reorganization completed successfully.")

if __name__ == '__main__':
    main()
