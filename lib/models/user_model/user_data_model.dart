class UserDataModel {
  String? id;
  RoleIdModel? roleId;
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
  int? v;

  UserDataModel({
    this.id,
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
    this.v,
  });

  UserDataModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    roleId = json['roleId'] != null
        ? RoleIdModel.fromJson(json['roleId'])
        : null;
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
    v = json['__v'];
  }
}


class RoleIdModel {
  String? id;
  String? user;
  String? name;
  String? bio;
  String? phoneNumber;
  String? profileImage;
  String? qualification;
  List<dynamic>? subjects;
  List<AvailabilityModel>? availability;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;
  int? v;

  RoleIdModel({
    this.id,
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
    this.v,
  });

  RoleIdModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    user = json['user'];
    name = json['name'];
    bio = json['bio'];
    phoneNumber = json['phoneNumber'];
    profileImage = json['profileImage'];
    qualification = json['qualification'];
    subjects = json['subjects'];

    if (json['availability'] != null) {
      availability = [];
      json['availability'].forEach((v) {
        availability!.add(AvailabilityModel.fromJson(v));
      });
    }

    isDeleted = json['isDeleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
  }
}

class AvailabilityModel {
  String? day;
  List<TimeSlotModel>? timeSlots;
  String? id;

  AvailabilityModel({this.day, this.timeSlots, this.id});

  AvailabilityModel.fromJson(Map<String, dynamic> json) {
    day = json['day'];

    if (json['timeSlots'] != null) {
      timeSlots = [];
      json['timeSlots'].forEach((v) {
        timeSlots!.add(TimeSlotModel.fromJson(v));
      });
    }

    id = json['_id'];
  }
}
class TimeSlotModel {
  String? startTime;
  String? endTime;
  String? status;
  String? id;

  TimeSlotModel({this.startTime, this.endTime, this.status, this.id});

  TimeSlotModel.fromJson(Map<String, dynamic> json) {
    startTime = json['startTime'];
    endTime = json['endTime'];
    status = json['status'];
    id = json['_id'];
  }
}
