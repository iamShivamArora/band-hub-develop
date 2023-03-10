import 'dart:convert';
import 'dart:io';

import 'package:band_hub/models/auth/login_response_model.dart';
import 'package:band_hub/routes/Routes.dart';
import 'package:band_hub/util/common_funcations.dart';
import 'package:band_hub/util/global_variable.dart';
import 'package:band_hub/util/sharedPref.dart';
import 'package:band_hub/widgets/app_color.dart';
import 'package:band_hub/widgets/app_text.dart';
import 'package:band_hub/widgets/custom_text_field.dart';
import 'package:band_hub/widgets/elevated_btn.dart';
import 'package:band_hub/widgets/elevated_stroke_btn.dart';
import 'package:band_hub/widgets/helper_widget.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../network/GoogleSignInProvider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool passwordView = true;
  bool rememberMe = false;
  FacebookLogin facebookLogin = FacebookLogin();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();

  getIsRemember() async {
    try {
      bool? isRememberValue = await SharedPref().getIsRemember();
      var email = '';
      var password = '';

      if (isRememberValue!) {
        var data = await SharedPref().getStoreRememberData();
        var simpleData = jsonDecode(data!);
        email = simpleData["email"];
        password = simpleData["password"];
      }
      setState(() {
        controllerEmail.text = email;
        controllerPassword.text = password;
        rememberMe = isRememberValue;
      });
    } catch (e) {
      print("remember check : " + e.toString());
    }
  }

  @override
  void initState() {
    getIsRemember();
    SharedPref().setToken("");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HelperWidget.noAppBar(),
      backgroundColor: AppColor.whiteColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusScope.of(context).requestFocus(FocusScopeNode()),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(
              height: 5,
            ),
            AppText(
              text: "Log In",
              textSize: 32,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(
              height: 25,
            ),
            AppText(
              text: "Welcome!",
              textSize: 14,
              fontWeight: FontWeight.w400,
            ),
            const SizedBox(
              height: 25,
            ),
            SimpleTf(
              controller: controllerEmail,
              title: "Email",
              inputType: TextInputType.emailAddress,
              action: TextInputAction.next,
            ),
            const SizedBox(
              height: 20,
            ),
            SimpleTf(
              controller: controllerPassword,
              password: passwordView,
              title: "Password",
              action: TextInputAction.done,
              suffix: passwordView
                  ? 'assets/images/ic_p_view.png'
                  : 'assets/images/ic_p_hide.png',
              onSuffixTap: () {
                if (!EasyLoading.isShow) {
                  passwordView = !passwordView;
                  setState(() {});
                }
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    rememberMe = !rememberMe;
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      SizedBox(
                        height: 16,
                        width: 16,
                        child: Stack(
                          children: [
                            Image.asset(
                              'assets/images/ic_check_box.png',
                              height: 16,
                              width: 16,
                            ),
                            Visibility(
                              visible: rememberMe,
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
                      AppText(
                        text: "Remember Me",
                        textSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () {
                    if (!EasyLoading.isShow) {
                      Get.toNamed(Routes.forgotPasswordScreen);
                    }
                  },
                  child: AppText(
                    text: "Forgot password?",
                    textSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedBtn(
              onTap: (() async {
                if (!EasyLoading.isShow) {
                  if (validation().isEmpty) {
                    await callApi(context);
                  } else {
                    Fluttertoast.showToast(msg: validation());
                  }
                }
              }),
              text: 'Log In',
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedStrokeBtn(
              text: 'Continue with Phone',
              onTap: (() {
                if (!EasyLoading.isShow) {
                  Get.toNamed(Routes.continueWithPhoneScreen);
                }
              }),
            ),
            const SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppText(
                  text: "Don???t have an account? ",
                  textSize: 12,
                  fontWeight: FontWeight.w400,
                ),
                InkWell(
                  onTap: (() {
                    if (!EasyLoading.isShow) {
                      Get.toNamed(Routes.signUpScreen);
                    }
                  }),
                  child: AppText(
                    text: "Sign up",
                    textSize: 12,
                    fontWeight: FontWeight.w400,
                    textColor: AppColor.appColor,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            Row(
              children: [
                Expanded(
                    child: Divider(
                  height: 10,
                  color: AppColor.grayColor.withOpacity(.30),
                  thickness: 1.2,
                )),
                const SizedBox(
                  width: 20,
                ),
                AppText(
                  text: "Or login with",
                  textSize: 12,
                  fontWeight: FontWeight.w400,
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                    child: Divider(
                  height: 10,
                  color: AppColor.grayColor.withOpacity(.30),
                  thickness: 1.2,
                )),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    googleClick();
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    padding: const EdgeInsets.all(12),
                    child: Image.asset('assets/images/ic_google.png'),
                    decoration: BoxDecoration(
                        color: AppColor.whiteColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: AppColor.grayColor.withAlpha(70),
                            blurRadius: 10.0,
                            offset: const Offset(2, 2),
                          ),
                        ]),
                  ),
                ),
                const SizedBox(
                  width: 25,
                ),
                InkWell(
                  onTap: () {
                    //facebook
                    fbClick();
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    padding: const EdgeInsets.all(12),
                    child: Image.asset('assets/images/ic_fb.png'),
                    decoration: BoxDecoration(
                        color: AppColor.whiteColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: AppColor.grayColor.withAlpha(70),
                            blurRadius: 10.0,
                            offset: const Offset(2, 2),
                          ),
                        ]),
                  ),
                ),
                Visibility(
                  visible: Platform.isIOS,
                  child: const SizedBox(
                    width: 25,
                  ),
                ),
                Visibility(
                  visible: Platform.isIOS,
                  child: InkWell(
                    onTap: () {
                      appleClick();
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      padding: const EdgeInsets.all(12),
                      child: Image.asset('assets/images/ic_apple.png'),
                      decoration: BoxDecoration(
                          color: AppColor.whiteColor,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: AppColor.grayColor.withAlpha(70),
                              blurRadius: 10.0,
                              offset: const Offset(2, 2),
                            ),
                          ]),
                    ),
                  ),
                ),
              ],
            )
          ]),
        ),
      ),
    );
  }

  Future callApi(BuildContext ctx) async {
    Map<dynamic, dynamic> body = {
      'password': controllerPassword.text.trim().toString(),
      'email': controllerEmail.text.trim().toString(),
      'device_type': Platform.isAndroid ? '1' : '2',
      // 'device_token': '',
      'type': "1"
    };
    print(body);

    EasyLoading.show(status: 'Loading');
    var connectivityResult = await (Connectivity().checkConnectivity());
    // if (loader != null) {
    //   loader.changeIsShowToast(
    //       !response.request!.url.path.contains(GlobalVariable.logout));
    // }

    if (!(connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi)) {
      throw new Exception('NO INTERNET CONNECTION');
    }
    var response = await http.put(
        Uri.parse(GlobalVariable.baseUrl + GlobalVariable.login),
        headers: await CommonFunctions().getHeader(),
        body: body);

    // if (response.statusCode == 201) {}
    print(response.body);

    try {
      Map<String, dynamic> res = json.decode(response.body);
      print(res);

      if (res['code'] != 200 || res == null) {
        String error = res['msg'];
        // Fluttertoast.showToast(msg: error, toastLength: Toast.LENGTH_SHORT);
        // Navigator.pop(ctx);
        print("scasd  " + error);
        throw new Exception(error);
      }
      LoginResponseModel result = LoginResponseModel.fromJson(res);
      EasyLoading.dismiss();
      Fluttertoast.showToast(msg: result.msg, toastLength: Toast.LENGTH_SHORT);
      sucussCall(result);

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

  void sucussCall(LoginResponseModel result) async {
    SharedPref().setToken(result.body.authKey);
    SharedPref().setIsRemember(rememberMe);
    if (rememberMe) {
      Map<String, String> data = {
        'email': controllerEmail.text,
        'password': controllerPassword.text
      };
      await SharedPref().storeRememberData(jsonEncode(data));
    }
    // SharedPref().setNotification(result.body.notificationStatus == 1);
    SharedPref().setPreferenceJson(jsonEncode(result));
    if (result.body.type == 1) {
      if (result.body.location.isEmpty) {
        Get.toNamed(Routes.setupProfileScreen, arguments: {
          "userName": result.body.fullName,
        });
      } else {
        Get.offAllNamed(Routes.userMainScreen);
      }
    } else {
      Get.offAllNamed(Routes.managerHomeScreen);
    }
  }

  String validation() {
    FocusScope.of(context).requestFocus(FocusScopeNode());

    if (controllerEmail.text.trim().isEmpty) {
      return "Please enter email";
    } else if (!CommonFunctions()
        .isEmailValid(controllerEmail.text.trim().toString())) {
      return "Please enter valid email";
    } else if (controllerPassword.text.trim().isEmpty) {
      return "Please enter password";
    } else {
      return "";
    }
  }

  googleClick() async {
    GoogleSignInProvider googleSign = GoogleSignInProvider();
    await googleSign.googleLogin();
    // String? token = await FirebaseMessaging.instance.getToken();
    // print('FCM ----  ' + token!);
    // Fluttertoast.showToast(msg: googleSign.user.id);
    print(googleSign.user.displayName);
    if (googleSign.user != null) {
      Map<dynamic, dynamic> body = {
        'social_id': googleSign.user.id,
        'social_type': '1',
        'email': googleSign.user.email,
        'name': googleSign.user.displayName,
        // 'image': googleSign.user.photoUrl,
        'device_token': "",
        if (Platform.isAndroid) 'device_type': '1' else 'device_type': '2',
      };
      // welcomeViewModel.socialLoginApi(context, loader, body);
    } else {
      Fluttertoast.showToast(msg: "Error occur");
    }
  }

  fbClick() async {
    final result = await facebookLogin.logIn(permissions: [
      FacebookPermission.email,
      FacebookPermission.publicProfile
    ]);

    if (result.status == FacebookLoginStatus.success) {
      print(result.accessToken!.token);
      final token = result.accessToken!.token;
      final graphResponse = await http.get(Uri.parse(
          'https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=${token}'));
      final profile = jsonDecode(graphResponse.body);
      print(profile);
      print(profile["picture"]["data"]["url"]);
      print(profile["name"]);
      print(profile["email"]);

      // String? fcm = await FirebaseMessaging.instance.getToken();
      // print('FCM ----  ' + fcm!);
      //print(profile["picture"]["data"]["url"]);   // profileImage
      Map<dynamic, dynamic> body = {
        'social_id': profile["id"],
        'social_type': '1',
        'email': profile["email"],
        'name': profile["name"],
        // 'image': profile["picture"]["data"]["url"],
        'device_token': "",
        if (Platform.isAndroid) 'device_type': '1' else 'device_type': '2',
      };
      facebookLogin.logOut();
      // welcomeViewModel.socialLoginApi(context, loader, body);
    } else if (result.status == FacebookLoginStatus.error) {
      print(result.error);
    } else {
      print(result.error);
    }
  }

  appleClick() async {
    final credentials = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    var name = credentials.givenName == null ? "" : credentials.givenName;
    var email = credentials.email == null ? "Apple Login" : credentials.email;
    var social_id = credentials.userIdentifier;
    print(credentials);

    // String? fcm = await FirebaseMessaging.instance.getToken();
    // print('FCM ----  ' + fcm!);

    Map<dynamic, dynamic> body = {
      'social_id': social_id,
      'social_type': '3',
      'email': email,
      'name': name,
      'device_token': "",
      if (Platform.isAndroid) 'device_type': '1' else 'device_type': '2',
    };
    // welcomeViewModel.socialLoginApi(context, loader, body);
  }
}
