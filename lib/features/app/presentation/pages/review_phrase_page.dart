import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/review_phrase_bloc.dart';

class ReviewPhrasePage extends StatelessWidget {
  const ReviewPhrasePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PopScope(
        onPopInvokedWithResult: (_, __) {
          context.read<ReviewPhraseBloc>().stopPlayer();
        },
        child: BlocBuilder(
          bloc: context.read<ReviewPhraseBloc>(),
          builder: (_, state) {
            if (state is CurrentPhrase) {
              final phrase = state.phrase;

              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      phrase.front,
                      style: const TextStyle(
                        fontSize: 50,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      phrase.back,
                      style: const TextStyle(fontSize: 30),
                    ),
                  ],
                ),
              );
            }

            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
