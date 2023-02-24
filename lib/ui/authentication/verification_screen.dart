import 'dart:convert';

import 'package:band_hub/util/common_funcations.dart';
import 'package:band_hub/util/global_variable.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../models/auth/login_response_model.dart';
import '../../routes/Routes.dart';
import '../../util/sharedPref.dart';
import '../../widgets/app_color.dart';
import '../../widgets/app_text.dart';
import '../../widgets/elevated_btn.dart';
import '../../widgets/helper_widget.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({Key? key}) : super(key: key);

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final controllerNumber = TextEditingController();
  final controllerEmail = TextEditingController();
  var otpLength = 4;
  bool isFromLogin = false;
  bool isFromUser = false;
  String number = "";
  String countryCode = "";
  String email = "";
  String authKey = "";
  String profileImage = "";
  String loginResult = "";
  Map<String, String> SignUpData = Map<String, String>();

  @override
  void initState() {
    isFromLogin = Get.arguments['isFromLogin'] ?? false;
    if (isFromLogin) {
      number = Get.arguments['number'] ?? "";
      countryCode = Get.arguments['countryCode'] ?? "";
      authKey = Get.arguments['authKey'] ?? "";
      loginResult = Get.arguments['loginResult'] ?? "";
    } else {
      isFromUser = Get.arguments['userType'] ?? false;
      SignUpData = Get.arguments['signupData'];
      profileImage = Get.arguments['profileImage'] ?? "";
      countryCode = SignUpData['countryCode']!;
      number = SignUpData['phone']!;
      email = SignUpData['email']!;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: HelperWidget.customAppBar(title: "Verification"),
        backgroundColor: AppColor.whiteColor,
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () =>
                    FocusScope.of(context).requestFocus(FocusScopeNode()),
                child: Column(children: [
                  SizedBox(
                    height: isFromLogin ? 120 : 20,
                  ),
                  AppText(
                    text: 'Code is sent to ' + countryCode + " " + number,
                    textSize: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 40),
                    child: PinCodeTextField(
                      controller: controllerNumber,
                      appContext: context,
                      onChanged: (value) {},
                      length: otpLength,
                      animationType: AnimationType.fade,
                      keyboardType: TextInputType.number,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(10),
                        fieldHeight: 42,
                        fieldWidth: 42,
                        borderWidth: 1,
                        activeFillColor: AppColor.appColor,
                        activeColor: AppColor.appColor,
                        inactiveFillColor: AppColor.appColor,
                        inactiveColor: AppColor.blackColor,
                        selectedColor: AppColor.appColor,
                      ),
                      animationDuration: Duration(milliseconds: 300),
                      onCompleted:
                          (String verificationCode) async {}, // end onSubmit
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  !isFromLogin
                      ? AppText(
                    text: 'Code is sent to $email',
                    textSize: 16,
                  )
                      : Container(),
                  !isFromLogin
                      ? Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 40),
                    child: PinCodeTextField(
                      controller: controllerEmail,
                            appContext: context,
                            onChanged: (value) {},
                            length: otpLength,
                            animationType: AnimationType.fade,
                            keyboardType: TextInputType.number,
                            pinTheme: PinTheme(
                              shape: PinCodeFieldShape.box,
                              borderRadius: BorderRadius.circular(10),
                              fieldHeight: 42,
                              fieldWidth: 42,
                              borderWidth: 1,
                              activeFillColor: AppColor.appColor,
                              activeColor: AppColor.appColor,
                              inactiveFillColor: AppColor.appColor,
                        inactiveColor: AppColor.blackColor,
                        selectedColor: AppColor.appColor,
                      ),
                      animationDuration: Duration(milliseconds: 300),
                      onCompleted: (String
                      verificationCode) async {}, // end onSubmit
                    ),
                  )
                      : Container(),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppText(
                        text: 'Didn’t receive code? ',
                        textSize: 12,
                      ),
                      GestureDetector(
                        onTap: () {
                          getOtpApi(context);
                        },
                        child: AppText(
                          text: 'Request again',
                          textSize: 12,
                          textColor: AppColor.appColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedBtn(
                    text: isFromLogin ? 'Verify' : 'Verify and Create Account',
                    onTap: () {
                      // if (isFromLogin) {
                      //   Get.offAllNamed(Routes.userMainScreen);
                      // } else if (isFromUser) {
                      //   Get.toNamed(Routes.setupProfileScreen);
                      // } else {
                      //   Get.offAllNamed(Routes.managerHomeScreen);
                      // }
                      if (validation().isEmpty) {
                        validateOtpApi(context);
                      } else {
                        Fluttertoast.showToast(
                            msg: validation(), toastLength: Toast.LENGTH_SHORT);
                      }
                    },
                  ),
                ]))));
  }

  Future signUp(BuildContext ctx) async {
    EasyLoading.show(status: 'Loading');
    print(SignUpData.toString());
    var request = new http.MultipartRequest(
        "POST", Uri.parse(GlobalVariable.baseUrl + GlobalVariable.signup));
    request.headers.addAll(await CommonFunctions().getHeader());
    request.fields.addAll(SignUpData);
    http.MultipartFile multipartFile =
        await http.MultipartFile.fromPath('profile_image', profileImage);

    request.files.add(multipartFile);
    var time = 0;
    try {
      var response = await request.send();

      var result = await response.stream.bytesToString();

      var res = LoginResponseModel.fromJson(json.decode(result));
      if (res.code == 200) {
        // Navigator.pop(ctx);
        EasyLoading.dismiss();
        if (time == 0) {
          if (isFromUser) {
            SharedPref().setToken(res.body.authKey);
            Get.back();
            Get.back();
            Get.toNamed(Routes.setupProfileScreen, arguments: {
              "userName": res.body.fullName,
            });
          } else {
            showSuccessDialog(res, res.body.authKey);
          }

          time = time + 1;
          print("sucasdsadsadasdasdascccccc");
        } else {
          print("sucasdsadsadasdasdascccccc ++++  1111");
        }

        return;
      } else {
        EasyLoading.dismiss();
        // Navigator.pop(ctx);
        throw new Exception(res.msg);
      }
    } catch (error) {
      EasyLoading.dismiss();
      Fluttertoast.showToast(
          msg: error.toString().substring(
              error.toString().indexOf(':') + 1, error
              .toString()
              .length),
          toastLength: Toast.LENGTH_SHORT);
      print(error);
    }
  }

  showSuccessDialog(LoginResponseModel result, String authKey) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              child: Container(
                width: MediaQuery.of(context).size
                    .width,
                padding:
                const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                decoration: BoxDecoration(
                    color: AppColor.whiteColor,
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle_rounded,
                        color: AppColor.greenColor, size: 80),
                    const SizedBox(
                      height: 20,
                    ),
                    AppText(
                        text: "Success",
                        textColor: AppColor.blackColor,
                        textAlign: TextAlign.center,
                        textSize: 16,
                        fontWeight: FontWeight.w500),
                    const SizedBox(
                      height: 10,
                    ),
                    AppText(
                        text:
                        "Congratulations, you have\ncompleted your registration!",
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
                            child: ElevatedBtn(
                              text: 'Done',
                              buttonColor: AppColor.appColor,
                              textColor: AppColor.whiteColor,
                              onTap: () {
                                // Get.back();
                                print(authKey);
                            SharedPref().setToken(authKey);
                            SharedPref().setPreferenceJson(jsonEncode(result));
                            Get.offAllNamed(Routes.managerHomeScreen);
                          },
                            )),
                      ],
                    )
                  ],
                ),
              ),
            ));
  }

  Future getOtpApi(BuildContext ctx) async {
    Map<dynamic, dynamic> body = isFromLogin
        ? {
      'type': "2",
      'phone': number,
      'countryCode': countryCode,
    }
        : {
      'email': email,
      'phone_number': number,
      'countryCode': countryCode,
    };
    print(body);

    EasyLoading.show(status: 'Loading');
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (!(connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi)) {
      throw new Exception('NO INTERNET CONNECTION');
    }
    var response = isFromLogin
        ? await http.put(
        Uri.parse(GlobalVariable.baseUrl + GlobalVariable.login),
        headers: await CommonFunctions().getHeader(),
        body: body)
        : await http.post(
        Uri.parse(GlobalVariable.baseUrl + GlobalVariable.sentOtp),
        headers: await CommonFunctions().getHeader(),
        body: body);

    print(response.body);
    // SuccessResponse? result = null;
    try {
      Map<String, dynamic> res = json.decode(response.body);
      // result = SuccessResponse.fromJson(res);
      if (res['code'] != 200 || json == null) {
        String error = res['msg'];
        print("scasd  " + error);
        throw new Exception(error);
      }

      EasyLoading.dismiss();
      Fluttertoast.showToast(msg: 'OTP send', toastLength: Toast.LENGTH_SHORT);
    } catch (error) {
      EasyLoading.dismiss();

      Fluttertoast.showToast(
          msg: error.toString().substring(
              error.toString().indexOf(':') + 1, error
              .toString()
              .length),
          toastLength: Toast.LENGTH_SHORT);
      throw error.toString();
    }
  }

  Future validateOtpApi(BuildContext ctx) async {
    Map<dynamic, dynamic> body = {
      'otp': controllerNumber.text.toString(),
      'emailOtp': controllerEmail.text.toString(),
    };
    print(body);

    EasyLoading.show(status: 'Loading');
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (!(connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi)) {
      throw new Exception('NO INTERNET CONNECTION');
    }
    var response = await http.post(
        Uri.parse(GlobalVariable.baseUrl + GlobalVariable.verifyOtp),
        headers: await CommonFunctions().getHeader(),
        body: body);

    print(response.body);
    // SuccessResponse? result = null;
    try {
      Map<String, dynamic> res = json.decode(response.body);

      // result = SuccessResponse.fromJson(res);
      if (res['code'] != 200 || json == null) {
        String error = res['msg'];
        print("scasd  " + error);
        throw new Exception(error);
      }

      EasyLoading.dismiss();
      Fluttertoast.showToast(msg: res['msg'], toastLength: Toast.LENGTH_SHORT);

      if (isFromLogin) {
        SharedPref().setToken(authKey);
        SharedPref().setPreferenceJson(loginResult);
        LoginResponseModel loginData =
        LoginResponseModel.fromJson(jsonDecode(loginResult));
        if (loginData.body.type == 1) {
          if (loginData.body.location.isEmpty) {
            Get.offAllNamed(Routes.setupProfileScreen, arguments: {
            "userName":loginData.body.fullName,
            });
          } else {
            Get.offAllNamed(Routes.userMainScreen);
          }
        } else {
          Get.offAllNamed(Routes.managerHomeScreen);
        }
      } else {
        signUp(ctx);
      }
    } catch (error) {
      EasyLoading.dismiss();

      Fluttertoast.showToast(
          msg: error.toString().substring(
              error.toString().indexOf(':') + 1, error
              .toString()
              .length),
          toastLength: Toast.LENGTH_SHORT);
      throw error.toString();
    }
  }

  String validation() {
    if (isFromLogin) {
      if (controllerNumber.text.isEmpty) {
        return "Please enter OTP";
      } else if (controllerNumber.text.length != otpLength) {
        return "Please enter valid OTP";
      } else {
        return "";
      }
    } else if (isFromUser) {
      if (controllerNumber.text.isEmpty) {
        return "Please enter phone number OTP";
      } else if (controllerNumber.text.length != otpLength) {
        return "Please enter valid phone number OTP";
      } else if (controllerEmail.text.isEmpty) {
        return "Please enter email OTP";
      } else if (controllerEmail.text.length != otpLength) {
        return "Please enter valid email OTP";
      } else {
        return "";
      }
    } else {
      if (controllerNumber.text.isEmpty) {
        return "Please enter OTP";
      } else if (controllerNumber.text.length != otpLength) {
        return "Please enter valid OTP";
      } else {
        return "";
      }
    }
  }
}
