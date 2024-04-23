import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../Functions/announcements.dart';

class AnnouncementsScreen extends StatefulWidget {
  @override
  _AnnouncementsScreenState createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  late Future<List<Announcement>> _announcementsFuture;

  @override
  void initState() {
    super.initState();
    _announcementsFuture = fetchAnnouncements();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  
  body: FutureBuilder<List<Announcement>>(
    future: _announcementsFuture,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else if (snapshot.hasError) {
        return Center(
          child: Text('Error: ${snapshot.error}'),
        );
      } else if (snapshot.hasData) {
        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            Announcement announcement = snapshot.data![index];
            return Card(
              margin: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(
                  announcement.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                onTap: () => _launchURL(announcement.link),
              ),
            );
          },
        );
      } else {
        return Center(
          child: Text('No announcements available'),
        );
      }
    },
  ),
);

  }

  void _launchURL(String url) async {
    print(url);
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
