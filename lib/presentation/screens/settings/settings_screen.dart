import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tick_mate_t3/presentation/bloc/settings/settings_bloc.dart';
import 'package:tick_mate_t3/presentation/bloc/settings/settings_event.dart';
import 'package:tick_mate_t3/presentation/bloc/settings/settings_state.dart';

/// 設定画面
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _apiKeyController = TextEditingController();
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    context.read<SettingsBloc>().add(const SettingsInitialized());
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocConsumer<SettingsBloc, SettingsState>(
        listener: (context, state) {
          if (state is SettingsLoaded && state.geminiApiKey != null) {
            _apiKeyController.text = state.geminiApiKey!;
          }
        },
        builder: (context, state) {
          if (state is SettingsInitial || state is SettingsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SettingsLoaded) {
            return _buildSettingsForm(context, state);
          } else if (state is SettingsError) {
            return Center(child: Text('エラー: ${state.message}'));
          }
          return const Center(child: Text('不明な状態です'));
        },
      ),
    );
  }

  Widget _buildSettingsForm(BuildContext context, SettingsLoaded state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Gemini APIキー設定',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Google Gemini APIキーを入力してください。APIキーはデバイスのセキュアストレージに保存され、アプリ内でのみ使用されます。',
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _apiKeyController,
            decoration: InputDecoration(
              labelText: 'Gemini APIキー',
              hintText: 'APIキーを入力',
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              ),
            ),
            obscureText: _obscureText,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed:
                      _apiKeyController.text.isEmpty
                          ? null
                          : () {
                            context.read<SettingsBloc>().add(
                              GeminiApiKeySaved(apiKey: _apiKeyController.text),
                            );
                          },
                  child: const Text('APIキーを保存'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed:
                      state.geminiApiKey == null
                          ? null
                          : () {
                            context.read<SettingsBloc>().add(
                              const GeminiApiKeyDeleted(),
                            );
                            _apiKeyController.clear();
                          },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('APIキーを削除'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed:
                state.isTesting || _apiKeyController.text.isEmpty
                    ? null
                    : () {
                      context.read<SettingsBloc>().add(
                        GeminiApiKeyTested(apiKey: _apiKeyController.text),
                      );
                    },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child:
                state.isTesting
                    ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                    : const Text('接続テスト'),
          ),
          if (state.testResult != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:
                    state.testSuccess == true
                        ? Colors.green.withAlpha(25)
                        : Colors.red.withAlpha(25),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: state.testSuccess == true ? Colors.green : Colors.red,
                ),
              ),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.testSuccess == true ? 'テスト成功' : 'テスト失敗',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color:
                          state.testSuccess == true ? Colors.green : Colors.red,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(state.testResult!),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
