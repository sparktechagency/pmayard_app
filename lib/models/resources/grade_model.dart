class GradesModel {
  String id;
  dynamic user;
  String name;
  bool isDeleted;
  DateTime createdAt;
  DateTime updatedAt;

  GradesModel({
    required this.id,
    required this.user,
    required this.name,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GradesModel.fromJson(Map<String, dynamic> json) => GradesModel(
    id: json["_id"],
    user: json["user"],
    name: json["name"],
    isDeleted: json["isDeleted"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );
}

class Meta {
  int total;
  int page;
  int limit;
  int totalPage;

  Meta({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPage,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    total: json["total"],
    page: json["page"],
    limit: json["limit"],
    totalPage: json["totalPage"],
  );
}
