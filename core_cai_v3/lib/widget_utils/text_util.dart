// import 'dart:html' as html;
// import 'dart:js' as js;

import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

Widget chatText(String text, BuildContext context) {
  return EasyRichText(
    text,
    selectable: true,
    defaultStyle: Theme.of(context).textTheme.bodyText2,
    patternList: [
      EasyRichTextPattern(
        targetString: EasyRegexPattern.emailPattern,
        urlType: 'email',
        style: Theme.of(context).textTheme.headline1,
        matchBuilder: (BuildContext context, RegExpMatch? match) {
          if (match == null) {
            return TextSpan(
              text: "",
              style: Theme.of(context).textTheme.headline1,
            );
          }
          return TextSpan(
              text: match[0],
              mouseCursor: SystemMouseCursors.click,
              style: Theme.of(context).textTheme.headline1,
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  _launchURL("mailto:${match[0]}");
                });
        },
      ),
      EasyRichTextPattern(
        targetString: EasyRegexPattern.webPattern,
        urlType: 'website',
        matchBuilder: (BuildContext context, RegExpMatch? match) {
          if (match == null) {
            return TextSpan(
              text: "",
              style: Theme.of(context).textTheme.headline1,
            );
          }
          return TextSpan(
              text: match[0],
              style: Theme.of(context).textTheme.headline1,
              mouseCursor: SystemMouseCursors.click,
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  _launchURL(match[0]!);
                });
        },
        style: Theme.of(context).textTheme.headline1,
      ),
    ],
  );
}

_launchURL(String str) async {
  String url = str;
  // if (await canLaunch(url)) {
  //   await launch(url);
  // } else {
  //   if (!str.contains("https") || !str.contains("http")) {
  //     js.context.callMethod("open", ["https://" + str]);
  //   }
  // }
  await launchUrlString(url);
}

TextSpan buildCommentText(
    {required BuildContext context,
    String? text,
    Map<String, dynamic>? taggedUsers,
    TextStyle? dynaStyle,
    TextStyle? mentionStyle}) {
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
                    ? Theme.of(context).textTheme.headline1
                    : Theme.of(context).textTheme.headline1,
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    if (mention["text"] != null &&
                        mention["text"].toString().contains(":")) {
                      String url = mention["linkData"].toString();
                      print("====Mention Link Click=======");
                      print(url);
                      // html.window.open(url, "_blank");
                      await launchUrlString(url);
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
            style: Theme.of(context).textTheme.headline1,
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                // html.window.open(text, "_blank");
                await launchUrlString(text);
              },
          ),
        );
      } else {
        children.add(TextSpan(
          text: text,
          style: Theme.of(context).textTheme.bodyText2,
        ));
      }

      return '';
    },
  );

  return TextSpan(children: children);
}
