import 'dart:convert';
import 'dart:io';

import 'package:band_hub/widgets/app_text.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../models/auth/login_response_model.dart';
import '../../routes/Routes.dart';
import '../../util/common_funcations.dart';
import '../../util/global_variable.dart';
import '../../widgets/app_color.dart';
import '../../widgets/country_picker/country.dart';
import '../../widgets/custom_phone_text_field.dart';
import '../../widgets/elevated_btn.dart';
import '../../widgets/helper_widget.dart';

class ContinueWithPhoneScreen extends StatefulWidget {
  const ContinueWithPhoneScreen({Key? key}) : super(key: key);

  @override
  State<ContinueWithPhoneScreen> createState() =>
      _ContinueWithPhoneScreenState();
}

class _ContinueWithPhoneScreenState extends State<ContinueWithPhoneScreen> {
  TextEditingController controllerPhone = TextEditingController();

  String countryCode = "+1";
  Country? selectedCountryData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.whiteColor,
        appBar: HelperWidget.customAppBar(title: 'Continue with Phone'),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () =>
                    FocusScope.of(context).requestFocus(FocusScopeNode()),
                child: Column(children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Image.asset(
                      'assets/images/ic_c_phone.png',
                      height: 120,
                    ),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  AppText(
                    text: "Enter Your Phone Number",
                    textSize: 14,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Stack(
                    children: [
                      SimplePhoneTf(
                        controller: controllerPhone,
                        hint: 'Enter phone number',
                        title: '',
                        onChanged: (_) {
                          print(_.dialingCode);
                          countryCode = '+' + _.dialingCode;
                          selectedCountryData = _;
                          setState(() {});
                        },
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        maxLength: 12,
                        selectedCountry: selectedCountryData != null
                            ? selectedCountryData!
                            : Country.US,
                      ),
                      Positioned(
                          bottom: 0,
                          right: 0,
                          child: Column(
                            children: [
                              ElevatedBtn(
                                width: 120,
                                heignt: 47,
                                text: "Continue",
                                onTap: () {
                                  if (validation().isEmpty) {
                                    callApi(context);
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: validation(),
                                        toastLength: Toast.LENGTH_SHORT);
                                  }
                                },
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                            ],
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ]))));
  }

  Future callApi(BuildContext ctx) async {
    Map<dynamic, dynamic> body = {
      'phone': controllerPhone.text.trim().toString(),
      'countryCode': countryCode,
      'type': "2",
      'device_type': Platform.isAndroid ? '1' : '2',
      'device_token': ' ',
    };

    print(body);

    EasyLoading.show(status: 'Loading');
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (!(connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi)) {
      throw new Exception('NO INTERNET CONNECTION');
    }
    var response = await http.put(
        Uri.parse(GlobalVariable.baseUrl + GlobalVariable.login),
        headers: await CommonFunctions().getHeader(),
        body: body);

    print(response.body);
    // LoginResponseModel? result = null;
    try {
      Map<String, dynamic> res = json.decode(response.body);

      if (res['code'] != 200 || res == null) {
        String error = res['msg'];
        // Fluttertoast.showToast(msg: error, toastLength: Toast.LENGTH_SHORT);
        // Navigator.pop(ctx);
        print("scasd  " + error);
        throw new Exception(error);
      }
      var result = LoginResponseModel.fromJson(res);
      EasyLoading.dismiss();
      Fluttertoast.showToast(msg: 'OTP send', toastLength: Toast.LENGTH_SHORT);
      Get.toNamed(Routes.verificationScreen, arguments: {
        "isFromLogin": true,
        "number": controllerPhone.text.trim().toString(),
        "countryCode": countryCode,
        "authKey": result.body.authKey,
        "loginResult": jsonEncode(result),
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

  String validation() {
    FocusScope.of(context).requestFocus(FocusScopeNode());

    if (controllerPhone.text.trim().isEmpty) {
      return "Please enter number";
    } else if (controllerPhone.text.trim().length < 10) {
      return "Please enter at least 10 digits in phone number";
    } else {
      return "";
    }
  }
}
