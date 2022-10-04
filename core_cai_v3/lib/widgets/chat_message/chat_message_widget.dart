import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/chat_message/chat_message_bloc.dart';
import '../../functions/app_colors.dart';
import '../../functions/custom_function.dart';
import '../../functions/transparent_image.dart';
import '../../model/chat_message.dart';
import '../../model/chat_user.dart';
import '../../widget_utils/text_util.dart';
import '../../widgets/chat_message/chat_message_tile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatMessageWidget extends StatelessWidget {
  final ChatMessage message;
  final List<ChatMessage> deleteMessage;
  final ChatUser? currentUser;

  final Widget Function(String msgType, ChatMessage message)
      getCustomChatMessageWidget;

  const ChatMessageWidget(
    this.message,
    this.deleteMessage,
    this.currentUser, {
    Key? key,
    required this.getCustomChatMessageWidget,
  }) : super(key: key);

  Widget getMessageFileWidget(BuildContext context) {
    return ChatMessageFile(
      isCurrentUserMessage: currentUser?.uid == message.user?.uid,
      textMessage: getMessageTextWidget(context),
      messageDate: getMessageDateTime(),
      fileName: message.fileName ?? "",
      fileType: message.fileType ?? "",
      fileUrl: message.fileUrl ?? "",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: (deleteMessage.contains(message))
          ? AppColors.primaryColorLight.withOpacity(0.5)
          : null,
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      child: Row(
        mainAxisAlignment: (currentUser?.uid == message.user?.uid)
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (currentUser?.uid != message.user?.uid) ...[
            getMessageUserIcon(context, message.user ?? ChatUser()),
            const SizedBox(
              width: 10,
            ),
          ],
          Container(
            padding: const EdgeInsets.all(10.0),
            child: ClipRRect(
              child: getChatMessageWidget(context),
            ),
            constraints: BoxConstraints(
              maxWidth: CustomFunctions.isMobile(context)
                  ? ((CustomFunctions.getMediaWidth(context)) - 100)
                  : ((CustomFunctions.getMediaWidth(context) / 2) - 5),
            ),
            decoration: BoxDecoration(
                color: (!CustomFunctions.isDarkTheme(context))
                    ? (currentUser?.uid == message.user?.uid)
                        ? AppColors.kChatBackgroundColor
                        : AppColors.kGreyColor
                    : (currentUser?.uid == message.user?.uid)
                        ? AppColors.isMeChatWidgetDark
                        : AppColors.chatWidgetDark,
                borderRadius: BorderRadius.circular(12)),
          ),
          if (currentUser?.uid == message.user?.uid) ...[
            const SizedBox(
              width: 10,
            ),
            getMessageUserIcon(context, message.user ?? ChatUser()),
          ],
        ],
      ),
    );

    // InkWell(
    //   onLongPress: () {
    //     addDeleteChatMessage(context);
    //   },
    //   onTap: () {
    //     if (deleteMessage.isNotEmpty == true) {
    //       addDeleteChatMessage(context);
    //     }
    //   },
    //   child: Container(
    //     color: (deleteMessage.contains(message))
    //         ? AppColors.primaryColorLight.withOpacity(0.5)
    //         : null,
    //     margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
    //     child: Row(
    //       mainAxisAlignment: (currentUser?.id == message.user?.uid)
    //           ? MainAxisAlignment.end
    //           : MainAxisAlignment.start,
    //       crossAxisAlignment: CrossAxisAlignment.end,
    //       children: [
    //         if (currentUser?.id != message.user?.uid) ...[
    //           getMessageUserIcon(context, message.user!),
    //           const SizedBox(
    //             width: 10,
    //           ),
    //         ],
    //         Container(
    //           padding: const EdgeInsets.all(10.0),
    //           child: ClipRRect(
    //             child: getChatMessageWidget(context),
    //           ),
    //           constraints: BoxConstraints(
    //             maxWidth: CustomFunctions.isMobile(context)
    //                 ? ((CustomFunctions.getMediaWidth(context)) - 100)
    //                 : ((CustomFunctions.getMediaWidth(context) / 2) - 5),
    //           ),
    //           decoration: BoxDecoration(
    //               color: (!CustomFunctions.isDarkTheme(context))
    //                   ? (currentUser?.id == message.user?.uid)
    //                       ? AppColors.kChatBackgroundColor
    //                       : AppColors.kGreyColor
    //                   : (currentUser?.id == message.user?.uid)
    //                       ? AppColors.isMeChatWidgetDark
    //                       : AppColors.chatWidgetDark,
    //               borderRadius: BorderRadius.circular(12)),
    //         ),
    //         if (currentUser?.id == message.user?.uid) ...[
    //           const SizedBox(
    //             width: 10,
    //           ),
    //           getMessageUserIcon(context, message.user!),
    //         ],
    //       ],
    //     ),
    //   ),
    // );
  }

  void addDeleteChatMessage(BuildContext context) {
    // if(deleteMessage.isEmpty == true){
    //   context.read<ChatMessageBloc>().add(AddDeleteMessageEvent(message, false));
    //   return;
    // }
    if (currentUser?.uid == message.user?.uid) {
      if (message.isDeleted == false || message.isDeleted == null) {
        if (deleteMessage.contains(message)) {
          context
              .read<ChatMessageBloc>()
              .add(AddDeleteMessageEvent(message, true));
        } else {
          context
              .read<ChatMessageBloc>()
              .add(AddDeleteMessageEvent(message, false));
        }
      }
    }
  }

  Widget getMessageUserIcon(BuildContext context, ChatUser user) {
    if (user.avatar?.isEmpty == false) {
      return CircleAvatar(
        radius: 12,
        backgroundImage: NetworkImage(user.avatar ?? ""),
        backgroundColor: Theme.of(context).primaryColor,
      );
    }
    return CircleAvatar(
      radius: 12,
      backgroundColor: Theme.of(context).primaryColor,
      child: Text(user.name![0]),
    );
  }

  Widget getMessageDateTime() {
    return Wrap(
      spacing: 5,
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        message.isPending()
            ? Icon(
                Icons.access_time,
                size: 15,
              )
            : message.isFailed()
                ? Icon(
                    Icons.info_outline,
                    size: 15,
                    color: Colors.red,
                  )
                : Icon(
                    Icons.check,
                    size: 15,
                  ),
        Text(
          DateFormat('d MMM hh:mm a').format(
            (DateTime.fromMillisecondsSinceEpoch(
                (message.createdAt ?? 0).toInt())),
          ),
          style: const TextStyle(fontSize: 10, color: Colors.grey),
        ),
        // Text(
        //   (message.createdAt ?? 0).toString(),
        //   style: const TextStyle(fontSize: 10, color: Colors.grey),
        // ),
      ],
    );
  }

  Widget getChatMessageWidget(BuildContext context) {
    if (message.isDeleted == true) {
      return getDeleteMessageWidget(context);
    }
    if (message.msgType == ChatMessage.string) {
      return getChatMessageTextWidget(context);
    } else if (message.msgType == ChatMessage.image ||
        message.msgType == ChatMessage.both) {
      return getChatMessageImageWidget(context);
    } else if (message.msgType == ChatMessage.msgFile) {
      return getMessageFileWidget(context);
    } else {
      return getCustomChatMessageWidget(message.msgType ?? "", message);
    }
    // return Container();
  }

  Widget getTaskStatusTextWidget(BuildContext context) {
    return ChatMessageText(
      isCurrentUserMessage: currentUser?.uid == message.user?.uid,
      textMessage: getTaskStatusText(context),
      messageDate: getMessageDateTime(),
    );
  }

  Widget getTaskStatusText(BuildContext context) {
    if (currentUser?.uid == message.user?.uid) {
      return chatText("You ${message.text}", context);
    } else {
      return chatText("${message.user?.name ?? ""} ${message.text}", context);
    }
  }

  Widget getDeleteMessageWidget(BuildContext context) {
    return ChatMessageText(
      isCurrentUserMessage: currentUser?.uid == message.user?.uid,
      textMessage: getDeleteText(context),
      messageDate: getMessageDateTime(),
    );
  }

  Widget getDeleteText(BuildContext context) {
    if (currentUser?.uid == message.user?.uid) {
      return chatText("You deleted this message", context);
    } else {
      return chatText("This message is deleted", context);
    }
  }

  Widget getChatMessageTextWidget(BuildContext context) {
    return ChatMessageText(
      isCurrentUserMessage: currentUser?.uid == message.user?.uid,
      textMessage: getMessageTextWidget(context),
      messageDate: getMessageDateTime(),
    );
    // return Column(
    //   mainAxisAlignment: (currentUser?.id == message.user?.uid)
    //       ? MainAxisAlignment.end
    //       : MainAxisAlignment.start,
    //   crossAxisAlignment: (currentUser?.id == message.user?.uid)
    //       ? CrossAxisAlignment.end
    //       : CrossAxisAlignment.start,
    //   children: [
    //     getMessageTextWidget(context),
    //     const SizedBox(
    //       height: 10,
    //     ),
    //     getMessageDateTime()
    //   ],
    // );
  }

  Widget getMessageTextWidget(BuildContext context) {
    // print('getMessageTextWidget $message');
    if (message.mentions != null && message.mentions?.isNotEmpty == true) {
      return SelectableText.rich(
        buildCommentText(
          context: context,
          text: message.textWithMention ?? "",
          taggedUsers: message.mentions ?? {},
        ),
      );
    }
    return chatText(message.text ?? "", context);
  }

  Widget getChatMessageImageWidget(BuildContext context) {
    List<AttachmentImages> attachmentImages = [];
    if (message.fileUrl != null && message.fileUrl?.isNotEmpty == true) {
      attachmentImages.add(AttachmentImages(fileUrl: message.fileUrl));
    }
    attachmentImages.addAll(message.attachmentImages ?? []);
    return ChatMessageImage<AttachmentImages>(
      images: [],
      isCurrentUserMessage: currentUser?.uid == message.user?.uid,
      textMessage: getMessageTextWidget(context),
      messageDate: getMessageDateTime(),
      imageUrl: message.fileUrl,
      imageList: attachmentImages,
      getImageUrl: (AttachmentImages attachmentImages) {
        return attachmentImages.fileUrl ?? "";
      },
      imageCachedList: message.imageCacheList,
    );
  }

  void showImage(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Material(
        type: MaterialType.transparency,
        child: Container(
          child: Column(
            children: [
              Row(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.end,
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: FadeInImage.memoryNetwork(
                    image: message.fileUrl ?? "",
                    placeholder: kTransparentImage,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
