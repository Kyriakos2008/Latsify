import 'package:flutter/material.dart';
import 'package:school_app/Screens/test_screen.dart';
import 'package:school_app/Screens/results_screen.dart';

class mainTests extends StatelessWidget {
  const mainTests({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const TabBar(
            tabs: [
              Tab(text: 'Διαγωνίσματα'),
              Tab(text: ' Βαθμολογίες'),
            ],
          ),
        ),
        body: TabBarView(
          children: _tabs,
        ),
      ),
    );
  }
}

final List<Widget> _tabs = [
  const TestScreen(),
  resultsScreen()
];
