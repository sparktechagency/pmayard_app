class GroupChatMessageModel {
  String id;
  String conversationName;
  String type;
  List<String> users;
  bool isDeleted;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  GroupChatMessageModel({
    required this.id,
    required this.conversationName,
    required this.type,
    required this.users,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory GroupChatMessageModel.fromJson(Map<String, dynamic> json) => GroupChatMessageModel(
    id: json["_id"]  ?? '',
    conversationName: json["conversationName"] ?? '',
    type: json["type"]  ?? '',
    users: List<String>.from(json["users"].map((x) => x)),
    isDeleted: json["isDeleted"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "conversationName": conversationName,
    "type": type,
    "users": List<dynamic>.from(users.map((x) => x)),
    "isDeleted": isDeleted,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
  };
}
