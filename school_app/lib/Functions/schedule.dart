import 'package:html/parser.dart' as parser;
import 'package:requests/requests.dart';
import 'package:html/dom.dart' as dom;

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
      for (dom.Element row in rows) {
        // Find all cell elements in the row
        List<dom.Element> cells = row.getElementsByTagName('td');

        // Loop through each cell element
        for (dom.Element cell in cells) {
          // Print the text content of the cell
          print(cell.text);
        }
      }
    }
  }
}
