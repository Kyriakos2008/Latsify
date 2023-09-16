import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:requests/requests.dart';

bool passwordCorrect = true;


//var url = 'http://81.4.170.42/~lyk-latsia-lef/epiloges/dilosichklogin.php';
login(username, password) async {
  var form = <String, String>{
    'username': username,
    'password': password,
  };

  var res = await Requests.post('http://81.4.170.42/~lyk-latsia-lef/epiloges/dilosichklogin.php', body: form,);

  print(res.statusCode);
  print(res.body);

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
      passwordCorrect = false;
    } else {
      passwordCorrect = true;
    }
    print(passwordCorrect);
    return passwordCorrect;
  } else {
    // Handle the error
    print('Failed to load the website');
  }
}
