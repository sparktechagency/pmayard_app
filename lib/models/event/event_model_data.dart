
class EventModelData {
  String? sId;
  String? name;
  String? startTime;
  String? endTime;
  String? eventDate;
  String? description;
  String? status;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;

  EventModelData(
      {this.sId,
        this.name,
        this.startTime,
        this.endTime,
        this.eventDate,
        this.description,
        this.status,
        this.isDeleted,
        this.createdAt,
        this.updatedAt});

  EventModelData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    eventDate = json['eventDate'];
    description = json['description'];
    status = json['status'];
    isDeleted = json['isDeleted'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
}
