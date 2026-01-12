class ChatModelData {
  String? sId;
  String? type;
  List<Users>? users;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;
  int? iV;
  LastMsg? lastMsg;

  ChatModelData({
    this.sId,
    this.type,
    this.users,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.lastMsg,
  });

  ChatModelData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    type = json['type'];
    if (json['users'] != null) {
      users = <Users>[];
      json['users'].forEach((v) {
        users!.add(new Users.fromJson(v));
      });
    }
    isDeleted = json['isDeleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    lastMsg = json['lastMsg'] != null
        ? new LastMsg.fromJson(json['lastMsg'])
        : null;
  }
}

class Users {
  String? sId;
  RoleId? roleId;
  String? roleRef;
  String? email;
  String? role;

  Users({this.sId, this.roleId, this.roleRef, this.email, this.role});

  Users.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    roleId = json['roleId'] != null
        ? new RoleId.fromJson(json['roleId'])
        : null;
    roleRef = json['roleRef'];
    email = json['email'];
    role = json['role'];
  }
}

class RoleId {
  String? sId;
  String? name;
  String? profileImage;

  RoleId({this.sId, this.name, this.profileImage});

  RoleId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    profileImage = json['profileImage'];
  }
}

class LastMsg {
  String? sId;
  String? senderId;
  String? messageText;
  bool? isRead;
  String? messageType;
  String? createdAt;

  LastMsg({
    this.sId,
    this.senderId,
    this.messageText,
    this.isRead,
    this.messageType,
    this.createdAt,
  });

  LastMsg.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    senderId = json['sender_id'];
    messageText = json['message_text'];
    isRead = json['is_read'];
    messageType = json['message_type'];
    createdAt = json['createdAt'];
  }
}
