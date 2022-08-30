import 'package:flutter/material.dart';

class ChatMessagesWidget<Messages> extends StatelessWidget {
  final ScrollController scrollController;
  final List<Messages> messages;
  final Widget? Function(int index)? isDisplayDateHeader;
  final Widget? Function(int index)? isLastMessage;
  final Widget Function(Messages message, {required int index})
      chatMessageWidget;
  const ChatMessagesWidget({
    Key? key,
    required this.scrollController,
    required this.chatMessageWidget,
    this.messages = const [],
    this.isDisplayDateHeader,
    this.isLastMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      reverse: true,
      controller: scrollController,
      itemCount: messages.length,
      itemBuilder: (BuildContext context, int index) {
        if (isDisplayDateHeader!(index) != null) {
          return Column(
            children: [
              chatMessageWidget(messages[index], index: index),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  isDisplayDateHeader!(index)!,
                ],
              ),
              const SizedBox(
                height: 5,
              ),
            ],
          );
        }
        return chatMessageWidget(messages[index], index: index);
      },
    );
  }
}
