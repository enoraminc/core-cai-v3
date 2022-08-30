// import 'dart:js' as js;
import 'dart:html' as html;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

TextSpan buildCommentText(
    {BuildContext? context,
    String? text,
    Map<String, dynamic>? taggedUsers,
    TextStyle? dynaStyle,
    TextStyle? mentionStyle,
    Color linkColor = const Color(0xFF4acb08)}) {
  var children = <InlineSpan>[];
  String? _pattern = (taggedUsers != null)
      ? "(${taggedUsers.keys.map((key) => RegExp.escape(key)).join('|')})"
      : null;
  text!.splitMapJoin(
    RegExp('$_pattern'),
    onMatch: (Match match) {
      try {
        if (taggedUsers != null && taggedUsers.isNotEmpty) {
          final mention = taggedUsers[match[0]!] ??
              taggedUsers[taggedUsers.keys.firstWhere((element) {
                final reg = RegExp(element);

                return reg.hasMatch(match[0]!);
              })]!;

          children.add(
            TextSpan(
                text: (mention["text"] != null)
                    ? mention["text"]
                    : mention.toString(),
                style: (mention["text"] != null &&
                        mention["text"].toString().contains(":"))
                    ? TextStyle(
                        color: linkColor, decoration: TextDecoration.underline)
                    : TextStyle(color: linkColor),
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    if (mention["text"] != null &&
                        mention["text"].toString().contains(":")) {
                      String url = mention["linkData"].toString();
                      html.window.open(url, "_blank");
                      // js.context.callMethod("open", [url]);
                    }
                  }),
          );
        }
      } catch (e) {}

      return '';
    },
    onNonMatch: (String text) {
      if (text.contains("http") ||
          text.contains(".com") ||
          text.contains(".in") ||
          text.contains(".net")) {
        children.add(
          TextSpan(
            text: text,
            style: TextStyle(
                color: linkColor, decoration: TextDecoration.underline),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                html.window.open(text, "_blank");
                // js.context.callMethod("open", [text]);
              },
          ),
        );
      } else {
        children.add(TextSpan(
          text: text,
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ));
      }

      return '';
    },
  );

  return TextSpan(children: children);
}
