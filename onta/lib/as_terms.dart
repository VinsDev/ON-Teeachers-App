import 'package:flutter/material.dart';
import 'package:onta/colors/colors.dart';

class AssessmentSessions extends StatelessWidget {
  final String selectedClass;
  const AssessmentSessions({super.key, required this.selectedClass});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: appColor,
            title: Text('$selectedClass Assessment',
                style: const TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4))));
  }
}
