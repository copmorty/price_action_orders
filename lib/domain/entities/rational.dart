// import 'package:equatable/equatable.dart';

// class Rational extends Equatable {
//   final int integerPart;
//   final int decimalPart;
//   static final _pattern = RegExp(r'^([+-]?\d*)(\.\d*)?([eE][+-]?\d+)?$');

//   Rational(this.integerPart, this.decimalPart);

//   @override
//   List<Object> get props => [integerPart, decimalPart];

//   static parse(String strNumber) {
//     final match = _pattern.firstMatch(strNumber);

//     if (match == null) {
//       throw FormatException();
//     }

//     final dotIndex = strNumber.indexOf('.');
//     final intPart = int.parse(strNumber.substring(0, dotIndex));
//     final decPart = int.parse(strNumber.substring(dotIndex + 1, strNumber.length));

//     return Rational(intPart, decPart);
//   }

//   String toString() {
//     String intPart = integerPart.toString();
//     String decPart = decimalPart.toString();
//     decPart = decPart == '0' ? '00000000' : decPart;
//     return intPart + '.' + decPart;
//   }

//   String toShortString() {
//     String intPart = integerPart.toString();
//     String decPart = decimalPart.toString();
//     decPart = decPart == '0' ? '' : '.' + decPart;
//     return intPart + decPart;
//   }
// }
