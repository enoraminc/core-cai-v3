import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'text_styles.dart';

class DynamicTheme {
  static ThemeData lightTheme() {
    return ThemeData(
      bannerTheme: const MaterialBannerThemeData(
        backgroundColor: AppColors.primaryColorLight,
      ),
      iconTheme: const IconThemeData(
        color: AppColors.kIconColor,
      ),
      primaryColorDark: AppColors.kLightColor,
      primaryColorLight: AppColors.primaryLight,
      primaryColor: AppColors.primaryColorLight,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.kGreyColor,
      ),
      tabBarTheme: TabBarTheme(
        labelStyle: TextStyles.tabLabelStyle(AppColors.kLightColor),
      ),
      backgroundColor: AppColors.kIconColor.shade400,
      inputDecorationTheme: InputDecorationTheme(
        border: InputBorder.none,
        hintStyle: TextStyles.hintStyle(AppColors.blackColor.withOpacity(0.7)),
      ),
      textTheme: TextTheme(
        bodyText1: TextStyles.bodyText1(AppColors.blackColor),
        subtitle1:
            TextStyles.subTitle1Style(AppColors.blackColor.withOpacity(0.7)),
        caption: TextStyles.captionStyle(AppColors.blackColor.withOpacity(0.7)),
        bodyText2: TextStyles.Body2Style(AppColors.blackColor.withOpacity(0.7)),
        headline1: TextStyles.Headline1Style(AppColors.linkColorDark),
        subtitle2:
            TextStyles.subTitle2Style(AppColors.blackColor.withOpacity(0.7)),
        headline2: TextStyles.headLine2Style(
          AppColors.blackColor.withOpacity(0.7),
        ),
        headline3: TextStyles.headLine3Style(
          AppColors.blackColor.withOpacity(0.7),
        ),
      ),
      primaryTextTheme: TextTheme(
        bodyText1: TextStyles.hintStyle(AppColors.blackColor),
        headline1: TextStyles.primaryHeadline1Style(AppColors.blackColor),
        headline2: TextStyles.primaryHeadline2Style(AppColors.blackColor),
      ),
      scaffoldBackgroundColor: AppColors.kLightColor,
      highlightColor: AppColors.highlightLight,
      textSelectionTheme:
          TextSelectionThemeData(cursorColor: AppColors.blackColor),
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      bannerTheme: const MaterialBannerThemeData(
        backgroundColor: AppColors.primaryColorDark,
      ),
      iconTheme: const IconThemeData(
        color: AppColors.kIconColor,
      ),
      primaryColorDark: AppColors.kLightColor,
      primaryColorLight: AppColors.appBarDark,
      primaryColor: AppColors.primaryColorLight,
      scaffoldBackgroundColor: AppColors.chatBGDark,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.appBarDark,
      ),
      tabBarTheme: TabBarTheme(
        labelStyle: TextStyles.tabLabelStyle(AppColors.kLightColor),
      ),
      backgroundColor: AppColors.chatBGDark,
      inputDecorationTheme: InputDecorationTheme(
        border: InputBorder.none,
        hintStyle: TextStyles.hintStyle(AppColors.kLightColor.withOpacity(0.5)),
      ),
      textTheme: TextTheme(
        bodyText1: TextStyles.bodyText1(AppColors.kLightColor),
        subtitle1: TextStyles.subTitle1Style(
          AppColors.kLightColor.withOpacity(0.5),
        ),
        caption: TextStyles.captionStyle(AppColors.kLightColor),
        bodyText2: TextStyles.Body2Style(AppColors.kLightColor),
        headline1: TextStyles.Headline1Style(AppColors.linkColorDark),
        subtitle2: TextStyles.subTitle2Style(
          AppColors.kLightColor.withOpacity(0.5),
        ),
        headline2: TextStyles.headLine2Style(
          AppColors.kLightColor.withOpacity(0.5),
        ),
        headline3: TextStyles.headLine3Style(
          AppColors.kLightColor.withOpacity(0.5),
        ),
      ),
      primaryTextTheme: TextTheme(
        bodyText1: TextStyles.hintStyle(AppColors.kLightColor),
        headline1: TextStyles.primaryHeadline1Style(AppColors.kLightColor),
        headline2: TextStyles.primaryHeadline2Style(AppColors.kLightColor),
      ),
      highlightColor: AppColors.highlightDark,
      textSelectionTheme:
          TextSelectionThemeData(cursorColor: AppColors.kLightColor),
    );
  }
}

ThemeData getCalendarTheme(BuildContext context) {
  if (EasyDynamicTheme.of(context).themeMode == ThemeMode.light) {
    return ThemeData.light().copyWith(
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryColorLight,
        onPrimary: Colors.white,
        surface: AppColors.kLightColor,
        onSurface: AppColors.primaryColorLight,
      ),
      dialogBackgroundColor: AppColors.kLightColor,
      inputDecorationTheme: const InputDecorationTheme(
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.primaryColorLight,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(color: AppColors.primaryColorLight, width: 1.0),
        ),
      ),
    );
  } else {
    return ThemeData.light().copyWith(
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryColorLight,
        onPrimary: Colors.white,
        surface: AppColors.chatBGDark,
        onSurface: AppColors.kLightColor,
      ),
      dialogBackgroundColor: AppColors.chatBGDark,
      inputDecorationTheme: const InputDecorationTheme(
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.primaryColorLight,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(color: AppColors.primaryColorLight, width: 1.0),
        ),
      ),
    );
  }
}
