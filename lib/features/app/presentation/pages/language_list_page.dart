import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frazello/features/app/presentation/pages/phrase_list_page.dart';
import '../bloc/language_bloc.dart';

class LanguageListPage extends StatelessWidget {
  const LanguageListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Languages",
          style: TextStyle(
            fontSize: 30,
          ),
        ),
      ),
      body: BlocBuilder(
        bloc: context.read<LanguageBloc>()..getLanguages(),
        builder: (_, state) {
          if (state is LanguageListLoaded) {
            final languages = state.languages;

            return ListView.builder(
              itemCount: languages.length,
              itemBuilder: (_, idx) {
                final language = languages[idx];

                return ListTile(
                  title: Text(
                    language.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PhraseListPage(language),
                      ),
                    );
                  },
                );
              },
            );
          }

          return const LinearProgressIndicator();
        },
      ),
    );
  }
}
