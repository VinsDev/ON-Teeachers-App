import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:onta/models/classes.dart';
import 'package:onta/models/first.dart';

import '../models/one_class.dart';

class RemoteService {
  RemoteService(this.url);
  final String url;

  Future getData() async {
    var client = http.Client();
    var uri = Uri.parse("https://www.orbitalnodetechnologies.com/ontap$url");

    try {
      var response = await client.get(uri);
      if (response.statusCode == 200) {
        var json = response.body;
        if (url.contains("/Jobs international schools/getClassList")) {
          return classesFromJson(json);
        } else {
          return classDataFromJson(json);
        }
      }
    } on SocketException {
      return 0;
    } on HttpException {
      return 1;
    } on FormatException {
      return 2;
    }
  }

  Future login(String username, String password) async {
    final response = await http.post(
      Uri.parse('https://www.orbitalnodetechnologies.com/ontap$url'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          <String, String>{'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      print(response.body);
      return School.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create album.');
    }
  }
}




// https://www.orbitalnodetechnologies.com/ontap/Jobs international schools/getAttendanceForClass/SSS3