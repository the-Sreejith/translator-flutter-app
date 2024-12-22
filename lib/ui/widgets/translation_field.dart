
import 'package:flutter/material.dart';

class TranslationField extends StatelessWidget {
  final String label;
  final String hintText;
  final bool readOnly;
  final TextEditingController textController; 

  const TranslationField({
    required this.label,
    required this.hintText,
    required this.textController,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          height: 150, 
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(16),
          ),
          child: TextField(
            maxLines: null,
            readOnly: readOnly,
            controller: textController,
            decoration: InputDecoration(
              hintText: hintText,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }
}
