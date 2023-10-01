import 'package:flutter/material.dart';
import '../classes/models.dart';

class Selector extends StatefulWidget {
  Selector(
      {super.key,
      required this.data,
      required this.onSelected,
      required this.title});
  String title;
  List<AccountModel> data;
  Function(AccountModel) onSelected;
  @override
  State<Selector> createState() => _SelectorState();
}

class _SelectorState extends State<Selector> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: ListView(
          shrinkWrap: true,
          children: widget.data
              .map<Widget>((e) => Row(
                    children: [
                      Expanded(
                          child: TextButton(
                              style: const ButtonStyle(
                                  padding: MaterialStatePropertyAll<EdgeInsets>(
                                      EdgeInsets.zero),
                                  backgroundColor:
                                      MaterialStatePropertyAll<Color>(
                                    Colors.transparent,
                                  )),
                              onPressed: () {
                                widget.onSelected(e);
                                Navigator.pop(context);
                              },
                              child: Container(
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.only(bottom: 10),
                                  width: double.infinity,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: Colors.grey),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                          decoration: BoxDecoration(
                                              color: e.color,
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          width: 20,
                                          height: 20),
                                      const SizedBox(width: 10),
                                      Text(
                                        e.name,
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 15),
                                      ),
                                      Spacer(),
                                      Text(
                                        e.type,
                                        style: TextStyle(
                                            color: e.type == "earning"
                                                ? Colors.green
                                                : e.type == "expense"
                                                    ? Colors.red
                                                    : Colors.blue.shade400,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12),
                                      )
                                    ],
                                  ))))
                    ],
                  ))
              .toList()),
    );
  }
}

void showSelectorDialog(
    {required BuildContext context,
    required List<AccountModel> data,
    required Function(AccountModel) onSelected,
    required title}) {
  showDialog(
      context: context,
      builder: (context) =>
          Selector(data: data, onSelected: onSelected, title: title));
}
