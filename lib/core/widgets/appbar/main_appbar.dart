import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cashbook/core/theme/theme.dart';
import 'package:cashbook/features/notifications/presentation/pages/notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/theme/theme_bloc.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({super.key, required this.title, this.showTitle = true});

  final bool showTitle;
  final String title;

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
              showTitle
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset('assets/icons/app_icon/icon.png',
                            width: width * 0.1,
                            height: width * 0.05,
                            fit: BoxFit.contain),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          title,
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context)
                                  .extension<AppColorsExtension>()!
                                  .primary),
                        ),
                      ],
                    )
                  : IconButton(
                      onPressed: () {
                        Navigator.of(context).push(PageRouteBuilder(
                            pageBuilder: (context, a, b) =>
                                const Notifications(),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            }));
                      },
                      icon: Icon(
                        BootstrapIcons.bell_fill,
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
                  icon: BlocBuilder<ThemeBloc, ThemeState>(
                    builder: (context, state) => Icon(
                      state.isDark
                          ? BootstrapIcons.sun_fill
                          : BootstrapIcons.moon_fill,
                      color: Theme.of(context)
                          .extension<AppColorsExtension>()!
                          .primaryLight,
                    ),
                  )),
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
