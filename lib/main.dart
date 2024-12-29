import 'package:flutter/material.dart';
import 'package:translator/data/translator.dart';
import 'package:translator/models/language.dart';
import 'package:translator/provider/translation_provider.dart';
import 'ui/translation_screen.dart';
import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  List<Language> availableLanguages =
      await TranslatorService().fetchLanguages();

  // Fetch the last translation from local storage
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  // String? lastTranslation = prefs.getString('lastTranslation') ?? '';
  // String? lastFromLanguageCode = prefs.getString('lastFromLanguage') ?? '';
  // String? lastToLanguageCode = prefs.getString('lastToLanguage') ?? '';

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TranslationProvider()
            ..setLanguages(availableLanguages)
            // ..setLastTranslation(
            //   lastTranslation: lastTranslation,
            //   fromLanguageCode: lastFromLanguageCode,
            //   toLanguageCode: lastToLanguageCode,
            // ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.black,
          scaffoldBackgroundColor: const Color(0xFF121212),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1E1E1E),
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            centerTitle: true,
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: const Color(0xFF1E1E1E),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            hintStyle: const TextStyle(color: Colors.white54),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          listTileTheme: const ListTileThemeData(
            textColor: Colors.white,
            iconColor: Colors.white,
          ),
        ),
        home: TextTranslationScreen(),
      ),
    ),
  );
}
