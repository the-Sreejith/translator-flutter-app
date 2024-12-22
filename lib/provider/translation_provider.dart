import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import '../models/language.dart';

class TranslationProvider with ChangeNotifier {
  List<Language> _languages = [];
  Language _fromLanguage = Language.fromCode('en');
  Language _toLanguage = Language.fromCode('es');
  String _lastTranslation = '';

  List<Language> get languages => _languages;
  Language get fromLanguage => _fromLanguage;
  Language get toLanguage => _toLanguage;
  String get lastTranslation => _lastTranslation;

  void setLanguages(List<Language> languages) {
    _languages = languages;
    notifyListeners();
  }

  void setFromLanguage(Language language) {
    _fromLanguage = language;
    notifyListeners();
  }

  void setToLanguage(Language language) {
    _toLanguage = language;
    notifyListeners();
  }

  void setLastTranslation({
    required String? lastTranslation,
    required String? fromLanguageCode,
    required String? toLanguageCode,
  }) {
    _lastTranslation = lastTranslation ?? '';
    _fromLanguage = _languages.firstWhere(
      (lang) => lang.code == fromLanguageCode,
      orElse: () => Language.fromCode('en'),
    );
    _toLanguage = _languages.firstWhere(
      (lang) => lang.code == toLanguageCode,
      orElse: () => Language.fromCode('es'),
    );
    notifyListeners();
  }

  Future<void> saveLastTranslation(
      String translation, Language fromLang, Language toLang) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.setString('lastTranslation', translation);
    // await prefs.setString('lastFromLanguage', fromLang.code);
    // await prefs.setString('lastToLanguage', toLang.code);
  }
}
