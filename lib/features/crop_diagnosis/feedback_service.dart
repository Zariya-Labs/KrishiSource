import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FeedbackService {
  /// Logs an incorrect diagnosis to a local JSON file.
  static Future<void> logFeedback({
    required String imagePath,
    required String predictedDisease,
    required double confidence,
    required String userLabel,
  }) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/feedback_log.json');

      List<dynamic> logs = [];

      // Read existing logs if file exists
      if (await file.exists()) {
        final contents = await file.readAsString();
        if (contents.isNotEmpty) {
          logs = jsonDecode(contents);
        }
      }

      // Add the new entry
      final newEntry = {
        'timestamp': DateTime.now().toIso8601String(),
        'imagePath': imagePath,
        'predictedDisease': predictedDisease,
        'confidence': confidence,
        'userLabel': userLabel,
      };
      
      logs.add(newEntry);

      // Write back to the file
      await file.writeAsString(jsonEncode(logs));
      
      print('Feedback logged successfully: $newEntry');
    } catch (e) {
      print('Failed to log feedback: $e');
    }
  }
}
