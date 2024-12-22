import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'dart:convert';

import '../lib/data/translator.dart'; // Adjust the path based on your project structure

class MockClient extends Mock implements http.Client {}

void main() {
  group('Translator', () {
    final mockClient = MockClient();
    final translator = Translator();

    setUp(() {
      // Use the mock client for testing
      translator.client = mockClient;
    });

    test('detect() should return the detected language code', () async {
      const sampleText = 'Hallo Welt';
      const detectedLanguage = 'de';

      when(mockClient.post(
        Uri.https('google-translate1.p.rapidapi.com', '/language/translate/v2/detect'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(
          jsonEncode({
            'data': {
              'detections': [
                [
                  {'language': detectedLanguage}
                ]
              ]
            }
          }),
          200));

      final result = await translator.detect(sampleText);
      expect(result, detectedLanguage);
    });

    test('translate() should return the translated text', () async {
      const sampleText = 'Hello';
      const translatedText = 'Hallo';

      when(mockClient.post(
        Uri.https('google-translate1.p.rapidapi.com', '/language/translate/v2'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(
          jsonEncode({
            'data': {
              'translations': [
                {'translatedText': translatedText}
              ]
            }
          }),
          200));

      final result = await translator.translate(sampleText, 'en', 'de');
      expect(result, translatedText);
    });

    test('languages() should return the list of supported languages', () async {
      final supportedLanguages = ['en', 'de', 'fr'];

      when(mockClient.get(
        Uri.https('google-translate1.p.rapidapi.com', '/language/translate/v2/languages'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response(
          jsonEncode({
            'data': {
              'languages': supportedLanguages.map((lang) => {'language': lang}).toList()
            }
          }),
          200));

      final result = await translator.languages();
      expect(result, supportedLanguages);
    });
  });
}
