import '../core/utils/basic_import.dart';

class DoctorDetailsCard extends StatelessWidget {
  const DoctorDetailsCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.specialty,
    required this.clinicName,
    required this.rating,
    required this.yearsOfExperience,
    this.startingPrice,
    this.onTap,
    this.isPriceShow,
    this.borderHide,
  });

  final String imageUrl;
  final String name;
  final String specialty;
  final String clinicName;
  final double rating;
  final bool? isPriceShow;
  final bool? borderHide;
  final int yearsOfExperience;
  final double? startingPrice;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsetsGeometry.symmetric(
          horizontal: Dimensions.defaultHorizontalSize * 0.8,
          vertical: Dimensions.verticalSize * 0.4,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radius),
          border: borderHide == true
              ? null
              : Border.all(color: CustomColors.grayShade.withOpacity(0.15)),
        ),
        child: Row(
          crossAxisAlignment: crossStart,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(Dimensions.radius * 1.2),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                height: 100.h,
                width: 100.w,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => Icon(
                  Icons.image_not_supported,
                  color: Colors.grey.shade400,
                  size: Dimensions.iconSizeLarge * 2,
                ),
              ),
            ),
            Space.width.v10,
            Expanded(
              child: Column(
                crossAxisAlignment: crossStart,
                mainAxisSize: mainMin,
                children: [
                  Row(
                    mainAxisAlignment: mainSpaceBet,
                    crossAxisAlignment: crossStart,
                    children: [
                      Expanded(
                        child: TextWidget(
                          name.capitalizeSafe,
                          fontWeight: FontWeight.w600,
                          maxLines: 1,
                          textOverflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Space.width.add(8.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.widthSize * 0.8, // ~8
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: CustomColors.grayShade.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(
                            Dimensions.radius * 0.6,
                          ),
                        ),
                        child: TextWidget(
                          '$yearsOfExperience Years',
                          fontSize: Dimensions.bodySmall,
                          fontWeight: FontWeight.w600,
                          color: CustomColors.primary,
                        ),
                      ),
                    ],
                  ),

                  TextWidget(
                    specialty.capitalizeSafe,
                    fontSize: Dimensions.bodyMedium,
                    fontWeight: FontWeight.w400,
                    color: CustomColors.blackColor.withOpacity(0.7),
                    maxLines: 1,
                    textOverflow: TextOverflow.ellipsis,
                  ),

                  TextWidget(
                    clinicName.capitalizeSafe,
                    fontSize: Dimensions.bodyMedium,
                    fontWeight: FontWeight.w400,
                    color: CustomColors.blackColor.withOpacity(0.7),
                    maxLines: 1,
                    textOverflow: TextOverflow.ellipsis,
                  ),

                  Row(
                    mainAxisAlignment: mainSpaceBet,
                    children: [
                      Row(
                        children: [
                          ...List.generate(
                            5,
                            (i) => Icon(
                              i < rating.floor()
                                  ? Icons.star
                                  : (i < rating && rating % 1 >= 0.5)
                                  ? Icons.star_half
                                  : Icons.star_border,
                              color: Color(0xffF29500),
                              size: Dimensions.iconSizeDefault * 1.125,
                            ),
                          ),
                          Space.width.add(4.w),
                          TextWidget(
                            rating.toStringAsFixed(1),
                            fontSize: Dimensions.bodyMedium,
                            fontWeight: FontWeight.w600,
                            color: CustomColors.primary,
                          ),
                        ],
                      ),

                      if (isPriceShow == false)
                        Column(
                          crossAxisAlignment: crossEnd,
                          mainAxisSize: mainMin,
                          children: [
                            TextWidget(
                              'Starting at',
                              fontSize: Dimensions.labelSmall,
                              fontWeight: FontWeight.w400,
                            ),
                            TextWidget(
                              '₦${startingPrice ?? startingPrice?.toStringAsFixed(0)}',
                              fontSize: Dimensions.titleMedium,
                              fontWeight: FontWeight.w700,
                              color: CustomColors.primary,
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
