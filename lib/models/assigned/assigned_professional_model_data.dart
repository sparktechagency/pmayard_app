class AssignedProfessionalModelData {
  String? sId;
  ParentData? parent;
  String? professional;
  String? conversationId;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;
  int? iV;

  AssignedProfessionalModelData({
    this.sId,
    this.parent,
    this.professional,
    this.conversationId,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  AssignedProfessionalModelData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];

    // Handle the case where parent might be an ID string or a full object
    if (json['parent'] != null) {
      if (json['parent'] is String) {
        // If it's a string ID, just store as string (unexpected for this model but handle gracefully)
        // For this model, parent should typically be an object, but if it's a string, we can't parse it
      } else if (json['parent'] is Map<String, dynamic>) {
        // If it's a Map, create the ParentData object
        parent = ParentData.fromJson(json['parent'] as Map<String, dynamic>);
      }
    }

    // Handle the case where professional might be an ID string or a full object
    if (json['professional'] != null) {
      if (json['professional'] is String) {
        // If it's a string ID, store it
        professional = json['professional'] as String;
      } else if (json['professional'] is Map<String, dynamic>) {
        // If it's a Map (unexpected for this model but handle gracefully)
        // Store the ID from the map
        professional = json['professional']['_id'] as String?;
      }
    } else {
      professional = json['professional']; // original assignment for null case
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
    if (parent != null) {
      data['parent'] = parent!.toJson();
    }
    data['professional'] = professional;
    data['conversation_id'] = conversationId;
    data['isDeleted'] = isDeleted;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class ParentData {
  String? sId;
  ParentUser? user;
  String? name;
  String? phoneNumber;
  String? childsName;
  String? childsGrade;
  String? relationshipWithChild;
  String? profileImage;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;
  int? iV;

  ParentData({
    this.sId,
    this.user,
    this.name,
    this.phoneNumber,
    this.childsName,
    this.childsGrade,
    this.relationshipWithChild,
    this.profileImage,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  ParentData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    user = json['user'] != null ? ParentUser.fromJson(json['user']) : null;
    name = json['name'];
    phoneNumber = json['phoneNumber'];
    childsName = json['childs_name'];
    childsGrade = json['childs_grade'];
    relationshipWithChild = json['relationship_with_child'];
    profileImage = json['profileImage'];
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
    data['phoneNumber'] = phoneNumber;
    data['childs_name'] = childsName;
    data['childs_grade'] = childsGrade;
    data['relationship_with_child'] = relationshipWithChild;
    data['profileImage'] = profileImage;
    data['isDeleted'] = isDeleted;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class ParentUser {
  String? sId;
  String? email;
  String? role;

  ParentUser({this.sId, this.email, this.role});

  ParentUser.fromJson(Map<String, dynamic> json) {
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