import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomFunctions {
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 1200;
  }

  static bool isDarkTheme(BuildContext context) {
    if (EasyDynamicTheme.of(context).themeMode == ThemeMode.dark) {
      return true;
    } else {
      return false;
    }
  }

  static double getMediaWidth(BuildContext context) {
    if (kIsWeb) {
      if (MediaQuery.of(context).size.width <= 600) {
        return MediaQuery.of(context).size.width;
      } else if (MediaQuery.of(context).size.width >= 600 &&
          MediaQuery.of(context).size.width <= 1200) {
        return 1000;
      } else if (MediaQuery.of(context).size.width >= 1200 &&
          MediaQuery.of(context).size.width <= 1600) {
        return 1200;
      } else {
        return 1450;
      }
    }

    return MediaQuery.of(context).size.width;
  }
}

class SizeConfig {
  static double _screenWidth = 0.0;
  static double _screenHeight = 0.0;
  static double _blockSizeHorizontal = 0;
  static double _blockSizeVertical = 0;

  static double textMultiplier = 0.0;
  static double imageSizeMultiplier = 0.0;
  static double heightMultiplier = 10;
  static double widthMultiplier = 0.0;
  static bool isPortrait = true;
  static bool isMobilePortrait = false;

  void init(BoxConstraints constraints, Orientation orientation) {
    if (orientation == Orientation.portrait) {
      _screenWidth = constraints.maxWidth;
      _screenHeight = constraints.maxHeight;
      isPortrait = true;
      if (_screenWidth < 450) {
        isMobilePortrait = true;
      }
    } else {
      _screenWidth = constraints.maxHeight;
      _screenHeight = constraints.maxWidth;
      isPortrait = false;
      isMobilePortrait = false;
    }

    _blockSizeHorizontal = _screenWidth / 100;
    _blockSizeVertical = _screenHeight / 100;

    textMultiplier = _blockSizeVertical;
    imageSizeMultiplier = _blockSizeHorizontal;
    heightMultiplier = _blockSizeVertical;
    widthMultiplier = _blockSizeHorizontal;

    print(_blockSizeHorizontal);
    print(_blockSizeVertical);
  }
}
