import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:core_cai_v3/api/upload_media_api.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../api/chat_message_api.dart';
import '../../model/chat_message.dart';
import '../../model/chat_user.dart';

import 'package:collection/collection.dart';

part 'chat_message_event.dart';
part 'chat_message_state.dart';

class ChatMessageBloc extends Bloc<ChatMessageEvent, ChatMessageState> {
  final ChatMessageApi chatMessageApi;
  final UploadMediaApi uploadMediaApi;

  StreamSubscription? messageStream;

  ChatMessageBloc(
    this.chatMessageApi,
    this.uploadMediaApi,
  ) : super(const ChatMessageState()) {
    on<LoadChatMessages>(
      (event, emit) async {
        await _loadChatMessages(event, emit);
      },
    );

    on<UpdateMessages>(
      (event, emit) async {
        emit(state.copyWith(
          messages: event.messages,
        ));
      },
    );

    on<CreateMessage>(
      (event, emit) async {
        ChatMessage message = event.message.copyWith(
          groupId: event.contentPath,
        );
        try {
          emit(state.copyWith(isLoadingSend: true));

          // Pending Message
          List<ChatMessage> pendingMessages = state.pendingMessages;
          pendingMessages = [
            message.copyWith(state: ChatMessage.pendingState),
            ...pendingMessages
          ];
          emit(state.copyWith(
            pendingMessages: pendingMessages,
            messages: [
              message.copyWith(state: ChatMessage.pendingState),
              ...state.messages
            ],
          ));

          // await Future.delayed(const Duration(seconds: 10));
          // Upload Media

          // Upload Images
          List<AttachmentImages> attachmentImages = [];
          for (XFile imageFile in event.selectedImages) {
            final Uint8List? bytes = await imageFile.readAsBytes();
            String fileUrl = await uploadMediaApi.uploadImage(bytes!,
                imageFile.mimeType ?? "", imageFile.name.split(".").last);
            attachmentImages.add(AttachmentImages(
              name: imageFile.name,
              type: imageFile.name.split(".").last,
              fileUrl: fileUrl,
            ));
          }

          message = message.copyWith(
            attachmentImages: attachmentImages,
          );

          // Upload Video
          if (event.selectedVideos != null) {
            String fileUrl = await uploadMediaApi.uploadFile(
                event.selectedVideos!, "video/x-matroska", "mkv");
            Uint8List videoThumbnailBytes =
                await uploadMediaApi.getVideoTumbnail(fileUrl);
            String thumbNailUrl = await uploadMediaApi.uploadImage(
                videoThumbnailBytes, "image/jpg", "jpg");

            message = message.copyWith(
              fileUrl: fileUrl,
              videoThumbnail: thumbNailUrl,
            );
          }

          // Upload File
          if (event.selectedFiles != null) {
            String fileUrl = await uploadMediaApi.uploadFile(
                event.selectedFiles!,
                ("application/${event.selectedFileType}"),
                event.selectedFileName ?? ".".split(".").last,
                fileName: event.selectedFileName);

            message = message.copyWith(
              fileUrl: fileUrl,
            );
          }

          // Send
          await chatMessageApi.createMesage(event.contentPath, message);
        } catch (e) {
          // Failed Message
          List<ChatMessage> messages = state.messages;
          messages
              .removeWhere((element) => element.createdAt == message.createdAt);
          List<ChatMessage> pendingMessages = state.pendingMessages;
          pendingMessages
              .removeWhere((element) => element.createdAt == message.createdAt);
          pendingMessages = [
            message.copyWith(state: ChatMessage.failedState),
            ...pendingMessages
          ];
          emit(state.copyWith(
            pendingMessages: pendingMessages,
            messages: [
              message.copyWith(state: ChatMessage.failedState),
              ...messages
            ],
          ));
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
        // print(messageStream);
        await messageStream!.cancel();
      }

      messageStream = chatMessageApi
          .getChatMessages(event.path)
          .asBroadcastStream()
          .listen((List<ChatMessage> messages) {
        print("=========listen message ${messages.length}=======");
        List<ChatMessage> pendingMessages = state.pendingMessages;

        pendingMessages.forEachIndexed((index, pendingMessage) {
          if (pendingMessage.groupId != event.path) {
            pendingMessages.removeAt(index);
          } else if (messages
              .map((e) => e.createdAt)
              .toList()
              .contains(pendingMessage.createdAt)) {
            pendingMessages.removeAt(index);
          }
        });

        add(UpdateMessages(messages: [
          ...pendingMessages
              .map((e) => e.copyWith(state: ChatMessage.pendingState)),
          ...messages
        ]));
      });
    } catch (error) {
      emit(ChatMessageFailure(error: error.toString()));
      emit(state.copyWith(isLoading: false));
    }
  }
}
