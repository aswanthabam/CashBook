import 'package:cashbook/core/widgets/appbar/bottom_bar.dart';
import 'package:cashbook/core/widgets/appbar/main_appbar.dart';
import 'package:cashbook/core/widgets/error/error_display.dart';
import 'package:cashbook/data/models/liability.dart';
import 'package:cashbook/features/assets_liability/presentation/bloc/assets/assets_list_bloc.dart';
import 'package:cashbook/features/assets_liability/presentation/bloc/liability/liability_list_bloc.dart';
import 'package:cashbook/features/assets_liability/presentation/widgets/assets_displayer.dart';
import 'package:cashbook/features/assets_liability/presentation/widgets/liability_displayer.dart';
import 'package:cashbook/features/create/presentation/bloc/assets/assets_bloc.dart';
import 'package:cashbook/features/create/presentation/bloc/liability/liability_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AssetsLiabilityPage extends StatefulWidget {
  const AssetsLiabilityPage({super.key});

  @override
  State<AssetsLiabilityPage> createState() => _AssetsLiabilityPageState();
}

class _AssetsLiabilityPageState extends State<AssetsLiabilityPage> {
  List<Liability> liabilities = [];

  @override
  void initState() {
    super.initState();
    AssetsListBloc assetsListBloc = context.read<AssetsListBloc>();
    AssetsBloc assetsBloc = context.read<AssetsBloc>();

    LiabilityListBloc liabilityListBloc = context.read<LiabilityListBloc>();
    LiabilityBloc liabilityBloc = context.read<LiabilityBloc>();

    assetsListBloc.add(GetAssetsListEvent());
    assetsBloc.stream.listen((event) {
      if (event is AssetCreated) {
        assetsListBloc.add(GetAssetsListEvent());
      }
    });

    assetsListBloc.stream.listen((event) {
      if (event is AssetsListError) {
        Fluttertoast.showToast(msg: event.message);
      }
    });

    liabilityListBloc
        .add(GetLiabilitiesEvent(includeFinished: true, count: 10));
    liabilityBloc.stream.listen((event) {
      if (event is LiabilityCreated) {
        liabilityListBloc.add(GetLiabilitiesEvent());
      } else if (event is LiabilityEdited) {
        liabilityListBloc.add(GetLiabilitiesEvent());
      } else if (event is LiabilityPaid) {
        liabilityListBloc.add(GetLiabilitiesEvent());
      } else if (event is LiabilityPaymentEdited) {
        liabilityListBloc.add(GetLiabilitiesEvent());
      }
    });

    liabilityListBloc.stream.listen((event) {
      if (event is LiabilityListError) {
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
                  padding: EdgeInsets.only(left: 8, bottom: 10),
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
                      if (state.assets.isNotEmpty) {
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
                    }
                    return ErrorDisplay(
                      mainColor: Colors.red.withAlpha(200),
                      title: 'An Error Occurred',
                      description:
                          'An unexpected error occurred while fetching assets.',
                      icon: Icons.bug_report_outlined,
                    );
                  },
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 8, top: 20, bottom: 10),
                  child: Text(
                    "Your Liabilities",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                BlocConsumer<LiabilityListBloc, LiabilityListState>(
                  listener: (context, state) {
                    if (state is LiabilityListError) {
                      Fluttertoast.showToast(msg: state.message);
                    }
                  },
                  builder: (context, state) {
                    if (state is LiabilityListLoaded) {
                      if (state.liabilities.isNotEmpty) {
                        liabilities = state.liabilities;
                        return LiabilityDisplayer(
                          liabilities: state.liabilities,
                          assetsCount: state.liabilities.length,
                        );
                      }
                      return const ErrorDisplay(
                        title: 'No Liabilities Added',
                        description: 'Try adding a new asset you own.',
                        icon: Icons.not_interested_outlined,
                      );
                    } else if (state is LiabilityListError) {
                      return ErrorDisplay(
                        mainColor: Colors.red.withAlpha(200),
                        title: 'An Error Occurred',
                        description: state.message,
                        icon: Icons.bug_report_outlined,
                      );
                    }
                    if (liabilities.isNotEmpty) {
                      return LiabilityDisplayer(
                        liabilities: liabilities,
                        assetsCount: liabilities.length,
                      );
                    }
                    return const ErrorDisplay(
                      title: 'No Liabilities Added',
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
