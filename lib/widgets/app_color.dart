import 'package:flutter/material.dart';

class AppColor {
  AppColor._();

  static Color blackColor = const Color(0xff000000);
  static Color grayColor = const Color(0xffa7a7a7);
  static Color appColor = const Color(0xffD22630);
  static Color blueColor = const Color(0xff554ed8);
  static Color whiteColor = const Color(0xffffffff);
  static Color greenColor = const Color(0xff16D549);

  static Color themeColor = const Color.fromRGBO(210, 38, 48, 100);

 static MaterialColor materialColor = MaterialColor(AppColor.themeColor.value, {
  50: AppColor.themeColor,
  100: AppColor.themeColor,
  200: AppColor.themeColor,
  300: AppColor.themeColor,
  400: AppColor.themeColor,
  500: AppColor.themeColor,
  600: AppColor.themeColor,
  700: AppColor.themeColor,
  800: AppColor.themeColor,
  900: AppColor.themeColor
  });
}
