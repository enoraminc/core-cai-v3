part of flutter_mentions;

/// A custom implementation of [TextEditingController] to support @ mention or other
/// trigger based mentions.
class AnnotationEditingController extends TextEditingController {
  Map<String, Annotation> _mapping;
  String? _pattern;

  // Generate the Regex pattern for matching all the suggestions in one.
  AnnotationEditingController(this._mapping)
      : _pattern = _mapping.keys.isNotEmpty
            ? "(${_mapping.keys.map((key) => RegExp.escape(key)).join('|')})"
            : null;

  /// Can be used to get the markup from the controller directly.
  String get markupText {
    final someVal = _mapping.isEmpty
        ? text
        : text.splitMapJoin(
            RegExp('$_pattern'),
            onMatch: (Match match) {
              final mention = _mapping[match[0]!] ??
                  _mapping[_mapping.keys.firstWhere((element) {
                    final reg = RegExp(element);

                    return reg.hasMatch(match[0]!);
                  })]!;

              // Default markup format for mentions
              if (!mention.disableMarkup) {
                return mention.markupBuilder != null
                    ? mention.markupBuilder!(
                        mention.trigger, mention.id!, mention.display!)
                    : '${mention.trigger}[__${mention.id}__](__${mention.display}__)';
              } else {
                return match[0]!;
              }
            },
            onNonMatch: (String text) {
              return text;
            },
          );

    return someVal;
  }

  Map<String, dynamic> get getFullTextWithMention {
    Map<String, dynamic> respMap = Map<String, dynamic>();
    Map<String, dynamic> mentionUsers = Map<String, dynamic>();
    print("=====_pattern=====_pattern====_pattern====");
    print(_pattern);
    String fullText = "";
    String plainText = "";
    String commentText = "";
    _pattern = _mapping.keys.isNotEmpty
        ? "(${_mapping.keys.map((key) => RegExp.escape(key)).join('|')})"
        : null;
    final someVal = _mapping.isEmpty
        ? text
        : text.splitMapJoin(
            RegExp('$_pattern'),
            onMatch: (Match match) {
              final mention = _mapping[match[0]!] ??
                  _mapping[_mapping.keys.firstWhere((element) {
                    final reg = RegExp(element);

                    return reg.hasMatch(match[0]!);
                  })]!;
              fullText = fullText + mention.id!;
              plainText = plainText + mention.display!;

              if (mention.display!.contains(":")) {
                if (!mentionUsers.containsKey(mention.id!)) {
                  mentionUsers[mention.id!] = {
                    "text": mention.display!,
                    "linkData": mention.linkData!
                  };
                  commentText = commentText +
                      " <a href='${mention.linkData ?? ""}' target='_blank'> ${mention.display ?? ""} </a> ";
                }
              } else {
                if (!mentionUsers.containsKey(mention.id!)) {
                  // mentionUsers[mention.id!] = "@" + mention.display!;
                  mentionUsers[mention.id!] = {
                    "text": "@" + mention.display!,
                    "linkData": ""
                  };
                }
              }

              return "";
            },
            onNonMatch: (String text) {
              fullText = fullText + text;
              plainText = plainText + text;
              commentText = commentText + text;
              return text;
            },
          );
    respMap['text'] = fullText;
    respMap['mentions'] = mentionUsers;
    respMap['plainText'] = plainText;
    respMap['commentText'] = commentText;
    return respMap;
  }

  String get getFullText {
    String fullText = "";
    if (_mapping.isEmpty) {
      return text;
    }
    final someVal = _mapping.isEmpty
        ? text
        : text.splitMapJoin(
            RegExp('$_pattern'),
            onMatch: (Match match) {
              final mention = _mapping[match[0]!] ??
                  _mapping[_mapping.keys.firstWhere((element) {
                    final reg = RegExp(element);

                    return reg.hasMatch(match[0]!);
                  })]!;
              fullText = fullText + "@" + mention.id!;
              return "";
            },
            onNonMatch: (String text) {
              fullText = fullText + text;
              return text;
            },
          );
    return fullText;
  }

  Map<String, dynamic> get getAllMentions {
    Map<String, dynamic> mentionUsers = Map<String, dynamic>();
    final someVal = _mapping.isEmpty
        ? text
        : text.splitMapJoin(
            RegExp('$_pattern'),
            onMatch: (Match match) {
              final mention = _mapping[match[0]!] ??
                  _mapping[_mapping.keys.firstWhere((element) {
                    final reg = RegExp(element);

                    return reg.hasMatch(match[0]!);
                  })]!;

              if (!mentionUsers.containsKey(mention.id!)) {
                mentionUsers[mention.id!] = mention.display;
              }
              return "";
            },
            onNonMatch: (String text) {
              return text;
            },
          );
    return mentionUsers;
  }

  Map<String, Annotation> get mapping {
    return _mapping;
  }

  set mapping(Map<String, Annotation> _mapping) {
    this._mapping = _mapping;

    _pattern = "(${_mapping.keys.map((key) => RegExp.escape(key)).join('|')})";
  }

  @override
  TextSpan buildTextSpan(
      {BuildContext? context, TextStyle? style, bool? withComposing}) {
    var children = <InlineSpan>[];

    if (_pattern == null || _pattern == '()') {
      children.add(TextSpan(text: text, style: style));
    } else {
      text.splitMapJoin(
        RegExp('$_pattern'),
        onMatch: (Match match) {
          if (_mapping.isNotEmpty) {
            final mention = _mapping[match[0]!] ??
                _mapping[_mapping.keys.firstWhere((element) {
                  final reg = RegExp(element);

                  return reg.hasMatch(match[0]!);
                })]!;

            children.add(
              TextSpan(
                text: match[0],
                style: style!.merge(mention.style),
              ),
            );
          }

          return '';
        },
        onNonMatch: (String text) {
          children.add(TextSpan(text: text, style: style));
          return '';
        },
      );
    }

    return TextSpan(style: style, children: children);
  }
}
