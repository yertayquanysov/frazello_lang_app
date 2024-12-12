import 'package:frazello/features/app/domain/models/phrase.dart';

abstract class PhraseRepository {
  Future<List<Phrase>> getPhrases(int languageId);

  Future<List<Phrase>> getEmptyAudioPhrases();

  Future<void> add({
    required String front,
    required String back,
    required int languageId,
  });

  Future<void> delete(Phrase phrase);

  Future<void> updateFrontAudioUrl({
    required int phraseId,
    required String url,
  });

  Future<void> updateBackAudioUrl({
    required int phraseId,
    required String url,
  });

  void updateReviewCount(int phraseId);
}
