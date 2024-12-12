import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frazello/features/app/data/repositories/audio_generate_repository.dart';
import 'package:frazello/features/app/presentation/pages/review_phrase_page.dart';
import '../../domain/models/phrase.dart';
import '../../domain/models/project_list.dart';
import '../bloc/phrase_list_bloc.dart';
import '../bloc/review_phrase_bloc.dart';
import 'add_phrase_page.dart';

class PhraseListPage extends StatelessWidget {
  const PhraseListPage(this.language, {super.key});

  final Language language;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(language.name),
        actions: [
          TextButton(
            onPressed: () {
              context.read<ReviewPhraseBloc>().getPhrases(language.id);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ReviewPhrasePage()),
              );
            },
            child: const Text(
              "Review",
              style: TextStyle(fontSize: 20),
            ),
          ),
          TextButton(
            child: const Text(
              "Generate audios",
              style: TextStyle(fontSize: 20),
            ),
            onPressed: () => context
                .read<AudioGenerateRepositoryImpl>()
                .generateAudioFiles(),
          )
        ],
      ),
      body: BlocBuilder(
        bloc: context.read<PhraseListBloc>()..getPhrases(language.id),
        builder: (_, state) {
          if (state is PhraseListLoaded) {
            final phrases = state.phrases;

            return ListView.builder(
              itemCount: phrases.length,
              itemBuilder: (_, idx) {
                final Phrase phrase = phrases[idx];

                return ListTile(
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          title: const Text("Delete?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("No"),
                            ),
                            TextButton(
                              child: const Text("Delete"),
                              onPressed: () =>
                                  context.read<PhraseListBloc>().delete(phrase),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  trailing: Visibility(
                    visible: phrase.isAudioAvailable,
                    child: IconButton(
                      icon: const Icon(Icons.play_circle, size: 30),
                      onPressed: () =>
                          context.read<ReviewPhraseBloc>().playPhrase(phrase),
                    ),
                  ),
                  title: Text(
                    phrase.front,
                    style: const TextStyle(fontSize: 25),
                  ),
                  subtitle: Text(
                    phrase.back,
                    style: const TextStyle(fontSize: 20),
                  ),
                );
              },
            );
          }

          return const LinearProgressIndicator();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text(
          "Add phrase",
          style: TextStyle(fontSize: 30),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddPhrasePage(language.id)),
          );
        },
      ),
    );
  }
}
