/*
class AllConversationModel {
  final bool success;
  final int statusCode;
  final String message;
  final List<Conversation>? conversation;

  final Recipient? recipient;
  final Meta meta;

  AllConversationModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.conversation,
    required this.meta,
    this.recipient,
  });

  factory AllConversationModel.fromJson(Map<String, dynamic> json) =>
      AllConversationModel(
        success: json["success"],
        statusCode: json["statusCode"],
        message: json["message"],
        recipient: Recipient.fromJson(json['recipient'] ?? {}),
        conversation: List<Conversation>.from(
          json["data"].map((x) => Conversation.fromJson(x)),
        ),
        meta: Meta.fromJson(json["meta"]),
      );
}

class Conversation {
  final String id;
  final String conversationId;
  final Receiver sender;
  final Receiver receiver;
  final String text;
  final List<String> images;
  final bool seen;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  Conversation({
    required this.id,
    required this.conversationId,
    required this.sender,
    required this.receiver,
    required this.text,
    required this.images,
    required this.seen,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) => Conversation(
    id: json["_id"],
    conversationId: json["conversationId"],
    sender: Receiver.fromJson(json["sender"]),
    receiver: Receiver.fromJson(json["receiver"]),
    text: json["text"],
    images: List<String>.from(json["images"].map((x) => x)),
    seen: json["seen"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );
}

class Receiver {
  final String id;
  final String role;

  Receiver({required this.id, required this.role});

  factory Receiver.fromJson(Map<String, dynamic> json) =>
      Receiver(id: json["id"], role: json["role"]);
}

class Meta {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  Meta({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    total: json["total"],
    page: json["page"],
    limit: json["limit"],
    totalPages: json["totalPages"],
  );
}

class Recipient {
  final String id;
  final String role;
  final String name;
  final String image;

  Recipient({
    required this.id,
    required this.role,
    required this.name,
    required this.image,
  });

  factory Recipient.fromJson(Map<String, dynamic> json) {
    return Recipient(
      id: json['id'] ?? '',
      role: json['role'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
    );
  }
}


*/

import '../../../core/helpers/safe_parser_helper.dart';

class AllConversationModel {
  final bool success;
  final int statusCode;
  final String message;
  final List<Conversation> conversation;
  final Recipient? recipient;
  final Meta meta;

  AllConversationModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.conversation,
    required this.meta,
    this.recipient,
  });

  factory AllConversationModel.fromJson(Map<String, dynamic>? json) {
    final map = json ?? <String, dynamic>{};

    return AllConversationModel(
      success: SafeParser.boolVal(map['success']),
      statusCode: SafeParser.intVal(map['statusCode']),
      message: SafeParser.str(map['message']),
      recipient: SafeParser.object<Recipient>(
        map['recipient'],
        (e) => Recipient.fromJson(e),
      ),
      conversation: SafeParser.list<Conversation>(
        map['data'],
        (e) => Conversation.fromJson(e),
      ),
      meta:
          SafeParser.object<Meta>(map['meta'], (e) => Meta.fromJson(e)) ??
          Meta.fallback(),
    );
  }
}

class Conversation {
  final String id;
  final String conversationId;
  final Receiver sender;
  final Receiver receiver;
  final String text;
  final List<String> images;
  final bool seen;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int v;

  Conversation({
    required this.id,
    required this.conversationId,
    required this.sender,
    required this.receiver,
    required this.text,
    required this.images,
    required this.seen,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory Conversation.fromJson(Map<String, dynamic>? json) {
    final map = json ?? <String, dynamic>{};

    return Conversation(
      id: SafeParser.str(map['_id']),
      conversationId: SafeParser.str(map['conversationId']),
      sender:
          SafeParser.object<Receiver>(
            map['sender'],
            (e) => Receiver.fromJson(e),
          ) ??
          Receiver.fallback(),
      receiver:
          SafeParser.object<Receiver>(
            map['receiver'],
            (e) => Receiver.fromJson(e),
          ) ??
          Receiver.fallback(),
      text: SafeParser.str(map['text']),
      images: SafeParser.stringList(map['images']),
      seen: SafeParser.boolVal(map['seen']),
      createdAt: SafeParser.date(map['createdAt']),
      updatedAt: SafeParser.date(map['updatedAt']),
      v: SafeParser.intVal(map['__v']),
    );
  }
}

class Receiver {
  final String id;
  final String role;

  Receiver({required this.id, required this.role});

  factory Receiver.fromJson(Map<String, dynamic>? json) {
    final map = json ?? <String, dynamic>{};

    return Receiver(
      id: SafeParser.str(map['id']),
      role: SafeParser.str(map['role']),
    );
  }

  static Receiver fallback() => Receiver(id: '', role: '');
}

class Recipient {
  final String id;
  final String role;
  final String name;
  final String image;

  Recipient({
    required this.id,
    required this.role,
    required this.name,
    required this.image,
  });

  factory Recipient.fromJson(Map<String, dynamic>? json) {
    final map = json ?? <String, dynamic>{};

    return Recipient(
      id: SafeParser.str(map['id']),
      role: SafeParser.str(map['role']),
      name: SafeParser.str(map['name']),
      image: SafeParser.str(map['image']),
    );
  }

  static Recipient fallback() =>
      Recipient(id: '', role: '', name: '', image: '');
}

class Meta {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  Meta({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory Meta.fromJson(Map<String, dynamic>? json) {
    final map = json ?? <String, dynamic>{};

    return Meta(
      total: SafeParser.intVal(map['total']),
      page: SafeParser.intVal(map['page'], 1),
      limit: SafeParser.intVal(map['limit'], 20),
      totalPages: SafeParser.intVal(map['totalPages']),
    );
  }

  static Meta fallback() => Meta(total: 0, page: 1, limit: 20, totalPages: 0);
}
