class AssignViewProfileModel {
  String id;
  User user;
  String name;
  String phoneNumber;
  String childsName;
  String childsGrade;
  String relationshipWithChild;
  String profileImage;
  bool isDeleted;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  AssignViewProfileModel({
    required this.id,
    required this.user,
    required this.name,
    required this.phoneNumber,
    required this.childsName,
    required this.childsGrade,
    required this.relationshipWithChild,
    required this.profileImage,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory AssignViewProfileModel.fromJson(Map<String, dynamic> json) => AssignViewProfileModel(
    id: json["_id"],
    user: User.fromJson(json["user"]),
    name: json["name"],
    phoneNumber: json["phoneNumber"],
    childsName: json["childs_name"],
    childsGrade: json["childs_grade"],
    relationshipWithChild: json["relationship_with_child"],
    profileImage: json["profileImage"],
    isDeleted: json["isDeleted"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );
}

class User {
  String id;
  String roleId;
  String email;
  String role;
  bool isActive;
  bool isVerified;
  bool isDeleted;
  dynamic passwordChangedAt;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  String roleRef;
  User({
    required this.id,
    required this.roleId,
    required this.email,
    required this.role,
    required this.isActive,
    required this.isVerified,
    required this.isDeleted,
    required this.passwordChangedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.roleRef,
  });
  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["_id"],
    roleId: json["roleId"],
    email: json["email"],
    role: json["role"],
    isActive: json["isActive"],
    isVerified: json["isVerified"],
    isDeleted: json["isDeleted"],
    passwordChangedAt: json["passwordChangedAt"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    roleRef: json["roleRef"],
  );
}
