import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cashbook/core/theme/theme.dart';
import 'package:cashbook/core/utils/utils.dart';
import 'package:cashbook/data/models/liability.dart';
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
              // TODO : IMPLEMENT SHOW ASSET
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
                    style: const TextStyle(fontSize: 12))
              ],
            ),
            trailing: Text(
              widget.liabilities[widget.liabilities.length - index - 1].amount
                  .toString(),
              style: const TextStyle(
                  color: Colors.red, fontSize: 15, fontWeight: FontWeight.bold),
            ),
          );
        });
  }
}
