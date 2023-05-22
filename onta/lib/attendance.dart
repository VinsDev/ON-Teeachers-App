import 'package:flutter/material.dart';
import 'package:onta/models/one_class.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'colors/colors.dart';
import 'services/http_helper.dart';

class Attendance extends StatefulWidget {
  final String selectedClass;
  final String term;
  const Attendance(
      {super.key, required this.selectedClass, required this.term});

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  ItemScrollController itemScrollController1 = ItemScrollController();
  ItemScrollController itemScrollController2 = ItemScrollController();
  ClassData cls = ClassData(attendanceDates: [
    AttendanceDates(date: '2023-01-10-5', active: false)
  ], students: [
    Students(
        name: 'John', gender: 'male', afternoon: ['Mark'], morning: ['Mark'])
  ], todayIndex: 0);
  var arr = [];

  var isLoaded = false;
  var unsuccessfulLoad = false;
  String message = "";

  String session = '2023/2024';

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    var collector = await RemoteService(
            "/Jobs international schools/getAttendanceForClass/${widget.selectedClass}")
        .getData();
    if (collector.runtimeType != int) {
      cls = collector;
      if (cls != null) {
        setState(() {
          _getThingsOnStartup().then((value) => {
                itemScrollController1.scrollTo(
                    index: cls.todayIndex,
                    duration: const Duration(seconds: 1),
                    curve: Curves.easeInOutCubic)
              });
          isLoaded = true;
        });
      }
    } else {
      cls = ClassData(attendanceDates: [
        AttendanceDates(date: '2023-01-10-5', active: false)
      ], students: [
        Students(
            name: 'John',
            gender: 'male',
            afternoon: ['Mark'],
            morning: ['Mark'])
      ], todayIndex: 0);
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
            elevation: 0,
            backgroundColor: appColor,
            title: Text('${widget.selectedClass} Attendance',
                style: const TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4)),
            actions: [
              TextButton(
                  onPressed: () {},
                  child: const Text(
                    'SAVE',
                    style: TextStyle(color: Colors.white),
                  ))
            ],
            bottom: TabBar(
              padding: const EdgeInsets.only(bottom: 12),
              indicatorColor: Colors.white,
              isScrollable: true,
              indicatorSize: TabBarIndicatorSize.label,
              tabs: const [
                Text(
                  'Morning',
                  style: TextStyle(fontSize: 18),
                ),
                Text('Afternoon', style: TextStyle(fontSize: 18)),
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
            Visibility(
                visible: isLoaded, replacement: shimmer(), child: morning()),
            Visibility(
                visible: isLoaded, replacement: shimmer(), child: afternoon())
          ])),
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

  morning() {
    return Column(
      children: [
        Container(
          height: 16,
          width: double.maxFinite,
          color: Colors.yellow,
          child: Center(
            child: Text(
              session,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.6),
            ),
          ),
        ),
        Container(
            height: 60,
            width: double.maxFinite,
            color: Colors.yellow,
            child: ScrollablePositionedList.builder(
              itemBuilder: ((context, index) {
                arr = cls.attendanceDates[index].date.split('-');
                if (index == cls.todayIndex) {
                  return day(weekDay(int.parse(arr[3])), arr[2],
                      month(int.parse(arr[1])), true, index);
                }
                return day(weekDay(int.parse(arr[3])), arr[2],
                    month(int.parse(arr[1])), false, index);
              }),
              itemCount: cls.attendanceDates.length,
              scrollDirection: Axis.horizontal,
              itemScrollController: itemScrollController1,
            )),
        Expanded(child: studentsList(cls.students, true))
      ],
    );
  }

  afternoon() {
    return Column(
      children: [
        Container(
          height: 16,
          width: double.maxFinite,
          color: Colors.yellow,
          child: Center(
            child: Text(
              session,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.6),
            ),
          ),
        ),
        Container(
            height: 60,
            width: double.maxFinite,
            color: Colors.yellow,
            child: ScrollablePositionedList.builder(
              itemBuilder: ((context, index) {
                arr = cls.attendanceDates[index].date.split('-');
                if (index == cls.todayIndex) {
                  return day(weekDay(int.parse(arr[3])), arr[2],
                      month(int.parse(arr[1])), true, index);
                }
                return day(weekDay(int.parse(arr[3])), arr[2],
                    month(int.parse(arr[1])), false, index);
              }),
              itemCount: cls.attendanceDates.length,
              scrollDirection: Axis.horizontal,
              itemScrollController: itemScrollController2,
            )),
        Expanded(child: studentsList(cls.students, false))
      ],
    );
  }

  day(String day, String date, String month, bool active, int index) {
    return InkWell(
      onTap: () {
        setState(() {
          cls.todayIndex = index;
        });
      },
      child: Container(
        width: 50,
        margin: const EdgeInsets.only(top: 5, bottom: 5, left: 6, right: 3),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 0.5),
            borderRadius: BorderRadius.circular(10),
            color: active ? const Color.fromARGB(255, 16, 7, 97) : appColor),
        child: Column(
          children: [
            Text(
              day,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w400),
            ),
            Text(
              date,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
            ),
            Text(
              month,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }

  weekDay(int index) {
    switch (index) {
      case 0:
        return 'SUN';
      case 1:
        return 'MON';
      case 2:
        return 'TUE';
      case 3:
        return 'WED';
      case 4:
        return 'THU';
      case 5:
        return 'FRI';
      case 6:
        return 'SAT';

      default:
        return;
    }
  }

  month(int number) {
    switch (number) {
      case 1:
        return 'JAN';
      case 2:
        return 'FEB';
      case 3:
        return 'MAR';
      case 4:
        return 'APR';
      case 5:
        return 'MAY';
      case 6:
        return 'JUN';
      case 7:
        return 'JUL';
      case 8:
        return 'AUG';
      case 9:
        return 'SEP';
      case 10:
        return 'OCT';
      case 11:
        return 'NOV';
      case 12:
        return 'DEC';
      default:
        return;
    }
  }

  studentsList(List<Students> items, bool morning) {
    List<String> status = ['Mark', 'Present', 'Absent', 'Sick'];
    return ListView.separated(
      padding: const EdgeInsets.only(top: 1),
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          enableFeedback: true,
          onTap: (() {}),
          title: Container(
            alignment: Alignment.centerLeft,
            height: 50,
            padding: const EdgeInsets.only(left: 10),
            child: Text(items[index].name,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 75, 74, 74),
                    letterSpacing: 0.2)),
          ),
          subtitle: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 10),
            child: Text(capitalize(items[index].gender),
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 75, 74, 74),
                    letterSpacing: 0.3)),
          ),
          trailing: DropdownButton(
              underline: Container(),
              value: morning
                  ? cls.students[index].morning[cls.todayIndex]
                  : cls.students[index].afternoon[cls.todayIndex],
              icon: const Icon(Icons.arrow_drop_down_sharp),
              items: status.map((String state) {
                if (state == 'Mark') {
                  return DropdownMenuItem(
                    enabled: false,
                    value: state,
                    child: Text(
                      state,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 121, 119, 119),
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  );
                }
                if (state == 'Present') {
                  return DropdownMenuItem(
                    value: state,
                    child: Text(
                      state,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 16, 180, 21),
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  );
                }
                if (state == 'Absent') {
                  return DropdownMenuItem(
                    value: state,
                    child: Text(
                      state,
                      style: const TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  );
                }
                if (state == 'Sick') {
                  return DropdownMenuItem(
                    value: state,
                    child: Text(
                      state,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 255, 0, 234),
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  );
                }
                return DropdownMenuItem(
                  value: state,
                  child: Text(
                    state,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  if (morning) {
                    cls.students[index].morning[cls.todayIndex] = newValue!;
                  } else {
                    cls.students[index].afternoon[cls.todayIndex] = newValue!;
                  }
                });
              }),
        );
      },
      itemCount: items.length,
      separatorBuilder: (BuildContext context, int index) {
        return Container(
          height: 0.8,
          color: const Color.fromARGB(255, 201, 199, 199),
          width: double.maxFinite,
        );
      },
    );
  }
}

Future _getThingsOnStartup() async {
  await Future.delayed(const Duration(milliseconds: 1000));
}

String capitalize(String text) {
  return text[0].toUpperCase() + text.substring(1).toLowerCase();
}
