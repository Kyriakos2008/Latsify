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

  void logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('firstLogin', true);
    prefs.setString('username', 'none');
    prefs.setString('password', 'none');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          //automaticallyImplyLeading: false,
          title: Text(
            'Welcome',
            style: TextStyle(fontSize: 25),
          )),
      drawer: Container(
        width: MediaQuery.of(context).size.width * 0.6,
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.15,
                child: DrawerHeader(
                  child: Text('Alfa Version'),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              ListTile(
                title: Text('Log Out'),
                onTap: () {
                  logOut();
                },
              ),
            ],
          ),
        ),
      ),
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
                                  'Room: ${parsedDaySchedule?[index][subjectIndex].roomNumber ?? ''}\nTeacher: ${parsedDaySchedule?[index][subjectIndex].teacherName ?? ''}\nClass Number: ${parsedDaySchedule?[index][subjectIndex].classNumber ?? ''}',
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
