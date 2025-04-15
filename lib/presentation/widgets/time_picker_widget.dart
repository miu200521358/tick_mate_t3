import 'package:flutter/material.dart';
import 'package:tick_mate/gen/l10n/app_localizations.dart';

/// 時刻選択ウィジェット
class TimePickerWidget extends StatefulWidget {
  const TimePickerWidget({
    super.key,
    this.initialTimeOfDay,
    required this.onTimeSelected,
    required this.labelText,
  });

  final TimeOfDay? initialTimeOfDay;
  final ValueChanged<TimeOfDay?> onTimeSelected;
  final String labelText;

  @override
  State<TimePickerWidget> createState() => _TimePickerWidgetState();
}

class _TimePickerWidgetState extends State<TimePickerWidget> {
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _selectedTime = widget.initialTimeOfDay;
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      helpText: AppLocalizations.of(context)!.selectTime, // Use localization
      confirmText:
          AppLocalizations.of(
            context,
          )!.dateTimePickerConfirm, // Use localization
      cancelText:
          AppLocalizations.of(
            context,
          )!.dateTimePickerCancel, // Use localization
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
      widget.onTimeSelected(_selectedTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final MaterialLocalizations materialLocalizations =
        MaterialLocalizations.of(context);

    return InputDecorator(
      decoration: InputDecoration(
        labelText: widget.labelText,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 16.0,
        ),
      ),
      child: InkWell(
        onTap: () => _selectTime(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              _selectedTime != null
                  ? materialLocalizations.formatTimeOfDay(
                    _selectedTime!,
                    alwaysUse24HourFormat:
                        MediaQuery.of(context).alwaysUse24HourFormat,
                  )
                  : localizations.selectTime, // Show "Select Time" if null
            ),
            const Icon(Icons.access_time),
          ],
        ),
      ),
    );
  }
}
