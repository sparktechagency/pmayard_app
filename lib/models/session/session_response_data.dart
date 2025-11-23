
class SessionParentModelData {
  String? sId;
  String? parent;
  Professional? professional;
  String? conversationId;
  String? day;
  String? date;
  String? subject;
  String? status;
  String? code;
  bool? isSessionVerified;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;
  int? iV;

  SessionParentModelData(
      {this.sId,
        this.parent,
        this.professional,
        this.conversationId,
        this.day,
        this.date,
        this.subject,
        this.status,
        this.code,
        this.isSessionVerified,
        this.isDeleted,
        this.createdAt,
        this.updatedAt,
        this.iV});

  SessionParentModelData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    parent = json['parent'];
    professional = json['professional'] != null
        ? new Professional.fromJson(json['professional'])
        : null;
    conversationId = json['conversation_id'];
    day = json['day'];
    date = json['date'];
    subject = json['subject'];
    status = json['status'];
    code = json['code'];
    isSessionVerified = json['isSessionVerified'];
    isDeleted = json['isDeleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }
}

class Professional {
  String? sId;
  User? user;
  String? name;
  String? bio;
  String? phoneNumber;
  String? profileImage;
  String? qualification;
  List<String>? subjects;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Professional(
      {this.sId,
        this.user,
        this.name,
        this.bio,
        this.phoneNumber,
        this.profileImage,
        this.qualification,
        this.subjects,
        this.isDeleted,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Professional.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    name = json['name'];
    bio = json['bio'];
    phoneNumber = json['phoneNumber'];
    profileImage = json['profileImage'];
    qualification = json['qualification'];
    subjects = json['subjects'].cast<String>();
    isDeleted = json['isDeleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }
}

class User {
  String? sId;
  String? email;

  User({this.sId, this.email});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    email = json['email'];
  }
}
