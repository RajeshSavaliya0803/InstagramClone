import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppText extends StatelessWidget {
  final String? text;
  final double? size;
  final FontWeight? fontWeight;
  final Color? color;
  final double? wordSpacing;
  final VoidCallback? onClick;
  final TextOverflow? overflow;
  final bool? softWrap;
  final double? textScaleFactor;
  final int? maxLines;
  final TextDirection? textDirection;

  const AppText({
    super.key,
    this.text,
    this.size,
    this.fontWeight,
    this.color,
    this.wordSpacing,
    this.onClick,
    this.overflow,
    this.softWrap,
    this.textScaleFactor,
    this.maxLines,
    this.textDirection,
  });

  @override
  Widget build(BuildContext context) {
    return Text(text ?? '',
        maxLines: maxLines,
        textDirection: textDirection,
        style: GoogleFonts.inter(
            color: color,
            fontSize: size,
            fontWeight: fontWeight,
            fontStyle: FontStyle.normal),
        overflow: overflow,
        softWrap: softWrap,
        textScaleFactor: textScaleFactor);
  }
}
