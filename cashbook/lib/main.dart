import 'package:flutter/material.dart';
import 'package:cashbook/pages/home.dart';

void main() {
  runApp(Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "CashBook",
      routes: {"home": (context) => Home()},
      initialRoute: "home",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: "poppins"),
    );
  }
}
