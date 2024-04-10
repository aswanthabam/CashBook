import 'package:cashbook/core/theme/theme.dart';
import 'package:cashbook/core/utils/utils.dart';
import 'package:flutter/material.dart';

class MoneyDisplay extends StatefulWidget {
  const MoneyDisplay(
      {super.key,
      required this.amount,
      required this.subText,
      this.prefix = "- "});

  final String subText;
  final double amount;
  final String prefix;

  @override
  State<MoneyDisplay> createState() => _MoneyDisplayState();
}

class _MoneyDisplayState extends State<MoneyDisplay> {
  @override
  Widget build(BuildContext context) {
    String amount = formatMoney(amount: widget.amount, prefix: widget.prefix);
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(
            child: Text(
              amount,
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context)
                      .extension<AppColorsExtension>()!
                      .primary),
            ),
          ),
          Text(
            widget.subText,
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Theme.of(context)
                    .extension<AppColorsExtension>()!
                    .primarySemiDark),
          ),
        ],
      ),
    );
  }
}
