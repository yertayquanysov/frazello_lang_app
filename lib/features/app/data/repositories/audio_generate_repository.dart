import 'package:frazello/core/services/text2speech_service.dart';
import 'package:frazello/features/app/domain/models/phrase.dart';
import 'package:frazello/features/app/domain/repositories/audio_generate_repository.dart';
import 'package:frazello/features/app/domain/repositories/phrase_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../main.dart';

class AudioGenerateRepositoryImpl extends AudioGenerateRepository {

  AudioGenerateRepositoryImpl(
    this._phraseRepository,
    this._storageClient,
    this._text2speechService,
  );

  final PhraseRepository _phraseRepository;
  final SupabaseStorageClient _storageClient;
  final Text2SpeechService _text2speechService;

  StorageFileApi get _phrasesBucket => _storageClient.from('phrases');

  @override
  Future<void> generateAudioFiles() async {
    try {
      final phrases = await _phraseRepository.getEmptyAudioPhrases();

      for (final phrase in phrases) {
        logger.w('Generating: ${phrase.id}');

        if (phrase.frontAudioUrl.isEmpty) {
          await _handleAudioGeneration(
            text: phrase.front,
            cardType: 'front',
            languageId: phrase.languageId,
            phraseId: phrase.id,
          );
        }

        if (phrase.backAudioUrl.isEmpty) {
          await _handleAudioGeneration(
            text: phrase.back,
            cardType: 'back',
            languageId: phrase.languageId,
            phraseId: phrase.id,
          );
        }
      }
    } catch (e) {
      logger.e('Failed to generate audio files: $e');
      rethrow;
    }
  }

  @override
  Future<void> regeneratePhraseAudio(Phrase phrase) async {
    try {
      await _handleAudioGeneration(
        text: phrase.front,
        cardType: 'front',
        languageId: phrase.languageId,
        phraseId: phrase.id,
      );

      await _handleAudioGeneration(
        text: phrase.back,
        cardType: 'back',
        languageId: phrase.languageId,
        phraseId: phrase.id,
      );
    } catch (e) {
      logger.e('Failed to regenerate audio: $e');
      rethrow;
    }
  }

  Future<void> _handleAudioGeneration({
    required String text,
    required String cardType,
    required int languageId,
    required int phraseId,
  }) async {
    try {
      final uploadedAudioPath = await _uploadAudio(
        text: text,
        cardType: cardType,
        languageId: languageId,
        phraseId: phraseId,
      );

      final publicAudioUrl = _phrasesBucket.getPublicUrl(
        uploadedAudioPath.replaceFirst('phrases/', ''),
      );

      await _updatePhraseRepository(
        phraseId: phraseId,
        audioUrl: publicAudioUrl,
        cardType: cardType,
      );
    } catch (e) {
      logger.e(
          'Failed to handle audio generation for phraseId: $phraseId, cardType: $cardType. Error: $e');
      rethrow;
    }
  }

  Future<String> _uploadAudio({
    required String text,
    required String cardType,
    required int languageId,
    required int phraseId,
  }) async {
    final audioData = await _text2speechService.generateAudio(text);
    final filePath = '$languageId/$phraseId/$cardType.mp3';
    return _phrasesBucket.uploadBinary(
      filePath,
      audioData,
      fileOptions: const FileOptions(upsert: true),
    );
  }

  Future<void> _updatePhraseRepository({
    required int phraseId,
    required String audioUrl,
    required String cardType,
  }) async {
    if (cardType == 'front') {
      await _phraseRepository.updateFrontAudioUrl(
        phraseId: phraseId,
        url: audioUrl,
      );
    } else if (cardType == 'back') {
      await _phraseRepository.updateBackAudioUrl(
        phraseId: phraseId,
        url: audioUrl,
      );
    }
  }
}
