import 'package:flutter/material.dart';
import 'package:cashbook/components/appbar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Text("Current Status"),
              Container(
                padding: EdgeInsets.all(10),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(30)),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.lightBlue.shade100,
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Expence",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.red.shade600,
                                      fontWeight: FontWeight.w800),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "110.4\$",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 30,
                                      color: Colors.red.shade400,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Earnings",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.green.shade600,
                                      fontWeight: FontWeight.w800),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "100\$",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 30,
                                      color: Colors.green.shade400,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 10),
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
              const SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.grey.withAlpha(100),
                    borderRadius: BorderRadius.circular(30)),
                child: Column(children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colors.black, width: 1))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total This Month"),
                        Text(
                          "-10.4\$",
                          style: TextStyle(
                              color: Colors.red.shade500,
                              fontWeight: FontWeight.w700),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colors.black, width: 1))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Major Spending on "),
                        Text(
                          "Food A/C",
                          style: TextStyle(
                              color: Colors.red.shade500,
                              fontWeight: FontWeight.w700),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colors.black, width: 1))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Major Earnings Threw"),
                        Text(
                          "Salary A/c",
                          style: TextStyle(
                              color: Colors.green.shade500,
                              fontWeight: FontWeight.w700),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colors.black, width: 1))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Net Balance"),
                        Text(
                          "500\$",
                          style: TextStyle(
                              color: Colors.green.shade500,
                              fontWeight: FontWeight.w700),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "More Details >>",
                          style: TextStyle(
                              color: Colors.blue.shade400,
                              fontWeight: FontWeight.w700),
                        )
                      ],
                    ),
                  ),
                ]),
              )
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
