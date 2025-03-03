import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class ReusableContainer extends StatelessWidget {
  String title;
  BorderRadius borderRadius;

  ReusableContainer(
      {super.key,
      required this.borderRadius,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black,
        width: 1),
        borderRadius: borderRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15,
        horizontal: 11),
        child: Center(
          child: Text(
            title,
            style: GoogleFonts.nunitoSans(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.normal),
          ),
        ),
      ),
    );
  }
}
