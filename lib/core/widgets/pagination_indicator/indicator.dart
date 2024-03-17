import 'package:cashbook/core/theme/theme.dart';
import 'package:flutter/material.dart';

class PaginationIndicator extends StatefulWidget {
  const PaginationIndicator({super.key, required this.index, this.count = 3});
  final int count;
  final int index;

  @override
  State<PaginationIndicator> createState() => _PaginationIndicatorState();
}

class _PaginationIndicatorState extends State<PaginationIndicator> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: height * 0.017,
      width: width * 0.14,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.count,
        itemBuilder: (context, index) {
          if (index == widget.index) {
            return Container(
              margin:  EdgeInsets.all(width * 0.01),
              width: width * 0.04,
              height: height * 0.02,
              decoration: BoxDecoration(
                color: Theme.of(context).extension<AppColorsExtension>()!.primaryDark,
                borderRadius: BorderRadius.circular(50),
              ),
            );
          }
          return Container(
            margin: EdgeInsets.all(width * 0.01),
            width: width * 0.02,
            height: height * 0.02,
            decoration: BoxDecoration(
              color: Theme.of(context).extension<AppColorsExtension>()!.primaryLight,
              shape: BoxShape.circle,
            ),
          );
        },
      ),
    );
  }
}