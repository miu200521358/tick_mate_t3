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
  
  // 繰り返しパターンの詳細設定用の状態変数
  final List<bool> _selectedWeekdays = List.generate(7, (_) => false); // 月〜日
  int _selectedDayOfMonth = 1; // 毎月○日用
  int _selectedWeekOfMonth = 0; // 第○週用
  int _selectedWeekdayOfMonth = 0; // ○曜日用
  int _selectedMonth = 1; // 毎年○月用
  int _selectedDayOfYear = 1; // 毎年○月○日用
  
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

      // 繰り返しパターンの詳細情報を保存するマップ
      final Map<String, dynamic> repeatDetails = {};
      
      // 繰り返しパターンに応じた詳細情報を設定
      switch (_repeatType) {
        case RepeatType.weekly:
          repeatDetails['weekdays'] = _selectedWeekdays;
          break;
        case RepeatType.biweekly:
          repeatDetails['weekdays'] = _selectedWeekdays;
          break;
        case RepeatType.monthlyByWeekday:
          repeatDetails['weekOfMonth'] = _selectedWeekOfMonth;
          repeatDetails['weekdayOfMonth'] = _selectedWeekdayOfMonth;
          break;
        case RepeatType.bimonthlyByWeekday:
          repeatDetails['weekOfMonth'] = _selectedWeekOfMonth;
          repeatDetails['weekdayOfMonth'] = _selectedWeekdayOfMonth;
          break;
        case RepeatType.monthlyByDay:
          repeatDetails['dayOfMonth'] = _selectedDayOfMonth;
          break;
        case RepeatType.bimonthlyByDay:
          repeatDetails['dayOfMonth'] = _selectedDayOfMonth;
          break;
        case RepeatType.yearly:
          repeatDetails['month'] = _selectedMonth;
          repeatDetails['dayOfYear'] = _selectedDayOfYear;
          break;
        default:
          // 他の繰り返しパターンでは詳細情報は不要
          break;
      }

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
          repeatDetails: repeatDetails, // 繰り返しパターンの詳細情報を追加
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

  // Helper to build the repeat type dropdown items
  List<DropdownMenuItem<RepeatType>> _buildRepeatTypeDropdownItems(
    AppLocalizations l10n,
  ) {
    final Map<RepeatType, String> repeatLabels = {
      RepeatType.none: l10n.repeatNone,
      RepeatType.daily: l10n.repeatDaily,
      RepeatType.weekdays: l10n.repeatWeekdays,
      RepeatType.weekly: l10n.repeatWeekly,
      RepeatType.biweekly: l10n.repeatBiweekly,
      RepeatType.monthlyByWeekday: l10n.repeatMonthlyByWeekday,
      RepeatType.bimonthlyByWeekday: l10n.repeatBimonthlyByWeekday,
      RepeatType.monthlyByDay: l10n.repeatMonthlyByDay,
      RepeatType.bimonthlyByDay: l10n.repeatBimonthlyByDay,
      RepeatType.yearly: l10n.repeatYearly,
    };

    return repeatLabels.entries.map((entry) {
      return DropdownMenuItem(value: entry.key, child: Text(entry.value));
    }).toList();
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
          // 成功メッセージを表示
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.timerCreatedSuccessfully)),
          );
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
                const SizedBox(height: 16),

                // <<< 繰り返しパターン選択UIを追加 >>>
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.repeatPattern,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          // 繰り返しなし
                          RadioListTile<RepeatType>(
                            title: Text(l10n.repeatNone),
                            value: RepeatType.none,
                            groupValue: _repeatType,
                            onChanged: (RepeatType? value) {
                              setState(() {
                                _repeatType = value!;
                              });
                            },
                          ),
                          const Divider(height: 1),
                          
                          // 毎日
                          RadioListTile<RepeatType>(
                            title: Text(l10n.repeatDaily),
                            value: RepeatType.daily,
                            groupValue: _repeatType,
                            onChanged: (RepeatType? value) {
                              setState(() {
                                _repeatType = value!;
                              });
                            },
                          ),
                          const Divider(height: 1),
                          
                          // 平日（月～金）
                          RadioListTile<RepeatType>(
                            title: Text(l10n.repeatWeekdays),
                            value: RepeatType.weekdays,
                            groupValue: _repeatType,
                            onChanged: (RepeatType? value) {
                              setState(() {
                                _repeatType = value!;
                              });
                            },
                          ),
                          const Divider(height: 1),
                          
                          // 毎週
                          RadioListTile<RepeatType>(
                            title: Text(l10n.repeatWeekly),
                            value: RepeatType.weekly,
                            groupValue: _repeatType,
                            onChanged: (RepeatType? value) {
                              setState(() {
                                _repeatType = value!;
                              });
                            },
                          ),
                          // 毎週の曜日選択
                          if (_repeatType == RepeatType.weekly)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                              child: Wrap(
                                spacing: 8.0,
                                children: [
                                  FilterChip(
                                    label: Text(l10n.monday),
                                    selected: _selectedWeekdays[0],
                                    onSelected: (bool selected) {
                                      setState(() {
                                        _selectedWeekdays[0] = selected;
                                      });
                                    },
                                  ),
                                  FilterChip(
                                    label: Text(l10n.tuesday),
                                    selected: _selectedWeekdays[1],
                                    onSelected: (bool selected) {
                                      setState(() {
                                        _selectedWeekdays[1] = selected;
                                      });
                                    },
                                  ),
                                  FilterChip(
                                    label: Text(l10n.wednesday),
                                    selected: _selectedWeekdays[2],
                                    onSelected: (bool selected) {
                                      setState(() {
                                        _selectedWeekdays[2] = selected;
                                      });
                                    },
                                  ),
                                  FilterChip(
                                    label: Text(l10n.thursday),
                                    selected: _selectedWeekdays[3],
                                    onSelected: (bool selected) {
                                      setState(() {
                                        _selectedWeekdays[3] = selected;
                                      });
                                    },
                                  ),
                                  FilterChip(
                                    label: Text(l10n.friday),
                                    selected: _selectedWeekdays[4],
                                    onSelected: (bool selected) {
                                      setState(() {
                                        _selectedWeekdays[4] = selected;
                                      });
                                    },
                                  ),
                                  FilterChip(
                                    label: Text(l10n.saturday),
                                    selected: _selectedWeekdays[5],
                                    onSelected: (bool selected) {
                                      setState(() {
                                        _selectedWeekdays[5] = selected;
                                      });
                                    },
                                  ),
                                  FilterChip(
                                    label: Text(l10n.sunday),
                                    selected: _selectedWeekdays[6],
                                    onSelected: (bool selected) {
                                      setState(() {
                                        _selectedWeekdays[6] = selected;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          const Divider(height: 1),
                          
                          // 隔週
                          RadioListTile<RepeatType>(
                            title: Text(l10n.repeatBiweekly),
                            value: RepeatType.biweekly,
                            groupValue: _repeatType,
                            onChanged: (RepeatType? value) {
                              setState(() {
                                _repeatType = value!;
                              });
                            },
                          ),
                          const Divider(height: 1),
                          
                          // 毎月第○曜日
                          RadioListTile<RepeatType>(
                            title: Text(l10n.repeatMonthlyByWeekday),
                            value: RepeatType.monthlyByWeekday,
                            groupValue: _repeatType,
                            onChanged: (RepeatType? value) {
                              setState(() {
                                _repeatType = value!;
                              });
                            },
                          ),
                          // 毎月第○曜日の詳細設定
                          if (_repeatType == RepeatType.monthlyByWeekday)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                              child: Row(
                                children: [
                                  // 第○週の選択
                                  Expanded(
                                    child: DropdownButtonFormField<int>(
                                      value: _selectedWeekOfMonth,
                                      decoration: InputDecoration(
                                        labelText: '週',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      items: [
                                        DropdownMenuItem(value: 0, child: Text(l10n.firstWeek)),
                                        DropdownMenuItem(value: 1, child: Text(l10n.secondWeek)),
                                        DropdownMenuItem(value: 2, child: Text(l10n.thirdWeek)),
                                        DropdownMenuItem(value: 3, child: Text(l10n.fourthWeek)),
                                        DropdownMenuItem(value: 4, child: Text(l10n.lastWeek)),
                                      ],
                                      onChanged: (int? value) {
                                        if (value != null) {
                                          setState(() {
                                            _selectedWeekOfMonth = value;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  // ○曜日の選択
                                  Expanded(
                                    child: DropdownButtonFormField<int>(
                                      value: _selectedWeekdayOfMonth,
                                      decoration: InputDecoration(
                                        labelText: '曜日',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      items: [
                                        DropdownMenuItem(value: 0, child: Text(l10n.monday)),
                                        DropdownMenuItem(value: 1, child: Text(l10n.tuesday)),
                                        DropdownMenuItem(value: 2, child: Text(l10n.wednesday)),
                                        DropdownMenuItem(value: 3, child: Text(l10n.thursday)),
                                        DropdownMenuItem(value: 4, child: Text(l10n.friday)),
                                        DropdownMenuItem(value: 5, child: Text(l10n.saturday)),
                                        DropdownMenuItem(value: 6, child: Text(l10n.sunday)),
                                      ],
                                      onChanged: (int? value) {
                                        if (value != null) {
                                          setState(() {
                                            _selectedWeekdayOfMonth = value;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          const Divider(height: 1),
                          
                          // 隔月第○曜日
                          RadioListTile<RepeatType>(
                            title: Text(l10n.repeatBimonthlyByWeekday),
                            value: RepeatType.bimonthlyByWeekday,
                            groupValue: _repeatType,
                            onChanged: (RepeatType? value) {
                              setState(() {
                                _repeatType = value!;
                              });
                            },
                          ),
                          const Divider(height: 1),
                          
                          // 毎月○日
                          RadioListTile<RepeatType>(
                            title: Text(l10n.repeatMonthlyByDay),
                            value: RepeatType.monthlyByDay,
                            groupValue: _repeatType,
                            onChanged: (RepeatType? value) {
                              setState(() {
                                _repeatType = value!;
                              });
                            },
                          ),
                          // 毎月○日の詳細設定
                          if (_repeatType == RepeatType.monthlyByDay)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: DropdownButtonFormField<int>(
                                      value: _selectedDayOfMonth,
                                      decoration: InputDecoration(
                                        labelText: '日付',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      items: List.generate(31, (index) {
                                        return DropdownMenuItem(
                                          value: index + 1,
                                          child: Text('${index + 1}日'),
                                        );
                                      }),
                                      onChanged: (int? value) {
                                        if (value != null) {
                                          setState(() {
                                            _selectedDayOfMonth = value;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          const Divider(height: 1),
                          
                          // 隔月○日
                          RadioListTile<RepeatType>(
                            title: Text(l10n.repeatBimonthlyByDay),
                            value: RepeatType.bimonthlyByDay,
                            groupValue: _repeatType,
                            onChanged: (RepeatType? value) {
                              setState(() {
                                _repeatType = value!;
                              });
                            },
                          ),
                          const Divider(height: 1),
                          
                          // 毎年○月○日
                          RadioListTile<RepeatType>(
                            title: Text(l10n.repeatYearly),
                            value: RepeatType.yearly,
                            groupValue: _repeatType,
                            onChanged: (RepeatType? value) {
                              setState(() {
                                _repeatType = value!;
                              });
                            },
                          ),
                          // 毎年○月○日の詳細設定
                          if (_repeatType == RepeatType.yearly)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                              child: Row(
                                children: [
                                  // 月の選択
                                  Expanded(
                                    child: DropdownButtonFormField<int>(
                                      value: _selectedMonth,
                                      decoration: InputDecoration(
                                        labelText: '月',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      items: List.generate(12, (index) {
                                        return DropdownMenuItem(
                                          value: index + 1,
                                          child: Text('${index + 1}月'),
                                        );
                                      }),
                                      onChanged: (int? value) {
                                        if (value != null) {
                                          setState(() {
                                            _selectedMonth = value;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  // 日の選択
                                  Expanded(
                                    child: DropdownButtonFormField<int>(
                                      value: _selectedDayOfYear,
                                      decoration: InputDecoration(
                                        labelText: '日',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      items: List.generate(31, (index) {
                                        return DropdownMenuItem(
                                          value: index + 1,
                                          child: Text('${index + 1}日'),
                                        );
                                      }),
                                      onChanged: (int? value) {
                                        if (value != null) {
                                          setState(() {
                                            _selectedDayOfYear = value;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
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
