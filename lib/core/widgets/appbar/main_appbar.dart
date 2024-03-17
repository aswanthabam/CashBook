import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cashbook/core/providers/theme_provider.dart';
import 'package:cashbook/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(50);
  
  @override
  Widget build(BuildContext context) {
    // final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Consumer<ModelTheme>(
        builder: (context, ModelTheme themeNotifier, child) { return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      height: preferredSize.height + MediaQuery.of(context).padding.top + width * 0.035,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
         SizedBox(width: width * 0.035,),
        IconButton(
          onPressed: () {},
          icon:  Icon(BootstrapIcons.person_fill,color: Theme.of(context).extension<AppColorsExtension>()!.primaryLight,),
        ),
        const Spacer(),
        IconButton(
          onPressed: () {
            themeNotifier.isDark = !themeNotifier.isDark;
          },
          icon:  Icon(BootstrapIcons.moon, color: Theme.of(context).extension<AppColorsExtension>()!.primaryLight,),
        ),
         SizedBox(width: width * 0.035,),
      ],
    ),);});
  }
 @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return "Main App Bar";
  } 
}