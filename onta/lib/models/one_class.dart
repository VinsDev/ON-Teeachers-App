import 'dart:convert';

ClassData classDataFromJson(String str) => ClassData.fromJson(json.decode(str));

String classDataToJson(ClassData data) => json.encode(data.toJson());

class ClassData {
  ClassData({
    required this.attendanceDates,
    required this.todayIndex,
    required this.students,
  });
  late final List<AttendanceDates> attendanceDates;
  late int todayIndex;
  late final List<Students> students;

  ClassData.fromJson(Map<String, dynamic> json) {
    attendanceDates = List.from(json['attendance_dates'])
        .map((e) => AttendanceDates.fromJson(e))
        .toList();
    todayIndex = json['today_index'];
    students =
        List.from(json['students']).map((e) => Students.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['attendance_dates'] = attendanceDates.map((e) => e.toJson()).toList();
    _data['today_index'] = todayIndex;
    _data['students'] = students.map((e) => e.toJson()).toList();
    return _data;
  }
}

class AttendanceDates {
  AttendanceDates({
    required this.date,
    required this.active,
  });
  late final String date;
  late final bool active;

  AttendanceDates.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['date'] = date;
    _data['active'] = active;
    return _data;
  }
}

class Students {
  Students({
    required this.name,
    required this.gender,
    required this.morning,
    required this.afternoon,
  });
  late final String name;
  late final String gender;
  late final List<String> morning;
  late final List<String> afternoon;

  Students.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    gender = json['gender'];
    morning = List.castFrom<dynamic, String>(json['morning']);
    afternoon = List.castFrom<dynamic, String>(json['afternoon']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name;
    _data['gender'] = gender;
    _data['morning'] = morning;
    _data['afternoon'] = afternoon;
    return _data;
  }
}
