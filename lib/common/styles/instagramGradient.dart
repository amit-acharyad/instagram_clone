import 'package:flutter/material.dart';

class InstagramGradientIcon extends StatelessWidget {
  const InstagramGradientIcon({super.key, required this.icon});
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return const LinearGradient(
          colors: [
            Color(0xFFF58529), // Instagram gradient colors
            Color(0xFFDD2A7B),
            Color(0xFF8134AF),
            Color(0xFF515BD4),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(bounds);
      },
      child: Icon(
        icon,
        size: 50,
        color: Colors.white, // The icon will take the gradient color
      ),
    );
  }
}
