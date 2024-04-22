import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cashbook/core/theme/theme.dart';
import 'package:cashbook/core/utils/utils.dart';
import 'package:cashbook/core/widgets/error/error_display.dart';
import 'package:cashbook/data/models/liability.dart';
import 'package:cashbook/features/assets_liability/presentation/bloc/liability/liability_list_bloc.dart';
import 'package:cashbook/features/create/presentation/bloc/liability/liability_bloc.dart';
import 'package:cashbook/features/create/presentation/pages/add_expense_page.dart';
import 'package:cashbook/features/create/presentation/pages/add_liability_page.dart';
import 'package:cashbook/features/home/presentation/widgets/history_displayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  void initState() {
    super.initState();
    LiabilityBloc liabilityBloc = BlocProvider.of<LiabilityBloc>(context);
    LiabilityListBloc liabilityListBloc =
        BlocProvider.of<LiabilityListBloc>(context);
    liabilityListBloc.add(GetLiabilityPayoutsEvent(id: widget.liability.id));
    liabilityBloc.stream.listen((event) {
      if (event is LiabilityPaid) {
        liabilityListBloc
            .add(GetLiabilityPayoutsEvent(id: widget.liability.id));
      } else if (event is LiabilityPaymentEdited) {
        liabilityListBloc
            .add(GetLiabilityPayoutsEvent(id: widget.liability.id));
      }
    });
  }

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
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                AppBar(
                  title: const Text('Liability'),
                  actions: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shadowColor: Colors.transparent,
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.black,
                            elevation: 0),
                        onPressed: () {
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
                        child: const Row(
                          children: [
                            Icon(
                              Icons.edit,
                              size: 20,
                            ),
                            SizedBox(width: 10),
                            Text("Edit"),
                          ],
                        ))
                  ],
                ),
                Container(
                    padding: EdgeInsets.all(width * 0.05),
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
                                    }, iconPack: IconPack.allMaterial) ??
                                    BootstrapIcons.hourglass_split,
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
                          widget.liability.description ??
                              "No description added",
                          style:
                              const TextStyle(fontSize: 16, color: Colors.grey),
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
                            Text(
                                formatMoney(amount: widget.liability.remaining),
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
                    )),
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    "Payouts",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: BlocConsumer<LiabilityListBloc, LiabilityListState>(
                      listener: (context, state) {},
                      builder: (context, state) {
                        if (state is LiabilityPayoutsLoaded) {
                          if (state.expenses.isNotEmpty) {
                            return HistoryDisplayer(
                                expenses: state.expenses,
                                historyCount: state.expenses.length);
                          }
                          return const ErrorDisplay(
                            title: "No Payouts!",
                            description:
                                "No payouts have been made for this liability yet",
                            icon: Icons.not_interested,
                          );
                        } else if (state is LiabilityPayoutsError) {
                          return ErrorDisplay(
                            title: "Error occurred!",
                            description:
                                "An unexpected error occurred while getting liability payouts",
                            icon: Icons.bug_report_outlined,
                            mainColor: Colors.red.withAlpha(200),
                          );
                        }
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }),
                ),
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
