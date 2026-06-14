import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'crop_diagnosis_service.dart';

enum CropDiagnosisStatus { uninitialized, ready, processing, success, failure }

class CropDiagnosisState {
  final CropDiagnosisStatus status;
  final String? imagePath;
  final String? diseaseName;
  final double? confidence;
  final String? errorMessage;

  CropDiagnosisState({
    required this.status,
    this.imagePath,
    this.diseaseName,
    this.confidence,
    this.errorMessage,
  });

  CropDiagnosisState.initial() : this(status: CropDiagnosisStatus.uninitialized);

  CropDiagnosisState copyWith({
    CropDiagnosisStatus? status,
    String? imagePath,
    String? diseaseName,
    double? confidence,
    String? errorMessage,
  }) {
    return CropDiagnosisState(
      status: status ?? this.status,
      imagePath: imagePath ?? this.imagePath,
      diseaseName: diseaseName ?? this.diseaseName,
      confidence: confidence ?? this.confidence,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class CropDiagnosisController extends Notifier<CropDiagnosisState> {
  final CropDiagnosisService _service = CropDiagnosisService();
  final ImagePicker _picker = ImagePicker();

  @override
  CropDiagnosisState build() {
    // Safely dispose native model pointers when controller is removed
    ref.onDispose(() {
      _service.dispose();
    });
    _init();
    return CropDiagnosisState.initial();
  }

  Future<void> _init() async {
    try {
      await _service.initializeModel();
      state = CropDiagnosisState(status: CropDiagnosisStatus.ready);
    } catch (e) {
      state = CropDiagnosisState(
        status: CropDiagnosisStatus.failure,
        errorMessage: "Failed to initialize ML Model: $e",
      );
    }
  }

  /// Triggers image capture/selection and processes on-device model diagnosis.
  Future<void> pickAndDiagnose(ImageSource source) async {
    if (state.status == CropDiagnosisStatus.processing) return;

    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );

      if (pickedFile == null) {
        return; // User cancelled
      }

      state = state.copyWith(
        status: CropDiagnosisStatus.processing,
        imagePath: pickedFile.path,
        diseaseName: null,
        confidence: null,
        errorMessage: null,
      );

      // Perform inference using preprocessed inputs
      final result = await _service.diagnoseImage(pickedFile.path);

      state = state.copyWith(
        status: CropDiagnosisStatus.success,
        diseaseName: result.diseaseName,
        confidence: result.confidence,
      );
    } catch (e) {
      state = state.copyWith(
        status: CropDiagnosisStatus.failure,
        errorMessage: "Diagnosis failed: $e",
      );
    }
  }

  void reset() {
    state = CropDiagnosisState(status: CropDiagnosisStatus.ready);
  }
}

// Expose the controller state notifier provider
final cropDiagnosisProvider = NotifierProvider<CropDiagnosisController, CropDiagnosisState>(() {
  return CropDiagnosisController();
});
