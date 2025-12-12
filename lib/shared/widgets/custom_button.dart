import 'package:flutter/cupertino.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color?  backgroundColor;
  final Color? textColor;
  final bool isLoading;
  final double? width;
  final double height;

  const CustomButton({
    super.key,
    required this. text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.isLoading = false,
    this.width,
    this.height = 50,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ??  double.infinity,
      height: height,
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        borderRadius: BorderRadius.circular(25),
        color: backgroundColor ?? const Color(0xFF2C3E50),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const CupertinoActivityIndicator(
          color: CupertinoColors.white,
        )
            : Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            letterSpacing: 1,
            color: textColor ??  CupertinoColors.white,
          ),
        ),
      ),
    );
  }
}