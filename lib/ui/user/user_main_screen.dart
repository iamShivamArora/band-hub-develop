import 'dart:convert';
import 'dart:io';

import 'package:band_hub/ui/user/home/account/user_account_screen.dart';
import 'package:band_hub/ui/user/home/message/user_message_screen.dart';
import 'package:band_hub/ui/user/home/user_home_screen.dart';
import 'package:band_hub/util/sharedPref.dart';
import 'package:band_hub/widgets/app_color.dart';
import 'package:band_hub/widgets/helper_widget.dart';
import 'package:band_hub/ui/user/home/booking/user_booking_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../routes/Routes.dart';
import '../../util/common_funcations.dart';
import '../../util/global_variable.dart';

class UserMainScreen extends StatefulWidget {
  const UserMainScreen({Key? key}) : super(key: key);

  @override
  State<UserMainScreen> createState() => _UserMainScreenState();
}

class _UserMainScreenState extends State<UserMainScreen> {
  int index = 0;

  @override
  void initState() {
    getNotificationStatusChange(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: HelperWidget.noAppBar(color: AppColor.appColor),
      backgroundColor: AppColor.whiteColor,
      resizeToAvoidBottomInset: false,
      body: DefaultTabController(
        length: 4,
        child: Column(children: [
          const Expanded(
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                UserHomeScreen(),
                UserBookingScreen(),
                UserMessageScreen(),
                UserAccountScreen(),
              ],
            ),
          ),
          Container(
            height: 70,
            margin: EdgeInsets.only(bottom: Platform.isIOS ? 20 : 0),
            decoration: BoxDecoration(
                color: AppColor.whiteColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.grayColor.withAlpha(80),
                    blurRadius: 10.0,
                    offset: const Offset(2, 2),
                  ),
                ]),
            child: TabBar(
              isScrollable: false,
              indicator: UnderlineTabIndicator(
                  insets: const EdgeInsets.fromLTRB(36.0, 0.0, 36.0, 67.5),
                  borderSide: BorderSide(width: 2.5, color: AppColor.appColor)),
              onTap: (value) {
                index = value;
                setState(() {});
              },
              // indicatorSize: TabBarIndicatorSize.label,
              labelPadding: EdgeInsets.zero,
              labelStyle: const TextStyle(
                fontSize: 11,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w400,
              ),
              unselectedLabelColor: Colors.black,
              labelColor: const Color(0xffD22630),
              tabs: [
                Tab(
                  iconMargin: const EdgeInsets.all(7),
                  icon: Image.asset(
                    index == 0
                        ? 'assets/images/ic_home.png'
                        : 'assets/images/ic_home_new_black.png',
                    height: 18,
                  ),
                  text: 'Home',
                ),
                Tab(
                  iconMargin: const EdgeInsets.all(7),
                  icon: Image.asset(
                    'assets/images/ic_booking.png',
                    height: 18,
                    color: index == 1 ? AppColor.appColor : AppColor.blackColor,
                  ),
                  text: 'Bookings',
                ),
                Tab(
                  iconMargin: const EdgeInsets.all(7),
                  icon: Image.asset(
                    'assets/images/ic_message.png',
                    height: 18,
                    color: index == 2 ? AppColor.appColor : AppColor.blackColor,
                  ),
                  text: 'Messages',
                ),
                Tab(
                  iconMargin: const EdgeInsets.all(7),
                  icon: Image.asset(
                    'assets/images/ic_profile.png',
                    height: 18,
                    color: index == 3 ? AppColor.appColor : AppColor.blackColor,
                  ),
                  text: 'Account',
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Future getNotificationStatusChange(BuildContext ctx) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (!(connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi)) {
      throw new Exception('NO INTERNET CONNECTION');
    }
    var response = await http.get(
        Uri.parse(
            GlobalVariable.baseUrl + GlobalVariable.getNotificationStatus),
        headers: await CommonFunctions().getHeader());

    print(response.body);
    try {
      Map<String, dynamic> res = json.decode(response.body);
      if (res['code'] == 401) {
        String error = res['msg'];
        Get.toNamed(Routes.logInScreen);
        throw new Exception(error);
      }
      if (res['code'] != 200 || json == null) {
        String error = res['msg'];
        // Fluttertoast.showToast(msg: error, toastLength: Toast.LENGTH_SHORT);
        // Navigator.pop(ctx);
        print("scasd  " + error);
        throw new Exception(error);
      }

      SharedPref().setNotification(res['body']['notificationStatus'] == 1);
      // return ApiSignUpDataModel.fromJson(json.decode(response.body));
    } catch (error) {
      Fluttertoast.showToast(
          msg: error.toString().substring(
              error.toString().indexOf(':') + 1, error.toString().length),
          toastLength: Toast.LENGTH_SHORT);
      throw error.toString();
    }
  }
}
