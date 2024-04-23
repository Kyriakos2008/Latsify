import 'package:requests/requests.dart';
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart';

class Announcement {
  final String title;
  final String link;

  Announcement({required this.title, required this.link});
}

Future<List<Announcement>> fetchAnnouncements() async {
  final response = await Requests.get(
      "http://81.4.170.42/~lyk-latsia-lef/epiloges/indexstudent.php");

  if (response.statusCode == 200) {
    final document = parser.parse(response.body);
    List<Announcement> announcements = [];

    // Extracting announcements from tables with "Αρ." in the first cell
    List<Element> tables = document.querySelectorAll('table.myTable');
    for (var table in tables) {
      var firstCell = table.querySelector('tr th');
      if (firstCell != null && firstCell.text.trim() == "Αρ.") {
        List<Element> rows = table.querySelectorAll('tr');
        for (var row in rows) {
          var cells = row.querySelectorAll('td');
          if (cells.length >= 2) {
            var title = cells[1].text.trim();
            var link = cells[2].querySelector('a')?.attributes['href'] ?? '';
            // Check if the link is relative, if so, prepend the base URL
            if (!link.startsWith("http")) {
              link = "http://81.4.170.42/~lyk-latsia-lef/epiloges/$link";
            }
            announcements.add(Announcement(title: title, link: link));
          }
        }
      }
    }
    return announcements;
  } else {
    throw Exception('Failed to load announcements');
  }
}

