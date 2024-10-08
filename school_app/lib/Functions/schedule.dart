import 'package:html/parser.dart' as parser;
import 'package:requests/requests.dart';
import 'package:html/dom.dart' as dom;
import 'package:school_app/Functions/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:school_app/Screens/main_screen.dart';
import 'package:school_app/replacements.dart';

List<List<String>> daySchedule = [];
bool? isUserOk;
bool? exists;

logingOut() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.clear();
  daySchedule.clear();
  return;
}

Future<void> schedule() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  daySchedule = [];
  var schedule = await Requests.get(
      'https://admin.lyk-latsia-lef.schools.ac.cy//epiloges/mathitisp2.php');

  if (schedule.statusCode == 200) {
    dom.Document document = parser.parse(schedule.body);

    // Find all table elements with class 'myTable'
    List<dom.Element> tables = document.querySelectorAll('.myTable');

    tables.forEach((table) {
      // Find all row elements in the table
      List<dom.Element> rows = table.querySelectorAll('tr');

      rows.forEach((row) {
        // Find all cell elements in the row
        List<dom.Element> cells = row.querySelectorAll('td');

        // Check if the row has more than one column
        if (cells.length > 1) {
          // Loop through each cell element, starting from the second column (index 1)
          cells.skip(1).forEach((cell) {
            // If the column list does not exist, create it
            if (daySchedule.length <= cells.indexOf(cell) - 1) {
              daySchedule.add([]);
            }

            // Check if the cell text is equal to '// ()'
            if (cell.text != 'x//  () ' && cell.text != '***//  () ') {
              //&& cell.text != '//  () '
              // Append the cell text to the column list
              daySchedule[cells.indexOf(cell) - 1].add(cell.text);
            }
          });
        }
      });
    });
    String dayScheduleJson = jsonEncode(daySchedule);
    prefs.setString("dayScheduleKey", dayScheduleJson);

    return;
  } else {}
}

scheduleget() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // Retrieve your JSON string using the getString method with the same key
  String? dayScheduleJson = prefs.getString("dayScheduleKey");

  // Decode your JSON string back into a Dart object
  List<List<String>> daySchedule = (jsonDecode(dayScheduleJson!) as List)
      .map((element) => List<String>.from(element))
      .toList();

  //scheduleVerify();
  return daySchedule;
}

detailsGet() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  cell1 = prefs.getString('cell1');
  cell2 = prefs.getString('cell2');
  cell3 = prefs.getString('cell3');
  cell4 = prefs.getString('cell4');
  nameOnly = prefs.getString('nameOnly');
  return;
}

Future<void> scheduleVerify() async {
  if (await login(null, null)) {
    await schedule();
    parsedDaySchedule = parseSubjects(daySchedule);
  }
}

class SchoolSubject {
  final String roomNumber;
  final String className;
  final String teacherName;
  final String classNumber;

  SchoolSubject(
      this.roomNumber, this.className, this.teacherName, this.classNumber);
}



List<List<SchoolSubject>> parseSubjects(List<List<String>> daySchedule) {
  return daySchedule.map((daySubjects) {
    return daySubjects.map((subject) {
      var parts = subject.split('/');
      var nameAndNumber = parts[2].split('(');
      var teacherName = nameAndNumber[0].trim();
      var classNumber = nameAndNumber[1].substring(
          0, nameAndNumber[1].length - 2); // remove last two characters
      var className = parts[1];

      // Check if the className is in the replacements map
      if (replacements.containsKey(className)) {
        // If it is, replace it with the corresponding value
        className = replacements[className]!;
      }

      return SchoolSubject(parts[0], className, teacherName, classNumber);
    }).toList();
  }).toList();
}

