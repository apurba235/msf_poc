import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:msf/utils/color_consts.dart';

class CommonFilledButton extends StatelessWidget {
  const CommonFilledButton({super.key, this.onPressed, this.child, this.buttonText, this.padding, this.borderRadius});

  final void Function()? onPressed;
  final Widget? child;
  final String? buttonText;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
          padding: padding ?? const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
          backgroundColor: AppColorConsts.lightDeepRed,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(10),
          )),
      child: child ??
          Text(
            buttonText!,
            style: GoogleFonts.monomaniacOne.call().copyWith(color: AppColorConsts.white, fontSize: 18),
          ),
    );
  }
}
