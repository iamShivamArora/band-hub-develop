import 'dart:convert';
import 'dart:io';

import 'package:band_hub/routes/Routes.dart';
import 'package:band_hub/widgets/app_color.dart';
import 'package:band_hub/widgets/app_text.dart';
import 'package:band_hub/widgets/country_picker/flutter_country_picker.dart';
import 'package:band_hub/widgets/custom_phone_text_field.dart';
import 'package:band_hub/widgets/custom_text_field.dart';
import 'package:band_hub/widgets/elevated_btn.dart';
import 'package:band_hub/widgets/elevated_stroke_btn.dart';
import 'package:band_hub/widgets/helper_widget.dart';
import 'package:band_hub/widgets/image_picker.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../util/common_funcations.dart';
import '../../util/global_variable.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isSelectUser = true;
  bool passwordView = true;
  bool confirmPasswordView = true;
  String countryCode = "+1";
  Country? selectedCountryData;

  bool acceptTerms = false;

  File? imageFile;

  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerAbout = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  TextEditingController controllerConfirmPassword = TextEditingController();
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerNumber = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.whiteColor,
        appBar: HelperWidget.noAppBar(),
        body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () =>
                  FocusScope.of(context).requestFocus(FocusScopeNode()),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 25,
                    ),
                    AppText(
                      text: "Sign Up",
                      textSize: 32,
                      fontWeight: FontWeight.w600,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    AppText(
                      text: "Enter your details below & complete sign up",
                      textSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: 140,
                        height: 150,
                        child: InkWell(
                          onTap: () {
                            showImagePicker();
                          },
                          child: Stack(children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Container(
                                  width: 140,
                                  height: 140,
                                  decoration: BoxDecoration(
                                      color: AppColor.grayColor.withAlpha(70),
                                      borderRadius: BorderRadius.circular(100)),
                                  child: imageFile != null
                                      ? Image.file(
                                          imageFile!,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.asset(
                                          'assets/images/ic_user.png')),
                            ),
                            Positioned.fill(
                                child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Image.asset(
                                      'assets/images/ic_camera_red.png',
                                      height: 35,
                                      width: 35,
                                    )))
                          ]),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                            child: isSelectUser
                                ? ElevatedBtn(
                                    text: 'User',
                                    onTap: (() {
                                      isSelectUser = true;
                                      setState(() {});
                                    }),
                                  )
                                : ElevatedStrokeBtn(
                                    onTap: (() {
                                      isSelectUser = true;
                                      setState(() {});
                                    }),
                                    text: "User",
                                  )),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                            child: isSelectUser
                                ? ElevatedStrokeBtn(
                                    onTap: (() {
                                      isSelectUser = false;
                                      setState(() {});
                                    }),
                                    text: "Manager",
                                  )
                                : ElevatedBtn(
                                    text: 'Manager',
                                    onTap: (() {
                                      isSelectUser = false;
                                    }),
                                  )),
                        const SizedBox(
                          width: 15,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SimpleTf(
                      controller: controllerName,
                      title: "Full Name",
                      maxLength: 25,
                      action: TextInputAction.next,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SimplePhoneTf(
                      controller: controllerNumber,
                      action: TextInputAction.next,
                      title: 'Phone Number',
                      hint: 'Phone Number',
                      onChanged: (_) {
                        countryCode = "+" + _.dialingCode;
                        selectedCountryData = _;
                        setState(() {});
                      },
                      selectedCountry: selectedCountryData != null
                          ? selectedCountryData!
                          : Country.US,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SimpleTf(
                      controller: controllerEmail,
                      action: TextInputAction.next,
                      title: "Email",
                      inputType: TextInputType.emailAddress,
                    ),
                    SizedBox(
                      height: isSelectUser ? 0 : 20,
                    ),
                    Visibility(
                      visible: !isSelectUser,
                      child: SimpleTf(
                        controller: controllerAbout,
                        title: "About",
                        height: 100,
                        lines: 4,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SimpleTf(
                      controller: controllerPassword,
                      password: passwordView,
                      action: TextInputAction.next,
                      title: "Password",
                      suffix: passwordView
                          ? 'assets/images/ic_p_view.png'
                          : 'assets/images/ic_p_hide.png',
                      onSuffixTap: () {
                        passwordView = !passwordView;
                        setState(() {});
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SimpleTf(
                      controller: controllerConfirmPassword,
                      password: confirmPasswordView,
                      action: TextInputAction.done,
                      title: "Confirm Password",
                      suffix: confirmPasswordView
                          ? 'assets/images/ic_p_view.png'
                          : 'assets/images/ic_p_hide.png',
                      onSuffixTap: () {
                        confirmPasswordView = !confirmPasswordView;
                        setState(() {});
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {
                        acceptTerms = !acceptTerms;
                        setState(() {});
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 15,
                            width: 15,
                            margin: const EdgeInsets.only(top: 2),
                            child: Stack(
                              children: [
                                Image.asset(
                                  'assets/images/ic_check_box.png',
                                  height: 16,
                                  width: 16,
                                ),
                                Visibility(
                                  visible: acceptTerms,
                                  child: Positioned.fill(
                                      child: Align(
                                          alignment: Alignment.center,
                                          child: Image.asset(
                                            'assets/images/ic_tick.png',
                                            height: 10,
                                            width: 10,
                                          ))),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                              child: RichText(
                            text: TextSpan(
                                text:
                                    'By creating an account you agree with our ',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: AppColor.blackColor,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Poppins'),
                                children: [
                                  TextSpan(
                                    text: 'terms & conditions.',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: AppColor.blackColor,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Poppins'),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => Get.toNamed(
                                              Routes.privacyTermsAboutScreen,
                                              arguments: {
                                                "isFrom": "Terms and Conditions"
                                              }),
                                  )
                                ]),
                          )

                              //  AppText(
                              //   text:
                              //       "",
                              //   textSize: 13,
                              //   fontWeight: FontWeight.w400,
                              // ),
                              ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedBtn(
                      text: 'Create Account',
                      onTap: (() {
                        if (validation().isEmpty) {
                          getOtpApi(context);

                          // if (!isSelectUser) {
                          //
                          //   signUp(context, body);
                          // } else {
                          //   Get.toNamed(Routes.setupProfileScreen, arguments: {
                          //     'bodySignup': body,
                          //     'signUpImage': imageFile!.path
                          //   });
                          // }
                        } else {
                          Fluttertoast.showToast(msg: validation());
                        }
                        // Get.toNamed(Routes.setupProfileScreen, arguments: {
                        //   'bodySignup': {"full_name": "sd"},
                        //   'signUpImage':imageFile!.path
                        // });
                      }),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppText(
                          text: "Already have an account? ",
                          textSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                        InkWell(
                          onTap: (() {
                            Get.offAllNamed(Routes.logInScreen);
                          }),
                          child: AppText(
                            text: "Log in",
                            textSize: 12,
                            fontWeight: FontWeight.w600,
                            textColor: AppColor.appColor,
                            underline: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                  ]),
            )));
  }

  Future getOtpApi(BuildContext ctx) async {
    Map<dynamic, dynamic> body = {
      'email': controllerEmail.text.trim().toString(),
      'phone_number': controllerNumber.text.trim().toString(),
      'countryCode': countryCode,
    };
    print(body);

    EasyLoading.show(status: 'Loading');
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (!(connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi)) {
      throw new Exception('NO INTERNET CONNECTION');
    }
    var response = await http.post(
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
      Fluttertoast.showToast(msg: res['msg'], toastLength: Toast.LENGTH_SHORT);
      Map<String, String> signUpBody = {
        "full_name": controllerName.text.trim().toString(),
        "email": controllerEmail.text.trim().toString(),
        "password": controllerPassword.text.trim().toString(),
        "phone": controllerNumber.text.trim().toString(),
        "countryCode": countryCode,
        "type": isSelectUser ? "1" : "2",
        "device_type": "1",
        "device_token": "saa",
      };
      if (!isSelectUser) {
        signUpBody['description'] = controllerAbout.text.trim().toString();
      }
      Get.toNamed(Routes.verificationScreen, arguments: {
        "isFromLogin": false,
        "signupData": signUpBody,
        "userType": isSelectUser,
        "profileImage": imageFile!.path,
      });
    } catch (error) {
      EasyLoading.dismiss();

      Fluttertoast.showToast(
          msg: error.toString().substring(
              error.toString().indexOf(':') + 1, error.toString().length),
          toastLength: Toast.LENGTH_SHORT);
      throw error.toString();
    }
  }

  void showImagePicker() {
    showDialog(
      context: Get.context!,
      builder: (_) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        insetPadding: EdgeInsets.zero,
        content: Container(
          margin: const EdgeInsets.symmetric(vertical: 20),
          width: MediaQuery.of(context).size.width / 1.3,
          height: 200,
          decoration: BoxDecoration(
              color: AppColor.whiteColor,
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              AppText(
                text: 'Select Image',
                textColor: AppColor.blackColor,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(
                height: 40,
              ),
              InkWell(
                onTap: () async {
                  Get.back();
                  String? selectedImage = await ImagePickerUtility()
                      .pickImageFromCamera(isCropping: true);
                  imageFile = File(selectedImage!);
                  setState(() {});
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera_alt,
                      color: AppColor.blackColor,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    AppText(
                      text: 'Select image from camera',
                      textSize: 12,
                      textColor: AppColor.blackColor,
                    ),
                  ],
                ),
              ),
              Container(
                height: 1,
                margin: const EdgeInsets.symmetric(vertical: 15),
                width: 200,
                color: AppColor.grayColor.withOpacity(.40),
              ),
              InkWell(
                onTap: () async {
                  Get.back();
                  String? selectedImage = await ImagePickerUtility()
                      .pickImageFromGallery(isCropping: true);
                  imageFile = File(selectedImage!);
                  setState(() {});
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.photo,
                      color: AppColor.blackColor,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    AppText(
                      text: 'Select image from gallery',
                      textSize: 12,
                      textColor: AppColor.blackColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String validation() {
    FocusScope.of(context).requestFocus(FocusScopeNode());
    if (imageFile == null) {
      return "Please select profile image";
    } else if (controllerName.text.trim().isEmpty) {
      return "Please enter name";
    } else if (controllerNumber.text.trim().isEmpty) {
      return "Please enter number";
    } else if (controllerNumber.text.trim().length < 10) {
      return "Please enter at least 10 digits in phone number";
    } else if (controllerEmail.text.trim().isEmpty) {
      return "Please enter email";
    } else if (!CommonFunctions()
        .isEmailValid(controllerEmail.text.trim().toString())) {
      return "Please enter valid email";
    } else if (!isSelectUser && controllerAbout.text.trim().isEmpty) {
      return "Please enter about";
    } else if (controllerPassword.text.trim().isEmpty) {
      return "Please enter password";
    } else if (controllerPassword.text.length < 6) {
      return "Please enter at least 6 characters in password";
    } else if (controllerConfirmPassword.text.toString().trim().isEmpty) {
      return "Please confirm your password";
    } else if (controllerPassword.text != controllerConfirmPassword.text) {
      return "Password and confirm password must match";
    } else if (!acceptTerms) {
      return "Please accept terms and conditions";
    } else {
      /*if (!isSelectUser) {
        if (controllerAbout.text.trim().isEmpty) {
          return "Please enter about";
        }
      }*/
      return "";
    }
  }
}
