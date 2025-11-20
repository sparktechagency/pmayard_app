import 'package:pmayard_app/controllers/auth/profile_confirm/models/availability_model.dart';

class ProfileModel {
  String? name;
  String? bio;
  String? phoneNumber;
  String? qualification;
  List<String>? subjects;
  List<AvailabilityModel>? availability;

  ProfileModel({
    this.name,
    this.bio,
    this.phoneNumber,
    this.qualification,
    this.subjects,
    this.availability,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      name: json["name"],
      bio: json["bio"],
      phoneNumber: json["phoneNumber"],
      qualification: json["qualification"],
      subjects: json["subjects"] != null
          ? List<String>.from(json["subjects"])
          : [],
      availability: json["availability"] != null
          ? List<AvailabilityModel>.from(
          json["availability"].map((x) => AvailabilityModel.fromJson(x)))
          : [],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "bio": bio,
      "phoneNumber": phoneNumber,
      "qualification": qualification,
      "subjects": subjects,
      "availability": availability?.map((x) =>  x.toJson()).toList(),
    };
  }
}




