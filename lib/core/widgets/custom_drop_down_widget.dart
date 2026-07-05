import '../utils/basic_import.dart';

class CustomDropDownWidget extends StatefulWidget {
  final String hint;
  final String? label;
  final List<String> items;
  final String? initialValue;
  final Function(String) onChanged;

  const CustomDropDownWidget({
    super.key,
    this.hint = "Select Option",
    required this.items,
    this.initialValue,
    required this.onChanged,
    this.label,
  });

  @override
  State<CustomDropDownWidget> createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends State<CustomDropDownWidget> {
  @override
  void didUpdateWidget(covariant CustomDropDownWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initialValue != widget.initialValue) {
      setState(() {
        _selectedValue = widget.initialValue;
      });
    }
  }

  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: crossStart,
      children: [
        // TextWidget(
        //   padding: EdgeInsetsGeometry.only(
        //     bottom: Dimensions.spaceBetweenInputTitleAndBox * 0.6,
        //   ),
        //   widget.label ?? "Select option",
        //   fontSize: Dimensions.titleSmall,
        //   fontWeight: FontWeight.w500,
        //   color: CustomColors.blackColor,
        // ),
        Container(
          padding: Dimensions.defaultHorizontalSize.edgeHorizontal * 0.5,
          height: Dimensions.inputBoxHeight * 0.9,
          decoration: BoxDecoration(
            border: Border.all(
              color: _selectedValue == null
                  ? CustomColors.disableColor
                  : CustomColors.primary,
              width: 1.4,
            ),
            borderRadius: BorderRadius.circular(Dimensions.radius * 0.8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              borderRadius: BorderRadius.circular(Dimensions.radius),
              dropdownColor: CustomColors.whiteColor,
              iconEnabledColor: _selectedValue == null
                  ? CustomColors.borderColor
                  : CustomColors.primary,
              value: _selectedValue,
              isExpanded: true,
              hint: TextWidget(
                widget.hint,
                fontSize: Dimensions.titleSmall * 1.2,
                color: CustomColors.blackColor.withOpacity(0.7),
                fontWeight: FontWeight.w500,
              ),
              items: widget.items
                  .map(
                    (item) => DropdownMenuItem(
                      value: item,
                      child: TextWidget(
                        item,
                        fontSize: Dimensions.titleSmall * 1.2,

                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() => _selectedValue = value);
                widget.onChanged(value!);
              },
            ),
          ),
        ),
      ],
    );
  }
}
