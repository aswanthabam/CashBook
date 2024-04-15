import 'package:cashbook/core/widgets/appbar/bottom_bar.dart';
import 'package:cashbook/core/widgets/appbar/main_appbar.dart';
import 'package:cashbook/features/assets_liability/presentation/bloc/assets_list_bloc.dart';
import 'package:cashbook/features/assets_liability/presentation/widgets/assets_displayer.dart';
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
            child: BlocConsumer<AssetsListBloc, AssetsListState>(
              listener: (context, state) {
                if (state is AssetsListError) {
                  Fluttertoast.showToast(msg: state.message);
                }
              },
              builder: (context, state) {
                if (state is AssetsListLoaded) {
                  return AssetsDisplayer(
                    assets: state.assets,
                    assetsCount: 5,
                  );
                }
                return AssetsDisplayer(
                  assets: [],
                  assetsCount: 5,
                );
              },
            ),
          )
        ])));
  }
}
