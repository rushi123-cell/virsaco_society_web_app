import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF2AB4C0); // Teal/Cyan from website
  static const Color secondary = Color(0xFF001C30); // Navy Blue from website
  
  static const Color background = Color(0xFFF8FAFB);
  static const Color white = Colors.white;
  static const Color black = Color(0xFF1D1D1D);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color lightGrey = Color(0xFFE0E0E0);
  
  static const Color error = Color(0xFFE53935);
  static const Color success = Color(0xFF43A047);
  static const Color warning = Color(0xFFFB8C00);

  // Profile Specific Colors
  static const Color profileBackground = Color(0xFFF4F7FA);
  static const Color profileGradientEnd = Color(0xFF00334E);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, Color(0xFF1E8E99)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
