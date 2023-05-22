import 'dart:convert';

List<String> classesFromJson(String str) =>
    List<String>.from(json.decode(str).map((x) => x));

String classesToJson(List<String> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x)));
