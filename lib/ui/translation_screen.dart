import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:translator/data/translator.dart';
import 'package:translator/provider/translation_provider.dart';
import 'package:translator/ui/widgets/language_bottom_sheet.dart';
import 'package:translator/ui/widgets/language_card.dart';
import 'package:translator/ui/widgets/translation_field.dart';

class TextTranslationScreen extends StatefulWidget {
  @override
  State<TextTranslationScreen> createState() => _TextTranslationScreenState();
}

class _TextTranslationScreenState extends State<TextTranslationScreen> {
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _outputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _inputController.addListener(() {
      final translProvider = context.read<TranslationProvider>();
      TranslatorService()
          .translate(
        _inputController.text,
        translProvider.fromLanguage,
        translProvider.toLanguage,
      )
          .then((value) {
        _outputController.text = value;
        translProvider.saveLastTranslation(
          value,
          translProvider.fromLanguage,
          translProvider.toLanguage,
        );
      }).catchError((error) {
        _outputController.text = error.toString();
      });
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final translationProvider = Provider.of<TranslationProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Text Translation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                LanguageCard(
                  language: translationProvider.fromLanguage,
                  onTap: () => _showLanguageSelection(context, true),
                ),
                const Icon(Icons.swap_horiz, size: 32),
                LanguageCard(
                  language: translationProvider.toLanguage,
                  onTap: () => _showLanguageSelection(context, false),
                ),
              ],
            ),
            const SizedBox(height: 32),
            TranslationField(
              label: 'Translate From ${translationProvider.fromLanguage.name}',
              hintText: 'Enter text here...',
              textController: _inputController,
            ),
            const SizedBox(height: 16),
            TranslationField(
              label: 'Translate To ${translationProvider.toLanguage.name}',
              hintText: 'Translation will appear here...',
              textController: _outputController,
              readOnly: true,
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageSelection(BuildContext context, bool isFromLanguage) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) {
        return LanguageSelectionBottomSheet(
          isFromLanguage: isFromLanguage,
        );
      },
    );
  }
}
