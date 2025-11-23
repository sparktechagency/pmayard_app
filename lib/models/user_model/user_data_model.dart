class UserModelData {
  String? sId;
  RoleId? roleId;
  String? email;
  String? role;
  bool? isActive;
  String? otp;
  String? expiresAt;
  bool? isVerified;
  bool? isDeleted;
  String? passwordChangedAt;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? roleRef;

  UserModelData({
    this.sId,
    this.roleId,
    this.email,
    this.role,
    this.isActive,
    this.otp,
    this.expiresAt,
    this.isVerified,
    this.isDeleted,
    this.passwordChangedAt,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.roleRef,
  });

  UserModelData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    roleId = json['roleId'] != null ? RoleId.fromJson(json['roleId']) : null;
    email = json['email'];
    role = json['role'];
    isActive = json['isActive'];
    otp = json['otp'];
    expiresAt = json['expiresAt'];
    isVerified = json['isVerified'];
    isDeleted = json['isDeleted'];
    passwordChangedAt = json['passwordChangedAt'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    roleRef = json['roleRef'];
  }
}

class RoleId {
  String? sId;
  String? user;
  String? name;
  String? bio;
  String? phoneNumber;
  String? profileImage;
  String? qualification;
  List<String>? subjects;
  List<Availability>? availability;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;
  int? iV;

  RoleId({
    this.sId,
    this.user,
    this.name,
    this.bio,
    this.phoneNumber,
    this.profileImage,
    this.qualification,
    this.subjects,
    this.availability,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  RoleId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    user = json['user'];
    name = json['name'];
    bio = json['bio'];
    phoneNumber = json['phoneNumber'];
    profileImage = json['profileImage'];
    qualification = json['qualification'];
    // Fix: Handle null safely
    subjects = json['subjects'] != null
        ? List<String>.from(json['subjects'])
        : null;
    if (json['availability'] != null) {
      availability = <Availability>[];
      json['availability'].forEach((v) {
        availability!.add(Availability.fromJson(v));
      });
    }
    isDeleted = json['isDeleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }
}

class Availability {
  String? day;
  List<TimeSlots>? timeSlots;
  String? sId;

  Availability({this.day, this.timeSlots, this.sId});

  Availability.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    if (json['timeSlots'] != null) {
      timeSlots = <TimeSlots>[];
      json['timeSlots'].forEach((v) {
        timeSlots!.add(TimeSlots.fromJson(v));
      });
    }
    sId = json['_id'];
  }
}

class TimeSlots {
  String? startTime;
  String? endTime;
  String? status;
  String? sId;

  TimeSlots({this.startTime, this.endTime, this.status, this.sId});

  TimeSlots.fromJson(Map<String, dynamic> json) {
    startTime = json['startTime'];
    endTime = json['endTime'];
    status = json['status'];
    sId = json['_id'];
  }
}