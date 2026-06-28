/*
class ChatPersonListModel {
  final bool success;
  final int statusCode;
  final String message;
  final List<PersonData> data;
  final ChatPersonListModelMeta meta;

  ChatPersonListModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
    required this.meta,
  });

  factory ChatPersonListModel.fromJson(Map<String, dynamic> json) =>
      ChatPersonListModel(
        success: json["success"],
        statusCode: json["statusCode"],
        message: json["message"],
        data: List<PersonData>.from(
          json["data"].map((x) => PersonData.fromJson(x)),
        ),
        meta: ChatPersonListModelMeta.fromJson(json["meta"]),
      );
}

class PersonData {
  final String id;
  final List<Participant> participants;
  final String? appointmentId;
  final DatumMeta meta;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;
  final LastMessage lastMessage;

  PersonData({
    required this.id,
    required this.participants,
    this.appointmentId,
    required this.meta,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.lastMessage,
  });

  factory PersonData.fromJson(Map<String, dynamic> json) => PersonData(
    id: json["_id"],
    participants: List<Participant>.from(
      json["participants"].map((x) => Participant.fromJson(x)),
    ),
    appointmentId: json["appointmentId"] ?? '',
    meta: DatumMeta.fromJson(json["meta"]),
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    lastMessage: LastMessage.fromJson(json["lastMessage"]),
  );
}

class LastMessage {
  final String id;
  final String conversationId;
  final Receiver sender;
  final Receiver receiver;
  final String text;
  final List<String> images;
  final dynamic video;
  final dynamic videoCover;
  final bool seen;
  final dynamic deliveredAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  LastMessage({
    required this.id,
    required this.conversationId,
    required this.sender,
    required this.receiver,
    required this.text,
    required this.images,
    required this.video,
    required this.videoCover,
    required this.seen,
    required this.deliveredAt,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory LastMessage.fromJson(Map<String, dynamic> json) => LastMessage(
    id: json["_id"],
    conversationId: json["conversationId"],
    sender: Receiver.fromJson(json["sender"]),
    receiver: Receiver.fromJson(json["receiver"]),
    text: json["text"],
    images: List<String>.from(json["images"].map((x) => x)),
    video: json["video"],
    videoCover: json["videoCover"],
    seen: json["seen"],
    deliveredAt: json["deliveredAt"],
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

class DatumMeta {
  final String id;
  final DateTime lastActivityAt;

  DatumMeta({required this.id, required this.lastActivityAt});

  factory DatumMeta.fromJson(Map<String, dynamic> json) => DatumMeta(
    id: json["_id"],
    lastActivityAt: DateTime.parse(json["lastActivityAt"]),
  );
}

class Participant {
  final String id;
  final String role;
  final String name;
  final String image;

  Participant({
    required this.id,
    required this.role,
    required this.name,
    required this.image,
  });

  factory Participant.fromJson(Map<String, dynamic> json) => Participant(
    id: json["id"],
    role: json["role"],
    name: json["name"],
    image: json["image"],
  );
}

class ChatPersonListModelMeta {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  ChatPersonListModelMeta({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory ChatPersonListModelMeta.fromJson(Map<String, dynamic> json) =>
      ChatPersonListModelMeta(
        total: json["total"],
        page: json["page"],
        limit: json["limit"],
        totalPages: json["totalPages"],
      );
}


*/

/*
import '../../../core/helpers/helpers.dart';

class ChatPersonListModel {
  final bool success;
  final int statusCode;
  final String message;
  final List<PersonData> data;
  final ChatPersonListModelMeta meta;

  const ChatPersonListModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
    required this.meta,
  });

  factory ChatPersonListModel.fromJson(Map<String, dynamic>? json) {
    final map = json ?? {};

    return ChatPersonListModel(
      success: JsonHelper.getBool(map['success']),
      statusCode: JsonHelper.getInt(map['statusCode']),
      message: JsonHelper.getString(map['message']),
      data: JsonHelper.getList(
        map['data'],
      ).map((e) => PersonData.fromJson(JsonHelper.getMap(e))).toList(),
      meta: ChatPersonListModelMeta.fromJson(JsonHelper.getMap(map['meta'])),
    );
  }

  factory ChatPersonListModel.empty() => ChatPersonListModel(
    success: false,
    statusCode: 0,
    message: '',
    data: const [],
    meta: ChatPersonListModelMeta.empty(),
  );
}

class PersonData {
  final String id;
  final List<Participant> participants;
  final String appointmentId;
  final DatumMeta meta;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;
  final LastMessage lastMessage;

  const PersonData({
    required this.id,
    required this.participants,
    required this.appointmentId,
    required this.meta,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.lastMessage,
  });

  factory PersonData.fromJson(Map<String, dynamic>? json) {
    final map = json ?? {};

    return PersonData(
      id: JsonHelper.getString(map['_id']),
      participants: JsonHelper.getList(
        map['participants'],
      ).map((e) => Participant.fromJson(JsonHelper.getMap(e))).toList(),
      appointmentId: JsonHelper.getString(map['appointmentId']),
      meta: DatumMeta.fromJson(JsonHelper.getMap(map['meta'])),
      createdAt: JsonHelper.getDateTime(map['createdAt']),
      updatedAt: JsonHelper.getDateTime(map['updatedAt']),
      v: JsonHelper.getInt(map['__v']),
      lastMessage: LastMessage.fromJson(JsonHelper.getMap(map['lastMessage'])),
    );
  }

  factory PersonData.empty() => PersonData(
    id: '',
    participants: const [],
    appointmentId: '',
    meta: DatumMeta.empty(),
    createdAt: DateTime(1970),
    updatedAt: DateTime(1970),
    v: 0,
    lastMessage: LastMessage.empty(),
  );
}

class LastMessage {
  final String id;
  final String conversationId;
  final Receiver sender;
  final Receiver receiver;
  final String text;
  final List<String> images;
  final String video;
  final String videoCover;
  final bool seen;
  final String deliveredAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  const LastMessage({
    required this.id,
    required this.conversationId,
    required this.sender,
    required this.receiver,
    required this.text,
    required this.images,
    required this.video,
    required this.videoCover,
    required this.seen,
    required this.deliveredAt,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory LastMessage.fromJson(Map<String, dynamic>? json) {
    final map = json ?? {};

    return LastMessage(
      id: JsonHelper.getString(map['_id']),
      conversationId: JsonHelper.getString(map['conversationId']),
      sender: Receiver.fromJson(JsonHelper.getMap(map['sender'])),
      receiver: Receiver.fromJson(JsonHelper.getMap(map['receiver'])),
      text: JsonHelper.getString(map['text']),
      images: JsonHelper.getList(
        map['images'],
      ).map((e) => JsonHelper.getString(e)).toList(),
      video: JsonHelper.getString(map['video']),
      videoCover: JsonHelper.getString(map['videoCover']),
      seen: JsonHelper.getBool(map['seen']),
      deliveredAt: JsonHelper.getString(map['deliveredAt']),
      createdAt: JsonHelper.getDateTime(map['createdAt']),
      updatedAt: JsonHelper.getDateTime(map['updatedAt']),
      v: JsonHelper.getInt(map['__v']),
    );
  }

  factory LastMessage.empty() => LastMessage(
    id: '',
    conversationId: '',
    sender: Receiver.empty(),
    receiver: Receiver.empty(),
    text: '',
    images: const [],
    video: '',
    videoCover: '',
    seen: false,
    deliveredAt: '',
    createdAt: DateTime(1970),
    updatedAt: DateTime(1970),
    v: 0,
  );
}

class Receiver {
  final String id;
  final String role;

  const Receiver({required this.id, required this.role});

  factory Receiver.fromJson(Map<String, dynamic>? json) {
    final map = json ?? {};

    return Receiver(
      id: JsonHelper.getString(map['id']),
      role: JsonHelper.getString(map['role']),
    );
  }

  factory Receiver.empty() => const Receiver(id: '', role: '');
}

class DatumMeta {
  final String id;
  final DateTime lastActivityAt;

  const DatumMeta({required this.id, required this.lastActivityAt});

  factory DatumMeta.fromJson(Map<String, dynamic>? json) {
    final map = json ?? {};

    return DatumMeta(
      id: JsonHelper.getString(map['_id']),
      lastActivityAt: JsonHelper.getDateTime(map['lastActivityAt']),
    );
  }

  factory DatumMeta.empty() =>
      DatumMeta(id: '', lastActivityAt: DateTime(1970));
}

class Participant {
  final String id;
  final String role;
  final String name;
  final String image;

  const Participant({
    required this.id,
    required this.role,
    required this.name,
    required this.image,
  });

  factory Participant.fromJson(Map<String, dynamic>? json) {
    final map = json ?? {};

    return Participant(
      id: JsonHelper.getString(map['id']),
      role: JsonHelper.getString(map['role']),
      name: JsonHelper.getString(map['name']),
      image: JsonHelper.getString(map['image']),
    );
  }

  factory Participant.empty() =>
      const Participant(id: '', role: '', name: '', image: '');
}

class ChatPersonListModelMeta {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  const ChatPersonListModelMeta({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory ChatPersonListModelMeta.fromJson(Map<String, dynamic>? json) {
    final map = json ?? {};

    return ChatPersonListModelMeta(
      total: JsonHelper.getInt(map['total']),
      page: JsonHelper.getInt(map['page']),
      limit: JsonHelper.getInt(map['limit']),
      totalPages: JsonHelper.getInt(map['totalPages']),
    );
  }

  factory ChatPersonListModelMeta.empty() => const ChatPersonListModelMeta(
    total: 0,
    page: 1,
    limit: 10,
    totalPages: 0,
  );
}
*/

import '../../../core/helpers/safe_parser_helper.dart';

class ChatPersonListModel {
  final bool success;
  final int statusCode;
  final String message;
  final List<PersonData> data;
  final ChatPersonListModelMeta meta;

  const ChatPersonListModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
    required this.meta,
  });

  factory ChatPersonListModel.fromJson(Map<String, dynamic>? json) {
    final map = json ?? <String, dynamic>{};

    return ChatPersonListModel(
      success: SafeParser.boolVal(map['success']),
      statusCode: SafeParser.intVal(map['statusCode']),
      message: SafeParser.str(map['message']),
      data: SafeParser.list<PersonData>(
        map['data'],
        (e) => PersonData.fromJson(e),
      ),
      meta: ChatPersonListModelMeta.fromJson(SafeParser.map(map['meta']) ?? {}),
    );
  }

  static ChatPersonListModel fallback() => ChatPersonListModel(
    success: false,
    statusCode: 0,
    message: '',
    data: const [],
    meta: ChatPersonListModelMeta.fallback(),
  );
}

class PersonData {
  final String id;
  final List<Participant> participants;
  final String appointmentId;
  final DatumMeta meta;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int v;
  final LastMessage lastMessage;

  const PersonData({
    required this.id,
    required this.participants,
    required this.appointmentId,
    required this.meta,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.lastMessage,
  });

  factory PersonData.fromJson(Map<String, dynamic>? json) {
    final map = json ?? <String, dynamic>{};

    return PersonData(
      id: SafeParser.id(map['_id']),
      participants: SafeParser.list<Participant>(
        map['participants'],
        (e) => Participant.fromJson(e),
      ),
      appointmentId: SafeParser.str(map['appointmentId']),
      meta: DatumMeta.fromJson(SafeParser.map(map['meta']) ?? {}),
      createdAt: SafeParser.date(map['createdAt']),
      updatedAt: SafeParser.date(map['updatedAt']),
      v: SafeParser.intVal(map['__v']),
      lastMessage: LastMessage.fromJson(
        SafeParser.map(map['lastMessage']) ?? {},
      ),
    );
  }

  static PersonData fallback() => PersonData(
    id: '',
    participants: const [],
    appointmentId: '',
    meta: DatumMeta.fallback(),
    createdAt: null,
    updatedAt: null,
    v: 0,
    lastMessage: LastMessage.fallback(),
  );
}

class LastMessage {
  final String id;
  final String conversationId;
  final Receiver sender;
  final Receiver receiver;
  final String text;
  final List<String> images;
  final String video;
  final String videoCover;
  final bool seen;
  final String deliveredAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int v;

  const LastMessage({
    required this.id,
    required this.conversationId,
    required this.sender,
    required this.receiver,
    required this.text,
    required this.images,
    required this.video,
    required this.videoCover,
    required this.seen,
    required this.deliveredAt,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory LastMessage.fromJson(Map<String, dynamic>? json) {
    final map = json ?? <String, dynamic>{};

    return LastMessage(
      id: SafeParser.id(map['_id']),
      conversationId: SafeParser.str(map['conversationId']),
      sender: Receiver.fromJson(SafeParser.map(map['sender']) ?? {}),
      receiver: Receiver.fromJson(SafeParser.map(map['receiver']) ?? {}),
      text: SafeParser.str(map['text']),
      images: SafeParser.stringList(map['images']),
      video: SafeParser.str(map['video']),
      videoCover: SafeParser.str(map['videoCover']),
      seen: SafeParser.boolVal(map['seen']),
      deliveredAt: SafeParser.str(map['deliveredAt']),
      createdAt: SafeParser.date(map['createdAt']),
      updatedAt: SafeParser.date(map['updatedAt']),
      v: SafeParser.intVal(map['__v']),
    );
  }

  static LastMessage fallback() => LastMessage(
    id: '',
    conversationId: '',
    sender: Receiver.fallback(),
    receiver: Receiver.fallback(),
    text: '',
    images: const [],
    video: '',
    videoCover: '',
    seen: false,
    deliveredAt: '',
    createdAt: null,
    updatedAt: null,
    v: 0,
  );
}

class Receiver {
  final String id;
  final String role;

  const Receiver({required this.id, required this.role});

  factory Receiver.fromJson(Map<String, dynamic>? json) {
    final map = json ?? <String, dynamic>{};

    return Receiver(
      id: SafeParser.id(map['id']),
      role: SafeParser.str(map['role']),
    );
  }

  static Receiver fallback() => const Receiver(id: '', role: '');
}

class DatumMeta {
  final String id;
  final DateTime? lastActivityAt;

  const DatumMeta({required this.id, required this.lastActivityAt});

  factory DatumMeta.fromJson(Map<String, dynamic>? json) {
    final map = json ?? <String, dynamic>{};

    return DatumMeta(
      id: SafeParser.id(map['_id']),
      lastActivityAt: SafeParser.date(map['lastActivityAt']),
    );
  }

  static DatumMeta fallback() => DatumMeta(id: '', lastActivityAt: null);
}

class Participant {
  final String id;
  final String role;
  final String name;
  final String image;

  const Participant({
    required this.id,
    required this.role,
    required this.name,
    required this.image,
  });

  factory Participant.fromJson(Map<String, dynamic>? json) {
    final map = json ?? <String, dynamic>{};

    return Participant(
      id: SafeParser.id(map['id']),
      role: SafeParser.str(map['role']),
      name: SafeParser.str(map['name']),
      image: SafeParser.str(map['image']),
    );
  }

  static Participant fallback() =>
      const Participant(id: '', role: '', name: '', image: '');
}

class ChatPersonListModelMeta {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  const ChatPersonListModelMeta({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory ChatPersonListModelMeta.fromJson(Map<String, dynamic>? json) {
    final map = json ?? <String, dynamic>{};

    return ChatPersonListModelMeta(
      total: SafeParser.intVal(map['total']),
      page: SafeParser.intVal(map['page']),
      limit: SafeParser.intVal(map['limit']),
      totalPages: SafeParser.intVal(map['totalPages']),
    );
  }

  static ChatPersonListModelMeta fallback() => const ChatPersonListModelMeta(
    total: 0,
    page: 1,
    limit: 10,
    totalPages: 0,
  );
}

extension LastMessageX on LastMessage {
  String get formattedTime {
    final dt = createdAt;
    if (dt == null) return '';

    final hour = dt.hour;
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour % 12 == 0 ? 12 : hour % 12;

    return '$displayHour:$minute $period';
  }
}
