import 'package:flutter/material.dart';
import 'package:school_app/Functions/tests.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  List<MyTableData> tableData = [];

  @override
  void initState() {
    super.initState();
    fetchTests();
  }

  void fetchTests() async {
    List<MyTableData> data = await getTests();
    print('got tests');
    setState(() {
      tableData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('Building widget with ${tableData.length} items');
    return Scaffold(
      body: ListView.builder(
        itemCount: tableData.length,
        itemBuilder: (context, index) {
          // Display each item in a ListTile with specific formatting
          return Card(
            child: ListTile(
              title: Text(tableData[index].column2), // Left side
              trailing: Text(tableData[index].column1), // Right side
            ),
          );
        },
      ),
    );
  }
}