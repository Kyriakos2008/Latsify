import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;
import 'package:requests/requests.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool passwordCorrect = true;
String? cell1;
String? cell2;
String? cell3;
String? cell4;
String? nameOnly;
String? nowUsername;
String? nowPassword;

login(username, password) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  nowUsername = null;
  nowPassword = null;

  if (prefs.getString('username') != null) {
    nowUsername = prefs.getString('username');
    nowPassword = prefs.getString('password');
  } else {
    nowUsername = username;
    nowPassword = password;
  }
  var form = <String?, String?>{
    'username': nowUsername,
    'password': nowPassword,
  };

  var res = await Requests.post(
    'http://81.4.170.42/~lyk-latsia-lef/epiloges/dilosichklogin.php',
    body: form,
  );
  //print(res.body);

  String text = 'ΛΑΘΟΣ ΚΩΔΙΚΟΣ - ΔΟΚΙΜΑΣΤΕ ΞΑΝΑ';

  if (res.statusCode == 200) {
    // Parse the response body as HTML document
    var document = parser.parse(res.body);

    // Find all the elements that contain the text
    var elements = document
        .querySelectorAll('*')
        .where((element) => element.text.contains(text))
        .toList();

    // Print the number of elements found
    if (elements.isNotEmpty) {
      passwordCorrect = false;
      print('you are NOT signed in');
    } else {
      passwordCorrect = true;
      print('you are signed in');
      dom.Document document2 = parser.parse(res.content());

      dom.Element? tableElement = document2.querySelector('.myTable');

      if (tableElement != null) {
        // Get the second row of the table
        List<dom.Element> rows = tableElement.querySelectorAll('tr');
        if (rows.length > 1) {
          dom.Element row = rows[1];

          // Get the first four cells of the row
          List<dom.Element> cells = row.querySelectorAll('td');
          if (cells.length >= 4) {
            // Assign the cell values to variables
            cell1 = cells[0].text;
            cell2 = cells[1].text;
            cell3 = cells[2].text;
            cell4 = cells[3].text;

            prefs.setString('cell1', cell1!);
            prefs.setString('cell2', cell2!);
            prefs.setString('cell3', cell3!);
            prefs.setString('cell4', cell4!);

            List<String>? words = cell1?.split(" ");
            nameOnly = words?[1];
            prefs.setString('nameOnly', nameOnly!);
            // Use the cell values...
          }
        }
      }
    }
    return passwordCorrect;
  } else {
    // Handle the error
  }
}
