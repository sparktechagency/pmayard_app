class MetarialsModel{
  String id;
  String subjectId;
  String title;
  String fileUrl;
  String mimeType;
  bool isDeleted;
  DateTime createdAt;
  DateTime updatedAt;

  MetarialsModel({
    required this.id,
    required this.subjectId,
    required this.title,
    required this.fileUrl,
    required this.mimeType,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MetarialsModel.fromJson(Map<String, dynamic> json) => MetarialsModel(
    id: json["_id"],
    subjectId: json["subjectId"],
    title: json["title"],
    fileUrl: json["fileUrl"],
    mimeType: json["mimeType"],
    isDeleted: json["isDeleted"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );
}

