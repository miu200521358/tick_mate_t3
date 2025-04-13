import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tick_mate/presentation/bloc/settings/settings_bloc.dart';
import 'package:tick_mate/presentation/bloc/settings/settings_event.dart';
import 'package:tick_mate/presentation/bloc/settings/settings_state.dart';

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
        title: Text(AppLocalizations.of(context)!.settings),
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
            return Center(
              child: Text(AppLocalizations.of(context)!.error(state.message)),
            );
          }
          return Center(child: Text(AppLocalizations.of(context)!.unknown));
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
          Text(
            AppLocalizations.of(context)!.geminiApiKeySettings,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(AppLocalizations.of(context)!.geminiApiKeyDescription),
          const SizedBox(height: 16),
          TextField(
            controller: _apiKeyController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.geminiApiKey,
              hintText: AppLocalizations.of(context)!.enterApiKey,
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
                  child: Text(AppLocalizations.of(context)!.saveApiKey),
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
                  child: Text(AppLocalizations.of(context)!.deleteApiKey),
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
                    : Text(AppLocalizations.of(context)!.connectionTest),
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
                    state.testSuccess == true
                        ? AppLocalizations.of(context)!.testSuccess
                        : AppLocalizations.of(context)!.testFailure,
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
