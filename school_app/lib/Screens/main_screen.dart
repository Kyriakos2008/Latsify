import 'dart:convert';
import 'package:school_app/main.dart';
import 'package:flutter/material.dart';
import 'package:school_app/Functions/schedule.dart';
import 'package:school_app/Screens/login_screen.dart';
import 'package:school_app/Functions/tests.dart';
import 'package:school_app/Functions/results.dart';
import 'package:http/http.dart' as http;

class mainScreen extends StatefulWidget {
  const mainScreen({super.key});

  @override
  State<mainScreen> createState() => _mainScreenState();
}

int today = 1;
List<List<SchoolSubject>>? parsedDaySchedule;
bool isScheduleLoading = true;
List<MyTableData> tableData = [];

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
    _userchecker();
    updateChecker();
  }

  void _getFirstData() async {
    List<MyTableData> data = await getTests();
    tableData = data;
    fetchresults();
  }

  _scheduleVerify() async {
    await scheduleVerify();
    isScheduleLoading = false;
    setState(() {});
    _getFirstData();
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
            title: const Icon(Icons.warning),
            content: const Text(
                'Δεν πληροίτε τις προϋποθέσεις για χρήση αυτής της εφαρμογής.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      exists = null;
    } else {
      _scheduleVerify();
    }
  }

  updateChecker() async {
    
    var latestVersionRaw = await http.get(Uri.parse(
        'https://raw.githubusercontent.com/Kyriakos2008/Latsify-Public/main/latestVersion.json'));
    var latestVersionVar = latestVersionRaw.body;

    var latestVersion = jsonDecode(latestVersionVar) as String;


    if (currentVersion != latestVersion) {
      showDialog(
      context: context,
      builder: (BuildContext Versioncontext) {
        return AlertDialog(
          title: const Icon(Icons.info),
          content: const Text('Μια νέα έκδοση είναι διαθέσιμη. Συνιστούμε την ενημέρωση της εφαρμογής για την καλύτερη εμπειρία.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(Versioncontext).pop(); // This will close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
    } else {
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Stack(children: [
        PageView.builder(
          controller: PageController(initialPage: today),
          itemCount: parsedDaySchedule?.length ?? 0,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    [
                      'Δευτέρα',
                      'Τρίτη',
                      'Τετάρτη',
                      'Πέμπτη',
                      'Παρασκευή'
                    ][index],
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).hintColor),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: parsedDaySchedule?[index].length ?? 0,
                    itemBuilder: (context, subjectIndex) {
                      return Card(
                        margin: const EdgeInsets.all(8.0),
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
        if (isScheduleLoading)
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: LinearProgressIndicator(),
          ),
      ]),
    );
  }
}
