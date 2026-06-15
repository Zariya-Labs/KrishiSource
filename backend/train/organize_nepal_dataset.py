import os
import sys
import shutil
import random
import logging
from pathlib import Path
from PIL import Image, ImageDraw

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[logging.StreamHandler(sys.stdout)]
)
logger = logging.getLogger(__name__)

def generate_synthetic_cardamom(class_name, dest_dir, count=150):
    dest_dir = Path(dest_dir)
    dest_dir.mkdir(parents=True, exist_ok=True)
    
    logger.info(f"Generating {count} synthetic cardamom images for '{class_name}'...")
    
    for idx in range(count):
        # Cardamom leaves are long, lanceolate, and dark green
        img = Image.new('RGB', (224, 224), color=(215, 225, 205)) # soil-like background
        draw = ImageDraw.Draw(img)
        
        # Color profile
        if class_name == 'healthy':
            base_color = (34, 110, 45) # rich cardamom green
        else: # blight
            base_color = (60, 95, 50) # dull green
            
        # Draw long lanceolate leaf
        # coordinates for long leaf
        draw.polygon(
            [(112, 10), (160, 112), (112, 214), (64, 112)], 
            fill=base_color, 
            outline=(20, 70, 30)
        )
        
        # Seed based on index for reproducible variations
        random.seed(idx)
        
        if class_name == 'Blight':
            # Add yellowing margins and necrotic brown patches
            # Draw necrotic streaks
            for _ in range(5):
                x1 = random.randint(80, 140)
                y1 = random.randint(30, 180)
                x2 = x1 + random.randint(-15, 15)
                y2 = y1 + random.randint(15, 35)
                draw.line([x1, y1, x2, y2], fill=(110, 70, 45), width=random.randint(3, 7)) # brown blight
                
            # Draw yellow halos around lesions
            for _ in range(3):
                x = random.randint(90, 130)
                y = random.randint(40, 160)
                r = random.randint(10, 20)
                draw.ellipse([x-r, y-r, x+r, y+r], outline=(200, 180, 50), width=2)
                
        # Save image
        img.save(dest_dir / f"cardamom_{class_name}_{idx}.jpg", "JPEG", quality=90)

def main():
    project_root = Path(__file__).resolve().parents[2]
    pv_color_dir = project_root / 'temp_raw_data' / 'extracted' / 'PlantVillage-Dataset-master' / 'raw' / 'color'
    local_data_dir = project_root / 'dataset'
    target_dir = project_root / 'dataset' / 'nepal_custom'
    
    # 1. Clean up old nepal_custom directory
    if target_dir.exists():
        logger.info(f"Removing existing nepal_custom folder: {target_dir}")
        shutil.rmtree(target_dir)
    target_dir.mkdir(parents=True, exist_ok=True)
    
    # 2. Ingest PlantVillage crops (max 150 images per class for balanced training)
    logger.info("Ingesting PlantVillage baseline classes...")
    if not pv_color_dir.exists():
        logger.error(f"PlantVillage color directory not found at: {pv_color_dir}")
        sys.exit(1)
        
    for p_dir in pv_color_dir.iterdir():
        if not p_dir.is_dir() or '___' not in p_dir.name:
            continue
            
        parts = p_dir.name.split('___')
        plant = parts[0].strip()
        disease = parts[1].strip()
        
        # Determine paths
        out_class_dir = target_dir / plant / disease
        out_class_dir.mkdir(parents=True, exist_ok=True)
        
        images = [img for img in p_dir.iterdir() if img.is_file() and img.suffix.lower() in ['.jpg', '.jpeg', '.png']]
        random.seed(42)
        if len(images) > 150:
            images = random.sample(images, 150)
            
        for img in images:
            shutil.copy(img, out_class_dir / img.name)
            
    # 3. Ingest local Rice datasets (merge train and val if present)
    logger.info("Ingesting local Rice datasets...")
    local_rice_mappings = {
        'rice_healthy': ('Rice', 'healthy'),
        'rice_bacterial_blight_blast': ('Rice', 'Bacterial_leaf_blight_blast')
    }
    
    for local_folder, (plant, disease) in local_rice_mappings.items():
        out_class_dir = target_dir / plant / disease
        out_class_dir.mkdir(parents=True, exist_ok=True)
        
        # Search in dataset/train and dataset/val
        images = []
        for split in ['train', 'val']:
            src_folder = local_data_dir / split / local_folder
            if src_folder.exists():
                images.extend([img for img in src_folder.iterdir() if img.is_file() and img.suffix.lower() in ['.jpg', '.jpeg', '.png']])
                
        logger.info(f"Found {len(images)} local images for {local_folder}")
        random.seed(42)
        if len(images) > 150:
            images = random.sample(images, 150)
            
        for img in images:
            shutil.copy(img, out_class_dir / img.name)
            
    # 4. Ingest local Maize datasets and merge with PlantVillage Corn_(maize)
    logger.info("Merging local Maize datasets with PlantVillage Corn...")
    local_maize_mappings = {
        'maize_healthy': ('Corn_(maize)', 'healthy'),
        'maize_leaf_blight_rust': ('Corn_(maize)', 'Northern_Leaf_Blight')
    }
    
    for local_folder, (plant, disease) in local_maize_mappings.items():
        out_class_dir = target_dir / plant / disease
        out_class_dir.mkdir(parents=True, exist_ok=True)
        
        # Search local files
        local_images = []
        for split in ['train', 'val']:
            src_folder = local_data_dir / split / local_folder
            if src_folder.exists():
                local_images.extend([img for img in src_folder.iterdir() if img.is_file() and img.suffix.lower() in ['.jpg', '.jpeg', '.png']])
                
        # Copy local images (up to 75 images, leaving 75 spots for PlantVillage corn)
        random.seed(42)
        if len(local_images) > 75:
            local_images = random.sample(local_images, 75)
            
        for img in local_images:
            shutil.copy(img, out_class_dir / f"local_{img.name}")
            
    # 5. Generate Cardamom datasets
    generate_synthetic_cardamom('healthy', target_dir / 'Cardamom' / 'healthy', count=150)
    generate_synthetic_cardamom('Blight', target_dir / 'Cardamom' / 'Blight', count=150)
    
    # Report stats
    logger.info("\n" + "=" * 60)
    logger.info(f"{'Plant':<25} | {'Disease':<30} | {'Count':<6}")
    logger.info("-" * 60)
    total_images = 0
    for plant_dir in sorted([d for d in target_dir.iterdir() if d.is_dir()]):
        for disease_dir in sorted([d for d in plant_dir.iterdir() if d.is_dir()]):
            cnt = len([f for f in disease_dir.iterdir() if f.is_file()])
            logger.info(f"{plant_dir.name:<25} | {disease_dir.name:<30} | {cnt:<6}")
            total_images += cnt
    logger.info("=" * 60)
    logger.info(f"Total organized images: {total_images}")
    logger.info("Nepali Custom Dataset initialized and organized successfully.")

if __name__ == '__main__':
    main()
