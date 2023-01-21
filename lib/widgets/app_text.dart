import 'package:band_hub/widgets/app_color.dart';
import 'package:flutter/cupertino.dart';


class AppText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final bool? underline;
  final bool? capitalise;
  final int? maxlines;
  final TextAlign? textAlign;
  final String? fontFamily;
  final FontWeight? fontWeight;
  final double? lineHeight;
  final FontStyle? fontStyle;
  final Color? textColor;
  final double? textSize;
  final overflow;

  AppText(
      {required this.text,
      this.style,
      this.maxlines,
      this.textAlign,
      this.underline,
      this.fontFamily,
      this.fontWeight,
      this.lineHeight,
      this.fontStyle,
      this.capitalise,
      this.textSize,
      this.textColor,
      this.overflow});

  @override
  Widget build(BuildContext context) {
    return Text(
      capitalise != null && capitalise! ? text.toUpperCase() : text,
      maxLines: maxlines != null ? maxlines : null,
      overflow: overflow != null ? overflow : null,
      textAlign: textAlign != null ? textAlign : null,
      style: style ??
          TextStyle(
            color: textColor ?? AppColor.blackColor,
            height: lineHeight,
            fontSize: textSize,
            fontWeight: fontWeight ?? FontWeight.w400,
            decoration: underline != null && underline == true
                ? TextDecoration.underline
                : null,
          ),
    );
  }
}
