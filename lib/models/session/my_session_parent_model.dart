
class MySessionParentModelData {
  Time? time;
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

  MySessionParentModelData(
      {this.time,
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
        this.updatedAt});

  MySessionParentModelData.fromJson(Map<String, dynamic> json) {
    time = json['time'] != null ? new Time.fromJson(json['time']) : null;
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.time != null) {
      data['time'] = this.time!.toJson();
    }
    data['_id'] = this.sId;
    data['parent'] = this.parent;
    if (this.professional != null) {
      data['professional'] = this.professional!.toJson();
    }
    data['conversation_id'] = this.conversationId;
    data['day'] = this.day;
    data['date'] = this.date;
    data['subject'] = this.subject;
    data['status'] = this.status;
    data['code'] = this.code;
    data['isSessionVerified'] = this.isSessionVerified;
    data['isDeleted'] = this.isDeleted;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
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

class Professional {
  String? sId;
  String? user;
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
    user = json['user'];
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['user'] = this.user;
    data['name'] = this.name;
    data['bio'] = this.bio;
    data['phoneNumber'] = this.phoneNumber;
    data['profileImage'] = this.profileImage;
    data['qualification'] = this.qualification;
    data['subjects'] = this.subjects;
    data['isDeleted'] = this.isDeleted;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
