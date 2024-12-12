import 'package:frazello/features/app/domain/models/phrase.dart';

abstract class AudioGenerateRepository {
  Future<void> generateAudioFiles();

  Future<void> regeneratePhraseAudio(Phrase phrase);
}
