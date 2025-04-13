import 'dart:io'; // For File operations
import 'package:flutter/foundation.dart'; // For debugPrint

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p; // For path manipulation
import 'package:tick_mate/domain/entities/character_entity.dart';
import 'package:tick_mate/domain/repositories/character_repository.dart';
import 'package:uuid/uuid.dart'; // For unique filenames

part 'character_detail_event.dart';
part 'character_detail_state.dart';

@injectable
class CharacterDetailBloc
    extends Bloc<CharacterDetailEvent, CharacterDetailState> {
  final CharacterRepository _characterRepository;
  final ImagePicker _imagePicker;
  final Uuid _uuid;

  // Keep track of the current character ID
  String? _currentCharacterId;

  CharacterDetailBloc(this._characterRepository, this._imagePicker, this._uuid)
    : super(CharacterDetailInitial()) {
    on<LoadCharacterDetail>(_onLoadCharacterDetail);
    on<PickAndSaveCharacterImage>(_onPickAndSaveCharacterImage);
  }

  Future<void> _onLoadCharacterDetail(
    LoadCharacterDetail event,
    Emitter<CharacterDetailState> emit,
  ) async {
    emit(CharacterDetailLoading());
    _currentCharacterId = event.characterId; // Store the ID
    try {
      final character = await _characterRepository.getCharacterById(
        event.characterId,
      );
      if (character == null) {
        emit(const CharacterDetailError('指定されたキャラクターが見つかりません。'));
      } else {
        emit(CharacterDetailLoaded(character));
      }
    } catch (e) {
      emit(CharacterDetailError('キャラクターの読み込みに失敗しました: $e'));
    }
  }

  Future<void> _onPickAndSaveCharacterImage(
    PickAndSaveCharacterImage event,
    Emitter<CharacterDetailState> emit,
  ) async {
    if (_currentCharacterId == null) {
      emit(const CharacterDetailError('キャラクターIDが不明です。'));
      return;
    }

    // Ensure we are in a loaded state before proceeding
    if (state is! CharacterDetailLoaded) {
      emit(const CharacterDetailError('キャラクターが読み込まれていません。'));
      return;
    }
    final currentCharacter = (state as CharacterDetailLoaded).character;

    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: event.source,
      );

      if (pickedFile != null) {
        emit(CharacterDetailLoading()); // Show loading indicator during save

        final Directory appDocDir = await getApplicationDocumentsDirectory();
        final String fileExtension = p.extension(pickedFile.path);
        final String newFileName = '${_uuid.v4()}$fileExtension';
        final String newPath = p.join(
          appDocDir.path,
          'character_images',
          newFileName,
        );

        // Ensure the directory exists
        final Directory imageDir = Directory(p.dirname(newPath));
        if (!await imageDir.exists()) {
          await imageDir.create(recursive: true);
        }

        // TODO: Delete old image file if it exists and is different
        // Copy the file (and use the variable to avoid warning)
        final File newImageFile = await File(pickedFile.path).copy(newPath);
        debugPrint('Image saved to: ${newImageFile.path}'); // Use the variable

        // Update character entity
        final updatedCharacter = currentCharacter.copyWith(
          imagePath: newPath, // Save the full path for simplicity now
          updatedAt: DateTime.now(),
        );

        // Save to repository
        await _characterRepository.saveCharacter(updatedCharacter);

        // Emit loaded state with updated character
        emit(CharacterDetailLoaded(updatedCharacter));
      } else {
        // User cancelled picker - potentially emit the previous state or a specific message
        // For now, just revert to the previously loaded state if possible
        if (state is CharacterDetailLoaded) {
          emit(
            CharacterDetailLoaded(currentCharacter),
          ); // Re-emit previous state
        } else {
          // If somehow not loaded, try reloading
          add(LoadCharacterDetail(_currentCharacterId!));
        }
      }
    } catch (e) {
      emit(CharacterDetailError('画像の処理中にエラーが発生しました: $e'));
      // Attempt to revert to previous loaded state on error
      if (state is CharacterDetailLoaded) {
        emit(CharacterDetailLoaded(currentCharacter));
      }
    }
  }
}
