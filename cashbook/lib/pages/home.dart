import 'package:flutter/material.dart';
import 'package:cashbook/components/appbar.dart';
import 'page-account.dart';
import 'page-main.dart';
import 'page-statistics.dart';

class Home extends StatefulWidget {
  Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int pageIndex = 0;
  List<Widget> pages = [
    PageMain(),
    PageAccount(),
    Container(),
    PageStatistics(),
    PageStatistics()
  ];

  void setPage(int id) {
    if (pageIndex != id) {
      setState(() {
        pageIndex = id;
      });
    }
  }

  bool isCurrent(int id) {
    if (pageIndex == id)
      return true;
    else
      return false;
  }

  void addEntity() {
    Navigator.pushNamed(context, "addentity");
  }

  void addAccount() {
    Navigator.pushNamed(context, "addaccount");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        onSettingsClick: () {
          Navigator.pushNamed(context, "settings");
        },
      ),
      body: Stack(
        children: [
          Positioned(
              top: 0,
              left: 0,
              width: MediaQuery.of(context).size.width,
              child: Column(children: [
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: pages[pageIndex]),
              ])),
          Positioned(
            bottom: 15,
            height: 95,
            width: 270,
            left: MediaQuery.of(context).size.width / 2 - 135,
            child: Stack(
              children: [
                Positioned(
                    width: 270,
                    height: 60,
                    bottom: 0,
                    child: Container(
                        width: 270,
                        height: 60,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withAlpha(150),
                                  offset: Offset(1, 1),
                                  blurRadius: 5)
                            ]),
                        child: Row())),
                Positioned(
                    height: 60,
                    bottom: 0,
                    child: Container(
                        width: 270,
                        height: 60,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Color(0x93375938),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            IconButton(
                                color: isCurrent(0)
                                    ? Color(0xff007A82)
                                    : Colors.black,
                                iconSize: 25,
                                onPressed: () {
                                  setPage(0);
                                },
                                icon: Icon(Icons.home_rounded)),
                            IconButton(
                                color: isCurrent(1)
                                    ? Color(0xff007A82)
                                    : Colors.black,
                                iconSize: 25,
                                onPressed: () {
                                  setPage(1);
                                },
                                icon: Icon(Icons.menu_book_rounded)),
                            SizedBox(
                              width: 50,
                            ),
                            IconButton(
                                color: isCurrent(3)
                                    ? Color(0xff007A82)
                                    : Colors.black,
                                iconSize: 25,
                                onPressed: () {
                                  setPage(3);
                                },
                                icon: Icon(Icons.auto_graph_rounded)),
                            IconButton(
                                color: isCurrent(4)
                                    ? Color(0xff007A82)
                                    : Colors.black,
                                iconSize: 25,
                                onPressed: () {
                                  setPage(4);
                                },
                                icon: Icon(Icons.tips_and_updates_rounded)),
                          ],
                        ))),
                Positioned(
                  left: 135 - 29,
                  top: 0,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50)),
                    width: 65,
                    height: 65,
                  ),
                ),
                Positioned(
                  left: 135 - 25,
                  top: 4,
                  child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Color(0xFF59925C),
                          borderRadius: BorderRadius.circular(50)),
                      child: IconButton(
                          color:
                              isCurrent(2) ? Color(0xff007A82) : Colors.black,
                          iconSize: 30,
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => Stack(children: [
                                      GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: MediaQuery.of(context)
                                                .size
                                                .height,
                                            color:
                                                Color.fromARGB(71, 89, 146, 92),
                                          )),
                                      Positioned(
                                          bottom: 110,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                GestureDetector(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                      addAccount();
                                                    },
                                                    child: Container(
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Container(
                                                              width: 60,
                                                              height: 60,
                                                              padding:
                                                                  EdgeInsets.all(
                                                                      10),
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .green,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              50)),
                                                              child: Icon(
                                                                  Icons.add)),
                                                          const SizedBox(
                                                              width: 15),
                                                          Text(
                                                            "Add Account",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                inherit: false,
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 16),
                                                          ),
                                                        ],
                                                      ),
                                                    )),
                                                GestureDetector(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                      addEntity();
                                                    },
                                                    child: Container(
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Container(
                                                              width: 60,
                                                              height: 60,
                                                              padding:
                                                                  EdgeInsets.all(
                                                                      10),
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .green,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              50)),
                                                              child: Icon(
                                                                  Icons.add)),
                                                          const SizedBox(
                                                              width: 15),
                                                          Text(
                                                            "Add Entity",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                inherit: false,
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 16),
                                                          ),
                                                        ],
                                                      ),
                                                    )),
                                              ]))
                                    ]));
                          },
                          icon: Icon(Icons.add))),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
