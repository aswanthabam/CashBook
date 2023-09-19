import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CashBook"),
      ),
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  EntityButton(
                      onClick: () {}, text: "Expence", icon: Icons.add),
                  EntityButton(
                      onClick: () {}, text: "Earnings", icon: Icons.add),
                  EntityButton(onClick: () {}, text: "Account", icon: Icons.add)
                ],
              ),
              SizedBox(height: 10),
              Text("Current Status"),
              SizedBox(height: 10),
              Text("Earnings : 1000\$"),
              Text("Expence : 500\$"),
            ],
          )),
    );
  }
}

class EntityButton extends StatelessWidget {
  EntityButton(
      {super.key,
      required this.onClick,
      required this.text,
      required this.icon,
      this.iconOnly = false,
      this.width = 80,
      this.height = 80,
      this.iconColor = const Color.fromRGBO(100, 181, 246, 1),
      this.textColor = const Color.fromRGBO(100, 181, 246, 1),
      this.background = Colors.white});
  void Function() onClick;
  late String text = "";
  late IconData icon;
  bool iconOnly = false;
  double width, height;
  Color background, textColor, iconColor;
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onClick,
        child: Container(
          padding: EdgeInsets.all(10),
          width: width,
          height: height,
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                color: iconColor.withAlpha(100),
                blurRadius: 5,
                offset: Offset(1, 0))
          ], color: background, borderRadius: BorderRadius.circular(20)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: iconColor,
                size: 30,
              ),
              iconOnly
                  ? Text("")
                  : Text(
                      text,
                      style: TextStyle(color: textColor, fontSize: 15),
                    ),
            ],
          ),
        ));
  }
}
