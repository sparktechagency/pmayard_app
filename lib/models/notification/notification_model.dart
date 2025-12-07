class NotificationModel {
  String id;
  Sender sender;
  dynamic recipient;
  Type type;
  String message;
  bool isRead;
  DateTime createdAt;
  DateTime updatedAt;

  NotificationModel({
    required this.id,
    required this.sender,
    required this.recipient,
    required this.type,
    required this.message,
    required this.isRead,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
    id: json["_id"],
    sender: Sender.fromJson(json["sender"]),
    recipient: json["recipient"],
    type: typeValues.map[json["type"]]!,
    message: json["message"],
    isRead: json["isRead"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "sender": sender.toJson(),
    "recipient": recipient,
    "type": typeValues.reverse[type],
    "message": message,
    "isRead": isRead,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}

class Sender {
  Id id;

  Sender({
    required this.id,
  });

  factory Sender.fromJson(Map<String, dynamic> json) => Sender(
    id: idValues.map[json["_id"]]!,
  );

  Map<String, dynamic> toJson() => {
    "_id": idValues.reverse[id],
  };
}

enum Id {
  THE_6921328_DBCBC3_B5_B908_D69_BF,
  THE_6926728068_D97299_AE6040_BD,
  THE_692_A77_E133_CA872_A5_A4_A8827
}

final idValues = EnumValues({
  "6921328dbcbc3b5b908d69bf": Id.THE_6921328_DBCBC3_B5_B908_D69_BF,
  "6926728068d97299ae6040bd": Id.THE_6926728068_D97299_AE6040_BD,
  "692a77e133ca872a5a4a8827": Id.THE_692_A77_E133_CA872_A5_A4_A8827
});

enum Type {
  USER_JOIN,
  USER_REGISTRATION
}

final typeValues = EnumValues({
  "user_join": Type.USER_JOIN,
  "user_registration": Type.USER_REGISTRATION
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
