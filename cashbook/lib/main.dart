import 'package:flutter/material.dart';
import 'package:cashbook/pages/home.dart';
import 'package:cashbook/global.dart';
import 'package:cashbook/pages/addentityform.dart';
import 'package:cashbook/pages/settings.dart';
import 'package:cashbook/classes/ledger.dart';
import 'pages/addaccountform.dart';

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
        "home": (context) => Home(),
        "settings": (context) => Settings(),
        "addentity": (context) => AddEntityForm(),
        "addaccount": (context) => AddAccountForm()
      },
      initialRoute: "home",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily: "poppins",
          textButtonTheme: const TextButtonThemeData(
              style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll<Color>(Colors.green),
            foregroundColor: MaterialStatePropertyAll<Color>(Colors.white),
          )),
          inputDecorationTheme: InputDecorationTheme(
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.circular(10)),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.blue, width: 1),
                borderRadius: BorderRadius.circular(10)),
            errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red, width: 1),
                borderRadius: BorderRadius.circular(10)),
            focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red, width: 1),
                borderRadius: BorderRadius.circular(10)),
          )),
    );
  }
}
