import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

String getPlannerDate(String format) {
  DateTime now = DateTime.now();
  DateTime dateToShow;

  if (now.hour < 12) {
    dateToShow = now;
  } else {
    dateToShow = now.add(Duration(days: 1));
  }

  return DateFormat(format).format(dateToShow);
}

String plannerDate = getPlannerDate('yyyy-MM-dd');
String plannerDate1 = DateFormat('yyyy-MM-dd').format(DateTime.now());

String formattedDate = getPlannerDate('d MMMM yyyy');
String formattedDate1 = DateFormat('d MMMM yyyy').format(DateTime.now());

Map<String, Color> statusColor = {
  'Pending': const Color.fromRGBO(255, 195, 0, 10),
  'Completed': const Color.fromRGBO(86, 156, 0, 10),
  'Cancelled': Color.fromARGB(246, 236, 50, 72),
};

void showValidationError(String message, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: AppTemplate.bgClr,
      content: Text(
        message,
        style: GoogleFonts.inter(
            color: AppTemplate.primaryClr, fontWeight: FontWeight.w400),
      ),
    ),
  );
}
