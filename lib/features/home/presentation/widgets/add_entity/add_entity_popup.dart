import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cashbook/core/widgets/buttons/full_size_button.dart';
import 'package:cashbook/features/home/presentation/page/add_asset_page.dart';
import 'package:cashbook/features/home/presentation/page/add_expense_page.dart';
import 'package:cashbook/features/home/presentation/page/add_liability_page.dart';
import 'package:flutter/material.dart';

class AddEntityPopup extends StatefulWidget {
  const AddEntityPopup({super.key});

  @override
  State<AddEntityPopup> createState() => _AddEntityPopupState();
}

class _AddEntityPopupState extends State<AddEntityPopup> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Container(
        height: height * 0.35,
        width: width,
        padding: EdgeInsets.all(width * 0.05),
        decoration: BoxDecoration(
          // color: Theme.of(context).extension<AppColorsExtension>()!.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            FullSizeButton(
              leftIcon: BootstrapIcons.currency_rupee,
              rightIcon: BootstrapIcons.arrow_right,
              text: "Add Expense",
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        const AddExpensePage(heading: "Add Expense")));
              },
            ),
            // SizedBox(height: height * 0.01,),
            // FullSizeButton(
            //   leftIcon: BootstrapIcons.piggy_bank,
            //   rightIcon: BootstrapIcons.arrow_right,
            //   text: "Add Earning",
            //   onPressed: () {
            //     Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AddEarningPage(heading: "Add Earning", onSubmit: (){
            //       // TODO : IMPLEMENT ADD EARNING
            //       return true;
            //     })));
            //   },
            // ),
            SizedBox(
              height: height * 0.01,
            ),
            FullSizeButton(
              leftIcon: BootstrapIcons.building,
              rightIcon: BootstrapIcons.arrow_right,
              text: "Add Asset",
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AddAssetPage(
                        heading: "Add Asset",
                        onSubmit: () {
                          // TODO : IMPLEMENT ADD ASSET
                          return true;
                        })));
              },
            ),
            SizedBox(
              height: height * 0.01,
            ),
            FullSizeButton(
              leftIcon: BootstrapIcons.currency_exchange,
              rightIcon: BootstrapIcons.arrow_right,
              text: "Add Liability",
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AddLiabilityPage(
                        heading: "Add Liability",
                        onSubmit: () {
                          // TODO : IMPLEMENT ADD ASSET
                          return true;
                        })));
              },
            ),
          ],
        ));
  }
}

showAddEntityPopup(BuildContext context) {
  showModalBottomSheet(
      enableDrag: true,
      showDragHandle: true,
      context: context,
      builder: (context) => const AddEntityPopup());
}
