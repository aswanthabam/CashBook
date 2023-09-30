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
      padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(color: Colors.transparent),
      height: height + MediaQuery.of(context).viewPadding.top,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(onPressed: onMenuClick, icon: Icon(Icons.menu)),
          Row(
            children: [
              Icon(Icons.menu_book_rounded, color: Colors.blue.shade500),
              const SizedBox(width: 10),
              Text(
                "Cash Book",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.blue.shade500),
              ),
            ],
          ),
          IconButton(
              onPressed: onSettingsClick,
              icon: Icon(
                Icons.settings,
              )),
        ],
      ),
    );
  }
}
