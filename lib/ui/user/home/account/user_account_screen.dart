import 'dart:convert';

import 'package:band_hub/routes/Routes.dart';
import 'package:band_hub/util/sharedPref.dart';
import 'package:band_hub/widgets/app_color.dart';
import 'package:band_hub/widgets/app_text.dart';
import 'package:band_hub/widgets/elevated_btn.dart';
import 'package:band_hub/widgets/elevated_stroke_btn.dart';
import 'package:band_hub/widgets/helper_widget.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../util/common_funcations.dart';
import '../../../../util/global_variable.dart';

class UserAccountScreen extends StatefulWidget {
  const UserAccountScreen({Key? key}) : super(key: key);

  @override
  State<UserAccountScreen> createState() => _UserAccountScreenState();
}

class _UserAccountScreenState extends State<UserAccountScreen> {
  bool _switchValue = true;

  getNotification() async {
    _switchValue = (await SharedPref().getNotification())!;
    setState(() {});
  }

  @override
  void initState() {
    getNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: HelperWidget.noAppBar(),
        body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Center(
                child: AppText(
                  text: "Account",
                  textSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  Get.toNamed(Routes.notificationScreen);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(7),
                        height: 32,
                        width: 32,
                        decoration: BoxDecoration(
                            color: const Color(0xff774FFF),
                            borderRadius: BorderRadius.circular(100)),
                        child: Image.asset(
                          'assets/images/ic_bell.png',
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: AppText(
                          text: "Notifications",
                          textSize: 15,
                        ),
                      ),
                      Transform.scale(
                        scale: 0.8,
                        child: CupertinoSwitch(
                          activeColor: AppColor.blackColor,
                          value: _switchValue,
                          onChanged: (value) {
                            setState(() {
                              if (!EasyLoading.isShow) {
                                notificationStatusChange(context, value);
                              }
                              // _switchValue = value;
                            });
                          },
                        ),
                      ),
                      // const SizedBox(
                      //   width: 5,
                      // ),
                      /* const Icon(
                        Icons.arrow_forward_ios,
                        size: 15,
                      )*/
                    ],
                  ),
                ),
              ),
              Divider(
                height: 10,
                color: AppColor.grayColor.withOpacity(.20),
                thickness: 1.2,
              ),
              InkWell(
                onTap: () {
                  if (!EasyLoading.isShow) {
                    Get.toNamed(Routes.changePasswordScreen);
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/ic_yellow_lock.png',
                        height: 32,
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: AppText(
                          text: "Change Password",
                          textSize: 15,
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 15,
                      )
                    ],
                  ),
                ),
              ),
              Divider(
                height: 10,
                color: AppColor.grayColor.withOpacity(.20),
                thickness: 1.2,
              ),
              InkWell(
                onTap: () {
                  if (!EasyLoading.isShow) {
                    Get.toNamed(Routes.privacyTermsAboutScreen,
                        arguments: {"isFrom": "Privacy Policy"});
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/ic_question_mark.png',
                        height: 32,
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: AppText(
                          text: "Privacy Policy",
                          textSize: 15,
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 15,
                      )
                    ],
                  ),
                ),
              ),
              Divider(
                height: 10,
                color: AppColor.grayColor.withOpacity(.20),
                thickness: 1.2,
              ),
              InkWell(
                onTap: () {
                  if (!EasyLoading.isShow) {
                    Get.toNamed(Routes.privacyTermsAboutScreen,
                        arguments: {"isFrom": "Terms and Conditions"});
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/ic_document_purple.png',
                        height: 32,
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: AppText(
                          text: "Terms and Conditions",
                          textSize: 15,
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 15,
                      )
                    ],
                  ),
                ),
              ),
              Divider(
                height: 10,
                color: AppColor.grayColor.withOpacity(.20),
                thickness: 1.2,
              ),
              InkWell(
                onTap: () {
                  if (!EasyLoading.isShow) {
                    Get.toNamed(Routes.privacyTermsAboutScreen,
                        arguments: {"isFrom": "About"});
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    children: [
                      Container(
                        height: 32,
                        width: 32,
                        decoration: BoxDecoration(
                            color: const Color(0xffDA7D79),
                            borderRadius: BorderRadius.circular(100)),
                        child: const Icon(
                          Icons.info,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: AppText(
                          text: "About",
                          textSize: 15,
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 15,
                      )
                    ],
                  ),
                ),
              ),
              Divider(
                height: 10,
                color: AppColor.grayColor.withOpacity(.20),
                thickness: 1.2,
              ),
              // InkWell(
              //   onTap: () {
              //     Get.toNamed(Routes.bookingScreen);
              //   },
              //   child: Container(
              //     width: MediaQuery.of(context).size.width,
              //     padding:
              //         const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              //     decoration:
              //         BoxDecoration(borderRadius: BorderRadius.circular(15)),
              //     child: Row(
              //       children: [
              //         Image.asset(
              //           'assets/images/ic_document_green.png',
              //           height: 32,
              //         ),
              //         const SizedBox(
              //           width: 15,
              //         ),
              //         Expanded(
              //           child: AppText(
              //             text: "Bookings",
              //             textSize: 15,
              //           ),
              //         ),
              //         const Icon(
              //           Icons.arrow_forward_ios,
              //           size: 15,
              //         )
              //       ],
              //     ),
              //   ),
              // ),
              // Divider(
              //   height: 10,
              //   color: AppColor.grayColor.withOpacity(.20),
              //   thickness: 1.2,
              // ),
              InkWell(
                onTap: () {
                  if (!EasyLoading.isShow) {
                    showLogoutDialog();
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/ic_logout.png',
                        height: 32,
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: AppText(
                          text: "Logout",
                          textSize: 15,
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 15,
                      )
                    ],
                  ),
                ),
              ),
              Divider(
                height: 10,
                color: AppColor.grayColor.withOpacity(.20),
                thickness: 1.2,
              ),
            ])));
  }

  showLogoutDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                decoration: BoxDecoration(
                    color: AppColor.whiteColor,
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/ic_logout.png',
                      height: 70,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    AppText(
                        text: "Logout",
                        textColor: AppColor.blackColor,
                        textAlign: TextAlign.center,
                        textSize: 16,
                        fontWeight: FontWeight.w500),
                    const SizedBox(
                      height: 10,
                    ),
                    AppText(
                        text: "Are you sure you want to logout?",
                        textColor: AppColor.blackColor,
                        textAlign: TextAlign.center,
                        textSize: 12,
                        fontWeight: FontWeight.w400),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: ElevatedStrokeBtn(
                          text: 'No',
                          onTap: () {
                            if (!EasyLoading.isShow) {
                              Get.back();
                            }
                          },
                        )),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: ElevatedBtn(
                          text: 'Yes',
                          buttonColor: AppColor.appColor,
                          textColor: AppColor.whiteColor,
                          onTap: () {
                            if (!EasyLoading.isShow) {
                              Get.back();
                              callApi(context);
                            }
                          },
                        )),
                      ],
                    )
                  ],
                ),
              ),
            ));
  }

  Future callApi(BuildContext ctx) async {
    EasyLoading.show(status: 'Loading');
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (!(connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi)) {
      throw new Exception('NO INTERNET CONNECTION');
    }
    var response = await http.put(
        Uri.parse(GlobalVariable.baseUrl + GlobalVariable.logout),
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
      logoutCall();
      EasyLoading.dismiss();

      // return ApiSignUpDataModel.fromJson(json.decode(response.body));
    } catch (error) {
      EasyLoading.dismiss();

      Fluttertoast.showToast(
          msg: error.toString().substring(
              error.toString().indexOf(':') + 1, error.toString().length),
          toastLength: Toast.LENGTH_SHORT);
      throw error.toString();
    }
  }

  void logoutCall() {
    SharedPref().setToken("");
    Get.offAllNamed(Routes.logInScreen);
  }

  Future notificationStatusChange(BuildContext ctx, bool value) async {
    Map<dynamic, dynamic> body = {'status': value ? '1' : '2'};
    print(body);
    EasyLoading.show(status: 'Loading');
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (!(connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi)) {
      throw new Exception('NO INTERNET CONNECTION');
    }
    var response = await http.put(
        Uri.parse(GlobalVariable.baseUrl + GlobalVariable.notificationsOnOff),
        headers: await CommonFunctions().getHeader(),
        body: body);

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
      EasyLoading.dismiss();
      _switchValue = !_switchValue;
      SharedPref().setNotification(_switchValue);
      Fluttertoast.showToast(msg: res['msg'], toastLength: Toast.LENGTH_SHORT);

      setState(() {});
      // return ApiSignUpDataModel.fromJson(json.decode(response.body));
    } catch (error) {
      EasyLoading.dismiss();

      Fluttertoast.showToast(
          msg: error.toString().substring(
              error.toString().indexOf(':') + 1, error.toString().length),
          toastLength: Toast.LENGTH_SHORT);
      throw error.toString();
    }
  }
}
