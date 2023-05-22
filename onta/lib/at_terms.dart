import 'package:flutter/material.dart';
import 'package:onta/attendance.dart';
import 'package:onta/colors/colors.dart';

class AttendanceSessions extends StatelessWidget {
  final String selectedClass;
  const AttendanceSessions({super.key, required this.selectedClass});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: appColor,
          title: Text('$selectedClass Attendance',
              style: const TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4))),
      body: Container(
          child: termList(['First Term', 'Second Term', 'Third Term'])),
    );
  }

  termList(List<String> items) {
    return ListView.builder(
        padding: const EdgeInsets.only(top: 1),
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            enableFeedback: true,
            onTap: (() {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Attendance(
                            selectedClass: selectedClass,
                            term: items[index],
                          )));
            }),
            title: Container(
              alignment: Alignment.centerLeft,
              height: 50,
              padding: const EdgeInsets.only(left: 10),
              child: Text(items[index],
                  style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 75, 74, 74),
                      letterSpacing: 0.2)),
            ),
          );
        },
        itemCount: items.length);
  }
}
