class AssignModel {
  String id;
  Parent parent;
  Parent professional;
  String conversationId;
  bool isDeleted;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  AssignModel({
    required this.id,
    required this.parent,
    required this.professional,
    required this.conversationId,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory AssignModel.fromJson(Map<String, dynamic> json) => AssignModel(
    id: json["_id"],
    parent: Parent.fromJson(json["parent"]),
    professional: Parent.fromJson(json["professional"]),
    conversationId: json["conversation_id"],
    isDeleted: json["isDeleted"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );
}

class Parent {
  String id;
  User user;
  String name;
  String phoneNumber;
  String? childsName;
  String? childsGrade;
  String? relationshipWithChild;
  String profileImage;
  bool isDeleted;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  String? bio;
  String? qualification;
  List<String>? subjects;

  Parent({
    required this.id,
    required this.user,
    required this.name,
    required this.phoneNumber,
    this.childsName,
    this.childsGrade,
    this.relationshipWithChild,
    required this.profileImage,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    this.bio,
    this.qualification,
    this.subjects,
  });

  factory Parent.fromJson(Map<String, dynamic> json) => Parent(
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
    bio: json["bio"],
    qualification: json["qualification"],
    subjects: json["subjects"] == null ? [] : List<String>.from(json["subjects"]!.map((x) => x)),
  );
}

class User {
  String id;
  String email;
  String role;

  User({
    required this.id,
    required this.email,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["_id"],
    email: json["email"],
    role: json["role"],
  );
}
