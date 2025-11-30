class PrivacyPolicyDataModel {
  String? sId;
  String? title;
  String? content;
  String? updatedAt;

  PrivacyPolicyDataModel({this.sId, this.title, this.content, this.updatedAt});

  PrivacyPolicyDataModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    content = json['content'];
    updatedAt = json['updatedAt'];
  }
}
