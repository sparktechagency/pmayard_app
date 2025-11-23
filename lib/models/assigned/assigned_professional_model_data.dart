class AssignedProfessionalModelData {
  String? sId;
  Parent? parent;
  String? professional;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;
  int? iV;

  AssignedProfessionalModelData({
    this.sId,
    this.parent,
    this.professional,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  AssignedProfessionalModelData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    parent = json['parent'] != null
        ? Parent.fromJson(json['parent'])
        : null;
    professional = json['professional'];
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
    user = json['user'] != null ? User.fromJson(json['user']) : null;
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
