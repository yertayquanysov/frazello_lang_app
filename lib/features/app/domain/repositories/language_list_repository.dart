import 'package:frazello/features/app/domain/models/phrase.dart';
import 'package:frazello/features/app/domain/models/project_list.dart';

abstract class LanguageListRepository {
  Future<List<Language>> getLanguages();

  Future<void> add(Phrase phrase);
}
