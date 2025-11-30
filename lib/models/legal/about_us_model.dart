class AboutUsDataModel {
  String? sId;
  String? title;
  String? content;
  String? updatedAt;

  AboutUsDataModel({this.sId, this.title, this.content, this.updatedAt});

  AboutUsDataModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    content = json['content'];
    updatedAt = json['updatedAt'];
  }
}
