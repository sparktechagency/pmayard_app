class UserDataModel {
  String? sId;
  Null? roleId;
  String? email;
  String? role;
  bool? isActive;
  Null? otp;
  Null? expiresAt;
  bool? isVerified;
  bool? isDeleted;
  String? passwordChangedAt;
  String? createdAt;
  String? updatedAt;
  int? iV;

  UserDataModel({
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
  });

  UserDataModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    roleId = json['roleId'];
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['roleId'] = roleId;
    data['email'] = email;
    data['role'] = role;
    data['isActive'] = isActive;
    data['otp'] = otp;
    data['expiresAt'] = expiresAt;
    data['isVerified'] = isVerified;
    data['isDeleted'] = isDeleted;
    data['passwordChangedAt'] = passwordChangedAt;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}
