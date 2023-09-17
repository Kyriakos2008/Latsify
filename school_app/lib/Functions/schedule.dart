import 'package:html/parser.dart' as parser;
import 'package:requests/requests.dart';
import 'package:html/dom.dart' as dom;

List<List<String>> daySchedule = [];

schedule() async {
  var schedule = await Requests.get(
      'http://81.4.170.42/~lyk-latsia-lef/epiloges/mathitisp2.php');
  if (schedule.statusCode == 200) {
    dom.Document document = parser.parse(schedule.body);

    // Find all table elements in the document
    List<dom.Element> tables = document.getElementsByClassName('myTable');

// Loop through each table element
    for (dom.Element table in tables) {
      // Find all row elements in the table
      List<dom.Element> rows = table.getElementsByTagName('tr');

      // Loop through each row element
      // Loop through each row element
      for (dom.Element row in rows) {
        // Find all cell elements in the row
        List<dom.Element> cells = row.getElementsByTagName('td');

        // Check if the row has more than one column
        if (cells.length > 1) {
          // Loop through each cell element, starting from the second column (index 1)
          for (int i = 1; i < cells.length; i++) {
            // Get the cell element
            dom.Element cell = cells[i];

            // If the column list does not exist, create it
            if (daySchedule.length <= i - 1) {
              daySchedule.add([]);
            }

            // Check if the cell text is equal to '// ()'
            if (cell.text != 'x//  () ' && cell.text != '//  () ') {
              // Append the cell text to the column list
              daySchedule[i - 1].add(cell.text);
            }
          }
        }
      }
    }
    print('done schedule');
  }
  return;
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
      return SchoolSubject(parts[0], parts[1], teacherName, classNumber);
    }).toList();
  }).toList();
}