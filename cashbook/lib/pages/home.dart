import 'package:flutter/material.dart';
import 'package:cashbook/components/appbar.dart';
import 'page-account.dart';
import 'page-main.dart';

class Home extends StatefulWidget {
  Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int pageIndex = 0;
  List<Widget> pages = [PageMain(), PageAccount()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          elevation: 40,
          unselectedItemColor: Colors.white,
          selectedItemColor: Colors.amber.shade100,
          backgroundColor: Colors.green.shade800,
          currentIndex: pageIndex,
          onTap: (index) {
            setState(() {
              pageIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.library_books_rounded), label: "Accounts")
          ]),
      appBar: MyAppBar(
        onSettingsClick: () {
          Navigator.pushNamed(context, "settings");
        },
      ),
      body: pages[pageIndex],
    );
  }
}
