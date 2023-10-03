import 'package:flutter/material.dart';
import '../classes/ledger.dart';
import '../classes/models.dart';

class PageAccount extends StatefulWidget {
  const PageAccount({super.key});

  @override
  State<PageAccount> createState() => _PageAccountState();
}

class _PageAccountState extends State<PageAccount> {
  Ledger ledger = Ledger();
  List<AccountModel> accounts = [];
  @override
  void initState() {
    super.initState();
    AccountModel.all(ledger.getDatabase()).then((value) {
      setState(() {
        accounts = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
          children: accounts
              .map<Widget>(
                (e) => Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(color: Colors.grey.shade100),
                  child: Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                                color: e.color,
                                borderRadius: BorderRadius.circular(50)),
                          ),
                          SizedBox(width: 10),
                          Text(
                            e.name,
                            style: TextStyle(fontSize: 18, color: e.color),
                          ),
                          Spacer(),
                          Text(e.type),
                          SizedBox(
                            width: 10,
                          ),
                          IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.arrow_forward_ios_outlined))
                        ],
                      ),
                      Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.amber.shade200,
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text("Total This Month : "),
                                  Spacer(),
                                  Text(
                                    "110\$",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red),
                                  )
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Text(
                                      "Total ${e.type.replaceFirst(e.type[0], e.type[0].toUpperCase())} : "),
                                  Spacer(),
                                  Text(
                                    "${e.currentBalance} /-",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red),
                                  )
                                ],
                              ),
                            ],
                          ))
                    ],
                  ),
                ),
              )
              .toList()),
    );
  }
}
