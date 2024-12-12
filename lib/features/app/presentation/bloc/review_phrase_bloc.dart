import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frazello/core/services/audio_player.dart';
import 'package:frazello/features/app/domain/models/phrase.dart';
import 'package:frazello/features/app/domain/repositories/phrase_repository.dart';

abstract class ReviewPhraseState {}

class Loading extends ReviewPhraseState {}

class CurrentPhrase extends ReviewPhraseState {
  CurrentPhrase(this.phrase);

  final Phrase phrase;
}

class ReviewEnd extends ReviewPhraseState {}

class ReviewPhraseBloc extends Cubit<ReviewPhraseState> {
  ReviewPhraseBloc(
    this._audioPlayer,
    this._phraseRepository,
  ) : super(Loading());

  List<Phrase> _phrases = [];
  final PhrasePlayer _audioPlayer;
  final PhraseRepository _phraseRepository;

  int _currentLanguageId = 0;

  void showCard() async {
    if (_phrases.isEmpty) {
      getPhrases(_currentLanguageId);
    } else {
      final currentPhrase = _phrases.first;
      _phrases.remove(currentPhrase);

      emit(CurrentPhrase(currentPhrase));

      _audioPlayer.playAudio(currentPhrase, () {
        _phraseRepository.updateReviewCount(currentPhrase.id);
        showCard();
      });
    }
  }

  void getPhrases(int languageId) async {
    emit(Loading());

    _currentLanguageId = languageId;
    _phrases = await _phraseRepository.getPhrases(languageId);

    showCard();
  }

  void playPhrase(Phrase phrase) {
    _audioPlayer.playAudio(phrase, () {
      _phraseRepository.updateReviewCount(phrase.id);
    });
  }

  void stopPlayer() => _audioPlayer.stop();
}
