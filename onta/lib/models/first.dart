class School {
  final bool success;
  final String? schoolName;

  const School({required this.success, required this.schoolName});

  factory School.fromJson(Map<String, dynamic> json) {
    return School(
      success: json['success'],
      schoolName: json['school_name'],
    );
  }
}