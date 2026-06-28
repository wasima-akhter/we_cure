import 'package:glady/views/inbox/widget/single_image.dart';

import '../../../core/utils/basic_import.dart';

class ImageViewGridWidget {
  static Widget imageViewGrid({
    required List images,
    required double width,
    required bool isUploading,
    required bool isMe,
  }) {
    final imageCount = images.length;
    final maxWidth = width * 0.7;

    if (imageCount == 1) {
      return SingleImageWidget.buildSingleImage(
        images[0],
        maxWidth,
        isUploading,
        isMe,
        isSingle: true,
      );
    } else if (imageCount == 2) {
      return SizedBox(
        width: maxWidth,
        child: Row(
          children: [
            Expanded(
              child: SingleImageWidget.buildSingleImage(
                images[0],
                maxWidth / 2,
                isUploading,
                isMe,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: SingleImageWidget.buildSingleImage(
                images[1],
                maxWidth / 2,
                isUploading,
                isMe,
              ),
            ),
          ],
        ),
      );
    } else if (imageCount == 3) {
      return SizedBox(
        width: maxWidth,
        child: Column(
          spacing: 1,
          children: [
            SingleImageWidget.buildSingleImage(
              images[0],
              maxWidth,
              isUploading,
              isMe,
              height: 200.h,
            ),
            SizedBox(width: 3.w),
            Row(
              children: [
                Expanded(
                  child: SingleImageWidget.buildSingleImage(
                    images[1],
                    maxWidth / 2,
                    isUploading,
                    isMe,
                    height: 120.h,
                  ),
                ),
                SizedBox(width: 3.w),

                Expanded(
                  child: SingleImageWidget.buildSingleImage(
                    images[2],
                    maxWidth / 2,
                    isUploading,
                    isMe,
                    height: 120.h,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else if (imageCount == 4) {
      return SizedBox(
        width: maxWidth,
        child: Column(
          spacing: 1,
          children: [
            Row(
              children: [
                Expanded(
                  child: SingleImageWidget.buildSingleImage(
                    images[0],
                    maxWidth / 2,
                    isUploading,
                    isMe,
                    height: 140.h,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: SingleImageWidget.buildSingleImage(
                    images[1],
                    maxWidth / 2,
                    isUploading,
                    isMe,
                    height: 140.h,
                  ),
                ),
              ],
            ),
            SizedBox(width: 3.w),
            Row(
              children: [
                Expanded(
                  child: SingleImageWidget.buildSingleImage(
                    images[2],
                    maxWidth / 2,
                    isUploading,
                    isMe,
                    height: 140.h,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: SingleImageWidget.buildSingleImage(
                    images[3],
                    maxWidth / 2,
                    isUploading,
                    isMe,
                    height: 140.h,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return SizedBox(
        width: maxWidth,
        child: Column(
          spacing: 1,
          children: [
            Row(
              children: [
                Expanded(
                  child: SingleImageWidget.buildSingleImage(
                    images[0],
                    maxWidth / 2,
                    isUploading,
                    isMe,
                    height: 140.h,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: SingleImageWidget.buildSingleImage(
                    images[1],
                    maxWidth / 2,
                    isUploading,
                    isMe,
                    height: 140.h,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 3),
            Row(
              children: [
                Expanded(
                  child: SingleImageWidget.buildSingleImage(
                    images[2],
                    maxWidth / 2,
                    isUploading,
                    isMe,
                    height: 140.h,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Stack(
                    children: [
                      SingleImageWidget.buildSingleImage(
                        images[3],
                        maxWidth / 2,
                        isUploading,
                        isMe,
                        height: 140.h,
                      ),
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.65),
                            borderRadius: BorderRadius.circular(
                              Dimensions.radius,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '+${imageCount - 4}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28.sp,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }
}
