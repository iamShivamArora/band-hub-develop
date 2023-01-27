import 'package:band_hub/routes/Routes.dart';
import 'package:band_hub/util/sharedPref.dart';
import 'package:band_hub/widgets/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:intl/intl.dart';

import 'global_variable.dart';

class CommonFunctions {
  Future<Map<String, String>> getHeader() async {
    String? token = await SharedPref().getToken();

    if (token != null && token.isNotEmpty) {
      print(token);
      return {"security_key": "bandHub@123", 'auth_key': token};
    } else {
      return {
        "security_key": "bandHub@123",
      };
    }
  }

  Widget loadingCircle() {
    return CircularProgressIndicator(color: AppColor.appColor);
  }

  bool isEmailValid(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);

    return regExp.hasMatch(em);
  }

  String changeDateFormat(String savedDateString) {
    DateTime tempDate = new DateFormat("yyyy-MM-dd").parse(savedDateString);
    String date = DateFormat("dd.MM.yyyy").format(tempDate);
    return date;
  }

  void invalideAuth(res) {
    if (res['code'] == 403) {
      String error = res['msg'];
      Get.toNamed(Routes.logInScreen);
      throw new Exception(error);
    }
  }

  String changeServerDateDisplayFormat(String savedDateString) {
    DateTime tempDate = new DateFormat("yyyy-MM-dd").parse(savedDateString);
    String date = DateFormat("dd/MM/yyyy").format(tempDate);
    return date;
  }

  String changeDateToServerFormat(String savedDateString) {
    DateTime tempDate = new DateFormat("dd/MM/yyyy").parse(savedDateString);
    String date = DateFormat("yyyy-MM-dd").format(tempDate);
    return date;
  }

  String getStatusType(int status) {
    //	0=Pending ,1= Accept ,2= decline,3= ongoing ,4 = complete,5 = Cancel booking
    switch (status) {
      case 0:
        {
          return 'Pending';
        }
      case 1:
        {
          return 'Accept';
        }
      case 2:
        {
          return 'Decline';
        }
      case 3:
        {
          return 'Ongoing';
        }
      case 4:
        {
          return 'Complete';
        }
      case 5:
        {
          return 'Cancel booking';
        }
      default:
        {
          return '';
        }
    }
  }

  Color getColorForStatus(int status) {
    //	0=Pending ,1= Accept ,2= decline,3= ongoing ,4 = complete,5 = Cancel booking
    switch (status) {
      case 0:
        {
          return Colors.amber;
        }
      case 1:
        {
          return Colors.green;
        }
      case 2:
        {
          return Colors.red;
        }
      case 3:
        {
          return Colors.amber;
        }
      case 4:
        {
          return Colors.green;
        }
      case 5:
        {
          return Colors.red;
        }
      default:
        {
          return Colors.black;
        }
    }
  }

  String zeroBeforeIfNeeded(String value) {
    if (value.length == 1) {
      return '0' + value;
    } else {
      return value;
    }
  }

  String daeTimeToStringDateorTime(DateTime savedDateString, String format) {
    //dd.MM.yyyy
    if (format.isEmpty) {
      format = "dd/MM/yyyy";
    }
    final DateFormat formatter = DateFormat(format);
    final String date = formatter.format(savedDateString);

    return date;
  }

  String timeAgoFormat(String savedDateString) {
    DateTime tempDate =
    new DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(savedDateString);
    String date = DateFormat("dd-MM-yyyy hh:mm a").format(tempDate);

    // print(date);
    var dateTimeDuration =
    DateTime.now().difference(DateTime.parse(savedDateString));
    // var duration = Duration(minutes: 12);
    // print(DateTime.now().difference(DateTime.parse(savedDateString)));
    // print(DateTime.now().difference(DateTime.now().subtract(Duration(minutes: 12))));

    return GetTimeAgo.parse(DateTime.now().subtract(dateTimeDuration));
  }

  Widget setNetworkImages({String imageUrl = "",
    double circle = 0.0,
    double width = 0.0,
    double height = 0.0,
    bool isUser = false,
    BoxFit boxFit = BoxFit.cover}) {
    return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(circle)),
        child: Image.network(
          imageUrl.contains(GlobalVariable.imageUrl)
              ? imageUrl
              : isUser
                  ? GlobalVariable.imageUserUrl + imageUrl
                  : GlobalVariable.imageUrl + imageUrl,
          width: width,
          height: height,
          fit: boxFit,
          loadingBuilder: (BuildContext ctx, Widget child,
              ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) {
              return child;
            } else {
              return Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(circle)),
                    color: AppColor.grayColor),
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor:
                    AlwaysStoppedAnimation<Color>(AppColor.appColor),
                  ),
                ),
              );
            }
          },
          errorBuilder: (BuildContext ctx, Object child, StackTrace? error) {
            return ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(circle)),
              child: Container(
                color: AppColor.grayColor,
                child: Image.asset(
                    isUser
                        ? height < width
                            ? "assets/images/error_image.png"
                            : "assets/images/ic_user.png"
                        : "assets/images/error_image.png",
                    width: width,
                    height: height,
                    fit: BoxFit.cover),
              ),
            );
          },
        ));
  }
}
