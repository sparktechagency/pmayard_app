
class TimeSlotModel {
  String? startTime;
  String? endTime;
  String? status;

  TimeSlotModel({this.startTime, this.endTime, this.status});

  factory TimeSlotModel.fromJson(Map<String, dynamic> json) {
    return TimeSlotModel(
      startTime: json["startTime"],
      endTime: json["endTime"],
      status: json["status"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "startTime": startTime,
      "endTime": endTime,
      "status": status,
    };
  }
}
