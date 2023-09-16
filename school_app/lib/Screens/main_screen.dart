import 'package:flutter/material.dart';
import 'package:school_app/Functions/schedule.dart';

class mainScreen extends StatefulWidget {
  const mainScreen({super.key});

  @override
  State<mainScreen> createState() => _mainScreenState();
}

class _mainScreenState extends State<mainScreen> {
  // Define a function that calls the schedule function when the button is pressed
  void _onPressed() {
    schedule();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      // Use a RaisedButton widget to create a simple button
      child: ElevatedButton(
        // Set the text of the button to 'Schedule'
        child: Text('Schedule'),
        // Set the onPressed property to the _onPressed function
        onPressed: _onPressed,
      ),
    );
  }
}
