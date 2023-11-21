import 'package:requests/requests.dart';
import 'package:html/parser.dart' as parser;

List<Map<String, String>> scrapedData = [];
bool areResultsLoading = true;

Future<void> fetchresultsMain() async {
  final response = await Requests.get(
      'http://81.4.170.42/~lyk-latsia-lef/epiloges/btetr.php');

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
