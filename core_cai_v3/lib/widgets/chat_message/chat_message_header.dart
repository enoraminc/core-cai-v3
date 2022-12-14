import 'package:flutter/material.dart';

import '../../functions/custom_function.dart';

class ChatMessageHeader extends StatelessWidget {
  final Widget leadingWidget;
  final Widget title;
  final Widget subTitle;
  final List<Widget> actions;
  final bool backButton;
  final bool Function(BuildContext) isMobile;
  const ChatMessageHeader(
      {Key? key,
      required this.leadingWidget,
      required this.title,
      required this.subTitle,
      this.isMobile = CustomFunctions.isMobile,
      this.backButton = true,
      this.actions = const []})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      titleSpacing: 0.0,
      title: Row(
        children: [
          (isMobile(context) && backButton)
              ? IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              : const SizedBox(
                  width: 10.0,
                ),
          leadingWidget,
          const SizedBox(width: 10.0),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                title,
                // Text(
                //   title,
                //   style: Theme.of(context).textTheme.bodyText1,
                //   maxLines: 1,
                //   overflow: TextOverflow.ellipsis,
                // ),
                subTitle,
              ],
            ),
          )
        ],
      ),
      actions: actions,
    );
  }
}
