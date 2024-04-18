import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

import 'package:school_app/Functions/results.dart';
import 'package:school_app/Functions/tests.dart';
import '../Functions/schedule.dart';
import '../Screens/login_screen.dart';

class settingsPage extends StatefulWidget {
  const settingsPage({super.key});
  @override
  State<settingsPage> createState() => _settingsPageState();
}

class _settingsPageState extends State<settingsPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void getColor() async {
    final prefs = await SharedPreferences.getInstance();
    selectedColorInt = await prefs.getInt('mainColor');
    if (selectedColorInt == null) {
      selectedColor = Colors.blue;
    } else {
      selectedColor = Color(selectedColorInt!);
    }
    setState(() {});
  }

  void changeColor(Color color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('mainColor', color.value);
    selectedColor = color;
    setState(() {});
  }

  void _showRestart() async {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: ((context) {
          return AlertDialog(
            title: const Center(
              child: Icon(Icons.info_outline_rounded),
            ),
            content: const SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                      'Επανεκκινήστε την εφαρμογή για να τεθούν σε ισχύ οι αλλαγές')
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Οκ'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }));
  }

  void logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    daySchedule.clear();
    tests.clear();
    scrapedData.clear();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Ρυθμίσεις"),
        ),
        body: SettingsList(
          sections: [
            SettingsSection(
              title: const Text('Πρωτεύον χρώμα'),
              tiles: [
                SettingsTile(
                    title: MaterialColorPicker(
                        allowShades: false,
                        onMainColorChange: (color) {
                          changeColor(color!);
                          _showRestart();
                        },
                        selectedColor: selectedColor)),
              ],
            ),
            SettingsSection(
              title: const Text('Λογαριασμός'),
              tiles: [
                SettingsTile(
                  title: TextButton(
                    onPressed: () {
                      logOut();
                    },
                    child: Row(
                      children: [
                        Text('Αποσύνδεση'),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                          child: Icon(Icons.logout),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )
          ],
        ));
  }
}
