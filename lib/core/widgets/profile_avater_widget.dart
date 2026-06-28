import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shadify/shadify.dart';

import '../themes/token.dart';

class ProfileAvatarWidget extends StatelessWidget {
  final String? imageUrl;
  final File? imageFile; // ✅ New optional file
  final double size;

  final bool hasBorder;
  final Color? borderColor;
  final double borderWidth;

  const ProfileAvatarWidget({
    super.key,
    this.imageUrl,
    this.imageFile,
    this.size = 48,
    this.hasBorder = false,
    this.borderColor,
    this.borderWidth = 2,
  });

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    if (imageFile != null) {
      // ✅ Show local file image
      imageWidget = Image.file(
        imageFile!,
        width: size,
        height: size,
        fit: BoxFit.cover,
      );
    } else if (imageUrl != null && imageUrl!.isNotEmpty) {
      // ✅ Show network image
      imageWidget = CachedNetworkImage(
        imageUrl: imageUrl!,
        width: size.w,
        height: size.w,
        fit: BoxFit.cover,
        placeholder: (context, url) =>
            Container(
              width: size.w,
              height: size.w,

              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade200,
              ),
            ).withShadifyLoading(
              loading: true,
              borderRadius: BorderRadius.circular(100.r),
            ),
        errorWidget: (context, url, error) => Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey.shade300,
          ),
          child: Icon(
            Icons.image_not_supported,
            color: Colors.grey,
            size: size.w,
          ),
        ),
      );
    } else {
      // ✅ Default placeholder if nothing provided
      imageWidget = Container(
        width: size.w,
        height: size.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey.shade300,
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Icon(Icons.person, size: size.w / 2, color: Colors.white),
        ),
      );
    }

    return Container(
      width: size.w,
      height: size.w,
      alignment: Alignment.center,
      padding: hasBorder ? EdgeInsets.all(borderWidth) : EdgeInsets.zero,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: hasBorder
            ? Border.all(
                color: borderColor ?? CustomColors.primary,
                width: borderWidth,
              )
            : null,
      ),
      child: ClipOval(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: imageWidget,
        ),
      ),
    );
  }
}
