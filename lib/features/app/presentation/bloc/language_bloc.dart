import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frazello/features/app/domain/models/project_list.dart';
import 'package:frazello/features/app/domain/repositories/language_list_repository.dart';

abstract class LanguageListState {}

class Loading extends LanguageListState {}

class LanguageListLoaded extends LanguageListState {
  final List<Language> languages;

  LanguageListLoaded(this.languages);
}

class LanguageBloc extends Cubit<LanguageListState> {
  final LanguageListRepository _languageListRepository;

  LanguageBloc(this._languageListRepository) : super(Loading());

  void getLanguages() async {
    emit(Loading());

    final languages = await _languageListRepository.getLanguages();

    emit(LanguageListLoaded(languages));
  }
}
