import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cashbook/core/theme/theme.dart';
import 'package:cashbook/core/utils/utils.dart';
import 'package:cashbook/data/models/asset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';

class AssetsDisplayer extends StatefulWidget {
  const AssetsDisplayer(
      {super.key, required this.assets, required this.assetsCount});

  final List<Asset> assets;
  final int assetsCount;

  @override
  State<AssetsDisplayer> createState() => _AssetsDisplayerState();
}

class _AssetsDisplayerState extends State<AssetsDisplayer> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(top: height * 0.02),
        itemCount: widget.assets.length > widget.assetsCount
            ? widget.assetsCount
            : widget.assets.length,
        itemBuilder: (context, index) {
          String? icon = widget.assets[widget.assets.length - index - 1].icon;
          int color = widget.assets[widget.assets.length - index - 1].color;
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
              widget.assets[widget.assets.length - index - 1].title,
              style: TextStyle(
                  fontSize: 14,
                  color:
                      Theme.of(context).extension<AppColorsExtension>()!.black),
            ),
            subtitle: Row(
              children: [
                Text(
                    formatDate(
                        widget.assets[widget.assets.length - index - 1].date),
                    style: const TextStyle(fontSize: 12)),
              ],
            ),
            trailing: Text(
              widget.assets[widget.assets.length - index - 1].worth.toString(),
              style: const TextStyle(
                  color: Colors.red, fontSize: 15, fontWeight: FontWeight.bold),
            ),
          );
        });
  }
}
