import 'package:flutter/material.dart';

import '../helper/color.dart';
import '../helper/custom_text.style.dart';

class MyTextButton extends StatelessWidget {
  final Color btnBackgroundColor;
  final String btnText;
  final VoidCallback onPress;
  final double borderRadius;

  final Color btnTextColor;

  const MyTextButton({
    super.key,
    this.btnBackgroundColor = AppColors.primary,
    required this.btnText,
    required this.onPress,
    this.borderRadius = 27,
    this.btnTextColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPress,
      style: ElevatedButton.styleFrom(
        backgroundColor: btnBackgroundColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: BorderSide(width: 1, color: Colors.black12),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          btnText,
          style: myTextStyle21(
            fontweight: FontWeight.bold,
            textColor: btnTextColor,
          ),
        ),
      ),
    );
  }
}
