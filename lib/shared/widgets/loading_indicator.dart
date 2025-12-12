import 'package:flutter/cupertino.dart';

class LoadingIndicator extends StatelessWidget {
  final Color? color;
  final double size;

  const LoadingIndicator({
    super.key,
    this.color,
    this.size = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CupertinoActivityIndicator(
        color: color ?? const Color(0xFF8A9A5B),
        radius: size / 2,
      ),
    );
  }
}

class FullScreenLoader extends StatelessWidget {
  final String?  message;

  const FullScreenLoader({
    super.key,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF8F5F0).withValues(alpha: 0.9),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CupertinoActivityIndicator(
              color: Color(0xFF8A9A5B),
              radius: 20,
            ),
            if (message != null) ...[
              const SizedBox(height:  16),
              Text(
                message!,
                style:  const TextStyle(
                  color: Color(0xFF666666),
                  fontSize: 14,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}