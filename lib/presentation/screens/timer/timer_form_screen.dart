import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tick_mate/core/services/error_handler_service.dart';

import 'package:tick_mate/domain/entities/timer_entity.dart';
import 'package:tick_mate/gen/l10n/app_localizations.dart';
import 'package:tick_mate/presentation/bloc/timer/timer_bloc.dart';
import 'package:tick_mate/presentation/bloc/timer/timer_event.dart';
import 'package:tick_mate/presentation/bloc/timer/timer_state.dart';
import 'package:tick_mate/presentation/widgets/date_time_picker_widget.dart';
import 'package:tick_mate/presentation/widgets/time_picker_widget.dart'; // <<< 追加

/// タイマー作成画面
class TimerFormScreen extends StatefulWidget {
  const TimerFormScreen({super.key, this.initialTimer});

  /// 初期表示するタイマー（編集時に使用）
  final TimerEntity? initialTimer;

  @override
  State<TimerFormScreen> createState() => _TimerFormScreenState();
}

class _TimerFormScreenState extends State<TimerFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();

  // <<< 状態変数を追加・変更 >>>
  TimeSpecificationType _timeSpecificationType =
      TimeSpecificationType.dateTime; // Default
  DateTime? _selectedDateTime;
  TimeOfDay? _startTimeOfDay;
  TimeOfDay? _endTimeOfDay;
  TimerType _timerType = TimerType.schedule; // Keep existing fields for now
  RepeatType _repeatType = RepeatType.none; // Keep existing fields for now
  final List<String> _characterIds = [
    'sample_character_id',
  ]; // Keep existing fields for now

  @override
  void initState() {
    super.initState();
    _initializeFormValues();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  /// フォームの初期値を設定
  void _initializeFormValues() {
    if (widget.initialTimer != null) {
      final timer = widget.initialTimer!;
      _titleController.text = timer.title;
      _timeSpecificationType = timer.timeSpecificationType; // <<< 追加
      // Convert UTC DateTime from entity to local time for the picker
      _selectedDateTime = timer.dateTime?.toLocal();
      _startTimeOfDay = timer.startTimeOfDay; // <<< 追加
      _endTimeOfDay = timer.endTimeOfDay; // <<< 追加
      _timerType = timer.timerType;
      _repeatType = timer.repeatType;
      _characterIds.clear();
      _characterIds.addAll(timer.characterIds);
    }
  }

  /// タイマーの作成または更新を行う
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // TODO: Add validation for time pickers based on _timeSpecificationType
      // e.g., ensure start time is before end time for timeRange

      context.read<TimerBloc>().add(
        TimerCreated(
          title: _titleController.text,
          // <<< Pass new fields to event >>>
          timeSpecificationType: _timeSpecificationType,
          dateTime:
              _timeSpecificationType == TimeSpecificationType.dateTime
                  ? _selectedDateTime
                  : null,
          startTimeOfDay:
              (_timeSpecificationType == TimeSpecificationType.specificTime ||
                      _timeSpecificationType == TimeSpecificationType.timeRange)
                  ? _startTimeOfDay
                  : null,
          endTimeOfDay:
              _timeSpecificationType == TimeSpecificationType.timeRange
                  ? _endTimeOfDay
                  : null,
          timeRange: null, // Keep null for now, as per original TODO
          timerType: _timerType,
          repeatType: _repeatType,
          characterIds: _characterIds,
        ),
      );
      // Navigator.pop は BlocListener で成功時に行う
    }
  }

  // Helper to build the time specification dropdown items
  List<DropdownMenuItem<TimeSpecificationType>> _buildTimeSpecDropdownItems(
    AppLocalizations l10n,
  ) {
    return TimeSpecificationType.values.map((type) {
      String text;
      switch (type) {
        case TimeSpecificationType.dateTime:
          text = l10n.timeSpecTypeDateTime;
          break;
        case TimeSpecificationType.specificTime:
          text = l10n.timeSpecTypeSpecificTime;
          break;
        case TimeSpecificationType.timeRange:
          text = l10n.timeSpecTypeTimeRange;
          break;
      }
      return DropdownMenuItem(value: type, child: Text(text));
    }).toList();
  }

  // Helper to build the conditional time input widget
  Widget _buildTimeInputWidget(AppLocalizations l10n) {
    switch (_timeSpecificationType) {
      case TimeSpecificationType.dateTime:
        return DateTimePickerWidget(
          initialDateTime: _selectedDateTime,
          onDateTimeSelected: (dateTime) {
            setState(() {
              _selectedDateTime = dateTime;
              // Clear other time fields when switching type
              _startTimeOfDay = null;
              _endTimeOfDay = null;
            });
          },
        );
      case TimeSpecificationType.specificTime:
        return TimePickerWidget(
          initialTimeOfDay: _startTimeOfDay,
          labelText: l10n.timePickerLabel,
          onTimeSelected: (time) {
            setState(() {
              _startTimeOfDay = time;
              // Clear other time fields when switching type
              _selectedDateTime = null;
              _endTimeOfDay = null;
            });
          },
        );
      case TimeSpecificationType.timeRange:
        return Column(
          children: [
            TimePickerWidget(
              initialTimeOfDay: _startTimeOfDay,
              labelText: l10n.timePickerLabelFrom,
              onTimeSelected: (time) {
                setState(() {
                  _startTimeOfDay = time;
                  // Clear other time fields when switching type
                  _selectedDateTime = null;
                });
              },
            ),
            const SizedBox(height: 16),
            TimePickerWidget(
              initialTimeOfDay: _endTimeOfDay,
              labelText: l10n.timePickerLabelTo,
              onTimeSelected: (time) {
                setState(() {
                  _endTimeOfDay = time;
                  // Clear other time fields when switching type
                  _selectedDateTime = null;
                });
              },
            ),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final errorHandler = GetIt.instance<ErrorHandlerService>();

    return BlocListener<TimerBloc, TimerState>(
      listener: (context, state) {
        if (state is TimerError) {
          errorHandler.showErrorDialog(
            context,
            state.message,
            title: l10n.error(''),
          );
        } else if (state is TimerCreateSuccess) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.initialTimer == null ? l10n.addTimer : 'タイマー編集',
          ), // TODO: Localize edit title
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // タイトル入力
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'タイマー名', // TODO: Localize "Timer Title"
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'タイトルを入力してください'; // TODO: Localize validation
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // <<< 時間指定種別ドロップダウンを追加 >>>
                DropdownButtonFormField<TimeSpecificationType>(
                  value: _timeSpecificationType,
                  decoration: InputDecoration(
                    labelText: l10n.timeSpecificationTypeLabel,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: _buildTimeSpecDropdownItems(l10n),
                  onChanged: (TimeSpecificationType? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _timeSpecificationType = newValue;
                        // Reset time fields when type changes to avoid inconsistent state
                        _selectedDateTime = null;
                        _startTimeOfDay = null;
                        _endTimeOfDay = null;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),

                // <<< 条件付き時間入力ウィジェット >>>
                _buildTimeInputWidget(l10n),
                const SizedBox(height: 32),

                // 送信ボタン
                Center(
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    child: Text(
                      l10n.dateTimePickerConfirm,
                    ), // Use confirm label for save
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
