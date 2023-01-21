import 'package:band_hub/widgets/elevated_btn.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:band_hub/widgets/app_color.dart';
import 'package:band_hub/widgets/app_text.dart';
import 'package:image_viewer/image_viewer.dart';

class HelperWidget {
  static customAppBar(
      {String? title, String? assetImage, Color? color, Function()? onTap}) {
    return AppBar(
        backgroundColor: color ?? AppColor.whiteColor,
        title: AppText(
          text: (title ?? ""),
          fontWeight: FontWeight.w400,
          textColor: Colors.black,
          textSize: 18,
        ),
        leading: Container(
          margin: const EdgeInsets.only(left: 10),
          child: IconButton(
            icon: Image.asset(
              'assets/images/ic_back.png',
              height: 22,
            ),
            onPressed: () => Get.back(),
          ),
        ),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          assetImage == null
              ? Container()
              : InkWell(
                  splashColor: Colors.transparent,
                  onTap: onTap,
                  child: Container(
                    padding: const EdgeInsets.only(right: 20),
                    child: Image.asset(
                      assetImage,
                      height: 20,
                      color: Colors.black,
                      width: 20,
                    ),
                  ),
                )
        ],
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ));
  }

  static noAppBar({Brightness? brightness, Color? color}) {
    return AppBar(
      toolbarHeight: 0,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.black),
      backgroundColor: color ?? Colors.white,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
  }

  static bool validateEmail(String email) {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    return emailValid;
  }

  static bool validatePassword(String password) {
    bool passwordValid =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
            .hasMatch(password);
    return passwordValid;
  }

  static showToast({message}) {
    // return Fluttertoast.showToast(
    //   msg: message,
    //   toastLength: Toast.LENGTH_SHORT,
    //   gravity: ToastGravity.BOTTOM,
    //   backgroundColor: AppColor.blackColor,
    //   textColor: AppColor.whiteColor,
    //   fontSize: 13.0,
    // );
  }

  static showLoader() {
    return showDialog(
      context: Get.context!,
      builder: (_) => Center(
        child: Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
              color: AppColor.whiteColor,
              borderRadius: BorderRadius.circular(10)),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset('assets/images/loader.gif')),
        ),
      ),
    );
  }

  static showScreenLoader() {
    return SizedBox(
      height: Get.height,
      width: Get.width,
      child: Center(
        child: Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
              color: AppColor.whiteColor,
              borderRadius: BorderRadius.circular(10)),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset('assets/images/loader.gif')),
        ),
      ),
    );
  }

  static String capitalize(String value) {
    if (value.trim().isEmpty) return "";
    return "${value[0].toUpperCase()}${value.substring(1).toLowerCase()}";
  }

  static String timeAgo(DateTime fatchedDate) {
    DateTime currentDate = DateTime.now();

    var different = currentDate.difference(fatchedDate);

    if (different.inDays > 365) {
      return "${(different.inDays / 365).floor()} ${(different.inDays / 365).floor() == 1 ? "year" : "years"} ago";
    }
    if (different.inDays > 30) {
      return "${(different.inDays / 30).floor()} ${(different.inDays / 30).floor() == 1 ? "month" : "months"} ago";
    }
    if (different.inDays > 7) {
      return "${(different.inDays / 7).floor()} ${(different.inDays / 7).floor() == 1 ? "week" : "weeks"} ago";
    }
    if (different.inDays > 0) {
      return "${different.inDays} ${different.inDays == 1 ? "day" : "days"} ago";
    }
    if (different.inHours > 0) {
      return "${different.inHours} ${different.inHours == 1 ? "hour" : "hours"} ago";
    }
    if (different.inMinutes > 0) {
      return "${different.inMinutes} ${different.inMinutes == 1 ? "minute" : "minutes"} ago";
    }
    if (different.inMinutes == 0) return 'Just Now';

    return fatchedDate.toString();
  }

  static showImageViewer(List<String> urls, int index) {
    ImageViewer.showImageSlider(images: urls, startingPosition: index);
  }

  static String jobStatus(int status) {
    String jobStatus = '';
    switch (status) {
      case 0:
        jobStatus = "Pending";
        break;
      case 1:
        jobStatus = "Accepted";
        break;
      case 2:
        jobStatus = "Cancelled";
        break;
      case 3:
        jobStatus = "Completed";
        break;
      case 4:
        jobStatus = "Job Started";
        break;
      case 5:
        jobStatus = "Cancelled By User";
        break;
    }
    return jobStatus;
  }

  static Color? jobStatusColor(int? status) {
    switch (status) {
      case 0:
        return Colors.amber;
      case 1:
        return Colors.indigo;
      case 2:
        return Colors.red;
      case 3:
        return Colors.green;
      case 4:
        return Colors.green[300];
      case 5:
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  static void showPicker(
      List<String> list, void Function(int)? onSelectedItemChanged) {
    _showDialog(
      CupertinoPicker(
        magnification: 1.22,
        squeeze: 1.2,
        useMagnifier: true,
        itemExtent: 32.0,
        // This is called when selected item is changed.
        onSelectedItemChanged: onSelectedItemChanged,
        children: List<Widget>.generate(list.length, (int index) {
          return Center(
            child: AppText(
              text: list[index],
            ),
          );
        }),
      ),
    );
  }

  static void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
        context: Get.context!,
        builder: (BuildContext context) => Container(
              height: 216,
              padding: const EdgeInsets.only(top: 6.0),
              // The Bottom margin is provided to align the popup above the system navigation bar.
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              // Provide a background color for the popup.
              color: CupertinoColors.systemBackground.resolveFrom(context),
              // Use a SafeArea widget to avoid system overlaps.
              child: SafeArea(
                top: false,
                child: child,
              ),
            ));
  }

  static void showDateDialog(Function(DateTime) onDateTimeChanged) {
    _showDialog(Material(
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Container(
              margin: const EdgeInsets.only(right: 15, bottom: 10),
              child: AppText(
                text: "Done",
                textSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: CupertinoDatePicker(
              initialDateTime: DateTime.now(),
              mode: CupertinoDatePickerMode.date,
              use24hFormat: true,
              // This is called when the user changes the date.
              onDateTimeChanged: onDateTimeChanged,
            ),
          ),
        ],
      ),
    ));
  }
}
