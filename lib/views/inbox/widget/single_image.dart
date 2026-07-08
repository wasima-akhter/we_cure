import 'dart:io';

import '../../../core/utils/basic_import.dart';

class SingleImageWidget {
  static Widget buildSingleImage(
    String imagePath,
    double width,
    bool isUploading,
    bool isMe, {
    double? height,
    bool isSingle = false,
  }) {
    // ✅ Local file নাকি network URL check
    final bool isLocalFile =
        !imagePath.startsWith('http') && File(imagePath).existsSync();

    final imageWidget = isLocalFile
        ? Image.file(
            File(imagePath),
            fit: BoxFit.contain,
            width: double.infinity,
            height: double.infinity,
          )
        : Image.network(
            imagePath,
            fit: BoxFit.contain,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[200],
                child: const Icon(Icons.broken_image),
              );
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;

              return const Center(child: CircularProgressIndicator());
            },
          );
    return Stack(
      children: [
        isSingle
            ? Container(
                width: width * 0.85,
                height: 300.h,
                constraints: BoxConstraints(
                  minWidth: 200.w,
                  minHeight: 150.h,
                  maxHeight: 400.h,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.radius),
                  child: imageWidget,
                ),
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(Dimensions.radius),
                child: imageWidget,
              ),

        if (isUploading)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(Dimensions.radius),
              ),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
          ),
      ],
    );
  }
}
