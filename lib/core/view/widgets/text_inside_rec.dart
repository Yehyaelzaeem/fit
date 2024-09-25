import 'package:app/core/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class TextInsideRec extends StatelessWidget {
  final String text;

  const TextInsideRec({
    required this.text,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9.0),
        color: const Color(0xFFF1F1F1),
      ),
      child: SizedBox(
        width: deviceWidth / 1.3,
        child: Column(
          children: <Widget>[
            SizedBox(height: 8),
            Text(
              text,
              style: GoogleFonts.cairo(
                fontSize: 13.0,
                color: Colors.black,
                fontWeight: FontWeight.w600,
                height: 1.5,
              ),
            ),
            SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
