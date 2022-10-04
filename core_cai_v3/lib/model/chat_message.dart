import 'dart:typed_data';

import 'chat_user.dart';

class ChatMessage {
  static String image = 'image';
  static String string = 'text';
  static String msgFile = 'file';
  static String both = 'both';
  static String command = 'command';
  static String webContent = 'webContent';
  static String googlemeet = 'googlemeet';
  static String video = 'video';
  static String task = 'task';

  final String? id;
  final String? text;
  final String? msgType;
  final String? fileUrl;
  final ChatUser? user;
  final num? createdAt;
  final String? activityId;
  final Map<String, dynamic>? otherData;
  final String? fileType;
  final String? chatThreadId;
  final List<String>? users;
  bool? isDeleted;
  bool? isSelected;
  Map<String, dynamic>? mentions;
  final String? textWithMention;
  final String? videoThumbnail;
  final String? googleMeetLink;
  final String? fileName;
  final List<AttachmentImages>? attachmentImages;

  final String? state;
  final String? groupId;

  final List<Uint8List> imageCacheList;

  static String pendingState = "Pending";
  static String successState = "Success";
  static String failedState = "Failed";

  bool isPending() => state == pendingState;
  bool isFailed() => state == failedState;

  ChatMessage({
    this.id,
    this.text,
    this.msgType,
    this.fileUrl,
    this.user,
    this.createdAt,
    this.activityId,
    this.otherData,
    this.fileType,
    this.chatThreadId,
    this.users,
    this.isDeleted,
    this.isSelected,
    this.mentions,
    this.textWithMention,
    this.videoThumbnail,
    this.googleMeetLink,
    this.fileName,
    this.attachmentImages,
    this.state,
    this.groupId,
    this.imageCacheList = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'msgType': msgType,
      'fileUrl': fileUrl,
      'user': user!.toMap(),
      'createdAt': createdAt,
      'activityId': activityId,
      'fileType': fileType,
      'chatThreadId': chatThreadId,
      'users': users,
      'isDeleted': isDeleted,
      'mentions': mentions,
      'textWithMention': textWithMention,
      'videoThumbnail': videoThumbnail,
      'googleMeetLink': googleMeetLink,
      'fileName': fileName,
      'otherData': otherData,
      'attachmentImages': attachmentImages?.map((e) => e.toJson()).toList(),
      'state': state,
      'groupId': groupId,
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    ChatUser? chatUser;
    Map<String, dynamic> userMap = map['user'];

    chatUser = ChatUser.fromMap(userMap);

    List<String> userList = [];
    if (map['users'] != null) {
      for (String u in map['users']) {
        userList.add(u);
      }
    }

    List<AttachmentImages> attachmentImagesList = [];

    if (map['attachmentImages'] != null) {
      for (dynamic img in map['attachmentImages']) {
        attachmentImagesList.add(AttachmentImages.fromJson(img));
      }
    }

    return ChatMessage(
      id: map['id'] as String?,
      text: map['text'] as String?,
      msgType: map['msgType'] as String?,
      fileUrl: map['fileUrl'] as String?,
      user: chatUser,
      createdAt: map['createdAt'] as num?,
      activityId: (map['activityId'] != null) ? map['activityId'] : "",
      fileType: map['fileType'] ?? "",
      chatThreadId: map['chatThreadId'],
      users: userList,
      isDeleted: map['isDeleted'],
      mentions: map['mentions'],
      textWithMention: map['textWithMention'],
      videoThumbnail: map['videoThumbnail'],
      googleMeetLink: map['googleMeetLink'],
      fileName: map['fileName'],
      otherData: map['otherData'],
      attachmentImages: attachmentImagesList,
      state: map['state'],
      groupId: map['groupId'],
    );
  }

  ChatMessage copyWith({
    String? id,
    String? text,
    String? msgType,
    String? fileUrl,
    ChatUser? user,
    num? createdAt,
    String? activityId,
    Map<String, dynamic>? otherData,
    String? fileType,
    String? chatThreadId,
    List<String>? users,
    bool? isDeleted,
    bool? isSelected,
    Map<String, dynamic>? mentions,
    String? textWithMention,
    String? videoThumbnail,
    String? googleMeetLink,
    String? fileName,
    List<AttachmentImages>? attachmentImages,
    String? state,
    String? groupId,
    List<Uint8List>? imageCacheList,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      text: text ?? this.text,
      msgType: msgType ?? this.msgType,
      fileUrl: fileUrl ?? this.fileUrl,
      user: user ?? this.user,
      createdAt: createdAt ?? this.createdAt,
      activityId: activityId ?? this.activityId,
      otherData: otherData ?? this.otherData,
      fileType: fileType ?? this.fileType,
      chatThreadId: chatThreadId ?? this.chatThreadId,
      users: users ?? this.users,
      isDeleted: isDeleted ?? this.isDeleted,
      isSelected: isSelected ?? this.isSelected,
      mentions: mentions ?? this.mentions,
      textWithMention: textWithMention ?? this.textWithMention,
      videoThumbnail: videoThumbnail ?? this.videoThumbnail,
      googleMeetLink: googleMeetLink ?? this.googleMeetLink,
      fileName: fileName ?? this.fileName,
      attachmentImages: attachmentImages ?? this.attachmentImages,
      state: state ?? this.state,
      groupId: groupId ?? this.groupId,
      imageCacheList: imageCacheList ?? this.imageCacheList,
    );
  }

  @override
  String toString() {
    return 'ChatMessage(id: $id, text: $text, msgType: $msgType, fileUrl: $fileUrl, user: $user, createdAt: $createdAt, activityId: $activityId, otherData: $otherData, fileType: $fileType, chatThreadId: $chatThreadId, users: $users, isDeleted: $isDeleted, isSelected: $isSelected, mentions: $mentions, textWithMention: $textWithMention, videoThumbnail: $videoThumbnail, googleMeetLink: $googleMeetLink, fileName: $fileName, attachmentImages: $attachmentImages)';
  }
}

class AttachmentImages {
  String? fileUrl;
  String? name;
  String? type;

  AttachmentImages({this.fileUrl, this.name, this.type});

  AttachmentImages.fromJson(Map<String, dynamic> json) {
    fileUrl = json['fileUrl'];
    name = json['name'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fileUrl'] = fileUrl;
    data['name'] = name;
    data['type'] = type;
    return data;
  }

  Map<String, dynamic> toCommentJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['path'] = fileUrl;
    data['filename'] = name;
    return data;
  }
}
