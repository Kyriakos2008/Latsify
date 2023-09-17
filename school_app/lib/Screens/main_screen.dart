import 'package:flutter/material.dart';
import 'package:school_app/Functions/schedule.dart';
import 'package:school_app/Screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    return Scaffold(
      
      body: PageView.builder(
        itemCount: parsedDaySchedule?.length ?? 0,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  ['Δευτέρα', 'Τρίτη', 'Τετάρτη', 'Πέμπτη', 'Παρασκευή'][index],
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).hintColor),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: parsedDaySchedule?[index].length ?? 0,
                  itemBuilder: (context, subjectIndex) {
                    return Card(
                      margin: EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(
                          parsedDaySchedule?[index][subjectIndex].className ??
                              '',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
                                  'Αίθουσα: ${parsedDaySchedule?[index][subjectIndex].roomNumber ?? ''}\nΚαθηγητής: ${parsedDaySchedule?[index][subjectIndex].teacherName ?? ''}\nΤμήμα: ${parsedDaySchedule?[index][subjectIndex].classNumber ?? ''}',
                                ),
                              );
                            },
                          );
                        },
                      ),
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
