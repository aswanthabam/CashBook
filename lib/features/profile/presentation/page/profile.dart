import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cashbook/core/datasource/local/database.dart';
import 'package:cashbook/core/theme/theme.dart';
import 'package:cashbook/core/widgets/appbar/bottom_bar.dart';
import 'package:cashbook/core/widgets/appbar/main_appbar.dart';
import 'package:cashbook/core/widgets/buttons/full_size_button.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
        bottomNavigationBar: const BottomBar(),
        body: SingleChildScrollView(
            child: Column(
          children: [
            const MainAppBar(),
            Padding(
              padding: EdgeInsets.all(width * 0.05),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: width * 0.05),
                      child: const Column(
                        children: [
                          Text(
                            "Profile",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: width * 0.05),
                      child: FullSizeButton(
                          padding: EdgeInsets.symmetric(
                              horizontal: width * 0.05, vertical: 0),
                          height: height * 0.075,
                          onPressed: () {
                            Navigator.of(context).pushNamed('history');
                          },
                          text: 'Your transactions',
                          leftIcon: BootstrapIcons.clock_history,
                          rightIcon: Icons.chevron_right),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: width * 0.05),
                      child: FullSizeButton(
                          padding: EdgeInsets.symmetric(
                              horizontal: width * 0.05, vertical: 0),
                          height: height * 0.075,
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title:
                                          const Text("Feature not available."),
                                      content: const Text(
                                          "This feature is currently not available."),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("OK"))
                                      ],
                                    ));
                          },
                          text: 'Export Data',
                          leftIcon: BootstrapIcons.download,
                          rightIcon: Icons.chevron_right),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: width * 0.05),
                      child: FullSizeButton(
                          padding: EdgeInsets.symmetric(
                              horizontal: width * 0.05, vertical: 0),
                          height: height * 0.075,
                          textColor: Theme.of(context)
                              .extension<AppColorsExtension>()!
                              .red,
                          iconColor: Theme.of(context)
                              .extension<AppColorsExtension>()!
                              .red,
                          borderColor: Theme.of(context)
                              .extension<AppColorsExtension>()!
                              .red,
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
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
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
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text("Yes, Erase",
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .extension<
                                                                    AppColorsExtension>()!
                                                                .red,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700))),
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text(
                                                        "No, Cancel")),
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
                    ),
                  ]),
            ),
          ],
        )));
  }
}
