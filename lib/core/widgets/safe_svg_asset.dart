import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SafeSvgWidget extends StatelessWidget {
  final String? assetPath;
  final double? width;
  final double? height;
  final Color? color;
  final BoxFit fit;
  final Widget? fallback;
  final bool showSkeleton;

  const SafeSvgWidget({
    super.key,
    required this.assetPath,
    this.width,
    this.height,
    this.color,
    this.fit = BoxFit.contain,
    this.fallback,
    this.showSkeleton = false,
  });

  bool get _hasAsset => assetPath != null && assetPath!.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    // Loading state
    if (showSkeleton) {
      return _SkeletonBox(width: width, height: height);
    }

    // Empty path fallback
    if (!_hasAsset) {
      return fallback ?? _defaultFallback();
    }

    return SvgPicture.asset(
      assetPath!,
      width: width,
      height: height,
      fit: fit,
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
      placeholderBuilder: (_) => _SkeletonBox(width: width, height: height),
      errorBuilder: (context, error, stackTrace) {
        return fallback ?? _defaultFallback();
      },
    );
  }

  Widget _defaultFallback() {
    return SizedBox(
      width: width,
      height: height,
      child: Icon(
        Icons.image_not_supported_outlined,
        size: width ?? 24,
        color: Colors.grey,
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  final double? width;
  final double? height;

  const _SkeletonBox({this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}
