import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:translator/models/language.dart';
import 'package:translator/provider/translation_provider.dart';

class LanguageSelectionBottomSheet extends StatefulWidget {
  final bool isFromLanguage;

  const LanguageSelectionBottomSheet({required this.isFromLanguage});

  @override
  State<LanguageSelectionBottomSheet> createState() =>
      _LanguageSelectionBottomSheetState();
}

class _LanguageSelectionBottomSheetState
    extends State<LanguageSelectionBottomSheet> {
  List<Language> _filteredLanguages = [];
  List<Language> allLanguages = [];

  @override
  void initState() {
    final _translationProvider = context.read<TranslationProvider>();
    allLanguages = _translationProvider.languages;
    _filteredLanguages = allLanguages;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Search...',
              prefixIcon: const Icon(Icons.search),
              fillColor: const Color(0xFF1E1E1E),
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (query) {
              print('onchanged $query');
              setState(() {
                _filteredLanguages = allLanguages.where((lang) {
                  return lang.name.toLowerCase().contains(query.toLowerCase());
                }).toList();
                print('filtered languages: ${_filteredLanguages.length}');
              });
            },
          ),
          const SizedBox(height: 16),
          const Text(
            'All Languages',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredLanguages.length,
              itemBuilder: (context, index) {
                final lang = _filteredLanguages[index];
                return ListTile(
                  leading: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[600],
                      borderRadius: BorderRadius.circular(50),
                    ),
                    width: 40,
                    height: 40,
                  ),
                  title: Text(
                    lang.name,
                    style: const TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    final translationProvider = Provider.of<TranslationProvider>(context, listen: false);
                    if (widget.isFromLanguage) {
                      translationProvider.setFromLanguage(lang);
                    } else {
                      translationProvider.setToLanguage(lang);
                    }
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              '${_filteredLanguages.length} Languages Found',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
