import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cashbook/core/providers/theme_provider.dart';
import 'package:cashbook/core/theme/app_palatte.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(50);
  
  @override
  Widget build(BuildContext context) {
    return Consumer<ModelTheme>(
        builder: (context, ModelTheme themeNotifier, child) { return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 25),
      height: preferredSize.height + MediaQuery.of(context).padding.top + 25,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(width: 25,),
        IconButton(
          onPressed: () {},
          icon: const Icon(BootstrapIcons.person_fill,color: AppPalatte.primaryLight,),
        ),
        const Spacer(),
        IconButton(
          onPressed: () {
            themeNotifier.isDark = !themeNotifier.isDark;
          },
          icon: const Icon(BootstrapIcons.moon, color: AppPalatte.primaryLight,),
        ),
        const SizedBox(width: 25,),
      ],
    ),);});
  }
 @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return "Main App Bar";
  } 
}