import 'package:flutter/material.dart';
import 'package:tick_mate/core/utils/date_time_utils.dart';
import 'package:tick_mate/gen/l10n/app_localizations.dart';

/// 日付と時刻を選択するためのウィジェット
class DateTimePickerWidget extends StatefulWidget {
  const DateTimePickerWidget({
    super.key,
    this.initialDateTime,
    required this.onDateTimeSelected,
    this.dateFormat = 'yyyy-MM-dd',
    this.timeFormat = 'HH:mm',
  });

  /// 初期表示する日時
  final DateTime? initialDateTime;

  /// 日付と時刻が選択された時のコールバック
  final void Function(DateTime) onDateTimeSelected;

  /// 日付のフォーマット
  final String dateFormat;

  /// 時刻のフォーマット
  final String timeFormat;

  @override
  State<DateTimePickerWidget> createState() => _DateTimePickerWidgetState();
}

class _DateTimePickerWidgetState extends State<DateTimePickerWidget> {
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  late String _formattedDate;
  late String _formattedTime;

  @override
  void initState() {
    super.initState();
    _initializeDateTime();
  }

  /// 日時の初期化
  void _initializeDateTime() {
    final now = DateTime.now();
    _selectedDate = widget.initialDateTime ?? now;
    _selectedTime = TimeOfDay(
      hour: widget.initialDateTime?.hour ?? now.hour,
      minute: widget.initialDateTime?.minute ?? now.minute,
    );
    _updateFormattedValues();
  }

  /// 表示用の日付と時刻を更新
  void _updateFormattedValues() {
    _formattedDate = DateTimeUtils.formatDateTime(
      _selectedDate,
      pattern: widget.dateFormat,
    );
    _formattedTime =
        '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}';
  }

  /// 日付選択ダイアログを表示
  Future<void> _selectDate(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText: l10n.selectDate,
      cancelText: l10n.dateTimePickerCancel,
      confirmText: l10n.dateTimePickerConfirm,
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _updateFormattedValues();
      });
      _notifyDateTimeChanged();
    }
  }

  /// 時刻選択ダイアログを表示
  Future<void> _selectTime(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      helpText: l10n.selectTime,
      cancelText: l10n.dateTimePickerCancel,
      confirmText: l10n.dateTimePickerConfirm,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
        _updateFormattedValues();
      });
      _notifyDateTimeChanged();
    }
  }

  /// 選択した日時の変更を通知
  void _notifyDateTimeChanged() {
    final dateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );
    widget.onDateTimeSelected(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.dateTimePickerTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: l10n.selectDate,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    suffixIcon: const Icon(Icons.calendar_today),
                  ),
                  child: Text(_formattedDate),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: InkWell(
                onTap: () => _selectTime(context),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: l10n.selectTime,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    suffixIcon: const Icon(Icons.access_time),
                  ),
                  child: Text(_formattedTime),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
