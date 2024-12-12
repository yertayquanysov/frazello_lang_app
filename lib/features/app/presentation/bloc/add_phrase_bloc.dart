import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frazello/features/app/domain/repositories/phrase_repository.dart';
import 'package:frazello/features/app/presentation/bloc/phrase_list_bloc.dart';
import 'package:frazello/main.dart';

abstract class PhraseState {}

class ProgressBar extends PhraseState {}

class View extends PhraseState {}

class PhraseAdded extends PhraseState {}

class AddPhraseBloc extends Cubit<PhraseState> {
  AddPhraseBloc(
    this._phraseRepository,
    this._phraseListBloc,
  ) : super(View());

  final PhraseRepository _phraseRepository;
  final PhraseListBloc _phraseListBloc;

  void add({
    required String front,
    required String back,
    required int languageId,
  }) async {
    try {
      emit(ProgressBar());

      await _phraseRepository.add(
        front: front,
        back: back,
        languageId: languageId,
      );

      _phraseListBloc.getPhrases(languageId);

      emit(PhraseAdded());
    } catch (e) {
      logger.e(e);
    }
  }
}
