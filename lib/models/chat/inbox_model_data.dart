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
  SenderId? senderId;
  List<AttachmentId>? attachmentId;
  bool? isRead;
  String? messageType;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? messageText;

  Messages(
      {this.sId,
        this.conversationId,
        this.senderId,
        this.attachmentId,
        this.isRead,
        this.messageType,
        this.isDeleted,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.messageText});

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
    isRead = json['is_read'];
    messageType = json['message_type'];
    isDeleted = json['isDeleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    messageText = json['message_text'];
  }
}

class SenderId {
  String? sId;
  Null? roleId;
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
  dynamic? fileUrl;
  String? mimeType;

  AttachmentId({this.sId, this.fileUrl, this.mimeType});

  AttachmentId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    fileUrl = json['fileUrl'];
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
  List<Attachment>? attachment;
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
    if (json['attachment'] != null) {
      attachment = <Attachment>[];
      json['attachment'].forEach((v) {
        attachment!.add(Attachment.fromJson(v));
      });
    }
    messageType = json['message_type'];
    timestamp = json['timestamp'];
  }
}

class Attachment {
  String? id;
  UserImage? fileUrl;  // String, NOT an object
  String? mimeType;
  String? fileName;

  Attachment({
    this.id,
    this.fileUrl,
    this.mimeType,
    this.fileName,
  });

  Attachment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fileUrl = json['fileUrl'];  // Direct string assignment
    mimeType = json['mimeType'];
    fileName = json['fileName'];
  }
}
