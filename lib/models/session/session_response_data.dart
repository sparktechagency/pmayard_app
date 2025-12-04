import 'package:pmayard_app/models/session/parent_model.dart';

import 'my_session_parent_model.dart';

class SessionParentModelData {
  String? sId;
  ParentModel? parent;
  Professional? professional;
  String? conversationId;
  String? day;
  String? date;
  String? subject;
  String? status;
  String? code;
  bool? isSessionVerified;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;
  int? iV;

  SessionParentModelData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];

    // Handle the case where parent might be an ID string or a full object
    if (json['parent'] != null) {
      if (json['parent'] is String) {
        // If it's a string ID, we can't create a ParentModel object from it
      } else if (json['parent'] is Map<String, dynamic>) {
        // If it's a Map, create the ParentModel object
        parent = ParentModel.fromJson(json['parent'] as Map<String, dynamic>);
      }
    }

    // Handle the case where professional might be an ID string or a full object
    if (json['professional'] != null) {
      if (json['professional'] is String) {
        // If it's a string ID, we can't create a Professional object from it
      } else if (json['professional'] is Map<String, dynamic>) {
        // If it's a Map, create the Professional object
        professional = Professional.fromJson(json['professional'] as Map<String, dynamic>);
      }
    }

    conversationId = json['conversation_id'];
    day = json['day'];
    date = json['date'];
    subject = json['subject'];
    status = json['status'];
    code = json['code'];
    isSessionVerified = json['isSessionVerified'];
    isDeleted = json['isDeleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }
}
