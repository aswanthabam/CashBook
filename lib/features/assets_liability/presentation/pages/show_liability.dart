import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cashbook/core/theme/theme.dart';
import 'package:cashbook/core/utils/utils.dart';
import 'package:cashbook/data/models/liability.dart';
import 'package:cashbook/features/create/presentation/pages/add_expense_page.dart';
import 'package:cashbook/features/create/presentation/pages/add_liability_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:intl/intl.dart';

class ShowLiabilityPage extends StatefulWidget {
  const ShowLiabilityPage({super.key, required this.liability});

  final Liability liability;

  @override
  State<ShowLiabilityPage> createState() => _ShowLiabilityPageState();
}

class _ShowLiabilityPageState extends State<ShowLiabilityPage> {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Stack(
      children: [
        Container(
          height: height * 0.975,
          padding: EdgeInsets.only(bottom: height * 0.025),
          child: SingleChildScrollView(
              child: Column(children: [
            AppBar(
              title: const Text('Liability'),
              actions: [
                PopupMenuButton<IconButton>(
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                                PageRouteBuilder(
                                    pageBuilder: (context, a, b) =>
                                        AddLiabilityPage(
                                          heading: "Edit Liability",
                                          liability: widget.liability,
                                        ),
                                    transitionsBuilder: (context, animation,
                                            secondaryAnimation, child) =>
                                        FadeTransition(
                                          opacity: animation,
                                          child: child,
                                        )));
                          },
                          child: const Text("Edit Liability"))
                    ];
                  },
                  child: const Icon(BootstrapIcons.three_dots_vertical),
                )
              ],
            ),
            Container(
                padding: EdgeInsets.all(width * 0.035),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                            deserializeIcon({
                              'key': widget.liability.icon,
                              'pack': 'material',
                            }, iconPack: IconPack.allMaterial),
                            size: 30,
                            color: Color(widget.liability.color)),
                        const SizedBox(width: 10),
                        Text(
                          widget.liability.title,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(widget.liability.color)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.liability.description ?? "No description added",
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text(
                          'Amount: ',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(formatMoney(amount: widget.liability.amount),
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text(
                          'Remaining: ',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(formatMoney(amount: widget.liability.remaining),
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Start Date: ${DateFormat("yyyy MMM dd, h:mm a").format(widget.liability.date.toLocal())}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'End Date: ${widget.liability.endDate ?? "End date not added"}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Interest Rate: ${widget.liability.interest} %',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ))
          ])),
        ),
        Positioned(
            bottom: 0,
            height: height * 0.05,
            width: width,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: width * 0.95,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context)
                          .extension<AppColorsExtension>()!
                          .primary,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(PageRouteBuilder(
                          pageBuilder: (context, a, b) => AddExpensePage(
                                heading: "Pay for Liability",
                                liability: widget.liability,
                              )));
                    },
                    child: Text(
                      "Pay",
                      style: TextStyle(
                          color: Theme.of(context)
                              .extension<AppColorsExtension>()!
                              .primaryLightTextColor),
                    ),
                  ),
                ),
              ],
            ))
      ],
    ));
  }
}
