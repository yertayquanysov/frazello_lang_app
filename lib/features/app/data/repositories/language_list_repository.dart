import 'package:frazello/features/app/domain/models/phrase.dart';
import 'package:frazello/features/app/domain/models/project_list.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/repositories/language_list_repository.dart';

class LanguageListRepositoryImpl extends LanguageListRepository {
  LanguageListRepositoryImpl(this.supabaseClient);

  final SupabaseClient supabaseClient;

  SupabaseQueryBuilder get languageTable => supabaseClient.from('languages');

  @override
  Future<List<Language>> getLanguages() async {
    final languages = await languageTable.select();
    return languages.map((data) => Language.fromMap(data)).toList();
  }

  @override
  Future<void> add(Phrase phrase) async {
    // await languageTable.insert(phrase.toJson());
  }
}
