import 'package:flutter/cupertino.dart';

class AuthButton extends StatelessWidget {
  final String text;
  final VoidCallback?  onPressed;
  final bool isLoading;
  final bool isSecondary;

  const AuthButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isSecondary = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child:  CupertinoButton(
        padding: EdgeInsets.zero,
        disabledColor: const Color(0xFFCCCCCC),
        color: isSecondary ? const Color(0xFF2C3E50) : const Color(0xFF8A9A5B),
        borderRadius: BorderRadius.circular(24),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const CupertinoActivityIndicator(
          color: CupertinoColors.white,
        )
            : Text(
          text,
          style: const TextStyle(
            fontSize:  15,
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
            color: Color(0xFFF8F5F0),
          ),
        ),
      ),
    );
  }
}