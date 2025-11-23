class SessionsResponseData {
  String? id;
  ParentData? parent;
  ProfessionalData? professional;
  String? day;
  String? date;
  String? subject;
  String? status;
  String? code;
  bool? isSessionVerified;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;

  SessionsResponseData({
    this.id,
    this.parent,
    this.professional,
    this.day,
    this.date,
    this.subject,
    this.status,
    this.code,
    this.isSessionVerified,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
  });

  factory SessionsResponseData.fromJson(Map<String, dynamic> json) {
    return SessionsResponseData(
      id: json['_id'],
      parent: json['parent'] != null
          ? (json['parent'] is String
          ? null
          : ParentData.fromJson(json['parent']))
          : null,
      professional: json['professional'] != null
          ? (json['professional'] is String
          ? null
          : ProfessionalData.fromJson(json['professional']))
          : null,
      day: json['day'],
      date: json['date'],
      subject: json['subject'],
      status: json['status'],
      code: json['code'],
      isSessionVerified: json['isSessionVerified'],
      isDeleted: json['isDeleted'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'parent': parent?.toJson(),
      'professional': professional?.toJson(),
      'day': day,
      'date': date,
      'subject': subject,
      'status': status,
      'code': code,
      'isSessionVerified': isSessionVerified,
      'isDeleted': isDeleted,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class ParentData {
  String? id;
  UserData? user;
  String? name;
  String? phoneNumber;
  String? childsName;
  String? childsGrade;
  String? relationshipWithChild;
  String? profileImage;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;

  ParentData({
    this.id,
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
  });

  factory ParentData.fromJson(Map<String, dynamic> json) {
    return ParentData(
      id: json['_id'],
      user: json['user'] != null ? UserData.fromJson(json['user']) : null,
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      childsName: json['childs_name'],
      childsGrade: json['childs_grade'],
      relationshipWithChild: json['relationship_with_child'],
      profileImage: json['profileImage'],
      isDeleted: json['isDeleted'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': user?.toJson(),
      'name': name,
      'phoneNumber': phoneNumber,
      'childs_name': childsName,
      'childs_grade': childsGrade,
      'relationship_with_child': relationshipWithChild,
      'profileImage': profileImage,
      'isDeleted': isDeleted,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class ProfessionalData {
  String? id;
  UserData? user;
  String? name;
  String? bio;
  String? phoneNumber;
  String? profileImage;
  String? qualification;
  List<String>? subjects;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;

  ProfessionalData({
    this.id,
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
  });

  factory ProfessionalData.fromJson(Map<String, dynamic> json) {
    return ProfessionalData(
      id: json['_id'],
      user: json['user'] != null ? UserData.fromJson(json['user']) : null,
      name: json['name'],
      bio: json['bio'],
      phoneNumber: json['phoneNumber'],
      profileImage: json['profileImage'],
      qualification: json['qualification'],
      subjects: json['subjects'] != null
          ? List<String>.from(json['subjects'])
          : null,
      isDeleted: json['isDeleted'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': user?.toJson(),
      'name': name,
      'bio': bio,
      'phoneNumber': phoneNumber,
      'profileImage': profileImage,
      'qualification': qualification,
      'subjects': subjects,
      'isDeleted': isDeleted,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class UserData {
  String? id;
  String? email;

  UserData({
    this.id,
    this.email,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['_id'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'email': email,
    };
  }
}