import 'package:intl/intl.dart';

String formatDate(DateTime date) {
  return DateFormat('dd-MMM h:m a').format(date);
}
