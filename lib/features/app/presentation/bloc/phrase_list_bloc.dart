import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frazello/features/app/domain/models/phrase.dart';
import 'package:frazello/features/app/domain/repositories/phrase_repository.dart';
import 'package:frazello/main.dart';

abstract class PhraseListState {}

class PhraseListLoaded extends PhraseListState {
  final List<Phrase> phrases;

  PhraseListLoaded({required this.phrases});
}

class ProgressBar extends PhraseListState {}

class PhraseListBloc extends Cubit<PhraseListState> {
  PhraseListBloc(this._phraseRepository) : super(ProgressBar());

  final PhraseRepository _phraseRepository;

  void delete(Phrase phrase) async {
    await _phraseRepository.delete(phrase);

    getPhrases(phrase.languageId);
  }

  void getPhrases(int languageId) async {
    try {
      emit(ProgressBar());

      final phrases = await _phraseRepository.getPhrases(languageId);

      emit(PhraseListLoaded(phrases: phrases));
    } catch (e) {
      logger.e("Error getPhrase: $e");
    }
  }
}
