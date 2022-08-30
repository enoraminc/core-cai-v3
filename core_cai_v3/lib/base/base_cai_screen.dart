import 'package:flutter/material.dart';

import '../functions/app_colors.dart';
import '../functions/custom_function.dart';

class BaseCaiScreen extends StatelessWidget {
  const BaseCaiScreen(
      {Key? key, this.sidebarWidget, this.mainWidget, this.isMobile = false})
      : super(key: key);
  final Widget? sidebarWidget;
  final Widget? mainWidget;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: CustomFunctions.isDarkTheme(context)
          ? AppColors.fullBackgroundDark
          : AppColors.kLightColor,
      child: Align(
        alignment: Alignment.center,
        child: Container(
          width: CustomFunctions.getMediaWidth(context),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColorDark,
            boxShadow: !CustomFunctions.isDarkTheme(context)
                ? [
                    const BoxShadow(color: Colors.grey, blurRadius: 5.0),
                  ]
                : null,
          ),
          child: isMobile
              ? sidebarWidget
              : Row(
                  children: [
                    if (sidebarWidget != null) sidebarWidget!,
                    if (mainWidget != null) Expanded(child: mainWidget!)
                  ],
                ),
        ),
      ),
    ));
  }
}
