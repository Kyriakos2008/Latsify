import 'package:flutter/material.dart';
import 'package:school_app/Functions/tests.dart';
import 'package:school_app/Screens/main_screen.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  void initState() {
    super.initState();
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
    body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FittedBox(
  fit: BoxFit.scaleDown,
  child: Text(
    'Προειδοποιημένα Διαγωνίσματα',
    style: TextStyle(
      fontSize: 25,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).hintColor,
    ),
  ),
),
        ),
        Expanded(
          child: Stack(
            children: [
              ListView.builder(
                itemCount: tableData.length,
                itemBuilder: (context, index) {
                  // Display each item in a ListTile with specific formatting
                  return Card(
                    margin: EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(
                        tableData[index].column2,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).hintColor,
                        ),
                      ), // Left side
                      trailing: Text(
                        tableData[index].column1,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).hintColor,
                        ),
                      ), // Right side
                    ),
                  );
                },
              ),
              if (areTestsLoading)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: LinearProgressIndicator(),
                ),
            ],
          ),
        ),
      ],
    ),
  );
}

}
