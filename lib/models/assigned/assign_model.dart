

class AssignModelData {
  String? sId;
  Parent? parent;
  Parent? professional;
  String? conversationId;
  String? day;
  String? date;
  String? subject;
  String? status;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;
  int? iV;

  AssignModelData(
      {this.sId,
        this.parent,
        this.professional,
        this.conversationId,
        this.day,
        this.date,
        this.subject,
        this.status,
        this.isDeleted,
        this.createdAt,
        this.updatedAt,
        this.iV});

  AssignModelData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    parent =
    json['parent'] != null ? new Parent.fromJson(json['parent']) : null;
    professional = json['professional'] != null
        ? new Parent.fromJson(json['professional'])
        : null;
    conversationId = json['conversation_id'];
    day = json['day'];
    date = json['date'];
    subject = json['subject'];
    status = json['status'];
    isDeleted = json['isDeleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }
}

class Parent {
  String? sId;
  User? user;
  String? name;
  String? profileImage;

  Parent({this.sId, this.user, this.name, this.profileImage});

  Parent.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    name = json['name'];
    profileImage = json['profileImage'];
  }
}

class User {
  String? sId;
  String? email;
  String? role;

  User({this.sId, this.email, this.role});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    email = json['email'];
    role = json['role'];
  }
}
