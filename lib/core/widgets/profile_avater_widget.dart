import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shadify/shadify.dart';

import '../themes/token.dart';

class ProfileAvatarWidget extends StatelessWidget {
  final String? imageUrl;
  final File? imageFile;
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
    final imageSize = hasBorder ? size - (borderWidth * 2) : size;

    Widget image;

    if (imageFile != null) {
      image = Image.file(
        imageFile!,
        width: imageSize,
        height: imageSize,
        fit: BoxFit.cover,
      );
    } else if (imageUrl != null && imageUrl!.isNotEmpty) {
      image = CachedNetworkImage(
        imageUrl: imageUrl!,
        width: imageSize,
        height: imageSize,
        fit: BoxFit.cover,
        placeholder: (context, url) {
          return Container(
            width: imageSize,
            height: imageSize,
            color: Colors.grey.shade200,
          ).withShadifyLoading(
            loading: true,
            borderRadius: BorderRadius.circular(imageSize / 2),
          );
        },
        errorWidget: (context, url, error) {
          return Container(
            width: imageSize,
            height: imageSize,
            color: Colors.grey.shade300,
            alignment: Alignment.center,
            child: Icon(
              Icons.image_not_supported,
              color: Colors.grey,
              size: imageSize * 0.45,
            ),
          );
        },
      );
    } else {
      image = Container(
        width: imageSize,
        height: imageSize,
        color: Colors.grey.shade300,
        alignment: Alignment.center,
        child: Icon(Icons.person, size: imageSize * 0.5, color: Colors.white),
      );
    }

    return SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: hasBorder
              ? Border.all(
                  color: borderColor ?? CustomColors.primary,
                  width: borderWidth,
                )
              : null,
        ),
        child: Padding(
          padding: EdgeInsets.all(hasBorder ? borderWidth : 0),
          child: ClipOval(
            child: SizedBox(width: imageSize, height: imageSize, child: image),
          ),
        ),
      ),
    );
  }
}
