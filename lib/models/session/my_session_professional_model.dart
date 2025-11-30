

class MySessionProfessionalModelData {
  Time? time;
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

  MySessionProfessionalModelData(
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

  MySessionProfessionalModelData.fromJson(Map<String, dynamic> json) {
    time = json['time'] != null ? new Time.fromJson(json['time']) : null;
    sId = json['_id'];
    parent =
    json['parent'] != null ? new Parent.fromJson(json['parent']) : null;
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.time != null) {
      data['time'] = this.time!.toJson();
    }
    data['_id'] = this.sId;
    if (this.parent != null) {
      data['parent'] = this.parent!.toJson();
    }
    data['professional'] = this.professional;
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

class Parent {
  String? sId;
  String? user;
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
    user = json['user'];
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['user'] = this.user;
    data['name'] = this.name;
    data['phoneNumber'] = this.phoneNumber;
    data['childs_name'] = this.childsName;
    data['childs_grade'] = this.childsGrade;
    data['relationship_with_child'] = this.relationshipWithChild;
    data['profileImage'] = this.profileImage;
    data['isDeleted'] = this.isDeleted;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
