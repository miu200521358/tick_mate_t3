import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tick_mate/core/services/error_handler_service.dart';

import 'package:tick_mate/domain/entities/timer_entity.dart';
import 'package:tick_mate/gen/l10n/app_localizations.dart';
import 'package:tick_mate/presentation/bloc/timer/timer_bloc.dart';
import 'package:tick_mate/presentation/bloc/timer/timer_event.dart';
import 'package:tick_mate/presentation/widgets/date_time_picker_widget.dart';

import 'package:tick_mate/presentation/bloc/timer/timer_state.dart';

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

  DateTime? _selectedDateTime;
  TimerType _timerType = TimerType.schedule;
  RepeatType _repeatType = RepeatType.none;
  final List<String> _characterIds = ['sample_character_id'];

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
      _titleController.text = widget.initialTimer!.title;
      // Convert UTC DateTime from entity to local time for the picker
      _selectedDateTime = widget.initialTimer!.dateTime?.toLocal();
      _timerType = widget.initialTimer!.timerType;
      _repeatType = widget.initialTimer!.repeatType;
      _characterIds.clear();
      _characterIds.addAll(widget.initialTimer!.characterIds);
    }
  }

  /// タイマーの作成または更新を行う
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      context.read<TimerBloc>().add(
        TimerCreated(
          title: _titleController.text,
          dateTime: _selectedDateTime,
          timeRange: null, // TODO: 時間範囲入力機能は別Issueで実装予定
          timerType: _timerType,
          repeatType: _repeatType,
          characterIds: _characterIds,
        ),
      );
      // Navigator.pop は BlocListener で成功時に行う
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final errorHandler = GetIt.instance<ErrorHandlerService>(); // <<< 追加

    // <<< BlocListener で Scaffold をラップ >>>
    return BlocListener<TimerBloc, TimerState>(
      listener: (context, state) {
        if (state is TimerError) {
          // エラーダイアログを表示 (ナビゲーションはしない)
          errorHandler.showErrorDialog(
            context,
            state.message,
            title: l10n.error(''), // Use generic error title for now
          );
        } else if (state is TimerCreateSuccess) {
          // 成功したら前の画面に戻る
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        // <<< 元の Scaffold は child になる >>>
        appBar: AppBar(
          title: Text(l10n.addTimer),
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
                    labelText:
                        l10n.addTimer, // Consider a more specific label like "Timer Title"
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'タイトルを入力してください'; // TODO: 多言語対応
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // 日時ピッカー
                DateTimePickerWidget(
                  initialDateTime: _selectedDateTime,
                  onDateTimeSelected: (dateTime) {
                    setState(() {
                      _selectedDateTime = dateTime;
                    });
                  },
                ),
                const SizedBox(height: 32),

                // 送信ボタン
                Center(
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    child: Text(l10n.dateTimePickerConfirm),
                  ),
                ),
              ],
            ),
          ),
        ),
      ), // <<< Scaffold の終わり >>>
    ); // <<< BlocListener の終わり >>>
  }
}
