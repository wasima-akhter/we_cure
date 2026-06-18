import '../../../core/utils/basic_import.dart';
import '../../../core/widgets/bottom_image_picker.dart';
import '../controller/inbox_controller.dart';

class TypeSectionWidget extends GetView<InboxController> {
  const TypeSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
      decoration: BoxDecoration(color: Colors.white),
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: TextField(
                controller: controller.textController,
                maxLines: null,
                minLines: 1,
                cursorColor: CustomColors.primary,
                textInputAction: TextInputAction.newline,
                style: TextStyle(fontSize: 15.sp),
                decoration: InputDecoration(
                  hintText: "Type a message...",
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  isDense: true,
                  filled: true,
                  fillColor: Colors.grey[100],

                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 10.h,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Dimensions.radius * 2),
                    borderSide: BorderSide(
                      color: CustomColors.grayShade.withOpacity(0.25),
                      width: 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Dimensions.radius * 2),
                    borderSide: BorderSide(
                      color: CustomColors.grayShade.withOpacity(0.25),
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Dimensions.radius * 2),
                    borderSide: BorderSide(
                      color: CustomColors.grayShade.withOpacity(0.25),
                      width: 1.2,
                    ),
                  ),

                  suffixIcon: GestureDetector(
                    onTap: () {
                      BottomImagePicker.show(
                        maxImages: 12,
                        multiple: true,
                        multipleImagesVariable: (images) {
                          controller.multipleImages.value = images;
                          return images;
                        },
                      );
                    },
                    child: Icon(
                      Icons.add_circle_outline,
                      size: Dimensions.iconSizeLarge,
                      color: CustomColors.grayShade,
                    ),
                  ),
                ),
              ),
            ),

            Space.width.v10,
            GestureDetector(
              onTap: controller.sendMessage,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: CustomColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.send, color: Colors.white, size: 20.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
