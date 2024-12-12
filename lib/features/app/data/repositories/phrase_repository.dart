import 'package:frazello/features/app/domain/models/phrase.dart';
import 'package:frazello/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/repositories/phrase_repository.dart';

class PhraseRepositoryImpl extends PhraseRepository {
  PhraseRepositoryImpl(
    this._supabaseClient,
    this._supabaseStorageClient,
  );

  final SupabaseClient _supabaseClient;
  final SupabaseStorageClient _supabaseStorageClient;

  SupabaseQueryBuilder get _phrasesTable => _supabaseClient.from("phrases");

  @override
  Future<List<Phrase>> getPhrases(int languageId) async {
    final phrasesList = await _phrasesTable
        .select()
        .eq('language_id', languageId)
        .order('reviews_count', ascending: true);

    return phrasesList.map((e) => Phrase.fromJson(e)).toList();
  }

  @override
  Future<void> add({
    required String front,
    required String back,
    required int languageId,
  }) async {
    final phrase = Phrase.insert(
      front: front,
      back: back,
      languageId: languageId,
    );

    await _phrasesTable.insert(phrase);
  }

  @override
  Future<void> updateBackAudioUrl({
    required int phraseId,
    required String url,
  }) async {
    logger.w("Updating back audio url...");

    _phrasesTable
        .update({'back_audio_url': url})
        .eq("id", phraseId)
        .then((e) => logger.w(e));
  }

  @override
  Future<void> updateFrontAudioUrl({
    required int phraseId,
    required String url,
  }) async {
    logger.w("Updating front audio url...");

    _phrasesTable
        .update({'front_audio_url': url})
        .eq("id", phraseId)
        .then((e) => logger.w(e));
  }

  @override
  Future<List<Phrase>> getEmptyAudioPhrases() async {
    final phrasesList = await _phrasesTable.select().or(
          'front_audio_url.is.null,'
          'back_audio_url.is.null,'
          'front_audio_url.eq."",'
          'back_audio_url.eq.""',
        );

    return phrasesList.map((e) => Phrase.fromJson(e)).toList();
  }

  @override
  Future<void> delete(Phrase phrase) async {
    await _phrasesTable.delete().eq('id', phrase.id).then((r) => logger.w(r));
    await _supabaseStorageClient.from("phrases").remove(
      [
        '${phrase.languageId}/${phrase.id}/front.mp3',
        '${phrase.languageId}/${phrase.id}/back.mp3',
      ],
    ).then((r) => logger.i(r));
  }

  @override
  void updateReviewCount(int phraseId) async {
    final response =
        await _phrasesTable.select('reviews_count').eq('id', phraseId);

    final currentCount = response.first['reviews_count'] as int;

    _phrasesTable
        .update({'reviews_count': currentCount + 1})
        .eq('id', phraseId)
        .then((r) => logger.i(r));
  }
}
