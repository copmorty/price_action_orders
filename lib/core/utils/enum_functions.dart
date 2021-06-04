String enumToShortString(enumValue) {
  return enumValue.toString().substring(enumValue.toString().indexOf('.') + 1);
  // return enumValue.toString().split('.').last;
}

String enumToCapitalizedSentenceString(enumValue) {
  final shortString = enumToShortString(enumValue);
  return shortString[0] + shortString.substring(1).toLowerCase();
}

String enumToCapitalizedWordsString(enumValue) {
  final shortString = enumToShortString(enumValue);
  return shortString.split('_').map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase()).join(' ');
}

String enumToCapitalizedCharactersString(enumValue) {
  final shortString = enumToShortString(enumValue);
  return shortString.split('_').map((word) => word.toUpperCase()).join(' ');
}
