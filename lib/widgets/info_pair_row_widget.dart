import '../core/utils/basic_import.dart';

class InfoPairRow extends StatelessWidget {
  final String leftTitle;
  final String leftValue;
  final String rightTitle;
  final String rightValue;

  const InfoPairRow({
    super.key,
    required this.leftTitle,
    required this.leftValue,
    required this.rightTitle,
    required this.rightValue,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainSpaceBet,
      children: [
        /// Left Column (start)
        _InfoColumn(title: leftTitle, value: leftValue, alignment: crossStart),

        /// Right Column (end)
        _InfoColumn(title: rightTitle, value: rightValue, alignment: crossEnd),
      ],
    );
  }
}

class _InfoColumn extends StatelessWidget {
  final String title;
  final String value;
  final CrossAxisAlignment alignment;

  const _InfoColumn({
    required this.title,
    required this.value,
    required this.alignment,
  });

  Color _getValueColor() {
    switch (value.toUpperCase()) {
      case 'CANCELLED':
        return CustomColors.rejected;
      case 'UPCOMING':
        return CustomColors.active;
      case 'COMPLETED':
        return CustomColors.success;
      case 'PENDING':
        return CustomColors.pending;
      default:
        return CustomColors.blackColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        TextWidget(
          title,
          fontSize: Dimensions.titleSmall,
          fontWeight: FontWeight.w600,
        ),
        Space.height.v5,
        TextWidget(
          value,
          color: _getValueColor(),
          fontSize: Dimensions.titleSmall,
          fontWeight:
              value.toUpperCase() == 'CANCELLED' ||
                  value.toUpperCase() == 'UPCOMING' ||
                  value.toUpperCase() == 'COMPLETED' ||
                  value.toUpperCase() == 'PENDING'
              ? FontWeight.w600
              : FontWeight.w500,
        ),
      ],
    );
  }
}
