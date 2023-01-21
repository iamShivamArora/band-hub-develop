import 'dart:async';
import 'dart:convert';

import 'package:band_hub/routes/Routes.dart';
import 'package:band_hub/util/sharedPref.dart';
import 'package:band_hub/widgets/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/auth/login_response_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    callNextScreen();
    super.initState();
  }

  callNextScreen() async {
    var token = await getToken();
    var d = await SharedPref().getPreferenceJson();
    LoginResponseModel result = LoginResponseModel.fromJson(jsonDecode(d));
    print(token);
    Timer(const Duration(seconds: 2), () {
      if (token.isEmpty) {
        Get.offAllNamed(Routes.introScreen);
      } else {
        if (result.body.type == 1) {
          if (result.body.location.isEmpty) {
            Get.offAllNamed(Routes.setupProfileScreen, arguments: {
              "userName": result.body.fullName,
            });
          } else {
            Get.offAllNamed(Routes.userMainScreen);
          }
        } else {
          Get.offAllNamed(Routes.managerHomeScreen);
        }
      }
    });
  }

  Future<String> getToken() async {
    String? tok = await SharedPref().getToken();
    if (tok != null) {
      return tok;
    } else {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    return Scaffold(
        backgroundColor: AppColor.whiteColor,
        body: Center(
          child: Image.asset('assets/images/ic_logo.png', height: 180),
        ));
  }
}
