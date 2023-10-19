import 'package:flutter/material.dart';
import 'package:school_app/Functions/tests.dart';
import 'package:school_app/Screens/main_screen.dart';
import 'dart:async';

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

    if (areTestsLoading) {
      checkBool();
    }
  }

  void checkBool() async {
    print('irte dame');
    print(areTestsLoading);

    Timer.periodic(Duration(seconds: 1), (timer) {
      if (areTestsLoading) {
        // The bool has changed to true, perform your action
        print('Your bool has changed to true. Performing the action.');
      } else {
        print('MALAKA AN EDOULEPSE');
        setState(() {});
        timer.cancel();
      }
    });
  }

  // void fetchTests() async {
  //   List<MyTableData> data = await getTests();
  //   setState(() {
  //     tableData = data;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    print('Building widget with ${tableData.length} items');
    return Scaffold(
      body: Stack(children: [
        Column(
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
              child: ListView(
                children: [
                  // Your first ListView.builder here
                  ...tableData.asMap().entries.map((entry) {
                    bool isFutureDate = isDateInFuture(entry.value.column1);
                    if (isFutureDate) {
                      Color backgroundColor = Colors.green.withOpacity(0.1);
                      return Card(
                        margin: EdgeInsets.all(8.0),
                        child: Container(
                          color: backgroundColor,
                          child: ListTile(
                            title: Text(
                              entry.value.column2,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                            trailing: Text(
                              entry.value.column1,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  }),
                  // Your second ListView.builder here
                  ...tableData.asMap().entries.map((entry) {
                    bool isPastDate = !isDateInFuture(entry.value.column1);
                    if (isPastDate) {
                      Color backgroundColor = Colors.red.withOpacity(0.1);
                      return Card(
                        margin: EdgeInsets.all(8.0),
                        child: Container(
                          color: backgroundColor,
                          child: ListTile(
                            title: Text(
                              entry.value.column2,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                            trailing: Text(
                              entry.value.column1,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  }),
                ],
              ),
            ),
          ],
        ),
        if (areTestsLoading)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: LinearProgressIndicator(),
          ),
      ]),
    );
  }
}









//  if (areTestsLoading)
//               Positioned(
//                 top: 0,
//                 left: 0,
//                 right: 0,
//                 child: LinearProgressIndicator(),
//               ),