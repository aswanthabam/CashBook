import 'package:cashbook/core/theme/app_palatte.dart';
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
    return SizedBox(
      height: 20,
      width: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.count,
        itemBuilder: (context, index) {
          if (index == widget.index) {
            return Container(
              margin: const EdgeInsets.all(5),
              width: 20,
              height: 10,
              decoration: BoxDecoration(
                color: AppPalatte.primaryDark,
                borderRadius: BorderRadius.circular(50),
              ),
            );
          }
          return Container(
            margin: const EdgeInsets.all(5),
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: AppPalatte.primaryLight,
              shape: BoxShape.circle,
            ),
          );
        },
      ),
    );
  }
}