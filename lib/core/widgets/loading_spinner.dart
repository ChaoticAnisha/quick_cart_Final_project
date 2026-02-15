import 'package:flutter/material.dart';

class LoadingSpinner extends StatelessWidget {
  final String? size;
  final Color? color;

  const LoadingSpinner({super.key, this.size = 'md', this.color});

  @override
  Widget build(BuildContext context) {
    double dimension;
    switch (size) {
      case 'sm':
        dimension = 20;
        break;
      case 'lg':
        dimension = 40;
        break;
      default:
        dimension = 30;
    }

    return SizedBox(
      width: dimension,
      height: dimension,
      child: CircularProgressIndicator(
        strokeWidth: 3,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? const Color(0xFFFFA500),
        ),
      ),
    );
  }
}
