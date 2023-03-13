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
    var token = await getToken() ?? "";

    if (token.isNotEmpty) {
      print(token);
      var d = await SharedPref().getPreferenceJson();
      LoginResponseModel result = LoginResponseModel.fromJson(jsonDecode(d));

      Timer(const Duration(seconds: 2), () {
        if (result.body.type == 1) {
          if (result.body.location.isEmpty) {
            SharedPref().setToken("");
            Get.offAllNamed(Routes.introScreen);
          } else {
            Get.offAllNamed(Routes.userMainScreen);
          }
        } else {
          Get.offAllNamed(Routes.managerHomeScreen);
        }
      });
    } else {
      Timer(const Duration(seconds: 2), () {
        Get.offAllNamed(Routes.introScreen);
      });
    }
  }

  Future<String?> getToken() async {
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

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
          backgroundColor: AppColor.whiteColor,
          body: Center(
            child: Image.asset('assets/images/ic_logo.png', height: 180),
          )),
    );
  }
}
