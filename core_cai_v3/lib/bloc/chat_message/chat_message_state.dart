part of 'chat_message_bloc.dart';

@immutable
class ChatMessageState {
  final bool isLoading;
  final bool isLoadingSend;
  final List<ChatMessage> messages;
  final List<ChatMessage> deleteMessages;
  final List<ChatMessage> pendingMessages;

  const ChatMessageState({
    this.isLoading = false,
    this.messages = const [],
    this.isLoadingSend = false,
    this.deleteMessages = const [],
    this.pendingMessages = const [],
  });

  ChatMessageState copyWith({
    bool? isLoading,
    List<ChatMessage>? messages,
    bool? isLoadingSend,
    List<ChatMessage>? deleteMessages,
    List<ChatMessage>? pendingMessages,
  }) {
    return ChatMessageState(
      isLoading: isLoading ?? this.isLoading,
      messages: messages ?? this.messages,
      isLoadingSend: isLoadingSend ?? this.isLoadingSend,
      deleteMessages: deleteMessages ?? this.deleteMessages,
      pendingMessages: pendingMessages ?? this.pendingMessages,
    );
  }
}

class ChatMessageFailure extends ChatMessageState {
  final String? error;

  const ChatMessageFailure({@required this.error}) : super();

  @override
  String toString() => 'ChatMessageFailure { error: $error }';
}

class ChatMessageSuccess extends ChatMessageState {
  final String? message;

  const ChatMessageSuccess({@required this.message}) : super();

  @override
  String toString() => 'ChatMessageSuccess { message: $message }';
}

class AddChatMessageSuccess extends ChatMessageState {
  final String? message;

  const AddChatMessageSuccess({@required this.message}) : super();

  @override
  String toString() => 'AddChatMessageSuccess { message: $message }';
}

class GetCountFailure extends ChatMessageState {
  final String? error;

  const GetCountFailure({@required this.error}) : super();

  @override
  String toString() => 'GetCountFailure { error: $error }';
}

class GetCountSuccess extends ChatMessageState {
  final String? count;

  const GetCountSuccess({@required this.count}) : super();

  @override
  String toString() => 'GetCountSuccess { count: $count }';
}

class DeleteChatMessageSuccess extends ChatMessageState {
  final String? message;

  const DeleteChatMessageSuccess({@required this.message}) : super();

  @override
  String toString() => 'DeleteChatMessageSuccess { message: $message }';
}

class DeleteChatMessageFailure extends ChatMessageState {
  final String? error;

  const DeleteChatMessageFailure({@required this.error}) : super();

  @override
  String toString() => 'DeleteChatMessageFailure { error: $error }';
}
