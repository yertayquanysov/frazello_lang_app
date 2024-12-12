import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../../config.dart';

abstract class Text2SpeechService {
  Future<Uint8List> generateAudio(String text);
}

class Text2SpeechServiceImpl extends Text2SpeechService {
  @override
  Future<Uint8List> generateAudio(String text) async {
    final url = Uri.parse(Config.elevenlabsApiUrl);

    final headers = {
      'Accept': 'audio/mpeg',
      'Content-Type': 'application/json',
      'xi-api-key': 'sk_476eaa1a13448f93343fb92492e2f633b982d0a49892ac23',
    };

    final body = jsonEncode({
      'text': text,
      'model_id': 'eleven_multilingual_v2',
      "voice_settings": {
        "stability": 0.5,
        "similarity_boost": 0.8,
        "style": 0.0,
        "use_speaker_boost": true,
      }
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception(
        'Error generating audio: ${response.statusCode} - ${response.body}',
      );
    }
  }
}
