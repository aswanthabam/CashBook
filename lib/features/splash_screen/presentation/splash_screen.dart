import 'package:cashbook/core/bloc/theme/theme_bloc.dart';
import 'package:cashbook/features/create/presentation/bloc/liability/liability_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    ThemeBloc bloc = context.read<ThemeBloc>();
    LiabilityBloc liabilityBloc = context.read<LiabilityBloc>();
    bloc.add(LoadTheme());
    bloc.stream.listen((event) {
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacementNamed(context, "home");
      });
    });
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
