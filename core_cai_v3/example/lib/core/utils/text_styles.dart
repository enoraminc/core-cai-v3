import 'package:flutter/material.dart';
import 'package:core_cai_v3/functions/custom_function.dart';
import 'app_colors.dart';

class TextStyles {
  static TextStyle hintStyle(Color color) => TextStyle(
        color: color,
        fontSize: 16,
      );

  static TextStyle captionStyle(Color color) => TextStyle(
        color: color,
        fontSize: 14,
      );

  static TextStyle tabLabelStyle(Color color) => TextStyle(
        fontSize: 16,
        color: color,
        fontWeight: FontWeight.bold,
      );

  static TextStyle normalContent(Color color) => TextStyle(
        fontSize: 16,
        color: color,
      );

  static TextStyle bodyText1(Color color) => TextStyle(
        color: color,
        fontSize: 18,
      );

  static TextStyle subTitle1Style(Color color) =>
      TextStyle(color: color, fontSize: 14);

  static TextStyle subTitle2Style(Color color) =>
      TextStyle(color: color, fontSize: 12);

  static TextStyle headLine2Style(Color color) =>
      TextStyle(color: color, fontSize: 12);

  static TextStyle headLine3Style(Color color) =>
      TextStyle(color: color, fontSize: 16);

  static TextStyle Body2Style(Color color) => TextStyle(
        color: color,
        fontSize: 16,
      );

  static TextStyle Headline1Style(Color color) => TextStyle(
        color: color,
        fontSize: 16,
      );

  static TextStyle editButtonStyle(Color color) => TextStyle(
        color: color,
        fontSize: 14,
      );

  static TextStyle primaryHeadline1Style(Color color) => TextStyle(
        color: color,
        fontSize: 18,
      );

  static TextStyle primaryHeadline2Style(Color color) => TextStyle(
        color: color,
        fontSize: 16,
      );

  static TextStyle descriptionStyle(Color color) => TextStyle(
      color: color, fontSize: 18, decoration: TextDecoration.underline);

  static TextStyle appNameLoginScreen(BuildContext context) {
    if (CustomFunctions.isDarkTheme(context)) {
      return const TextStyle(color: Colors.white, fontSize: 22);
    }
    return const TextStyle(color: AppColors.blackColor, fontSize: 22);
  }

  static TextStyle deleteTitleTaskStyle(BuildContext context) => TextStyle(
      color: CustomFunctions.isDarkTheme(context)
          ? AppColors.kLightColor
          : AppColors.blackColor,
      fontSize: 20);

  static TextStyle deleteSubTitleTaskStyle(BuildContext context,
          {bool isBold = false}) =>
      TextStyle(
          color: CustomFunctions.isDarkTheme(context)
              ? AppColors.kLightColor
              : AppColors.blackColor,
          fontSize: 18,
          fontWeight: (isBold) ? FontWeight.bold : null);
}
