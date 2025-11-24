class InboxModelData {
  OppositeUser? oppositeUser;
  List<Messages>? messages;

  InboxModelData({this.oppositeUser, this.messages});

  InboxModelData.fromJson(Map<String, dynamic> json) {
    oppositeUser = json['oppositeUser'] != null
        ? new OppositeUser.fromJson(json['oppositeUser'])
        : null;
    if (json['messages'] != null) {
      messages = <Messages>[];
      json['messages'].forEach((v) {
        messages!.add(new Messages.fromJson(v));
      });
    }
  }
}

// "oppositeUser": {
// "userId": "692196e10116d572cabc6b01",
// "email": "montasirmihad78@gmail.com",
// "role": "parent",
// "userName": "John Doe",
// "userImage": "https://res.cloudinary.com/dmzmx97wn/image/upload/v1763267118/d761168f-2634-4c19-8bdd-1b24f93a0960%20%281%29.jpg"
// },

class OppositeUser {
  String? userId;
  String? email;
  String? role;
  String? userName;
  String? userImage;

  OppositeUser({this.userId, this.email, this.role,this.userImage,this.userName});

  OppositeUser.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    email = json['email'];
    role = json['role'];
    userName = json['userName'];
    userImage = json['userImage'];
  }
}

class Messages {
  String? sId;
  String? conversationId;
  SenderId? senderId;
  List<AttachmentId>? attachmentId;
  String? messageText;
  String? messageType;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Messages({
    this.sId,
    this.conversationId,
    this.senderId,
    this.attachmentId,
    this.messageText,
    this.messageType,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  Messages.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    conversationId = json['conversation_id'];
    senderId = json['sender_id'] != null
        ? new SenderId.fromJson(json['sender_id'])
        : null;
    if (json['attachment_id'] != null) {
      attachmentId = <AttachmentId>[];
      json['attachment_id'].forEach((v) {
        attachmentId!.add(new AttachmentId.fromJson(v));
      });
    }
    messageText = json['message_text'];
    messageType = json['message_type'];
    isDeleted = json['isDeleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }
}

class SenderId {
  String? sId;
  String? roleId;
  String? email;
  String? role;

  SenderId({this.sId, this.roleId, this.email, this.role});

  SenderId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    roleId = json['roleId'];
    email = json['email'];
    role = json['role'];
  }
}

class AttachmentId {
  String? sId;
  String? fileUrl;
  String? mimeType;

  AttachmentId({this.sId, this.fileUrl, this.mimeType});

  AttachmentId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    fileUrl = json['fileUrl'];
    mimeType = json['mimeType'];
  }
}
