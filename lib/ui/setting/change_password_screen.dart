import 'dart:convert';

import 'package:band_hub/widgets/custom_text_field.dart';
import 'package:band_hub/widgets/elevated_btn.dart';
import 'package:band_hub/widgets/helper_widget.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../models/success_response.dart';
import '../../routes/Routes.dart';
import '../../util/common_funcations.dart';
import '../../util/global_variable.dart';
import 'package:http/http.dart' as http;
class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool oldPasswordView = true;
  bool newPasswordView = true;
  bool confirmPasswordView = true;

  TextEditingController controllerPassword = TextEditingController();
  TextEditingController controllerNewPassword = TextEditingController();
  TextEditingController controllerConfirmPassword = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: HelperWidget.customAppBar(title: 'Change Password'),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () =>
                  FocusScope.of(context).requestFocus(FocusScopeNode()),
              child: Column(children: [
                Center(
                    child: Image.asset(
                  'assets/images/ic_change_password.png',
                  height: 300,
                )),
                const SizedBox(
                  height: 20,
                ),
                SimpleTf(
                  controller: controllerPassword,
                  password: oldPasswordView,
                  title: "Old Password",
                  suffix: oldPasswordView
                      ? 'assets/images/ic_p_view.png'
                      : 'assets/images/ic_p_hide.png',
                  onSuffixTap: () {
                    oldPasswordView = !oldPasswordView;
                    setState(() {});
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                SimpleTf(
                  controller: controllerNewPassword,
                  password: newPasswordView,
                  title: "New Password",
                  suffix: newPasswordView
                      ? 'assets/images/ic_p_view.png'
                      : 'assets/images/ic_p_hide.png',
                  onSuffixTap: () {
                    newPasswordView = !newPasswordView;
                    setState(() {});
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                SimpleTf(
                  controller: controllerConfirmPassword,
                  password: confirmPasswordView,
                  title: "Confirm New Password",
                  suffix: confirmPasswordView
                      ? 'assets/images/ic_p_view.png'
                      : 'assets/images/ic_p_hide.png',
                  onSuffixTap: () {
                    confirmPasswordView = !confirmPasswordView;
                    setState(() {});
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                ElevatedBtn(text: 'Update',onTap: (){
                  if(validation().isEmpty){
                    callApi(context);
                  }
                  else{
                    Fluttertoast.showToast(msg: validation());
                  }

                },)
              ]),
            )));
  }

  String validation() {
    FocusScope.of(context).requestFocus(FocusScopeNode());
    if (controllerPassword.text.trim().isEmpty) {
      return "Please enter password";
    }
    else if (controllerNewPassword.text.trim().isEmpty) {
      return "Please enter new password";
    } else if (controllerNewPassword.text.length < 6) {
      return "Please enter at least 6 characters in new password";
    } else if (controllerConfirmPassword.text.toString().trim().isEmpty) {
      return "Please confirm your password";
    } else if (controllerNewPassword.text != controllerConfirmPassword.text) {
      return "Password and confirm password must match";
    }else {
      return "";
    }
  }

  Future callApi(BuildContext ctx) async {
    Map<dynamic, dynamic> body = {
      'old_password': controllerPassword.text.trim().toString(),
      'new_password': controllerNewPassword.text.trim().toString()
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
    var response = await http.post(
        Uri.parse(GlobalVariable.baseUrl + GlobalVariable.ChangePassword),
        headers: await CommonFunctions().getHeader(),
        body: body);

    // if (response.statusCode == 201) {}
    print(response.body);
    SuccessResponse? result = null;
    try {
      Map<String, dynamic> res = json.decode(response.body);
      if (res['code'] == 401) {
        String error = res['msg'];
        Get.toNamed(Routes.logInScreen);
        throw new Exception(error);
      }
      result = SuccessResponse.fromJson(res);
      if (res['code'] != 200 || json == null) {
        String error = res['msg'];
        // Fluttertoast.showToast(msg: error, toastLength: Toast.LENGTH_SHORT);
        // Navigator.pop(ctx);
        print("scasd  " + error);
        throw new Exception(error);
      }

      EasyLoading.dismiss();
      Fluttertoast.showToast(msg: result.msg, toastLength: Toast.LENGTH_SHORT);
      Get.back();
      // return ApiSignUpDataModel.fromJson(json.decode(response.body));
    } catch (error) {
      EasyLoading.dismiss();
      if (result != null) {
        Fluttertoast.showToast(
            msg: result.msg, toastLength: Toast.LENGTH_SHORT);
        throw result.msg;
      } else {
        Fluttertoast.showToast(
            msg: error.toString().substring(
                error.toString().indexOf(':') + 1, error.toString().length),
            toastLength: Toast.LENGTH_SHORT);
        throw error.toString();
      }
    }
  }
}
