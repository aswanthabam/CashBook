import 'package:flutter/material.dart';
import '../global.dart';
import '../classes/ledger.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Ledger ledger = Ledger();
  String loadingText = "";
  @override
  void initState() {
    super.initState();
    init();
  }

  void setLoadingText(String text) {
    setState(() {
      loadingText = text;
    });
  }

  void init() async {
    try {
      // do
      setLoadingText("Loading Ledger");
      ledger.load(1);
      await ledger.loaded;
      Navigator.pushReplacementNamed(context, 'home');
    } catch (err) {
      Global.log.f("Error initializing :  $err");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Positioned(
            top: 20 + MediaQuery.of(context).viewPadding.top,
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(loadingText, style: TextStyle(color: Colors.grey))
              ],
            )),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Image.asset(
                    'assets/icon/icon.png',
                    width: 70,
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: Text(
                    "Cash Book",
                    style: TextStyle(
                        fontSize: 20,
                        // fontWeight: FontWeight.w700,
                        color: Color(0xff375939)),
                  ),
                )
              ]),
        )
      ],
    ));
  }
}
