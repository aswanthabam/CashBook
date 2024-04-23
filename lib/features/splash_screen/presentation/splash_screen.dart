import 'package:cashbook/bloc/tag/tag_bloc.dart';
import 'package:cashbook/core/bloc/theme/theme_bloc.dart';
import 'package:cashbook/core/preferences/init_preferences.dart';
import 'package:cashbook/core/utils/permissions.dart';
import 'package:cashbook/features/create/presentation/bloc/liability/liability_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    var initializationPreferences = InitializationPreferences();

    requestPermission(Permission.storage);
    ThemeBloc bloc = context.read<ThemeBloc>();
    LiabilityBloc liabilityBloc = context.read<LiabilityBloc>();
    bloc.add(LoadTheme());
    bloc.stream.listen((event) {
      Future.delayed(const Duration(seconds: 1), () async {
        if (!await initializationPreferences.isInitialized()) {
          init().then((value) {
            Navigator.pushReplacementNamed(context, "home");
          });
          await initializationPreferences.initialize();
        } else {
          Navigator.pushReplacementNamed(context, "home");
        }
      });
    });
  }

  Future<void> init() async {
    TagBloc tagBloc = context.read<TagBloc>();
    tagBloc.add(CreateTagEvent(
        title: "Education", color: 0xfff72d58, icon: 'school_outlined'));
    tagBloc.add(CreateTagEvent(
        title: "Travel", color: 0xff5bf229, icon: 'travel_explore'));
    tagBloc.add(CreateTagEvent(
        title: "Shopping", color: 0xff40ecf5, icon: 'shopping_bag_outlined'));
    tagBloc.add(CreateTagEvent(
        title: "Health",
        color: 0xffd849f5,
        icon: 'health_and_safety_outlined'));
    tagBloc.add(CreateTagEvent(
        title: "Entertainment", color: 0xfff53ba1, icon: 'sports_esports'));
    tagBloc.add(CreateTagEvent(
        title: "Food", color: 0xfff2a529, icon: 'fastfood_outlined'));
  }

  @override
  Widget build(BuildContext context) {
    // final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          "assets/icons/app_icon/icon.png",
          width: width * 0.15,
          height: width * 0.15,
        ),
        const SizedBox(
          height: 20,
        ),
        Center(
          child: SizedBox(
            width: width * 0.05,
            height: width * 0.05,
            child: const CircularProgressIndicator(),
          ),
        ),
      ],
    ));
  }
}
