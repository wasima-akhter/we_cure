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
            fit: isSingle ? BoxFit.contain : BoxFit.cover,
            width: isSingle ? null : double.infinity,
            height: isSingle ? null : (height ?? 180.h),
          )
        : Image.network(
            imagePath,
            fit: isSingle ? BoxFit.contain : BoxFit.cover,
            width: isSingle ? null : double.infinity,
            height: isSingle ? null : (height ?? 180.h),
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: isSingle ? null : double.infinity,
                height: isSingle ? 200.h : (height ?? 180.h),
                constraints: isSingle
                    ? BoxConstraints(
                        maxWidth: width * 0.85,
                        minWidth: 200.w,
                        minHeight: 150.h,
                      )
                    : null,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(Dimensions.radius),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.broken_image_outlined,
                      size: 40.sp,
                      color: Colors.grey[400],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Failed to load',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              );
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                width: isSingle ? null : double.infinity,
                height: isSingle ? 200.h : (height ?? 180.h),
                constraints: isSingle
                    ? BoxConstraints(
                        maxWidth: width * 0.85,
                        minWidth: 200.w,
                        minHeight: 150.h,
                      )
                    : null,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(Dimensions.radius),
                ),
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2.w,
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                ),
              );
            },
          );

    return Stack(
      children: [
        isSingle
            ? ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: width * 0.85,
                  maxHeight: 400.h,
                  minWidth: 200.w,
                  minHeight: 150.h,
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

        // ✅ Upload overlay
        if (isUploading)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(Dimensions.radius),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 32.w,
                      height: 32.h,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3.w,
                      ),
                    ),
                    Space.height.v10,
                    Text(
                      "Uploading...",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
