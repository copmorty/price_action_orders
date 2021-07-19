import 'package:flutter/services.dart';

class ValidatorInputFormatter implements TextInputFormatter {
  final StringValidator editingValidator;

  ValidatorInputFormatter(this.editingValidator);

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final oldValueValid = editingValidator.isValid(oldValue.text);
    final newValueValid = editingValidator.isValid(newValue.text);
    if (oldValueValid && !newValueValid) {
      return oldValue;
    }
    return newValue;
  }
}

abstract class StringValidator {
  bool isValid(String value);
}

class RegexValidator implements StringValidator {
  final String regexSource;

  RegexValidator({required this.regexSource});

  /// value: the input string
  /// returns: true if the input string is a full match for regexSource
  bool isValid(String value) {
    try {
      final regex = RegExp(regexSource);
      final matches = regex.allMatches(value);
      for (Match match in matches) {
        if (match.start == 0 && match.end == value.length) {
          return true;
        }
      }
      return false;
    } catch (e) {
      // Invalid regex
      assert(false, e.toString());
      return true;
    }
  }
}

class DotCurrencyEditingRegexValidator extends RegexValidator {
  DotCurrencyEditingRegexValidator() : super(regexSource: "^\$|^(0|([1-9][0-9]{0,20}))(\\.[0-9]{0,20})?\$");
}

class CommaCurrencyEditingRegexValidator extends RegexValidator {
  CommaCurrencyEditingRegexValidator() : super(regexSource: "^\$|^(0|([1-9][0-9]{0,20}))(\\,[0-9]{0,20})?\$");
}
