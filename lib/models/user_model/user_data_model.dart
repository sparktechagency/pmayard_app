class UserModelData {
  String? sId;
  RoleId? roleId;
  String? email;
  String? role;
  bool? isActive;
  dynamic otp;
  dynamic expiresAt;
  bool? isVerified;
  bool? isDeleted;
  dynamic passwordChangedAt;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? fcmToken;
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
    this.fcmToken,
    this.roleRef,
  });

  factory UserModelData.fromJson(Map<String, dynamic> json) {
    return UserModelData(
      sId: json['_id'],
      roleId:
      json['roleId'] != null ? RoleId.fromJson(json['roleId']) : null,
      email: json['email'],
      role: json['role'],
      isActive: json['isActive'],
      otp: json['otp'],
      expiresAt: json['expiresAt'],
      isVerified: json['isVerified'],
      isDeleted: json['isDeleted'],
      passwordChangedAt: json['passwordChangedAt'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      iV: json['__v'],
      fcmToken: json['fcmToken'],
      roleRef: json['roleRef'],
    );
  }
}

class RoleId {
  String? sId;
  String? user;
  String? name;
  String? bio;
  String? phoneNumber;
  ProfileImage? profileImage;
  String? qualification;
  List<String> subjects;
  List<Availability> availability;
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
    List<String>? subjects,
    List<Availability>? availability,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.iV,
  })  : subjects = subjects ?? [],
        availability = availability ?? [];

  factory RoleId.fromJson(Map<String, dynamic> json) {
    return RoleId(
      sId: json['_id'],
      user: json['user'],
      name: json['name'],
      bio: json['bio'],
      phoneNumber: json['phoneNumber'],
      profileImage: json['profileImage'] != null
          ? ProfileImage.fromJson(json['profileImage'])
          : null,
      qualification: json['qualification'],
      subjects: json['subjects'] != null
          ? List<String>.from(json['subjects'])
          : [],
      availability: json['availability'] != null
          ? (json['availability'] as List)
          .map((e) => Availability.fromJson(e))
          .toList()
          : [],
      isDeleted: json['isDeleted'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      iV: json['__v'],
    );
  }
}

class ProfileImage {
  String? path;
  String? url;

  ProfileImage({this.path, this.url});

  factory ProfileImage.fromJson(Map<String, dynamic> json) {
    return ProfileImage(
      path: json['path'],
      url: json['url'],
    );
  }
}

class Availability {
  String? day;
  List<TimeSlots> timeSlots;
  String? sId;

  Availability({
    this.day,
    List<TimeSlots>? timeSlots,
    this.sId,
  }) : timeSlots = timeSlots ?? [];

  factory Availability.fromJson(Map<String, dynamic> json) {
    return Availability(
      day: json['day'],
      timeSlots: json['timeSlots'] != null
          ? (json['timeSlots'] as List)
          .map((e) => TimeSlots.fromJson(e))
          .toList()
          : [],
      sId: json['_id'],
    );
  }
}

class TimeSlots {
  String? startTime;
  String? endTime;
  String? status;
  String? sId;

  TimeSlots({
    this.startTime,
    this.endTime,
    this.status,
    this.sId,
  });

  factory TimeSlots.fromJson(Map<String, dynamic> json) {
    return TimeSlots(
      startTime: json['startTime'],
      endTime: json['endTime'],
      status: json['status'],
      sId: json['_id'],
    );
  }
}
