import 'package:decimal/decimal.dart';
import 'package:intl/intl.dart';

extension DecimalExtension on Decimal {
  String toCrypto({int? decimalDigits}) {
    decimalDigits = decimalDigits ?? 8;
    final integerCurrencyFormat = NumberFormat.currency(symbol: '', decimalDigits: 0);

    final String strNumber = this.toStringAsFixed(decimalDigits);
    final List<String> listNum = strNumber.split('.');

    final int integerPart = int.parse(listNum[0]);

    if (decimalDigits > 0)
      return integerCurrencyFormat.format(integerPart) + '.' + listNum[1];
    else
      return integerCurrencyFormat.format(integerPart);
  }
}
