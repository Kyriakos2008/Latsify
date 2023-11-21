import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:requests/requests.dart';
import 'package:html/dom.dart' as dom;
import 'package:school_app/Functions/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:school_app/Screens/main_screen.dart';

List<List<String>> daySchedule = [];
bool? isUserOk = null;
bool? exists;

userChecker() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var userCheck = await http.get(
      Uri.parse('https://kyriakos2008.github.io/School-App-Public/Users.json'));
  var jsonUsers = userCheck.body;

  var list =
      jsonDecode(jsonUsers) as List; // Parse the json file into a Dart list
  print(list);
  String? checkerUsername = prefs.getString('username');
  print(checkerUsername);
  exists = list.contains(
      checkerUsername); // Use the 'contains' method to check if nowUsername is in the list
  if (exists!) {
    // Do something if the username  exists in the list
    return exists;
  } else {
    // Do something else if the username does not exist in the list
    await logingOut();
    return exists;
  }
}

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
      'http://81.4.170.42/~lyk-latsia-lef/epiloges/mathitisp2.php');

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
    print('done schedule');
    return;
  } else {
    print('schedule failed');
  }
  
}

scheduleget() async {
  print('xekina to prama');
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

Map<String, String> replacements = {
  'Αγγ (Α)': 'Αγγλικά',
  'Τεχνλ (Α)': 'Τεχνολογία',
  'Γυμν-Α (Α)': 'Γυμναστική',
  'ΦΥΣ_προσ': 'Φυσική',
  'Φυσ (Α)': 'Φυσική',
  'ΜΑΘ_προσ': 'Μαθηματικά',
  'Αρχ (Α)': 'Αρχαία',
  'Νέα (Α)': 'Νέα Ελληνικά',
  'Οικον (Α)': 'Οικονομικά',
  'ΟΙΚ_προσ': 'Οικονομικά',
  'Θρη (α)': 'Θρησκευτικά',
  'Γαλλ (Α)': 'Γαλλικά',
  'Μουσ (Α)': 'Μουσική',
  'Χημ (Α)': 'Χημία',
  'Ιστ (Α)': 'Ιστορία',
  'Πληρ (Α)': 'Πληροφορική',
  'Τέχνη (Α)': 'Τέχνη',
  'Βιολ (Α)': 'Βιολογία',
  'Μαθ (Α)': 'Μαθηματικά',
  'ΙΣΤ_προσ': 'Ιστορία',
  'ΑΡΧ_προσ': 'Αρχαία',
  'ΓΥΜ-Κ': 'Γυμναστική',
  'ΑΓΓ_προσ': 'Αγγλικά',
  // '': '',
  // '': '',
  // '': '',
  // '': '',
  // '': '',
  // Add more replacements as needed
};

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
