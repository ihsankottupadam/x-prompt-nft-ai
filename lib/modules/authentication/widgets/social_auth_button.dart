import 'package:x_prompt/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class SocialAuthButton extends StatelessWidget {
  const SocialAuthButton(
      {super.key,
      required this.icon,
      required this.text,
      required this.onPressed});
  final IconData icon;
  final String text;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        fixedSize: Size(60.w, 6.5.h),
        side: const BorderSide(color: secondaryColor),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  icon,
                  color: secondaryColor,
                ),
              ],
            ),
          ),
          SizedBox(
            width: 3.w,
          ),
          Expanded(
            flex: 2,
            child: Text(
              text,
              style: GoogleFonts.dmSans().copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 14.sp,
                color: secondaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
