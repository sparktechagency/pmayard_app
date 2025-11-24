class TermsAndConditionDataModel {
  String? sId;
  String? title;
  String? content;
  String? updatedAt;

  TermsAndConditionDataModel({this.sId, this.title, this.content, this.updatedAt});

  TermsAndConditionDataModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    content = json['content'];
    updatedAt = json['updatedAt'];
  }
}
