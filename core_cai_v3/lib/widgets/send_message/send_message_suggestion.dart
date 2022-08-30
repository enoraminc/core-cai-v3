import 'dart:async';
// import 'dart:html' as html;
import 'dart:typed_data';

import '../../functions/custom_function.dart';
import '../../widgets/send_message/flutter_mention/flutter_mentions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SendMessageSuggestionWidget extends StatefulWidget {
  final TextEditingController? textController;
  final FocusNode? textNode;
  final bool? enable;
  final Widget? actionsWidget;
  final Function(Map<String, dynamic> textData)? onSend;
  final Function? onSelectImage;
  final Function? onSelectFile;
  final String? hintText;
  final Function? onPasteData;
  final Widget? trailing;
  final FocusNode? sendNode;
  final Function(
    String fileType,
    Uint8List bytes,
    String fileName,
  )? onDropImage;
  final List<Mention> mentions;
  AnnotationEditingController? sendMessageController;
  final Function()? onTapGoogleMeet;
  final FocusNode focusNode;
  final Widget? leadingIcon;
  List<TextInputFormatter>? inputFormatters;
  final Function() onTap;
  final bool autoFocus;

  SendMessageSuggestionWidget({
    Key? key,
    @required this.textController,
    @required this.textNode,
    @required this.onSelectImage,
    this.enable,
    this.actionsWidget,
    @required this.onSend,
    this.hintText = "Write something",
    this.onPasteData,
    this.trailing,
    this.sendNode,
    this.onDropImage,
    this.mentions = const [],
    this.sendMessageController,
    this.onTapGoogleMeet,
    required this.focusNode,
    this.onSelectFile,
    this.leadingIcon,
    this.inputFormatters,
    required this.onTap,
    this.autoFocus = true,
  }) : super(key: key);

  @override
  _SendMessageSuggestionWidgetState createState() =>
      _SendMessageSuggestionWidgetState();
}

class _SendMessageSuggestionWidgetState
    extends State<SendMessageSuggestionWidget> {
  final ScrollController _controller = ScrollController();
  String _pattern = '';
  OverlayEntry? _overlayEntry;
  LengthMap? _selectedMention;
  ValueNotifier<bool> showSuggestions = ValueNotifier(false);

  Map<String, Annotation> mapToAnnotation() {
    final data = <String, Annotation>{};

    // Loop over all the mention items and generate a suggestions matching list
    widget.mentions.forEach((element) {
      // if matchAll is set to true add a general regex patteren to match with
      if (element.matchAll) {
        data['${element.trigger}([A-Za-z0-9])*'] = Annotation(
          style: element.style,
          id: null,
          display: null,
          trigger: element.trigger,
          disableMarkup: element.disableMarkup,
          markupBuilder: element.markupBuilder,
          linkData: null,
        );
      }

      element.data.forEach(
        (e) => data["${element.trigger}${e['display']}"] = e['style'] != null
            ? Annotation(
                style: e['style'],
                id: e['id'],
                display: e['display'],
                trigger: element.trigger,
                disableMarkup: element.disableMarkup,
                markupBuilder: element.markupBuilder,
                linkData: e['linkData'],
              )
            : Annotation(
                style: element.style,
                id: e['id'],
                display: e['display'],
                trigger: element.trigger,
                disableMarkup: element.disableMarkup,
                markupBuilder: element.markupBuilder,
                linkData: e['linkData'],
              ),
      );
    });

    return data;
  }

  @override
  void initState() {
    final data = mapToAnnotation();
    widget.sendMessageController!.addListener(suggestionListener);
    widget.sendMessageController!.addListener(inputListeners);
    // WidgetsBinding.instance?.addPostFrameCallback(
    //     (_) => FocusScope.of(context).requestFocus(widget.textNode));
    super.initState();
  }

  void suggestionListener() {
    final cursorPos = widget.sendMessageController!.selection.baseOffset;

    if (cursorPos >= 0) {
      var _pos = 0;

      final lengthMap = <LengthMap>[];

      // split on each word and generate a list with start & end position of each word.
      widget.sendMessageController!.value.text
          .split(RegExp(r'(\s)'))
          .forEach((element) {
        lengthMap.add(
            LengthMap(str: element, start: _pos, end: _pos + element.length));

        _pos = _pos + element.length + 1;
      });

      final val = lengthMap.indexWhere((element) {
        _pattern = widget.mentions.map((e) => e.trigger).join('|');

        return element.end == cursorPos &&
            element.str.toLowerCase().contains(RegExp(_pattern));
      });

      showSuggestions.value = val != -1;
      if (mounted) {
        setState(() {
          _selectedMention = val == -1 ? null : lengthMap[val];
        });
      }
    }
  }

  void addMention(Map<String, dynamic> value, [Mention? list]) {
    final selectedMention = _selectedMention!;

    setState(() {
      _selectedMention = null;
    });

    final _list = widget.mentions
        .firstWhere((element) => selectedMention.str.contains(element.trigger));

    // find the text by range and replace with the new value.
    widget.sendMessageController!.text =
        widget.sendMessageController!.value.text.replaceRange(
      selectedMention.start,
      selectedMention.end,
      "${_list.trigger}${value['display']}${' '}",
    );

    // Move the cursor to next position after the new mentioned item.
    var nextCursorPosition =
        selectedMention.start + 1 + value['display']?.length as int? ?? 0;
    nextCursorPosition++;
    widget.sendMessageController!.selection =
        TextSelection.fromPosition(TextPosition(offset: nextCursorPosition));
  }

  void inputListeners() {}

  @override
  Widget build(BuildContext context) {
    final list = _selectedMention != null
        ? widget.mentions.firstWhere(
            (element) => _selectedMention!.str.contains(element.trigger))
        : widget.mentions[0];
    return
        // DropZone(
        // onDragEnter: () {
        //   print('drag enter');
        // },
        // onDragExit: () {
        //   print('drag exit');
        // },
        // onDrop: (List<html.File>? files) async {
        //   if (files != null) {
        //     var reader = html.FileReader()..readAsArrayBuffer(files[0]);
        //     await reader.onLoadEnd.first;
        //     print(files[0].name);
        //     print(files[0].type);
        //     Uint8List list = reader.result as Uint8List;
        //     widget.onDropImage!(files[0].type, list, files[0].name);
        //   }
        // },
        // child:
        SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).appBarTheme.backgroundColor,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(width: 8.0),
                            if (widget.leadingIcon != null) widget.leadingIcon!,
                            const SizedBox(width: 8.0),
                            Expanded(
                              child: RawKeyboardListener(
                                onKey: _handleKeyEvent,
                                focusNode: widget.focusNode,
                                child: TextField(
                                  onTap: widget.onTap,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  enabled: widget.enable,
                                  controller: widget.sendMessageController,
                                  style: Theme.of(context)
                                      .primaryTextTheme
                                      .bodyText1,
                                  decoration: InputDecoration(
                                    hintText: widget.hintText,
                                    border: InputBorder.none,
                                    hintStyle: Theme.of(context)
                                        .inputDecorationTheme
                                        .hintStyle,
                                  ),
                                  cursorColor: Theme.of(context).cursorColor,
                                  onSubmitted: (String str) {
                                    widget.onSend!;
                                  },
                                  maxLines: 5,
                                  minLines: 1,
                                  focusNode: widget.textNode,
                                  inputFormatters: widget.inputFormatters,
                                  autofocus: widget.autoFocus,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                widget.onSelectFile!();
                              },
                              child: Icon(
                                Icons.attach_file,
                                color: Theme.of(context).iconTheme.color,
                              ),
                            ),
                            SizedBox(
                              width: 6,
                            ),
                            InkWell(
                              onTap: () {
                                widget.onSelectImage!();
                              },
                              child: Icon(
                                Icons.camera_alt,
                                color: Theme.of(context).iconTheme.color,
                              ),
                            ),
                            const SizedBox(width: 8.0)
                          ],
                        ),
                      ),
                    ),
                    if (MediaQuery.of(context).size.width < 600) ...[
                      const SizedBox(width: 5.0),
                      InkWell(
                        onTap: () {
                          widget.onSend!({});
                        },
                        child: Icon(
                          Icons.send,
                          color: Theme.of(context).iconTheme.color,
                        ),
                      ),
                      const SizedBox(width: 8.0)
                    ],
                  ],
                ),
                ValueListenableBuilder(
                  valueListenable: showSuggestions,
                  builder: (BuildContext context, bool show, Widget? child) {
                    Timer.run(
                      () => showHideMentionList(context,
                          (show && list.data.isNotEmpty == true), list),
                    );
                    return const Text("");
                  },
                ),
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            )
            // ),
            );
  }

  void _handleKeyEvent(event) {
    final RawKeyEventData data = event.data;
    var unknownKey = '';
    for (ModifierKey modifier in data.modifiersPressed.keys) {
      for (KeyboardSide side in KeyboardSide.values) {
        if (data.isModifierPressed(modifier, side: side)) {
          var alienKey =
              '${_getEnumName(side)}${_getEnumName(modifier).replaceAll('Modifier', '')}';
          unknownKey = '$unknownKey$alienKey';
        }
      }
    }
    var ctrlPressed = event.isKeyPressed(LogicalKeyboardKey.control) ||
        unknownKey.contains(RegExp(r'(control|meta)'));
    var isV = event.logicalKey == LogicalKeyboardKey.keyV;
    if (ctrlPressed && isV) {
      // do stuff
      widget.onPasteData!();
      return;
    }
  }

  String _getEnumName(dynamic enumItem) {
    final String name = '$enumItem';
    final int index = name.indexOf('.');
    return index == -1 ? name : name.substring(index + 1);
  }

  OverlayEntry createOverlayEntry(
      BuildContext context, Mention mentions, bool isError) {
    final screenWidth = MediaQuery.of(context).size.width;
    return OverlayEntry(
      builder: (context) => Material(
        elevation: 10.0,
        borderRadius: BorderRadius.circular(10),
        color: Colors.transparent,
        shadowColor: Colors.transparent,
        child: GestureDetector(
          onTap: () {
            try {
              _overlayEntry?.remove();
            } catch (e) {
              print(e.toString());
              print("Error while removing _overlayEntry");
            }
          },
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  color: Colors.transparent,
                ),
              ),
              Positioned(
                bottom: MediaQuery.of(context).viewInsets.bottom + 75,
                width: MediaQuery.of(context).size.width - 20,
                left: 10,
                top: 5,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: CustomFunctions.getMediaWidth(context),
                    child: Row(
                      children: [
                        if (MediaQuery.of(context).size.width > 600)
                          SizedBox(
                            width: screenWidth * 0.25,
                            child: const Text(""),
                          ),
                        SizedBox(
                          width: ((CustomFunctions.getMediaWidth(context) / 2) -
                              5),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 25, right: 25, bottom: 0),
                            child: OptionList(
                              suggestionListHeight: 300,
                              suggestionBuilder: mentions.suggestionBuilder,
                              data: mentions.data.where((element) {
                                final ele = element['display'].toLowerCase();
                                final str = _selectedMention?.str
                                    .toLowerCase()
                                    .replaceAll(RegExp(_pattern), '');

                                return ele == str ? false : ele.contains(str);
                              }).toList(),
                              onTap: (value) {
                                addMention(value, mentions);
                                showSuggestions.value = false;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showHideMentionList(BuildContext con, bool isShow, Mention mentions) {
    if (isShow) {
      try {
        try {
          _overlayEntry?.remove();
        } catch (e) {}
        _overlayEntry = createOverlayEntry(con, mentions, false);
        Overlay.of(con)!.insert(_overlayEntry!);
      } catch (e) {
        _overlayEntry = createOverlayEntry(con, mentions, false);
        Overlay.of(con)!.insert(_overlayEntry!);
      }
    } else {
      try {
        _overlayEntry?.remove();
      } catch (e) {
        print(e.toString());
        print("Error while removing _overlayEntry");
      }
    }
  }

  @override
  void didUpdateWidget(widget) {
    super.didUpdateWidget(widget);

    widget.sendMessageController!.mapping = mapToAnnotation();
  }
}
