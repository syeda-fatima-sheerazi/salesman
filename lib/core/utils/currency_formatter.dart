/// Output jaise `R100,00` — comma decimal ke sath.
String formatMoney(num n, {String symbol = 'Rs'}) {
  final cents = (n.abs() * 100).round();
  final neg = n.isNegative;
  return '${neg ? '-' : ''}$symbol${cents ~/ 100},${(cents % 100).toString().padLeft(2, '0')}';
}
