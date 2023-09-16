import 'package:flutter/material.dart';
import 'package:school_app/Functions/schedule.dart';

class mainScreen extends StatefulWidget {
  const mainScreen({super.key});

  @override
  State<mainScreen> createState() => _mainScreenState();
}

class _mainScreenState extends State<mainScreen> {
  List<List<SchoolSubject>>? parsedDaySchedule;

  @override
  void initState() {
    super.initState();
    parsedDaySchedule = parseSubjects(daySchedule);
  }

  @override
  Widget build(BuildContext context) {
    print('here');
    return Scaffold(
      appBar: AppBar(
        title: Text('Day Schedule'),
      ),
      body: PageView.builder(
        itemCount: parsedDaySchedule?.length ?? 0,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Text([
                'Monday',
                'Tuesday',
                'Wednesday',
                'Thursday',
                'Friday'
              ][index]),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: parsedDaySchedule?[index].length ?? 0,
                  itemBuilder: (context, subjectIndex) {
                    return ListTile(
                      title: Text(
                          parsedDaySchedule?[index][subjectIndex].className ??
                              ''),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(parsedDaySchedule?[index]
                                          [subjectIndex]
                                      .className ??
                                  ''),
                              content: Text(
                                  'Room: ${parsedDaySchedule?[index][subjectIndex].roomNumber ?? ''}\nTeacher: ${parsedDaySchedule?[index][subjectIndex].teacherName ?? ''}\nClass Number: ${parsedDaySchedule?[index][subjectIndex].classNumber ?? ''}'),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
