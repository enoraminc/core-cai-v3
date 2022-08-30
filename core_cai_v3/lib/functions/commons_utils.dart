import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:js' as js;

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

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.inCaps,
      selection: newValue.selection,
    );
  }
}

extension CapExtension on String {
  String get inCaps =>
      length > 0 ? '${this[0].toUpperCase()}${this.substring(1)}' : '';
  String get allInCaps => this.toUpperCase();
  String get capitalizeFirstofEach => replaceAll(RegExp(' +'), ' ')
      .split(" ")
      .map((str) => str.inCaps)
      .join(" ");
}
