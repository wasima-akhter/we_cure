//          IconButton(
//             onPressed: () {
//               ImagePickerBottomSheet.show(
//                 singleImageVariable: (image) {
//                   controller.singleImage.value = image;
//                   print('✅ Single: ${image?.path}');
//                   return image;
//                 },
//               );
//             },
//             icon: Icon(
//               CupertinoIcons.photo_camera,
//               size: Dimensions.iconSizeLarge,
//             ),
//           ),
//
//           Obx(
//             () => ProfileAvatarWidget(
//               imageFile: File(controller.singleImage.value?.path ?? ''),
//             ),
//           ),

import 'package:image_picker/image_picker.dart';

import '../../../core/utils/basic_import.dart';

class BottomImagePicker extends StatelessWidget {
  final XFile? Function(XFile?)? singleImageVariable;
  final List<XFile> Function(List<XFile>)? multipleImagesVariable;
  final bool multiple;
  final int maxImages;
  final String title;

  const BottomImagePicker({
    super.key,
    this.singleImageVariable,
    this.multipleImagesVariable,
    this.multiple = false,
    this.maxImages = 10,
    this.title = 'Select Image',
  });

  @override
  Widget build(BuildContext context) {
    final ImagePicker picker = ImagePicker();

    return Container(
      padding: EdgeInsets.all(Dimensions.paddingSize * 0.25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Dimensions.radius),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              margin: EdgeInsets.only(bottom: 20.h),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(Dimensions.radius),
              ),
            ),
            Space.height.v10,

            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Space.height.v10,

            ListTile(
              leading: Icon(Icons.camera_alt, color: CustomColors.secondary),
              title: Text('Camera'),
              onTap: () async {
                Get.back();
                try {
                  final XFile? image = await picker.pickImage(
                    source: ImageSource.camera,
                    imageQuality: 80,
                    maxWidth: 1920,
                    maxHeight: 1920,
                  );
                  if (multiple) {
                    if (image != null) multipleImagesVariable?.call([image]);
                  } else {
                    singleImageVariable?.call(image);
                  }
                } catch (e) {
                  Get.snackbar(
                    'Error',
                    'Failed to capture image',
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                }
              },
            ),

            ListTile(
              leading: Icon(Icons.photo_library, color: CustomColors.primary),
              title: Text(multiple ? 'Gallery' : 'Gallery'),
              subtitle: multiple
                  ? Text('Select Up to $maxImages images')
                  : null,
              onTap: () async {
                Get.back();
                try {
                  if (multiple) {
                    final List<XFile> images = await picker.pickMultiImage(
                      imageQuality: 80,
                      maxWidth: 1920,
                      maxHeight: 1920,
                    );
                    if (images.isNotEmpty) {
                      if (images.length > maxImages) {
                        Get.snackbar(
                          'Limit Exceeded',
                          'Maximum $maxImages images allowed',
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                        return;
                      }
                      multipleImagesVariable?.call(images);
                    }
                  } else {
                    final XFile? image = await picker.pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 80,
                      maxWidth: 1920,
                      maxHeight: 1920,
                    );
                    singleImageVariable?.call(image);
                  }
                } catch (e) {
                  Get.snackbar(
                    'Error',
                    'Failed to pick image',
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> show({
    XFile? Function(XFile?)? singleImageVariable,
    List<XFile> Function(List<XFile>)? multipleImagesVariable,
    bool multiple = false,
    int maxImages = 10,
    String title = 'Select Image',
  }) async {
    assert(
      multiple ? multipleImagesVariable != null : singleImageVariable != null,
      'You must provide ${multiple ? "multipleImagesVariable" : "singleImageVariable"} when multiple is $multiple',
    );

    await Get.bottomSheet(
      BottomImagePicker(
        singleImageVariable: singleImageVariable,
        multipleImagesVariable: multipleImagesVariable,
        multiple: multiple,
        maxImages: maxImages,
        title: title,
      ),
      isScrollControlled: true,
    );
  }
}
