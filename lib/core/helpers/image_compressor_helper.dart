import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

Future<File?> compressImage(XFile image) async {
  try {
    final tempDir = await getTemporaryDirectory();

    final targetPath =
        '${tempDir.path}/profile_${DateTime.now().millisecondsSinceEpoch}.jpg';

    final compressedImage = await FlutterImageCompress.compressAndGetFile(
      image.path,
      targetPath,
      quality: 75,
      minWidth: 800,
      minHeight: 800,
      format: CompressFormat.jpeg,
    );

    if (compressedImage == null) {
      return File(image.path);
    }

    final compressedFile = File(compressedImage.path);

    // Optional logging
    final originalSize = await File(image.path).length();
    final compressedSize = await compressedFile.length();

    print(
      'Profile image: '
      '${(originalSize / 1024).toStringAsFixed(1)} KB → '
      '${(compressedSize / 1024).toStringAsFixed(1)} KB',
    );

    return compressedFile;
  } catch (e) {
    print('Image compression failed: $e');

    // If compression fails, use original image
    return File(image.path);
  }
}
