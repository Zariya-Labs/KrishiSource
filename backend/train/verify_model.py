import tensorflow as tf
from pathlib import Path
import numpy as np

def verify():
    model_path = Path('assets/model_multi.tflite')
    labels_path = Path('assets/labels.txt')
    
    print("--- Verification Report ---")
    print(f"Model path: {model_path} (exists: {model_path.exists()}, size: {model_path.stat().st_size if model_path.exists() else 0} bytes)")
    print(f"Labels path: {labels_path} (exists: {labels_path.exists()}, size: {labels_path.stat().st_size if labels_path.exists() else 0} bytes)")
    
    if not model_path.exists() or not labels_path.exists():
        print("Error: Model or Labels file missing.")
        return False
        
    try:
        # Load the TFLite model
        interpreter = tf.lite.Interpreter(model_path=str(model_path))
        interpreter.allocate_tensors()
        
        # Get input and output details
        input_details = interpreter.get_input_details()
        output_details = interpreter.get_output_details()
        
        print("\nInput Tensor Details:")
        for idx, detail in enumerate(input_details):
            print(f"  Input {idx}: Name={detail['name']}, Shape={detail['shape']}, Type={detail['dtype']}")
            
        print("\nOutput Tensor Details:")
        for idx, detail in enumerate(output_details):
            print(f"  Output {idx}: Name={detail['name']}, Shape={detail['shape']}, Type={detail['dtype']}")
            
        # Verify labels match output count
        with open(labels_path, 'r', encoding='utf-8') as f:
            labels = [line.strip() for line in f if line.strip()]
        
        output_shape = output_details[0]['shape']
        expected_classes = output_shape[-1]
        
        print(f"\nNumber of classes in labels.txt: {len(labels)}")
        print(f"Number of classes in TFLite output: {expected_classes}")
        
        if len(labels) == expected_classes:
            print("\nSuccess: Labels count matches model output classes!")
            return True
        else:
            print("\nError: Mismatch between labels count and model output classes.")
            return False
            
    except Exception as e:
        print(f"Error during verification: {e}")
        return False

if __name__ == '__main__':
    verify()
