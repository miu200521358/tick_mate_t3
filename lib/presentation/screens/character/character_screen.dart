import 'dart:io'; // For FileImage
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart'; // For ImageSource
import 'package:tick_mate/di/injection.dart';
import 'package:tick_mate/presentation/bloc/character_detail/character_detail_bloc.dart';

/// キャラクター詳細・編集画面
class CharacterScreen extends StatelessWidget {
  const CharacterScreen({super.key, required this.characterId});

  final String characterId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Provide CharacterDetailBloc and load initial data
      create:
          (context) =>
              getIt<CharacterDetailBloc>()
                ..add(LoadCharacterDetail(characterId)),
      child: Scaffold(
        appBar: AppBar(
          // Title will be set dynamically in BlocBuilder
        ),
        body: BlocBuilder<CharacterDetailBloc, CharacterDetailState>(
          builder: (context, state) {
            if (state is CharacterDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CharacterDetailLoaded) {
              final character = state.character;
              return SingleChildScrollView(
                // Allow scrolling for content
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // --- Image Display and Picker ---
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 80,
                          backgroundImage:
                              (character.imagePath != null &&
                                      character.imagePath!.isNotEmpty)
                                  ? FileImage(
                                    File(character.imagePath!),
                                  ) // Use FileImage for local paths
                                  : null, // Use default background if no image
                          child:
                              (character.imagePath == null ||
                                      character.imagePath!.isEmpty)
                                  ? const Icon(
                                    Icons.person,
                                    size: 80,
                                  ) // Placeholder icon
                                  : null,
                        ),
                        FloatingActionButton(
                          mini: true,
                          onPressed: () => _showImageSourceDialog(context),
                          child: const Icon(Icons.camera_alt),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // --- Character Details ---
                    Text(
                      character.name,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    // TODO: Display other character details (prompt, parameters etc.)
                    Text('Prompt: ${character.promptText}'), // Example
                    const SizedBox(height: 8),
                    Text('作成日: ${character.createdAt}'), // TODO: Format date
                    Text('更新日: ${character.updatedAt}'), // TODO: Format date
                    // TODO: Add Edit/Save buttons if needed
                  ],
                ),
              );
            } else if (state is CharacterDetailError) {
              // Show error and potentially a retry button
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('エラー: ${state.message}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<CharacterDetailBloc>().add(
                          LoadCharacterDetail(characterId),
                        );
                      },
                      child: const Text('再試行'),
                    ),
                  ],
                ),
              );
            }
            // Initial or unexpected state
            return const Center(child: Text('キャラクター情報を読み込んでいます...'));
          },
        ),
        // Set AppBar title dynamically based on state
        // This requires accessing the state again, maybe move AppBar inside BlocBuilder?
        // For simplicity, let's keep it basic for now.
        // appBar: AppBar(title: Text(state is CharacterDetailLoaded ? state.character.name : 'キャラクター詳細')),
      ),
    );
  }

  // --- Helper Method for Image Source Selection ---
  void _showImageSourceDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('ギャラリーから選択'),
                onTap: () {
                  context.read<CharacterDetailBloc>().add(
                    const PickAndSaveCharacterImage(ImageSource.gallery),
                  );
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('カメラで撮影'),
                onTap: () {
                  context.read<CharacterDetailBloc>().add(
                    const PickAndSaveCharacterImage(ImageSource.camera),
                  );
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
