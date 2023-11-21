import 'package:flutter/material.dart';
import 'package:school_app/Functions/results.dart';
import 'dart:async';



class resultsScreen extends StatefulWidget {
  @override
  _resultsScreen createState() => _resultsScreen();
}

class _resultsScreen extends State<resultsScreen> {
  @override
  void initState() {
    super.initState();
    if (areResultsLoading) {
      checkBool();
    }
  }

  void checkBool() async {
    Timer.periodic(Duration(milliseconds: 250), (timer) {
      if (!areResultsLoading) {
        setState(() {});
        timer.cancel();
      }
    });
  }

  Widget _buildListItem(int index) {
  String fourthColumnData = scrapedData[index]['fourthColumnData'] ?? '';
  String grade = '$fourthColumnData /20'; // Append '/20' to the grade

  return Card(
    margin: EdgeInsets.all(8.0),
    child: ListTile(
      title: Text(
        scrapedData[index]['secondColumnData'] ?? '',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).hintColor,
        ),
      ),
      trailing: Text(
        grade,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).hintColor,
        ),
      ),
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView.builder(
            itemCount: scrapedData.length,
            itemBuilder: (context, index) {
              return _buildListItem(index);
            },
          ),
          if (areResultsLoading)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: LinearProgressIndicator(),
            ),
        ],
      ),
    );
  }
}