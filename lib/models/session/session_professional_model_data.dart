
class SessionProfessionalModelData {
  String? sId;
  Parent? parent;
  String? professional;
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

  SessionProfessionalModelData(
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

  SessionProfessionalModelData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];

    // Handle the case where parent might be an ID string or a full object
    if (json['parent'] != null) {
      if (json['parent'] is String) {
        // If it's a string ID, we can't create a Parent object from it
      } else if (json['parent'] is Map<String, dynamic>) {
        // If it's a Map, create the Parent object
        parent = Parent.fromJson(json['parent'] as Map<String, dynamic>);
      }
    }

    professional = json['professional'];
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

class Parent {
  String? sId;
  User? user;
  String? name;
  String? phoneNumber;
  String? childsName;
  String? childsGrade;
  String? relationshipWithChild;
  String? profileImage;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Parent(
      {this.sId,
        this.user,
        this.name,
        this.phoneNumber,
        this.childsName,
        this.childsGrade,
        this.relationshipWithChild,
        this.profileImage,
        this.isDeleted,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Parent.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    name = json['name'];
    phoneNumber = json['phoneNumber'];
    childsName = json['childs_name'];
    childsGrade = json['childs_grade'];
    relationshipWithChild = json['relationship_with_child'];
    profileImage = json['profileImage'];
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
