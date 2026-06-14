import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:krishisource/features/crop_diagnosis/crop_diagnosis_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late CropDiagnosisService service;
  late Directory tempDir;

  setUp(() async {
    service = CropDiagnosisService();
    tempDir = await Directory.systemTemp.createTemp('crop_diagnosis_test');
  });

  tearDown(() async {
    service.dispose();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('CropDiagnosisService Tests', () {
    test('Initialization works and handles dummy model gracefully', () async {
      // The assets are not loaded in pure unit tests unless using special mock channels,
      // so initializeModel() should catch the exception and fall back.
      await service.initializeModel();
      expect(service.isModelLoaded, isFalse);
    });

    test('diagnoseImage throws FileSystemException when file does not exist', () async {
      await service.initializeModel();
      
      const nonExistentPath = 'non_existent_image.jpg';
      expect(
        () => service.diagnoseImage(nonExistentPath),
        throwsA(isA<FileSystemException>()),
      );
    });

    test('diagnoseImage returns fallback prediction for valid file path when model is not loaded', () async {
      await service.initializeModel();
      
      // Create a dummy image file
      final dummyFile = File('${tempDir.path}/test_image.jpg');
      await dummyFile.writeAsBytes([0, 1, 2, 3]);

      final result = await service.diagnoseImage(dummyFile.path);

      expect(result, isNotNull);
      expect(result.diseaseName, isNotEmpty);
      expect(result.confidence, greaterThanOrEqualTo(0.75));
      expect(result.confidence, lessThanOrEqualTo(1.0));
      
      // The formatted label should not contain underscores/triple underscores
      expect(result.diseaseName.contains('___'), isFalse);
      expect(result.diseaseName.contains('_'), isFalse);
    });
  });
}
