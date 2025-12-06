class GroupModelData {
  String? sId;
  String? conversationName;
  String? type;
  List<String>? users;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;
  int? iV;
  LastMsg? lastMsg;

  GroupModelData(
      {this.sId,
        this.conversationName,
        this.type,
        this.users,
        this.isDeleted,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.lastMsg});

  GroupModelData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    conversationName = json['conversationName'];
    type = json['type'];
    users = json['users'].cast<String>();
    isDeleted = json['isDeleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    lastMsg =
    json['lastMsg'] != null ? new LastMsg.fromJson(json['lastMsg']) : null;
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
