import 'package:html/parser.dart' as parser;
import 'package:requests/requests.dart';
import 'package:html/dom.dart' as dom;

List<List<String>> daySchedule = [];

Future<void> schedule() async {
  var schedule = await Requests.get('http://81.4.170.42/~lyk-latsia-lef/epiloges/mathitisp2.php');
  
  if (schedule.statusCode != 200) {
    return;
  }

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
          if (cell.text != 'x//  () ' && cell.text != '//  () ' && cell.text != '***//  () ') {
            // Append the cell text to the column list
            daySchedule[cells.indexOf(cell) - 1].add(cell.text);
          }
        });
      }
    });
  });

  print('done schedule');
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


