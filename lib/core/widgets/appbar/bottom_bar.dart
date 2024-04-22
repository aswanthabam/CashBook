import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cashbook/core/theme/theme.dart';
import 'package:cashbook/core/widgets/buttons/add_button.dart';
import 'package:cashbook/features/assets_liability/presentation/pages/assets_liability.dart';
import 'package:cashbook/features/history/presentation/page/history.dart';
import 'package:cashbook/features/home/presentation/page/home.dart';
import 'package:cashbook/features/home/presentation/widgets/add_entity/add_entity_popup.dart';
import 'package:cashbook/features/settings/presentation/page/settings.dart';
import 'package:flutter/material.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  Route _createRoute({required Widget child}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1, 0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      decoration: BoxDecoration(
          color:
              Theme.of(context).extension<AppColorsExtension>()!.transparent),
      child: Stack(
        children: [
          Positioned(
              bottom: 0,
              child: Container(
                  width: width,
                  height: height * 0.09,
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .extension<AppColorsExtension>()!
                        .primaryDark,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(width * 0.05),
                      topRight: Radius.circular(width * 0.05),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      BottomBarButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                              _createRoute(child: const Home()));
                        },
                        icon: BootstrapIcons.bank2,
                        text: "Home",
                      ),
                      BottomBarButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                              _createRoute(child: const History()));
                        },
                        icon: BootstrapIcons.clock_history,
                        text: "History",
                      ),
                      SizedBox(
                        width: width * 0.05,
                      ),
                      BottomBarButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                              _createRoute(child: const AssetsLiabilityPage()));
                        },
                        icon: BootstrapIcons.currency_exchange,
                        text: "Assets &\nLiabilities",
                      ),
                      BottomBarButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                              _createRoute(child: const Settings()));
                        },
                        icon: BootstrapIcons.gear_fill,
                        text: "Settings",
                      ),
                    ],
                  ))),
          SizedBox(
            height: (height * 0.09) + (width * 0.06),
          ),
          Positioned(
            left: width * 0.425,
            top: 0,
            height: height * 0.07,
            width: width * 0.15,
            child: Container(
              width: width * 0.15,
              height: width * 0.15,
              decoration: BoxDecoration(
                  color: Theme.of(context)
                      .extension<AppColorsExtension>()!
                      .primaryDark,
                  borderRadius: BorderRadius.circular(width * 0.1),
                  border: Border.all(
                    color: Theme.of(context)
                        .extension<AppColorsExtension>()!
                        .white,
                    width: 2,
                  )),
              child: AddButton(
                onPressed: () {
                  showAddEntityPopup(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BottomBarButton extends StatelessWidget {
  const BottomBarButton(
      {super.key,
      required this.onPressed,
      required this.icon,
      required this.text});

  final VoidCallback onPressed;
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return FittedBox(
      child: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            IconButton(
              padding: EdgeInsets.zero,
              onPressed: onPressed,
              constraints: BoxConstraints(maxHeight: height * 0.01),
              icon: Icon(
                icon,
                size: width * 0.05,
                color: Theme.of(context)
                    .extension<AppColorsExtension>()!
                    .primaryLightTextColor,
              ),
            ),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context)
                    .extension<AppColorsExtension>()!
                    .primaryLightTextColor,
                fontWeight: FontWeight.bold,
                fontSize: width * 0.025,
              ),
            ),
            SizedBox(
              height: height * 0.015,
            ),
          ],
        ),
      ),
    );
  }
}
