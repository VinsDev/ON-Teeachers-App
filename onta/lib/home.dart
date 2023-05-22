import 'package:flutter/material.dart';
import 'package:onta/as_terms.dart';
import 'package:onta/at_terms.dart';
import 'package:onta/colors/colors.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

import 'services/http_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String>? classes;
  String message = "";

  var isLoaded = false;
  var unsuccessfulLoad = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    var collector = await RemoteService("/Jobs international schools/getClassList").getData();
    if (collector.runtimeType != int) {
      classes = collector;
      if (classes != null) {
        setState(() {
          isLoaded = true;
        });
      }
    } else {
      switch (collector) {
        case 0:
          message = "Please ensure that you have internet connection";
          break;
        case 1:
          message = "No classes found on the database";
          break;
        case 2:
          message = "Bad request";
          break;
      }
      setState(() {
        unsuccessfulLoad = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0.5,
            backgroundColor: appColor,
            title: const Text('Government Secondary School Lafia',
                style: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4)),
            actions: [
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.more_vert_rounded))
            ],
            bottom: TabBar(
              padding: const EdgeInsets.only(bottom: 12),
              indicatorColor: Colors.white,
              isScrollable: true,
              indicatorSize: TabBarIndicatorSize.label,
              tabs: const [
                Text(
                  'Attendance',
                  style: TextStyle(fontSize: 18),
                ),
                Text('Assessments', style: TextStyle(fontSize: 18)),
              ],
              indicator: DotIndicator(
                color: Colors.white,
                distanceFromCenter: 16,
                radius: 3,
                paintingStyle: PaintingStyle.fill,
              ),
            ),
          ),
          body: TabBarView(children: [
            attendanceClassList(classes),
            const Center(
              child: Text('Term assessments'),
            ),
          ]),
        ));
  }

  attendanceClassList(List<String>? items) {
    return Visibility(
      visible: isLoaded,
      replacement: shimmer(),
      child: ListView.builder(
          padding: const EdgeInsets.only(top: 1),
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              enableFeedback: true,
              onTap: (() {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AttendanceSessions(selectedClass: items[index])));
              }),
              title: Container(
                alignment: Alignment.centerLeft,
                height: 50,
                padding: const EdgeInsets.only(left: 10),
                child: Text(items![index],
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(255, 75, 74, 74),
                        letterSpacing: 0.2)),
              ),
            );
          },
          itemCount: items?.length),
    );
  }

  shimmer() {
    return Visibility(
      visible: unsuccessfulLoad,
      replacement: Shimmer.fromColors(
        baseColor: Color.fromARGB(255, 192, 192, 192),
        highlightColor: Color.fromARGB(255, 224, 224, 224),
        child: ListView.builder(
          itemBuilder: (_, __) => Padding(
              padding: const EdgeInsets.only(
                  top: 8.0, bottom: 8, left: 35, right: 35),
              child: SizedBox(
                  height: 50,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 25,
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5)),
                      )
                    ],
                  ))),
          itemCount: 6,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message),
          SizedBox(
            height: 12,
          ),
          InkWell(
            onTap: () {
              setState(() {
                unsuccessfulLoad = false;
                getData();
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Color.fromARGB(255, 26, 30, 255)),
              child: Text(
                "Retry",
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }

  assesmentsClassList(List<String> items) {
    return ListView.builder(
        padding: const EdgeInsets.only(top: 1),
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            enableFeedback: true,
            onTap: (() {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          AssessmentSessions(selectedClass: items[index])));
            }),
            title: Container(
              alignment: Alignment.centerLeft,
              height: 50,
              padding: const EdgeInsets.only(left: 10),
              child: Text(items[index],
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 75, 74, 74),
                      letterSpacing: 0.2)),
            ),
          );
        },
        itemCount: items.length);
  }
}
