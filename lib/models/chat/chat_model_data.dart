class ChatModelData {
  String? sId;
  String? type;
  List<String>? users;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;
  int? iV;
  OtherUser? otherUser;
  LastMsg? lastMsg;

  ChatModelData(
      {this.sId,
        this.type,
        this.users,
        this.isDeleted,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.otherUser,
        this.lastMsg});

  ChatModelData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    type = json['type'];
    users = json['users'].cast<String>();
    isDeleted = json['isDeleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    otherUser = json['otherUser'] != null
        ? new OtherUser.fromJson(json['otherUser'])
        : null;
    lastMsg =
    json['lastMsg'] != null ? new LastMsg.fromJson(json['lastMsg']) : null;
  }

}

class OtherUser {
  String? sId;
  RoleId? roleId;
  String? email;
  String? role;
  String? profileImage;

  OtherUser({this.sId, this.roleId, this.email, this.role, this.profileImage});

  OtherUser.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    roleId =
    json['roleId'] != null ? new RoleId.fromJson(json['roleId']) : null;
    email = json['email'];
    role = json['role'];
    profileImage = json['profileImage'];
  }
}

class RoleId {
  String? sId;
  String? name;
  ProfileImage? profileImage;

  RoleId({this.sId, this.name, this.profileImage});

  RoleId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    profileImage = json['profileImage'] != null
        ? new ProfileImage.fromJson(json['profileImage'])
        : null;
  }
}

class ProfileImage {
  String? path;
  String? url;

  ProfileImage({this.path, this.url});

  ProfileImage.fromJson(Map<String, dynamic> json) {
    path = json['path'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['path'] = this.path;
    data['url'] = this.url;
    return data;
  }
}

class LastMsg {
  String? sId;
  String? senderId;
  String? messageText;
  bool? isRead;
  String? messageType;
  String? createdAt;

  LastMsg(
      {this.sId,
        this.senderId,
        this.messageText,
        this.isRead,
        this.messageType,
        this.createdAt});

  LastMsg.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    senderId = json['sender_id'];
    messageText = json['message_text'];
    isRead = json['is_read'];
    messageType = json['message_type'];
    createdAt = json['createdAt'];
  }
}
