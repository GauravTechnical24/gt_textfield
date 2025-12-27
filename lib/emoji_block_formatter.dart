import 'package:flutter/services.dart';

class EmojiBlockFormatter extends TextInputFormatter {
  static final _emojiRegex = RegExp(
    r'[\u{1F300}-\u{1FAFF}\u{1F000}-\u{1F6FF}\u{2600}-\u{27BF}]',
    unicode: true,
  );

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
  ) {
    // If new text contains emoji → revert to oldValue  
    if (_emojiRegex.hasMatch(newValue.text)) {
      return oldValue;
    }
    return newValue;
  }
}
