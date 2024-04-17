import 'package:cashbook/core/widgets/appbar/bottom_bar.dart';
import 'package:cashbook/core/widgets/appbar/main_appbar.dart';
import 'package:cashbook/core/widgets/error/error_display.dart';
import 'package:cashbook/features/assets_liability/presentation/bloc/assets_list_bloc.dart';
import 'package:cashbook/features/assets_liability/presentation/widgets/assets_displayer.dart';
import 'package:cashbook/features/create/presentation/bloc/assets/assets_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AssetsLiabilityPage extends StatefulWidget {
  const AssetsLiabilityPage({super.key});

  @override
  State<AssetsLiabilityPage> createState() => _AssetsLiabilityPageState();
}

class _AssetsLiabilityPageState extends State<AssetsLiabilityPage> {
  @override
  void initState() {
    super.initState();
    AssetsListBloc bloc = context.read<AssetsListBloc>();
    bloc.add(GetAssetsListEvent());
    bloc.stream.listen((event) {
      if (event is AssetCreated) {
        bloc.add(GetAssetsListEvent());
      }
      if (event is AssetsListError) {
        Fluttertoast.showToast(msg: event.message);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
        bottomNavigationBar: const BottomBar(),
        body: SingleChildScrollView(
            child: Column(children: [
          const MainAppBar(),
          Container(
            padding: EdgeInsets.all(width * 0.035),
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Text(
                    "Your Assets",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                BlocConsumer<AssetsListBloc, AssetsListState>(
                  listener: (context, state) {
                    if (state is AssetsListError) {
                      Fluttertoast.showToast(msg: state.message);
                    }
                  },
                  builder: (context, state) {
                    if (state is AssetsListLoaded) {
                      return AssetsDisplayer(
                        assets: state.assets,
                        assetsCount: state.assets.length,
                      );
                    }
                    return const ErrorDisplay(
                      title: 'No Assets Added',
                      description: 'Try adding a new asset you own.',
                      icon: Icons.not_interested_outlined,
                    );
                  },
                ),
              ],
            ),
          )
        ])));
  }
}
