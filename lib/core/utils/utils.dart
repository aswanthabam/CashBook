import 'package:intl/intl.dart';

String formatDate(DateTime date) {
  return DateFormat('dd-MMM h:m a').format(date);
}

String formatMoney({required double amount, String prefix = ""}) {
  double num = (amount >= 10000000000
      ? (amount / 1000000000)
      : ((amount >= 10000000 ? (amount / 1000000) : (amount))));
  String postfix =
      (amount >= 10000000000 ? " B" : ((amount >= 10000000 ? " M" : "")));
  String res = prefix +
      NumberFormat.currency(locale: 'en_IN', symbol: '₹ ')
          .format(num)
          .replaceAll(',', '') +
      postfix;
  return res;
}
