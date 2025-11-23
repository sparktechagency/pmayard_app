class AssignedResponseData {
  String? id;
  dynamic parent; // Can be String or ParentInfo
  dynamic professional; // Can be String or ProfessionalInfo
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;
  int? version;

  ParentInfo? get parentInfo =>
      parent is Map ? ParentInfo.fromJson(parent) : null;

  String? get parentId => parent is String ? parent : null;

  ProfessionalInfo? get professionalInfo =>
      professional is Map ? ProfessionalInfo.fromJson(professional) : null;

  String? get professionalId => professional is String ? professional : null;

  AssignedResponseData({
    this.id,
    this.parent,
    this.professional,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.version,
  });

  AssignedResponseData.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    parent = json['parent']; // Can be String or Map
    professional = json['professional']; // Can be String or Map
    isDeleted = json['isDeleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    version = json['__v'];
  }
}

class ProfessionalInfo {
  String? id;
  UserBasicInfo? user;
  String? name;
  String? bio;
  String? phoneNumber;
  String? profileImage;
  String? qualification;
  List<String>? subjects;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;
  int? version;

  ProfessionalInfo({
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
    this.version,
  });

  ProfessionalInfo.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    user = json['user'] != null ? UserBasicInfo.fromJson(json['user']) : null;
    name = json['name'];
    bio = json['bio'];
    phoneNumber = json['phoneNumber'];
    profileImage = json['profileImage'];
    qualification = json['qualification'];
    subjects = json['subjects'] != null
        ? List<String>.from(json['subjects'])
        : null;
    isDeleted = json['isDeleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    version = json['__v'];
  }
}

class ParentInfo {
  String? id;
  UserBasicInfo? user;
  String? name;
  String? phoneNumber;
  String? childsName;
  String? childsGrade;
  String? relationshipWithChild;
  String? profileImage;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;
  int? version;

  ParentInfo({
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
    this.version,
  });

  ParentInfo.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    user = json['user'] != null ? UserBasicInfo.fromJson(json['user']) : null;
    name = json['name'];
    phoneNumber = json['phoneNumber'];
    childsName = json['childs_name'];
    childsGrade = json['childs_grade'];
    relationshipWithChild = json['relationship_with_child'];
    profileImage = json['profileImage'];
    isDeleted = json['isDeleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    version = json['__v'];
  }
}

class UserBasicInfo {
  String? id;
  String? email;
  String? role;

  UserBasicInfo({
    this.id,
    this.email,
    this.role,
  });

  UserBasicInfo.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    email = json['email'];
    role = json['role'];
  }
}
