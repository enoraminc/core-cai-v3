import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import 'constant_image.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

class Helpers {
  static String formatNumber(String s) =>
      NumberFormat.decimalPattern('id').format(num.tryParse(s) ?? 0);

  static double stringToNumber(String s) =>
      double.tryParse(s.replaceAll(",", ".").replaceAll(".", "").trim()) ?? 0;

  static double decimalStringToNumber(String s) =>
      double.tryParse(s.replaceAll(".", "").replaceAll(",", ".")) ?? 0;

  static String decimalNumberToString(num s) => "$s".replaceAll(".", ",");

  static String formatAmount(num? amount) {
    if (amount != null) {
      NumberFormat rpFormat = NumberFormat.simpleCurrency(locale: 'in_id');
      return rpFormat
          .format(amount)
          .replaceAll(RegExp('Rp'), 'Rp. ')
          .replaceAll(',00', '');
    }
    return 'Rp. 0';
  }

  static void showSnackbar(BuildContext context, String msg, bool isError) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: isError ? Colors.red : Colors.green,
          content: Text(
            msg,
            style: const TextStyle(color: Colors.white),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  static void showErrorSnackbar(
      GlobalKey<ScaffoldState> scaffoldKey, String error) {
    // scaffoldKey.currentState!.showSnackBar(
    //   SnackBar(
    //     content: Text(error),
    //     backgroundColor: Colors.red,
    //     duration: const Duration(seconds: 2),
    //   ),
    // );
  }

  static void showLoader(BuildContext context) {
    Loader.show(context,
        isSafeAreaOverlay: false,
        progressIndicator: const CircularProgressIndicator(),
        isBottomBarOverlay: false,
        overlayFromBottom: 0,
        themeData: Theme.of(context).copyWith(
            colorScheme:
                ColorScheme.fromSwatch().copyWith(secondary: Colors.black38)),
        overlayColor: Colors.grey[800]?.withOpacity(0.3));
  }

  static void hideLoader(BuildContext context) {
    Loader.hide();
  }

  static void showSelectMediaDialog(
    BuildContext context,
    String title,
    Function? button1Click,
    Function? button2Click,
  ) {
    AlertDialog alert = AlertDialog(
      backgroundColor: Theme.of(context).backgroundColor,
      title: Text(
        title,
        style: Theme.of(context).primaryTextTheme.headline1,
      ),
      contentPadding: const EdgeInsets.all(10),
      content: StatefulBuilder(
        builder: (context, setState) {
          return Container(
            width: MediaQuery.of(context).size.width * 0.2,
            padding: const EdgeInsets.only(
              left: 8,
              right: 8,
              bottom: 12,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      if (button1Click != null) {
                        button1Click();
                        Navigator.pop(context);
                      }
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          ConstantImages.camera,
                          width: 80,
                          theme: const SvgTheme(
                            currentColor: Color(0xff329688),
                          ),
                        ),
                        Text("Camera",
                            style: Theme.of(context).textTheme.subtitle1),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      if (button2Click != null) {
                        button2Click();
                        Navigator.pop(context);
                      }
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          ConstantImages.gallery,
                          width: 80,
                          theme: const SvgTheme(
                            currentColor: Color(0xff329688),
                          ),
                        ),
                        Text(
                          "Gallery",
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    showDialog(
        context: context,
        builder: (context) {
          return alert;
        });
  }
}
