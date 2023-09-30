import 'package:flutter/material.dart';
import '../classes/database.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back)),
        ),
        body: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                TextButton(
                    onPressed: () {
                      DatabaseHelper dbh = DatabaseHelper();
                      dbh.deleteDatabases();
                    },
                    child: Text("Delete Database")),
                TextButton(
                    onPressed: () {
                      DatabaseHelper dbh = DatabaseHelper();
                      dbh.database;
                    },
                    child: Text("Create Database"))
              ],
            )));
  }
}
