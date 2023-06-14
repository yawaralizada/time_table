import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Application's information"),
      ),
      body: Padding(
        padding: EdgeInsets.only(right: 18.0, top: 18.0, left: 18.0),
        child: Text("this is for managing your income and outcome for daily  life"),
      ),
      backgroundColor: Colors.grey,
    );
  }
}
