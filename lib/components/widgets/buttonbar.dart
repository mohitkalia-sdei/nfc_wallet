import 'package:flutter/material.dart';
import 'package:nfc_wallet/theme/colors.dart';

class BottomBar extends StatelessWidget {
  final Function onTap;
  final String text;
  final Color? color;
  final Color? textColor;
  final bool isValid;

  const BottomBar({
    super.key,
    required this.onTap,
    required this.text,
    this.color,
    this.textColor,
    this.isValid = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isValid ? onTap as void Function()? : null,
      child: Container(
        decoration: BoxDecoration(
          color: color ?? primaryColor.withOpacity(isValid ? 1.0 : 0.5),
          borderRadius: const BorderRadius.all(
            Radius.circular(40),
          ),
        ),
        height: 48.0,
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Center(
          child: Text(
            text,
            style: textColor != null
                ? Theme.of(context).textTheme.bodyLarge?.copyWith(color: textColor)
                : Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ),
    );
  }
}
