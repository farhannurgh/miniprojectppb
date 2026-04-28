import 'dart:io';

import 'package:path_provider/path_provider.dart';

class StorageService {
  StorageService._();

  static Future<String> saveReportImage({
    required String userId,
    required String sourceImagePath,
  }) async {
    final Directory appDir = await getApplicationDocumentsDirectory();
    final Directory reportDir = Directory('${appDir.path}/reports');

    if (!await reportDir.exists()) {
      await reportDir.create(recursive: true);
    }

    final String fileName =
        'report_${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final String savedPath = '${reportDir.path}/$fileName';

    final File sourceFile = File(sourceImagePath);
    final File savedFile = await sourceFile.copy(savedPath);
    return savedFile.path;
  }
}
