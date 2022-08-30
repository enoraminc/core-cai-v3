part of 'chat_message_bloc.dart';

abstract class ChatMessageEvent {}

class LoadChatMessages extends ChatMessageEvent {
  final String locale;
  final String path;

  LoadChatMessages({
    required this.locale,
    required this.path,
  });

  @override
  List<Object> get props => [];
}

class UpdateMessages extends ChatMessageEvent {
  final List<ChatMessage>? messages;
  UpdateMessages({
    @required this.messages,
  });
}

class CreateMessage extends ChatMessageEvent {
  final ChatMessage message;
  final String contentPath;
  final String locale;
  final ChatUser user;
  CreateMessage(
      {required this.message,
      required this.contentPath,
      required this.locale,
      required this.user});
}

class UpdateLastMessageEvent extends ChatMessageEvent {
  final String? chatId;
  final String? userId;

  UpdateLastMessageEvent(
    this.chatId,
    this.userId,
  );
}

class AddDeleteMessageEvent extends ChatMessageEvent {
  final ChatMessage chatMessage;
  final bool isRemove;
  AddDeleteMessageEvent(
    this.chatMessage,
    this.isRemove,
  );
}

class DeleteTaskChatMessagesEvent extends ChatMessageEvent {
  final String taskId;
  DeleteTaskChatMessagesEvent(
    this.taskId,
  );
}

class DeleteUserChatMessagesEvent extends ChatMessageEvent {
  DeleteUserChatMessagesEvent();
}

class ClearDeleteChatMessagesEvent extends ChatMessageEvent {
  ClearDeleteChatMessagesEvent();
}
