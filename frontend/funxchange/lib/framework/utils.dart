import 'package:intl/intl.dart';

class Utils {
  static String formatDateTime(DateTime dateTime) {
    var format = DateFormat.yMEd().add_Hm();
    return format.format(dateTime);
  }
}
