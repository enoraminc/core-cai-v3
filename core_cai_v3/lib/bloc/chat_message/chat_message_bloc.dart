import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../api/chat_message_api.dart';
import '../../model/chat_message.dart';
import '../../model/chat_user.dart';

part 'chat_message_event.dart';
part 'chat_message_state.dart';

class ChatMessageBloc extends Bloc<ChatMessageEvent, ChatMessageState> {
  final ChatMessageApi chatMessageApi;

  StreamSubscription? messageStream;

  ChatMessageBloc(this.chatMessageApi) : super(const ChatMessageState()) {
    on<LoadChatMessages>(
      (event, emit) async {
        await _loadChatMessages(event, emit);
      },
    );

    on<UpdateMessages>(
      (event, emit) async {
        emit(state.copyWith(messages: event.messages));
      },
    );

    on<CreateMessage>(
      (event, emit) async {
        try {
          emit(state.copyWith(isLoadingSend: true));
          await chatMessageApi.createMesage(event.contentPath, event.message);
        } catch (e) {
          print(e);
        } finally {
          emit(state.copyWith(isLoadingSend: false));
        }
      },
    );

    on<ClearDeleteChatMessagesEvent>(
      (event, emit) async {
        emit(state.copyWith(deleteMessages: []));
      },
    );
  }

  _loadChatMessages(LoadChatMessages event, emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      if (messageStream != null) {
        print("=========messageStream=======");
        print(messageStream);
        await messageStream!.cancel();
      }

      messageStream = chatMessageApi
          .getChatMessages(event.path)
          .asBroadcastStream()
          .listen((List<ChatMessage> messages) {
        add(UpdateMessages(messages: messages));
      });
    } catch (error) {
      emit(ChatMessageFailure(error: error.toString()));
      emit(state.copyWith(isLoading: false));
    }
  }
}
