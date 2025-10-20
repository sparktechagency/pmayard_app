class ProfileConfirmPrms {
  String? name;
  String? bio;
  String? phoneNumber;
  String? qualification;
  List<String>? subjects;
  List<Availability>? availability;

  ProfileConfirmPrms(
      {this.name,
        this.bio,
        this.phoneNumber,
        this.qualification,
        this.subjects,
        this.availability});

  ProfileConfirmPrms.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    bio = json['bio'];
    phoneNumber = json['phoneNumber'];
    qualification = json['qualification'];
    subjects = json['subjects'].cast<String>();
    if (json['availability'] != null) {
      availability = <Availability>[];
      json['availability'].forEach((v) {
        availability!.add(new Availability.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['bio'] = bio;
    data['phoneNumber'] = phoneNumber;
    data['qualification'] = qualification;
    data['subjects'] = subjects;
    if (availability != null) {
      data['availability'] = availability!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Availability {
  String? day;
  List<TimeSlots>? timeSlots;

  Availability({this.day, this.timeSlots});

  Availability.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    if (json['timeSlots'] != null) {
      timeSlots = <TimeSlots>[];
      json['timeSlots'].forEach((v) {
        timeSlots!.add(new TimeSlots.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['day'] = day;
    if (timeSlots != null) {
      data['timeSlots'] = timeSlots!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TimeSlots {
  String? startTime;
  String? endTime;
  String? status;

  TimeSlots({this.startTime, this.endTime, this.status});

  TimeSlots.fromJson(Map<String, dynamic> json) {
    startTime = json['startTime'];
    endTime = json['endTime'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    data['status'] = status;
    return data;
  }
}
