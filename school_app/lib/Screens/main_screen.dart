import 'package:flutter/material.dart';
import 'package:school_app/Functions/schedule.dart';
import 'package:school_app/Screens/login_screen.dart';
import 'package:school_app/main.dart';

class mainScreen extends StatefulWidget {
  const mainScreen({super.key});

  @override
  State<mainScreen> createState() => _mainScreenState();
}

int today = 1;
List<List<SchoolSubject>>? parsedDaySchedule;

class _mainScreenState extends State<mainScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  void initState() {
    super.initState();
    scheduleget().then((value) {
      setState(() {
        daySchedule = value;
        parsedDaySchedule = parseSubjects(daySchedule);
      });
    });
    today = DateTime.now().weekday;
    if (today > 5) {
      // If it's Saturday or Sunday
      today = 0; // Set to Monday
    } else {
      today -= 1; // Subtract 1 because PageView index starts from 0
    }
    print('loaded');
    _userchecker();
  }

  _userchecker() async {
    if (await userChecker() == false) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Popup Title'),
              content: Text('This is the popup message.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
    }

  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: PageView.builder(
        controller: PageController(initialPage: today),
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
                              color: Theme.of(context).hintColor),
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
                                    style: TextStyle(
                                        color: Theme.of(context).hintColor)),
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
