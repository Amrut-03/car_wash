import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppTemplate {
  static const Color textClr = Colors.black;
  static const Color primaryClr = Colors.white;
  static const Color enabledBorderClr = Color(0xFF9B9B9B);
  static const Color buttonClr = Color(0xFF1E3763);
  static const Color bgClr = Color(0xFF021649);
  static const Color shadowClr = Color(0xFFE1E1E1);
}

String encKey = 'C0oRAe1QNtn3zYNvJ8rv';
String plannerDate = DateFormat('yyyy-MM-dd').format(
  DateTime.now().add(
    const Duration(days: 1),
  ),
);

String formattedDate = DateFormat('d MMMM yyyy').format(
    DateTime.now().add(
      const Duration(days: 1),
    ),
  );
