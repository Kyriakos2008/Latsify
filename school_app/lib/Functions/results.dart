import 'package:requests/requests.dart';
import 'package:html/parser.dart' as parser;
import 'package:school_app/replacements.dart';

List<Map<String, String>> scrapedData = [];
bool areResultsLoading = true;

Future<void> fetchresultsMain() async {
  final response = await Requests.get(
      'https://admin.lyk-latsia-lef.schools.ac.cy//epiloges/btetr.php');
  //print(response.body);

  if (response.statusCode == 200) {
    final document = parser.parse(response.body);
    final tables = document.querySelectorAll('.myTable');

    for (var table in tables) {
      final rows = table.querySelectorAll('tr');

      if (rows.length == 2) {
        final secondColumnData = rows[1].querySelectorAll('td')[1].text;
        final fourthColumnData = rows[1].querySelectorAll('td')[3].text;

        scrapedData.add({
          'secondColumnData': secondColumnData,
          'fourthColumnData': fourthColumnData,
        });
      }
    }

    // Update the UI with the scraped data
  } else {
    print(response.statusCode);
    throw Exception('Failed to load data');
  }
}

Future<void> replaceSecondColumnData() async {
  for (int i = 0; i < scrapedData.length; i++) {
    String? currentData = scrapedData[i]['secondColumnData'];
    if (replacements.containsKey(currentData)) {
      scrapedData[i]['secondColumnData'] = replacements[currentData]!;
    }
  }
}

void fetchresults() async {
  // Your existing code...
  await fetchresultsMain(); // Fetch data from the website
  await replaceSecondColumnData(); // Replace second column data with replacements
  areResultsLoading = false;
}
