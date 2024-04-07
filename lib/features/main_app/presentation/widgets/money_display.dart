import 'package:cashbook/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    double num = (widget.amount >= 10000000000
        ? (widget.amount / 1000000000)
        : ((widget.amount >= 10000000
            ? (widget.amount / 1000000)
            : (widget.amount))));
    String postfix = (widget.amount >= 10000000000
        ? " B"
        : ((widget.amount >= 10000000 ? " M" : "")));
    String amount = widget.prefix +
        NumberFormat.currency(locale: 'en_IN', symbol: '₹ ')
            .format(num)
            .replaceAll(',', '') +
        postfix;
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
