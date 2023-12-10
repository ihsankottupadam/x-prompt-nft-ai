import 'package:x_prompt/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton(
      {super.key,
      required this.text,
      required this.onPressed,
      this.showIcon = true});
  final String text;
  final VoidCallback? onPressed;
  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          backgroundColor: secondaryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox.shrink(),
          Text(
            text,
            style: GoogleFonts.dmSans().copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 13.sp,
                color: Colors.white),
          ),
          showIcon
              ? const Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: Colors.white,
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
