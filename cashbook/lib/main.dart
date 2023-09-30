import 'package:flutter/material.dart';
import 'package:cashbook/pages/home.dart';
import 'package:cashbook/global.dart';
import 'package:cashbook/pages/addform.dart';
import 'package:cashbook/pages/settings.dart';
import 'package:cashbook/classes/ledger.dart';

void main() {
  runApp(Main());
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  late Ledger ledger;
  @override
  void initState() {
    super.initState();
    ledger = Ledger();
    ledger.load(1);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "CashBook",
      routes: {
        "home": (context) => Home(
              ledger: ledger,
            ),
        "settings": (context) => Settings(),
        "addentity": (context) => AddEntityForm(ledger: ledger),
        "addaccount": (context) => AddAccountForm(ledger: ledger)
      },
      initialRoute: "home",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily: "poppins",
          textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll<Color>(Colors.green),
            foregroundColor: MaterialStatePropertyAll<Color>(Colors.white),
          )),
          inputDecorationTheme: InputDecorationTheme(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(10)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 1),
                  borderRadius: BorderRadius.circular(10)),
              errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 1),
                  borderRadius: BorderRadius.circular(10)))),
    );
  }
}
