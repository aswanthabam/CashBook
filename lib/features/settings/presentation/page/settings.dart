import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cashbook/core/datasource/local/database.dart';
import 'package:cashbook/core/theme/theme.dart';
import 'package:cashbook/core/widgets/appbar/bottom_bar.dart';
import 'package:cashbook/core/widgets/appbar/main_appbar.dart';
import 'package:cashbook/core/widgets/buttons/full_size_button.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
        bottomNavigationBar: const BottomBar(),
        body: SingleChildScrollView(
            child: Column(children: [
          const MainAppBar(),
          Padding(
            padding: EdgeInsets.all(width * 0.05),
            child: FullSizeButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => Dialog(
                            child: Padding(
                              padding: EdgeInsets.all(width * 0.05),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                      "Are you sure you want to erase all data?"),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      TextButton(
                                          onPressed: () async {
                                            if (await AppDatabase
                                                .dropDatabase()) {
                                              AppDatabase.create();
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "Successfully erased all data");
                                            } else {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "Failed to erase all data");
                                            }
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("Yes, Erase",
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .extension<
                                                          AppColorsExtension>()!
                                                      .red,
                                                  fontWeight:
                                                      FontWeight.w700))),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text("No, Cancel")),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ));
                },
                text: "Erase all data",
                leftIcon: BootstrapIcons.eraser,
                rightIcon: Icons.chevron_right),
          )
        ])));
  }
}
