import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:school_app/Functions/login.dart';
import 'package:school_app/Screens/main_screen.dart';
import 'package:school_app/Screens/settings_screen.dart';
import 'Screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Functions/schedule.dart';
import 'Screens/working_screen.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'Screens/mainTest_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_analytics/firebase_analytics.dart';


FirebaseAnalytics analytics = FirebaseAnalytics.instance;

String currentVersion = "1.0.1+1";
Color? selectedColor;
int? selectedColorInt;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SharedPreferences prefs = await SharedPreferences.getInstance();

  selectedColorInt = await prefs.getInt('mainColor');
  if (selectedColorInt == null) {
    selectedColor = Colors.blue;
  } else {
    selectedColor = Color(selectedColorInt!);
  }

  if (prefs.getBool('firstLogin') == false) {
    detailsGet();
    runApp(const MyApp2());
  } else {
    runApp(const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Σύνδεση',
      theme: ThemeData(
        useMaterial3: true,
        // Define the default brightness and colors.
        colorScheme: ColorScheme.fromSeed(
          seedColor: selectedColor!,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        // Define the default brightness and colors.
        colorScheme: ColorScheme.fromSeed(
          seedColor: selectedColor!,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.system,
      home: const LoginPage(),
    );
  }
}

class MyApp2 extends StatelessWidget {
  const MyApp2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Σύνδεση',
      theme: ThemeData(
        useMaterial3: true,
        // Define the default brightness and colors.
        colorScheme: ColorScheme.fromSeed(
          seedColor: selectedColor!,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        // Define the default brightness and colors.
        colorScheme: ColorScheme.fromSeed(
          seedColor: selectedColor!,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.system,
      home: NavBar(),
    );
  }
}

class NavBar extends StatefulWidget {
  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;
  late PageController _pageController;

  static List<Widget> _widgetOptions = <Widget>[
    mainScreen(),
    mainTests(),
    workingOnIt()
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(index,
          duration: Duration(milliseconds: 250), curve: Curves.easeOut);
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          'Γειά σου, $nameOnly',
          style: TextStyle(fontSize: 25),
        ),
      ),
      drawer: Container(
        width: MediaQuery.of(context).size.width * 0.6,
        child: _buildDrawer(),
      ),
      body: Stack(children: [
        SizedBox.expand(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _selectedIndex = index);
            },
            children: _widgetOptions,
          ),
        ),
      ]),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Πρόγραμμα',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Αξιολογήσεις',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.announcement),
            label: 'Ανακοινώσεις',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: selectedColor!,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.15,
            child: _buildDrawerHeader(),
          ),
          ListTile(
            title: Text('Τμήμα: $cell2'),
          ),
          ListTile(
            title: Text('Βοηθός διευθυντή: $cell3'),
          ),
          ListTile(
            title: Text('Υπεύθηνος καθηγητής: $cell4'),
          ),
          
          ListTile(
            title: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const settingsPage()),
                );
              },
              child: Row(
                children: [
                  Text('Ρυθμίσεις'),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(9, 0, 0, 0),
                    child: Icon(Icons.settings),
                  )
                ],
              ),
            ),
          ),
          ListTile(
            title: Text(currentVersion),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return DrawerHeader(
      child: AutoSizeText(
        '$cell1',
        style: TextStyle(fontSize: 20),
        maxLines: 2,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
