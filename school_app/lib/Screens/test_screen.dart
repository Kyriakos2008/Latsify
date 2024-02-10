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

    Timer.periodic(const Duration(milliseconds: 250), (timer) {
      if (areTestsLoading) {
        // The bool has changed to true, perform your action
      } else {
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
    super.build(context);
    return Scaffold(
      body: Stack(children: [
        Column(
          children: [
           
            Expanded(
              child: ListView(
                children: [
                  // Your first ListView.builder here
                  ...tableData.asMap().entries.map((entry) {
                    bool isFutureDate = isDateInFuture(entry.value.column1);
                    if (isFutureDate) {
                      Color backgroundColor = Colors.green.withOpacity(0.1);
                      return Card(
                        margin: const EdgeInsets.all(8.0),
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
                        margin: const EdgeInsets.all(8.0),
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
          const Positioned(
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