class ChatUser {
  final String? avatar;
  final String? name;
  final String? uid;

  ChatUser({this.avatar, this.name, this.uid});

  ChatUser copyWith({
    String? avatar,
    String? name,
    String? uid,
  }) {
    return ChatUser(
      avatar: avatar ?? this.avatar,
      name: name ?? this.name,
      uid: uid ?? this.uid,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'avatar': avatar,
      'name': name,
      'uid': uid,
    };
  }

  factory ChatUser.fromMap(Map<String, dynamic> map) {
    return ChatUser(
      avatar: map['avatar'] as String?,
      name: map['name'] as String?,
      uid: map['uid'] as String?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatUser &&
          runtimeType == other.runtimeType &&
          avatar == other.avatar &&
          name == other.name &&
          uid == other.uid;

  @override
  int get hashCode => avatar.hashCode ^ name.hashCode ^ uid.hashCode;
}
