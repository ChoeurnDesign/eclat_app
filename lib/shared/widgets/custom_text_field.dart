import 'package:flutter/cupertino.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String placeholder;
  final String? label;
  final IconData? icon;
  final bool obscureText;
  final TextInputType?  keyboardType;

  const CustomTextField({
    super.key,
    required this. controller,
    required this.placeholder,
    this. label,
    this.icon,
    this.obscureText = false,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null) ...[
            Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 8),
              child: Text(
                label!,
                style:  const TextStyle(
                  color: Color(0xFF8A9A5B),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 2,
                ),
              ),
            ),
          ],
          Container(
            height: 56,
            decoration: BoxDecoration(
              color: CupertinoColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFC4A484).withValues(alpha: 0.30),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                if (icon != null) ...[
                  const SizedBox(width: 16),
                  Icon(
                    icon,
                    size:  20,
                    color:  const Color(0xFF8A9A5B),
                  ),
                  const SizedBox(width: 12),
                ] else
                  const SizedBox(width: 16),
                Expanded(
                  child: CupertinoTextField(
                    controller: controller,
                    placeholder: placeholder,
                    keyboardType: keyboardType,
                    obscureText: obscureText,
                    placeholderStyle: const TextStyle(
                      color: Color(0xFFB8B8B8),
                      fontSize: 15,
                    ),
                    style: const TextStyle(
                      color: Color(0xFF2C3E50),
                      fontSize: 15,
                    ),
                    decoration: null,
                    padding: EdgeInsets.zero,
                    cursorColor: const Color(0xFF8A9A5B),
                  ),
                ),
                const SizedBox(width: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}