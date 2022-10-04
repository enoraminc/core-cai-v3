import 'dart:convert';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:core_cai_v3/model/chat_user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progress_indicators/progress_indicators.dart';
import '../bloc/chat_message/chat_message_bloc.dart';
import '../functions/app_colors.dart';
import '../functions/commons_utils.dart';
import '../functions/constant_image.dart';
import '../functions/custom_function.dart';
import '../functions/helpers.dart';
import '../functions/strings.dart';
import '../model/chat_message.dart';
import '../widget_utils/dropzone_widget.dart';
import '../widgets/bottom_sheet/bottom_sheet.dart';
import '../widgets/chat_item_screen.dart';
import '../widgets/chat_message/chat_message_header.dart';
import '../widgets/chat_message/chat_message_widget.dart';
import '../widgets/chat_message/chat_messages_widget.dart';
import '../widgets/search/sidebar_search.dart';
import '../widgets/send_message/flutter_mention/flutter_mentions.dart';
import '../widgets/send_message/send_message_suggestion.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

abstract class BaseChatScreen<S extends StatefulWidget> extends State<S>
    with SingleTickerProviderStateMixin {
  late final FocusNode focusNode = FocusNode(onKey: handleKeyPress);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController =
      ScrollController(initialScrollOffset: 0.0);

  final ImagePicker _picker = ImagePicker();
  List<XFile> selectedImages = [];

  String messageType = ChatMessage.string;

  Uint8List? selectedFile;
  String? selectedFileName;
  String? selectedFileType;
  AnnotationEditingController sendMessageController =
      AnnotationEditingController({});
  bool isActivityWidget = false;

  // Input
  Builder builder({required Widget child});
  String currentChatId();
  Widget floatingActionsWidget();
  Widget detailContentsWidget();
  Widget appBar();
  Widget getCustomMessageChatWidget(String msgType, ChatMessage message);

  ChatUser? getUser();
  Future<String?> uploadMediaMessage(Uint8List data,
      [String extension = "png"]);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        FocusScope.of(context).requestFocus(FocusNode());
        return false;
      },
      child: builder(
        child: Scaffold(
          key: _scaffoldKey,
          drawerEdgeDragWidth: 0,
          floatingActionButton: floatingActions(),
          body: _buildChat(),
        ),
      ),
    );
  }

  _sendMessage(ChatMessage message, ChatUser user) {
    // print("send message");
    context.read<ChatMessageBloc>().add(
          CreateMessage(
            message: message,
            contentPath: currentChatId(),
            user: user,
            locale: '',
            selectedFileName: selectedFileName,
            selectedFileType: selectedFileType,
            selectedFiles: selectedFile,
            selectedImages: selectedImages,
          ),
        );
    setState(() {
      sendMessageController.clear();
      // focusNode.canRequestFocus = true;
      selectedFile = null;
      selectedImages = [];
      selectedFileName = null;
      selectedFileType = null;
      messageType = ChatMessage.string;
    });
  }

  /// Show snackbar with this function
  void showSnackBar(
    String message, {
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor:
              isError ? Colors.red : Theme.of(context).colorScheme.secondary,
          content: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  Widget floatingActions() {
    return Builder(builder: (context) {
      return Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * 0.1),
            child: floatingActionsWidget(),
          ),
        ],
      );
    });
  }

  showDetailContent() async {
    await showCustomBottomSheet(
      context,
      title: "Detail",
      body: (BuildContext context, StateSetter setState) {
        return detailContentsWidget();
      },
    );
  }

  Widget _buildChat() {
    return Builder(builder: (context) {
      final isLoading = context
          .select((ChatMessageBloc element) => element.state.isLoadingSend);
      return Container(
        color: Theme.of(context).backgroundColor,
        child: Column(
          children: [
            appBar(),
            Expanded(child: _buildMessagesList()),
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (selectedImages.isEmpty == false &&
                      messageType == ChatMessage.image)
                    getMediaThumbnail(),
                  if (selectedFile != null &&
                      messageType == ChatMessage.msgFile)
                    getMediaFile(),
                  if (selectedFile != null && messageType == ChatMessage.video)
                    getMediaFile(),
                  // if (isLoading) ...[
                  //   const Text(""),
                  //   Align(
                  //     alignment: Alignment.bottomRight,
                  //     child: Padding(
                  //       padding: const EdgeInsets.only(right: 20),
                  //       child: JumpingDotsProgressIndicator(
                  //         fontSize: 40.0,
                  //         color: AppColors.primaryColorLight,
                  //       ),
                  //     ),
                  //   ),
                  // ],
                ],
              ),
            ),
            // Container(
            //   height: 70,
            //   width: double.infinity,
            //   color: Colors.red,
            // ),
            const SizedBox(
              height: 8,
            ),
            // currentUser != null ?
            _buildMessageComposer()
            //  : Container(),
          ],
        ),
      );
    });
  }

  Widget _buildMessagesList() {
    return Builder(
      builder: (context) {
        final messages =
            context.select((ChatMessageBloc element) => element.state.messages);

        return ChatMessagesWidget<ChatMessage>(
          scrollController: _scrollController,
          messages: messages,
          isDisplayDateHeader: (int index) =>
              isDisplayDateHeader(index, messages),
          chatMessageWidget: (ChatMessage message, {required int index}) {
            return ChatMessageWidget(
              message,
              const [],
              getUser(),
              getCustomChatMessageWidget: getCustomMessageChatWidget,
            );
          },
        );
      },
    );
  }

  Widget? isDisplayDateHeader(int index, List<ChatMessage> messages) {
    if (index > 0) {
      DateFormat format = DateFormat("dd-MM-yyyy hh:mm a");
      DateTime currentDate = format
          .parse(format.format(DateTime.fromMillisecondsSinceEpoch(
              messages[index].createdAt as int)))
          .toLocal();
      DateTime earlyDate = format
          .parse(format.format(DateTime.fromMillisecondsSinceEpoch(
              messages[index - 1].createdAt as int)))
          .toLocal();
      if (currentDate.day < earlyDate.day) {
        return Container(
          margin: const EdgeInsets.fromLTRB(0, 6, 0, 2),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: const Color(0xff329688),
          ),
          child: Text(
            CommonUtils.chatDateHeader(currentDate, earlyDate),
            style: const TextStyle(color: Colors.white),
          ),
        );
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  Widget contentTitle() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            "",
            style:
                Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: 15),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  showCustomDialog({
    required String title,
    required String description,
    required Function onTap,
  }) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Theme.of(context).backgroundColor,
              title: Align(
                alignment: Alignment.topLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        InkWell(
                          child: const Icon(
                            Icons.close,
                            color: Color(0xff329688),
                          ),
                          onTap: () {
                            Navigator.of(context).pop(context);
                          },
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                      child: Divider(
                        thickness: 1.0,
                        height: 1.0,
                        color: Color(0xff329688),
                      ),
                    )
                  ],
                ),
              ),
              content: SizedBox(
                width: 600,
                height: 80,
                child: Text(
                  description,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              actions: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(context);
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () {
                    onTap();
                    Navigator.of(context).pop(context);
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(),
                    child: Text(
                      "Yes",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildMessageComposer() {
    return Builder(builder: (context) {
      final isLoading = context
          .select((ChatMessageBloc element) => element.state.isLoadingSend);
      return DropZoneWidget(
        onDropImage: onDropImage,
        widget: SendMessageSuggestionWidget(
          autoFocus: false,
          onSelectImage: () {
            onSelectImageClick();
          },
          onSelectFile: () {
            onSelectFileClick();
          },
          textController: sendMessageController,
          textNode: focusNode,
          onSend: (Map<String, dynamic> textData) {
            onSendTextMessage();
          },
          inputFormatters: [
            UpperCaseTextFormatter(),
          ],
          sendMessageController: sendMessageController,
          enable: true,
          mentions: [
            Mention(
              disableMarkup: true,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              markupBuilder: (String txt1, String txt3, String txt2) {
                return "";
              },
              trigger: "@",
              suggestionBuilder: (Map<String, dynamic> data) {
                return Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).appBarTheme.backgroundColor,
                    border: Border(
                      bottom: BorderSide(
                        width: 1,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                  ),
                  padding: const EdgeInsets.only(left: 15, top: 5, bottom: 5),
                  child: Row(
                    children: [
                      (data['photo'] != null && data['photo'].isNotEmpty)
                          ? Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: CircleAvatar(
                                radius: 12,
                                backgroundColor: Colors.grey.shade800,
                                backgroundImage: NetworkImage(data['photo']),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: CircleAvatar(
                                backgroundColor: Colors.grey.shade800,
                                radius: 12,
                                child: Text(
                                  data['display'][0],
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                              ),
                            ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 18),
                          child: Text(data['display'],
                              style: Theme.of(context).textTheme.subtitle1),
                        ),
                      )
                    ],
                  ),
                );
              },
              data: [],
            ),
          ],
          onDropImage: (String fileType, Uint8List bytes, String fileName) {
            onDropImage(fileType, bytes, fileName);
          },
          onPasteData: () {
            onPasteImage();
          },
          onTap: () {},
          focusNode: FocusNode(),
        ),
      );
    });
  }

  onDropImage(String fileType, Uint8List bytes, String fileName) {
    if (Strings.imageTypes.contains(fileType.toLowerCase())) {
      setState(() {
        selectedImages.add(XFile.fromData(bytes, name: fileName));
        messageType = ChatMessage.image;
        selectedFile = null;
        selectedFileName = "";
        selectedFileType = "";
      });
    } else {
      setState(() {
        selectedFile = bytes;
        messageType = ChatMessage.msgFile;
        selectedFileName = fileName;
        selectedFileType = fileType;
        selectedImages = [];
      });
    }
  }

  onSelectImageClick() {
    Helpers.showSelectMediaDialog(context, Strings.pick_photo_title, () async {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        setState(() {
          selectedImages.add(image);
          messageType = ChatMessage.image;
          selectedFileName = image.name;
          selectedFileType = image.mimeType;
          selectedFile == null;
        });
      }
    }, () async {
      final List<XFile>? image = await _picker.pickMultiImage();
      if (image != null) {
        setState(() {
          selectedImages.addAll(image);
          messageType = ChatMessage.image;
          // selectedFileName = image.name;
          // selectedFileType = image.mimeType;
          selectedFile == null;
        });
      }
    });
  }

  onSelectFileClick() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      withData: true,
      type: FileType.any,
    );

    if (result != null) {
      if (Strings.imageTypes
          .contains(result.files.first.extension?.toLowerCase())) {
        setState(() {
          selectedImages.add(XFile.fromData(result.files.first.bytes!,
              name: result.files.first.name));
          messageType = ChatMessage.image;
          selectedFile = null;
          selectedFileName = result.files.first.name;
          selectedFileType = result.files.first.extension;
        });
      } else if (Strings.videoTypes
          .contains(result.files.first.extension!.toLowerCase())) {
        print("======result.files.first.extension=========");
        setState(() {
          selectedFile = result.files.first.bytes;
          messageType = ChatMessage.video;
          selectedFileName = result.files.first.name;
          selectedFileType = result.files.first.extension;
          selectedImages = [];
        });
      } else {
        setState(() {
          selectedFile = result.files.first.bytes;
          messageType = ChatMessage.msgFile;
          selectedFileName = result.files.first.name;
          selectedFileType = result.files.first.extension;
          print(result.files.first.name);
          print(result.files.first.extension);
          selectedImages = [];
        });
      }
    } else {
      // User canceled the picker
    }
  }

  Widget getMediaThumbnail() {
    return SizedBox(
      width: MediaQuery.of(context).size.width > 600
          ? (CustomFunctions.getMediaWidth(context) / 1.8)
          : CustomFunctions.getMediaWidth(context) - 75,
      height: CustomFunctions.isMobile(context) ? 80 : 110,
      child: ListView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: [
          ...selectedImages.map((e) {
            return Stack(children: [
              Container(
                margin: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  border: Border.all(width: 2),
                ),
                child: FutureBuilder<Image>(
                  future: getImageThumbnail(e),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return snapshot.data!;
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                ),
              ),
              Positioned(
                  right: 0,
                  child: InkWell(
                    onTap: () => {
                      setState(() {
                        if (e == selectedImages.first) {
                          messageType = ChatMessage.string;
                        }
                        selectedImages.remove(e);
                        // messageType = ChatMessage.string;
                        selectedFileName = null;
                        selectedFileType = null;
                      }),
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: AppColors.kLightColor,
                          border: Border.all(color: AppColors.kLightColor),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(12),
                          )),
                      child: SvgPicture.asset(
                        ConstantImages.crossIcon,
                        width: 16,
                      ),
                    ),
                  ))
            ]);
          }).toList(),
        ],
      ),
    );
  }

  Widget getMediaFile() {
    return Stack(
      children: [
        Container(
          height: CustomFunctions.isMobile(context) ? 75 : 100,
          width: CustomFunctions.isMobile(context) ? 75 : 100,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).appBarTheme.backgroundColor),
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.insert_drive_file_outlined,
                color: Theme.of(context).iconTheme.color,
                size: CustomFunctions.isMobile(context) ? 18 : 32,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                selectedFileName!,
                style: Theme.of(context).textTheme.subtitle1,
                maxLines: 1,
              ),
            ],
          ),
        ),
        Positioned(
          right: 0,
          child: InkWell(
            onTap: () => {
              setState(() {
                selectedFile = null;
                selectedFileName = null;
                selectedFileType = null;
                messageType = ChatMessage.string;
              }),
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                  color: AppColors.kLightColor,
                  border: Border.all(color: AppColors.kLightColor),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(12),
                  )),
              child: SvgPicture.asset(
                ConstantImages.crossIcon,
                width: 16,
              ),
            ),
          ),
        )
      ],
    );
  }

  Future<Image> getImageThumbnail(XFile file) async {
    final Uint8List? bytes = await file.readAsBytes();
    return Image.memory(
      bytes!,
      height: CustomFunctions.isMobile(context) ? 75 : 100,
      width: CustomFunctions.isMobile(context) ? 75 : 100,
      fit: BoxFit.cover,
    );
  }

  KeyEventResult handleKeyPress(FocusNode focusNode, RawKeyEvent event) {
    // handles submit on enter
    if (kIsWeb &&
        (event.isKeyPressed(LogicalKeyboardKey.enter) ||
            event.isKeyPressed(LogicalKeyboardKey.numpadEnter)) &&
        !event.isControlPressed &&
        !event.isShiftPressed) {
      onSendTextMessage();
      return KeyEventResult.handled;
    }

    if (kIsWeb &&
        (event.isKeyPressed(LogicalKeyboardKey.control)) &&
        (event.isKeyPressed(LogicalKeyboardKey.keyV))) {
      // onPasteImage();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  Widget unselectedChatWidget(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ClipRRect(
          //   borderRadius: BorderRadius.circular(300),
          //   child: Image.asset(
          //     "CAI",
          //   ),
          // ),
          // const SizedBox(
          //   height: 20,
          // ),
          Text(
            "No Content Selected",
            style: Theme.of(context).textTheme.bodyText1,
          )
        ],
      ),
    );
  }

  void onPasteImage() {
    print("===onPasteImage======onPasteImage======");
    var data = CommonUtils.getCopyPasteData();
    if (data != null) {
      var base64Data = data.split(",")[1];
      var imageType = data.split(",")[0].split("/")[1].split(";")[0];
      Uint8List decoded = base64Decode(base64Data);
      String imageName = "${DateTime.now().microsecondsSinceEpoch}.$imageType";
      if (!selectedImages.contains(XFile.fromData(decoded, name: imageName))) {
        setState(() {
          print("setting state");
          selectedImages.add(XFile.fromData(decoded, name: imageName));
          messageType = ChatMessage.image;
          selectedFile = null;
          selectedFileName = null;
          selectedFileType = null;
        });
      }
    }
  }

  Future<void> onSendTextMessage() async {
    final currentUser = getUser();
    if (currentUser == null) {
      showSnackBar("Login required to send message", isError: true);
      return;
    }
    if (messageType == ChatMessage.string &&
        sendMessageController.text.trim().isEmpty == false) {
      sendTextMessage(currentUser);
    } else if (messageType == ChatMessage.image) {
      sendImageMessage(currentUser);
    } else if (messageType == ChatMessage.msgFile) {
      sendFileMessage(currentUser);
    }
    // else if (messageType == ChatMessage.video) {
    //   sendVideoMessage(currentUser, selectedGround);
    // }
  }

  void sendTextMessage(ChatUser user) {
    final textData = sendMessageController.text;
    ChatMessage chatMessage = ChatMessage(
      msgType: ChatMessage.string,
      user: user,
      text: textData,
      textWithMention: textData,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      fileUrl: null,
      users: [],
      fileName: null,
      fileType: null,
    );
    _sendMessage(chatMessage, user);
  }

  Future<void> sendImageMessage(ChatUser user) async {
    // addChatMessageBloc.add(ShowLoadingEvent(true));
    final textData = sendMessageController.text;
    List<Uint8List> attachmentImagesCached = [];
    for (XFile imageFile in selectedImages) {
      final Uint8List bytes = await imageFile.readAsBytes();
      attachmentImagesCached.add(bytes);
    }

    ChatMessage chatMessage = ChatMessage(
      msgType: ChatMessage.image,
      user: user,
      textWithMention: textData,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      fileUrl: null,
      users: [],
      fileName: selectedFileName,
      fileType: selectedFileType,
      imageCacheList: attachmentImagesCached,
    );
    _sendMessage(chatMessage, user);
  }

  Future<void> sendFileMessage(ChatUser user) async {
    final textData = sendMessageController.text;

    ChatMessage chatMessage = ChatMessage();
    chatMessage = ChatMessage(
      msgType: ChatMessage.msgFile,
      user: user,
      text: textData,
      textWithMention: textData,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      users: [],
      fileName: selectedFileName,
      fileType: selectedFileType,
    );
    _sendMessage(chatMessage, user);
  }
}

class FloatingButton extends StatelessWidget {
  final String title;
  final Function() onTap;
  final IconData icon;

  const FloatingButton({
    Key? key,
    required this.title,
    required this.onTap,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
      tooltip: title,
      hoverElevation: 0.0,
      elevation: 0.0,
      backgroundColor: AppColors.primaryColorLight,
      onPressed: onTap,
      heroTag: title.trim().toLowerCase(),
      child: Icon(
        icon,
        color: AppColors.kLightColor,
      ),
    );
  }
}
