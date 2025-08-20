// local_file_service.dart

import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class LocalFileService {
  /// Firma logosunu uygulama içi belge klasörüne kaydeder.
  /// Dönüş değeri: kaydedilen dosyanın tam yolu
  Future<String> saveFirmaLogo(File file, String firmaId) async {
    final appDir = await getApplicationDocumentsDirectory();
    final logosDir = Directory('${appDir.path}/firma_logos');

    if (!await logosDir.exists()) {
      await logosDir.create(recursive: true);
    }

    final filename = '$firmaId${extension(file.path)}';
    final savedFile = await file.copy('${logosDir.path}/$filename');

    return savedFile.path;
  }

  /// Kayıtlı bir logoyu getirir.
  File? getFirmaLogo(String? path) {
    if (path == null) return null;
    final file = File(path);
    return file.existsSync() ? file : null;
  }
}
