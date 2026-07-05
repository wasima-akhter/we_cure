import 'package:glady/core/widgets/loading_widget.dart';

import '../utils/basic_import.dart';
import '../widgets/custom_drop_down_widget.dart';

class TimezoneDialog extends StatefulWidget {
  final String currentTimezone;
  final String profileTimezone;
  final List<String> timezones;
  final Future<void> Function(String timezone) onSave;
  final RxBool isLoading;

  const TimezoneDialog({
    super.key,
    required this.currentTimezone,
    required this.profileTimezone,
    required this.timezones,
    required this.onSave,
    required this.isLoading,
  });

  @override
  State<TimezoneDialog> createState() => _TimezoneDialogState();
}

class _TimezoneDialogState extends State<TimezoneDialog> {
  late String selectedTimezone;

  @override
  void initState() {
    super.initState();
    selectedTimezone = widget.currentTimezone;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: TextWidget(
        "Timezone Changed",
        fontSize: 22,
        fontWeight: FontWeight.w500,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            "Your account timezone is different from your device timezone.",
            fontWeight: FontWeight.w400,
            color: CustomColors.primary,
          ),
          const SizedBox(height: 12),
          TextWidget(
            "Account: ${widget.profileTimezone}",
            fontWeight: FontWeight.w500,
          ),
          const SizedBox(height: 4),
          TextWidget(
            "Device: ${widget.currentTimezone}",
            fontWeight: FontWeight.w500,
          ),
          const SizedBox(height: 20),

          CustomDropDownWidget(
            hint: "Select Timezone",
            initialValue: selectedTimezone,
            items: widget.timezones,
            onChanged: (value) {
              setState(() {
                selectedTimezone = value;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const TextWidget("Skip"),
        ),
        Obx(
          () => widget.isLoading.value
              ? LoadingWidget()
              : ElevatedButton(
                  onPressed: () async {
                    await widget.onSave(selectedTimezone);
                    Get.back();
                  },

                  child: TextWidget("Update", color: CustomColors.whiteColor),
                ),
        ),
      ],
    );
  }
}
