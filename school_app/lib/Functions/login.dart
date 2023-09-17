import 'package:html/parser.dart' as parser;
import 'package:requests/requests.dart';
// ignore: unused_import
import 'package:school_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool passwordCorrect = true;

//var url = 'http://81.4.170.42/~lyk-latsia-lef/epiloges/dilosichklogin.php';
login(username, password) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String? nowUsername;
  String? nowPassword;

  if (prefs.getString('username') != null) {
    nowUsername = prefs.getString('username');
    nowPassword = prefs.getString('password');
  } else {
    nowUsername = username;
    nowPassword = password;
  }
  print('user:' + '$nowUsername');
  print('pass:' + '$nowPassword');
  var form = <String?, String?>{
    'username': nowUsername,
    'password': nowPassword,
  };

  // await storage.write(key: 'username', value: username);
  // await storage.write(key: 'password', value: password);

  var res = await Requests.post(
    'http://81.4.170.42/~lyk-latsia-lef/epiloges/dilosichklogin.php',
    body: form,
  );

  print(res.statusCode);
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
    print('Found ${elements.length} elements with the text "$text"');
    if (elements.length > 0) {
      print('password incorrect');
      passwordCorrect = false;
    } else {
      print('password correct');
      passwordCorrect = true;
    }
    print(passwordCorrect);
    return passwordCorrect;
  } else {
    // Handle the error
    print('Failed to load the website');
  }
}
