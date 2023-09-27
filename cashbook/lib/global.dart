import 'package:logger/logger.dart';

class Global {
  static Logger log = Logger(
      printer: PrettyPrinter(colors: true, printEmojis: true, lineLength: 120));
}
