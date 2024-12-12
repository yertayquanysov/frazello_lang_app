import 'package:flutter/material.dart';
import 'package:frazello/features/app/domain/models/phrase.dart';
import 'package:just_audio/just_audio.dart';

abstract class PhrasePlayer {
  void playAudio(Phrase phrase, VoidCallback onPlayed);

  void stop();
}

class PhrasePlayerImpl extends PhrasePlayer {
  AudioPlayer? currentPlayer;

  @override
  void playAudio(Phrase phrase, VoidCallback onPlayed) async {

    currentPlayer?.dispose();
    currentPlayer = AudioPlayer();

    final playlist = ConcatenatingAudioSource(
      useLazyPreparation: true,
      shuffleOrder: DefaultShuffleOrder(),
      children: [
        AudioSource.uri(Uri.parse(phrase.frontAudioUrl)),
        AudioSource.uri(Uri.parse(phrase.backAudioUrl)),
      ],
    );

    currentPlayer?.setAudioSource(playlist);
    currentPlayer?.setSpeed(0.9);
    currentPlayer?.play();

    currentPlayer?.playerStateStream.listen((event) {
      if (event.processingState == ProcessingState.completed) {
        onPlayed();
      }
    });
  }

  @override
  void stop() {
    currentPlayer?.dispose();
  }
}
