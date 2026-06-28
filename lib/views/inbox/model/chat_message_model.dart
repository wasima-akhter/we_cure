import '../../../core/helpers/safe_parser_helper.dart';

/*
enum MessageType { text, image, video, audio }

class ChatMessageModel {
  /// Core ids
  final String? id; // backend message id
  final String? roomId;
  final String? senderId;
  final String? receiverId;

  /// Content
  final String message;
  final List<String>? images;

  /// Status
  final bool isMe;
  final bool isUploading;
  final bool isSeen;

  /// Meta
  final MessageType type;
  final DateTime createdAt;

  ChatMessageModel({
    this.id,
    this.roomId,
    this.senderId,
    this.receiverId,
    required this.message,
    this.images,
    required this.isMe,
    required this.type,
    this.isUploading = false,
    this.isSeen = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // ---------------------------
  // FROM JSON (socket / API)
  // ---------------------------
  factory ChatMessageModel.fromJson(Map<String, dynamic> json, String myId) {
    return ChatMessageModel(
      id: json['id']?.toString(),
      roomId: json['room_id'],
      senderId: json['sender_id'],
      receiverId: json['receiver_id'],
      message: json['message'] ?? '',
      images: json['images'] != null ? List<String>.from(json['images']) : null,
      isMe: json['sender_id'] == myProfileId(),
      isSeen: json['is_seen'] ?? false,
      isUploading: false,
      type: _parseMessageType(json['type']),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  // ---------------------------
  // TO JSON (emit / API)
  // ---------------------------
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'room_id': roomId,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'message': message,
      'images': images,
      'type': type.name,
      'is_seen': isSeen,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // ---------------------------
  // COPY WITH (update message)
  // ---------------------------
  ChatMessageModel copyWith({
    String? id,
    String? roomId,
    String? senderId,
    String? receiverId,
    String? message,
    List<String>? images,
    bool? isUploading,
    bool? isSeen,
    MessageType? type,
    DateTime? createdAt,
  }) {
    return ChatMessageModel(
      id: id ?? this.id,
      roomId: roomId ?? this.roomId,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      message: message ?? this.message,
      images: images ?? this.images,
      isMe: isMe,
      type: type ?? this.type,
      isUploading: isUploading ?? this.isUploading,
      isSeen: isSeen ?? this.isSeen,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // ---------------------------
  // MESSAGE TYPE PARSER
  // ---------------------------
  static MessageType _parseMessageType(String? value) {
    switch (value) {
      case 'image':
        return MessageType.image;
      case 'video':
        return MessageType.video;
      case 'audio':
        return MessageType.audio;
      default:
        return MessageType.text;
    }
  }
}

*/

enum MessageType { text, image, video, audio }

class ChatMessageModel {
  /// Core ids
  final String? id;
  final String? roomId;
  final String? senderId;
  final String? receiverId;

  /// Content
  final String message;
  final List<String> images;

  /// Status
  final bool isMe;
  final bool isUploading;
  final bool isSeen;

  /// Meta
  final MessageType type;
  final DateTime? createdAt;

  const ChatMessageModel({
    this.id,
    this.roomId,
    this.senderId,
    this.receiverId,
    this.message = '',
    this.images = const [],
    this.isMe = false,
    this.type = MessageType.text,
    this.isUploading = false,
    this.isSeen = false,
    this.createdAt,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic>? json, String myId) {
    final map = json ?? <String, dynamic>{};

    final senderId = SafeParser.id(map['sender_id']);

    return ChatMessageModel(
      id: SafeParser.nullableString(map['id']),
      roomId: SafeParser.nullableString(map['room_id']),
      senderId: senderId,
      receiverId: SafeParser.nullableString(map['receiver_id']),
      message: SafeParser.str(map['message']),
      images: SafeParser.stringList(map['images']),
      isMe: senderId == myId,
      isUploading: false,
      isSeen: SafeParser.boolVal(map['is_seen']),
      type: SafeParser.enumValue<MessageType>(
        map['type'],
        MessageType.values,
        fallback: MessageType.text,
      ),
      createdAt: SafeParser.date(map['created_at']),
    );
  }

  static ChatMessageModel fallback() => ChatMessageModel(
    id: null,
    roomId: null,
    senderId: null,
    receiverId: null,
    message: '',
    images: const [],
    isMe: false,
    isUploading: false,
    isSeen: false,
    type: MessageType.text,
    createdAt: null,
  );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'room_id': roomId,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'message': message,
      'images': images,
      'type': type.name,
      'is_seen': isSeen,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  ChatMessageModel copyWith({
    String? id,
    String? roomId,
    String? senderId,
    String? receiverId,
    String? message,
    List<String>? images,
    bool? isMe,
    bool? isUploading,
    bool? isSeen,
    MessageType? type,
    DateTime? createdAt,
  }) {
    return ChatMessageModel(
      id: id ?? this.id,
      roomId: roomId ?? this.roomId,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      message: message ?? this.message,
      images: images ?? this.images,
      isMe: isMe ?? this.isMe,
      isUploading: isUploading ?? this.isUploading,
      isSeen: isSeen ?? this.isSeen,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
