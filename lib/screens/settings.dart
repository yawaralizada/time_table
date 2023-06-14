import 'package:flutter/material.dart';



class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: const Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(Icons.display_settings),
          Text('View'),
          Icon(Icons.app_blocking),
          Icon(Icons.lock_sharp)
        ],
      ),
    );
  }
}
