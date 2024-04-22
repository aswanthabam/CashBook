import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cashbook/core/theme/theme.dart';
import 'package:cashbook/core/utils/utils.dart';
import 'package:cashbook/data/models/liability.dart';
import 'package:cashbook/features/assets_liability/presentation/pages/show_liability.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';

class LiabilityDisplayer extends StatefulWidget {
  const LiabilityDisplayer(
      {super.key, required this.liabilities, required this.assetsCount});

  final List<Liability> liabilities;
  final int assetsCount;

  @override
  State<LiabilityDisplayer> createState() => _LiabilityDisplayerState();
}

class _LiabilityDisplayerState extends State<LiabilityDisplayer> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(top: height * 0.02),
        itemCount: widget.liabilities.length > widget.assetsCount
            ? widget.assetsCount
            : widget.liabilities.length,
        itemBuilder: (context, index) {
          int color =
              widget.liabilities[widget.liabilities.length - index - 1].color;
          String? icon =
              widget.liabilities[widget.liabilities.length - index - 1].icon;
          return ListTile(
            onTap: () {
              Navigator.of(context).push(PageRouteBuilder(
                  pageBuilder: (context, a1, a2) => ShowLiabilityPage(
                        liability: widget
                            .liabilities[widget.liabilities.length - index - 1],
                      ),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    const begin = Offset(1.0, 0.0);
                    const end = Offset.zero;
                    const curve = Curves.ease;
                    var tween = Tween(begin: begin, end: end)
                        .chain(CurveTween(curve: curve));
                    var offsetAnimation = animation.drive(tween);
                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  }));
            },
            shape: const Border(top: BorderSide(color: Colors.grey, width: 1)),
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon != null
                      ? deserializeIcon({"key": icon, "pack": "material"},
                              iconPack: IconPack.allMaterial) ??
                          BootstrapIcons.hourglass_split
                      : BootstrapIcons.hourglass_split,
                  color: Color(color),
                ),
                const SizedBox(
                  height: 3,
                )
              ],
            ),
            horizontalTitleGap: 25,
            title: Text(
              widget.liabilities[widget.liabilities.length - index - 1].title,
              style: TextStyle(
                  fontSize: 14,
                  color:
                      Theme.of(context).extension<AppColorsExtension>()!.black),
            ),
            subtitle: Row(
              children: [
                Text(
                    formatDate(widget
                        .liabilities[widget.liabilities.length - index - 1]
                        .date),
                    style: const TextStyle(fontSize: 12)),
                Text(
                    " ⦿ ${widget.liabilities[widget.liabilities.length - index - 1].amount}",
                    style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context)
                            .extension<AppColorsExtension>()!
                            .green)),
              ],
            ),
            trailing: Text(
              widget
                  .liabilities[widget.liabilities.length - index - 1].remaining
                  .toString(),
              style: const TextStyle(
                  color: Colors.red, fontSize: 15, fontWeight: FontWeight.bold),
            ),
          );
        });
  }
}
