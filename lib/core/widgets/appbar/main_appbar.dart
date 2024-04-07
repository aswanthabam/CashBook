import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cashbook/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/theme/theme_bloc.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    // final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return BlocConsumer<ThemeBloc, ThemeState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          height: preferredSize.height +
              MediaQuery.of(context).padding.top +
              width * 0.035,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: width * 0.035,
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  BootstrapIcons.person_fill,
                  color: Theme.of(context)
                      .extension<AppColorsExtension>()!
                      .primaryLight,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  context.read<ThemeBloc>().add(ThemeChanged());
                },
                icon: Icon(
                  BootstrapIcons.moon,
                  color: Theme.of(context)
                      .extension<AppColorsExtension>()!
                      .primaryLight,
                ),
              ),
              SizedBox(
                width: width * 0.035,
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return "Main App Bar";
  }
}