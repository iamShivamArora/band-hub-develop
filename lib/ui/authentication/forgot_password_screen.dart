import 'dart:convert';

import 'package:band_hub/widgets/app_text.dart';
import 'package:band_hub/widgets/custom_text_field.dart';
import 'package:band_hub/widgets/elevated_btn.dart';
import 'package:band_hub/widgets/helper_widget.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../util/common_funcations.dart';
import '../../util/global_variable.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController controllerEmail = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HelperWidget.customAppBar(title: "Forgot password"),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).requestFocus(FocusScopeNode()),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/ic_red_lock.png',
                  height: 100,
                ),
                const SizedBox(
                  height: 60,
                ),
                Center(
                  child: AppText(
                    textAlign: TextAlign.center,
                    text:
                        'Enter your E-mail and we will send\nyou a recovery code.',
                    fontWeight: FontWeight.w400,
                    textSize: 15,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                SimpleTf(
                  controller: controllerEmail,
                  hint: "Email",
                  inputType: TextInputType.emailAddress,
                ),
                const SizedBox(
                  height: 80,
                ),
                ElevatedBtn(
                  text: 'Send',
                  onTap: () async {
                    if (validation().isEmpty) {
                      await callApi(context);
                    } else {
                      Fluttertoast.showToast(msg: validation());
                    }
                  },
                ),
                const SizedBox(
                  height: 80,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String validation() {
    FocusScope.of(context).requestFocus(FocusScopeNode());

    if (controllerEmail.text.trim().isEmpty) {
      return "Please enter email";
    } else if (!CommonFunctions()
        .isEmailValid(controllerEmail.text.trim().toString())) {
      return "Please enter valid email";
    } else {
      return "";
    }
  }

  Future callApi(BuildContext ctx) async {
    Map<dynamic, dynamic> body = {
      'email': controllerEmail.text.trim().toString()
    };
    print(body);

    EasyLoading.show(status: 'Loading');
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (!(connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi)) {
      throw new Exception('NO INTERNET CONNECTION');
    }
    var response = await http.post(
        Uri.parse(GlobalVariable.baseUrl + GlobalVariable.forgotPassword),
        headers: await CommonFunctions().getHeader(),
        body: body);

    print(response.body);

    try {
      Map<String, dynamic> res = json.decode(response.body);
      print(res);

      if (res['code'] != 200 || res == null) {
        String error = res['msg'];

        print("scasd  " + error);
        throw new Exception(error);
      }
      EasyLoading.dismiss();
      Get.back();
      Fluttertoast.showToast(msg: res['msg'], toastLength: Toast.LENGTH_SHORT);
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
