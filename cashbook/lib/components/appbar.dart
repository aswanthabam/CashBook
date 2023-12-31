import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  MyAppBar(
      {super.key,
      this.height = kToolbarHeight,
      this.onMenuClick,
      this.onSettingsClick});
  double height;
  Function()? onMenuClick;
  Function()? onSettingsClick;
  @override
  Size get preferredSize => Size.fromHeight(height);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).viewPadding.top + 15, bottom: 15),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(color: Colors.transparent),
      height: height + MediaQuery.of(context).viewPadding.top + 15,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // IconButton(onPressed: onMenuClick, icon: Icon(Icons.menu)),
          Row(
            children: [
              // Icon(Icons.menu_book_rounded, color: Colors.blue.shade500),
              const SizedBox(
                width: 20,
              ),
              Image.asset(
                "assets/icon/icon.png",
                width: 30,
              ),
              const SizedBox(width: 20),
              Text(
                "Cash Book",
                style: TextStyle(
                    fontSize: 20,
                    // fontWeight: FontWeight.w700,
                    color: Color(0xff375939)),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                  onPressed: onSettingsClick,
                  icon: Icon(
                    Icons.manage_accounts_rounded,
                    size: 27,
                  )),
              const SizedBox(width: 20),
            ],
          )
        ],
      ),
    );
  }
}
