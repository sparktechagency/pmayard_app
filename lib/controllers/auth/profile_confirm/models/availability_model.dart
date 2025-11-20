import 'package:pmayard_app/controllers/auth/profile_confirm/models/time_slot_model.dart';

class AvailabilityModel {
  String? day;
  List<TimeSlotModel>? timeSlots;

  AvailabilityModel({this.day, this.timeSlots});

  factory AvailabilityModel.fromJson(Map<String, dynamic> json) {
    return AvailabilityModel(
      day: json["day"],
      timeSlots: json["timeSlots"] != null
          ? List<TimeSlotModel>.from(
              json["timeSlots"].map((x) => TimeSlotModel.fromJson(x)),
            )
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "day": day,
      "timeSlots": timeSlots?.map((x) => x.toJson()).toList(),
    };
  }
}
