import 'package:html/parser.dart' as parser;
import 'package:requests/requests.dart';
import 'package:html/dom.dart' as dom;
import 'package:school_app/replacements.dart';

List<List<String>> tests = [];
bool areTestsLoading = true;

Future<List<MyTableData>> getTests() async {
  List<MyTableData> tableData = [];
  var schedule = await Requests.get(
      'https://admin.lyk-latsia-lef.schools.ac.cy//epiloges/dispdiagonismata.php');

  if (schedule.statusCode == 200) {
    dom.Document document = parser.parse(schedule.body);

    // Find all table elements with class 'myTable'
    List<dom.Element> tables = document.querySelectorAll('.myTable');

    tables.forEach((table) {
      // Find all row elements in the table, excluding the first row
      List<dom.Element> rows = table.querySelectorAll('tr').skip(1).toList();

      rows.forEach((row) {
        // Find all cell elements in the row
        List<dom.Element> cells = row.querySelectorAll('td');

        // Check if the row has more than two columns
        if (cells.length > 2) {
          // Extract text from the first and second columns
          String column1 = cells[0].text.trim();
          String column2 = cells[1].text.trim();

          // Replace the text in the second column using the replacements map
          if (replacements.containsKey(column2)) {
            column2 = replacements[column2]!;
          }

          // Create a MyTableData object and add it to the list
          tableData.add(MyTableData(column1: column1, column2: column2));
        }
      });
    });

    areTestsLoading = false;
    
    return tableData;
  } else {
    return []; // Return an empty list in case of an error
  }
}

bool isDateInFuture(String date) {
  try {
    // Parse the date string into a DateTime object
    List<String> dateParts = date.split('-');
    if (dateParts.length == 3) {
      int year = int.parse(dateParts[2]);
      int month = int.parse(dateParts[1]);
      int day = int.parse(dateParts[0]);

      DateTime parsedDate = DateTime(year, month, day);

      // Compare the parsed date with the current date or if it's today
      return parsedDate.isAfter(DateTime.now().subtract(const Duration(days: 1)));
    }
    return false;
  } catch (e) {
    // Handle parsing errors
    return false;
  }
}

class MyTableData {
  String column1;
  String column2;

  MyTableData({required this.column1, required this.column2});
}
