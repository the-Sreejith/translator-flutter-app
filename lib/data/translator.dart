import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:translator/models/language.dart';

class TranslatorService {
  final String apiKey = dotenv.env['API_KEY']??'';
  final String apiHost = dotenv.env['API_HOST']??'';

  

  Future<Language> detect(String text) async {
    final url = Uri.https(apiHost, '/language/translate/v2/detect');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'X-RapidAPI-Key': apiKey,
        'X-RapidAPI-Host': apiHost,
      },
      body: {'q': text},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final code= data['data']['detections'][0][0]['language'];
      return Language.fromCode(code);
    } else {
      print(response.body);
      throw Exception('Failed to detect language');
    }
  }

  Future<String> translate(String text, Language from, Language to) async {
    final url = Uri.https(apiHost, '/external-api/free-google-translator');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'X-RapidAPI-Key': apiKey,
        'X-RapidAPI-Host': apiHost,
      },
      body: {
        'q': text,
        'source': from.code,
        'target': to.code,
        'format': 'text',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data']['translations'][0]['translatedText'];
    } else {
  
      print(response.body);
      throw Exception('Failed to translate text');
    }
  }

  Future<List<Language>> fetchLanguages() async {
    final url = Uri.https(apiHost, '/language/translate/v2/languages');
    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'X-RapidAPI-Key': apiKey,
        'X-RapidAPI-Host': apiHost,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> languagesList = data['data']['languages'];

      return languagesList.map((lang) {
        final code = lang['language'];
        return Language.fromCode(code);
      }).toList();
    } else {
      throw Exception('Failed to fetch languages');
    }
  }
}

