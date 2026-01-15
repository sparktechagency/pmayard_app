class MetarialsModel {
  String? sId;
  String? subjectId;
  String? title;
  FileUrl? fileUrl;
  String? mimeType;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;

  MetarialsModel({
    this.sId,
    this.subjectId,
    this.title,
    this.fileUrl,
    this.mimeType,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
  });

  MetarialsModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    subjectId = json['subjectId'];
    title = json['title'];
    fileUrl = json['fileUrl'] != null
        ? FileUrl.fromJson(json['fileUrl'])
        : null;
    mimeType = json['mimeType'];
    isDeleted = json['isDeleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
}

class FileUrl {
  String? path;
  String? url;

  FileUrl({this.path, this.url});

  FileUrl.fromJson(Map<String, dynamic> json) {
    path = json['path'];
    url = json['url'];
  }
}