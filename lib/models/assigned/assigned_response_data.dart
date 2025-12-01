class AssignedParentModelData {
  String? sId;
  ProfessionalData? professional;
  String? parent;
  String? conversationId;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;
  int? iV;

  AssignedParentModelData({
    this.sId,
    this.professional,
    this.parent,
    this.conversationId,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  AssignedParentModelData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];

    // Handle the case where professional might be an ID string or a full object
    if (json['professional'] != null) {
      if (json['professional'] is String) {
        // If it's a string ID, just store as string, don't try to parse as object
      } else if (json['professional'] is Map<String, dynamic>) {
        // If it's a Map, create the ProfessionalData object
        professional = ProfessionalData.fromJson(json['professional'] as Map<String, dynamic>);
      }
    }

    // Handle the case where parent might be an ID string or a full object
    if (json['parent'] != null) {
      if (json['parent'] is String) {
        // If it's a string ID
        parent = json['parent'] as String;
      } else if (json['parent'] is Map<String, dynamic>) {
        // If it's a Map (unexpected for this model but handle gracefully)
        // We could store the ID from the map if needed
        parent = json['parent']['_id'] as String?;
      }
    } else {
      parent = json['parent']; // original assignment for null case
    }

    conversationId = json['conversation_id'];
    isDeleted = json['isDeleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_id'] = sId;
    if (professional != null) {
      data['professional'] = professional!.toJson();
    }
    data['parent'] = parent;
    data['conversation_id'] = conversationId;
    data['isDeleted'] = isDeleted;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class ProfessionalData {
  String? sId;
  ProfessionalUser? user;
  String? name;
  String? bio;
  String? phoneNumber;
  String? profileImage;
  String? qualification;
  List<String>? subjects;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;
  int? iV;

  ProfessionalData({
    this.sId,
    this.user,
    this.name,
    this.bio,
    this.phoneNumber,
    this.profileImage,
    this.qualification,
    this.subjects,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  ProfessionalData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    user = json['user'] != null ? ProfessionalUser.fromJson(json['user']) : null;
    name = json['name'];
    bio = json['bio'];
    phoneNumber = json['phoneNumber'];
    profileImage = json['profileImage'];
    qualification = json['qualification'];
    subjects = json['subjects'] != null ? List<String>.from(json['subjects']) : null;
    isDeleted = json['isDeleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_id'] = sId;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['name'] = name;
    data['bio'] = bio;
    data['phoneNumber'] = phoneNumber;
    data['profileImage'] = profileImage;
    data['qualification'] = qualification;
    data['subjects'] = subjects;
    data['isDeleted'] = isDeleted;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class ProfessionalUser {
  String? sId;
  String? email;
  String? role;

  ProfessionalUser({this.sId, this.email, this.role});

  ProfessionalUser.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    email = json['email'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_id'] = sId;
    data['email'] = email;
    data['role'] = role;
    return data;
  }
}