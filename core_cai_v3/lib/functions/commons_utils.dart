import 'dart:js' as js;

import 'package:intl/intl.dart';

class CommonUtils {
  static String chatDateHeader(
    DateTime currentDate,
    DateTime earlyDate,
  ) {
    DateTime nowDate = DateTime.now();
    if (earlyDate.day > nowDate.day) {
      if ((earlyDate.day - nowDate.day) >= 2) {
        return DateFormat("dd MMM").format(earlyDate.toLocal()).toString();
      } else if ((earlyDate.day - nowDate.day) >= 1) {
        return 'Yesterday';
      } else {
        return 'Today';
      }
    }
    if ((nowDate.day - earlyDate.day) >= 2) {
      return DateFormat("dd MMM").format(earlyDate.toLocal()).toString();
    } else if ((nowDate.day - earlyDate.day) >= 1) {
      return 'Yesterday';
    } else {
      return 'Today';
    }
  }

  static dynamic getCopyPasteData() {
    var data = js.context.callMethod("getImageFromClipBoard", []);
    return data;
  }
}
