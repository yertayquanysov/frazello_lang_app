import 'package:equatable/equatable.dart';

class Phrase extends Equatable {
  Phrase({
    required this.id,
    required this.front,
    required this.back,
    required this.languageId,
    this.frontAudioUrl = '',
    this.backAudioUrl = '',
  });

  final int id;
  final String front;
  final String back;
  final int languageId;
  String frontAudioUrl;
  String backAudioUrl;

  bool get isAudioAvailable =>
      frontAudioUrl.isNotEmpty && backAudioUrl.isNotEmpty;

  static Phrase fromJson(Map data) {
    return Phrase(
      id: data['id'],
      languageId: data['language_id'],
      front: data['front'],
      back: data['back'],
      frontAudioUrl: data['front_audio_url'] ?? "",
      backAudioUrl: data['back_audio_url'] ?? "",
    );
  }

  static Map insert({
    required String front,
    required String back,
    required int languageId,
  }) {
    return {
      "front": front,
      "back": back,
      "language_id": languageId,
    };
  }

  @override
  List<Object?> get props => [id];
}
