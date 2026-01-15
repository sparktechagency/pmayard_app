
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

class OppositeUser {
  String? userId;
  String? email;
  String? role;
  String? userName;
  UserImage? userImage;

  OppositeUser(
      {this.userId, this.email, this.role, this.userName, this.userImage});

  OppositeUser.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    email = json['email'];
    role = json['role'];
    userName = json['userName'];
    userImage = json['userImage'] != null
        ? new UserImage.fromJson(json['userImage'])
        : null;
  }
}

class UserImage {
  String? path;
  String? url;

  UserImage({this.path, this.url});

  UserImage.fromJson(Map<String, dynamic> json) {
    path = json['path'];
    url = json['url'];
  }
}

class Messages {
  String? sId;
  String? conversationId;
  String? senderId;
  List<AttachmentId>? attachmentId;
  String? messageText;
  bool? isRead;
  String? messageType;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Messages(
      {this.sId,
        this.conversationId,
        this.senderId,
        this.attachmentId,
        this.messageText,
        this.isRead,
        this.messageType,
        this.isDeleted,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Messages.fromJson(Map<String, dynamic> json) {
    senderId = json['sender_id'];
    conversationId = json['conversation_id'];
    sId = json['_id'];
    if (json['attachment_id'] != null) {
      attachmentId = <AttachmentId>[];
      json['attachment_id'].forEach((v) {
        attachmentId!.add(new AttachmentId.fromJson(v));
      });
    }
    messageText = json['message_text'];
    isRead = json['is_read'];
    messageType = json['message_type'];
    isDeleted = json['isDeleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }
}

class AttachmentId {
  String? sId;
  UserImage? fileUrl;
  String? mimeType;

  AttachmentId({this.sId, this.fileUrl, this.mimeType});

  AttachmentId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    fileUrl = json['fileUrl'] != null
        ? new UserImage.fromJson(json['fileUrl'])
        : null;
    mimeType = json['mimeType'];
  }
}








class SocketModelData {
  String? conversationId;
  Message? message;

  SocketModelData({this.conversationId, this.message});

  SocketModelData.fromJson(Map<String, dynamic> json) {
    conversationId = json['conversationId'];
    message = json['message'] != null
        ? Message.fromJson(json['message'])
        : null;
  }
}

// ============= MESSAGE (FOR SOCKET) =============
class Message {
  String? senderId;
  String? lastMessage;
  List<AttachmentId>? attachment;
  String? messageType;
  String? timestamp;

  Message({
    this.senderId,
    this.lastMessage,
    this.attachment,
    this.messageType,
    this.timestamp,
  });

  Message.fromJson(Map<String, dynamic> json) {
    senderId = json['sender_id'];
    lastMessage = json['lastMessage'];
    if (json['attachment_id'] != null) {
      attachment = <AttachmentId>[];
      json['attachment_id'].forEach((v) {
        attachment!.add(new AttachmentId.fromJson(v));
      });
    }
    messageType = json['message_type'];
    timestamp = json['timestamp'];
  }
}


