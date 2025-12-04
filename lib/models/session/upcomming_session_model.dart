class UpComingSessionModel {
  Time? time;
  String? sId;
  Parent? parent;
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

  UpComingSessionModel({
    this.time,
    this.sId,
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
    this.iV,
  });

  UpComingSessionModel.fromJson(Map<String, dynamic> json) {
    time = json['time'] != null ? new Time.fromJson(json['time']) : null;
    sId = json['_id'];
    parent = json['parent'] != null
        ? new Parent.fromJson(json['parent'])
        : null;
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

class Time {
  String? startTime;
  String? endTime;

  Time({this.startTime, this.endTime});

  Time.fromJson(Map<String, dynamic> json) {
    startTime = json['startTime'];
    endTime = json['endTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    return data;
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

  Parent({
    this.sId,
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
    this.iV,
  });

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

  Professional({
    this.sId,
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
    this.iV,
  });

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
