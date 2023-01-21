import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:band_hub/widgets/app_color.dart';
import 'package:band_hub/widgets/app_text.dart';
import 'package:get/get.dart';

class ElevatedStrokeBtn extends StatelessWidget {
  final String? text;
  final Function()? onTap;
  final double? padding;
  final double? width;
  final double? heignt;
  final Color? buttonColor;
  final double? textSize;
  final Color? textColor;

  // final Color? buackgroundColor;
  // final Color? borderColor;
  // final Color? textColor;

  ElevatedStrokeBtn(
      {this.text,
      this.onTap,
      this.padding,
      this.width,
      this.heignt,
      this.buttonColor,
      this.textSize,
      this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? Get.width,
      height: heignt??50,
      child: ElevatedButton(
          child: AppText(
            text: text ?? "",
            textColor: textColor ?? AppColor.appColor,
            fontWeight: FontWeight.w500,
            textSize: textSize ?? 15,
            maxlines: 1,
          ),
          style: ButtonStyle(
            alignment: Alignment.center,
            elevation: MaterialStateProperty.all<double>(0),
            // fixedSize: MaterialStateProperty.all<Size>(Size.fromWidth(MediaQuery.of(context).size.width)),
            // padding: MaterialStateProperty.all<EdgeInsets>(
            //     EdgeInsets.symmetric(vertical: padding ?? 13)),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            backgroundColor: MaterialStateProperty.all<Color>(
                AppColor.whiteColor),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: buttonColor ?? AppColor.appColor,width: 1),
              ),
            ),
          ),
          onPressed: () => {onTap != null ? onTap!() : null}),
    );
  }
}
