import 'dart:convert';
import 'package:band_hub/routes/Routes.dart';
import 'package:band_hub/util/common_funcations.dart';
import 'package:band_hub/util/global_variable.dart';
import 'package:band_hub/widgets/app_color.dart';
import 'package:band_hub/widgets/app_text.dart';
import 'package:band_hub/widgets/helper_widget.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class PrivacyTermsAboutScreen extends StatefulWidget {
  const PrivacyTermsAboutScreen({Key? key}) : super(key: key);

  @override
  State<PrivacyTermsAboutScreen> createState() =>
      _PrivacyTermsAboutScreenState();
}

class _PrivacyTermsAboutScreenState extends State<PrivacyTermsAboutScreen> {
  String isFrom = '';

  @override
  void initState() {
    super.initState();
    isFrom = Get.arguments["isFrom"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: HelperWidget.customAppBar(title: isFrom),
        body: Padding(
          padding: EdgeInsets.all(30),
          child: FutureBuilder<String?>(
              future: callApi(context),
              builder: (context, result) {
                if (result.hasData) {
                  return SingleChildScrollView(
                      child: Html(data: result.data!));
                } else if (result.hasError) {
                  return Center(
                      child: AppText(
                    text: result.data == null
                        ? result.error.toString()
                        : result.data!.toString(),
                    textSize: 12,
                    fontWeight: FontWeight.w500,
                    textColor: Color(0xff8A8A8A),
                  ));
                }
                return Center(
                    child: CircularProgressIndicator(
                  color: AppColor.appColor,
                ));
              }),
        ));
  }

  Future<String?> callApi(BuildContext ctx) async {
    Map<dynamic, dynamic> body = {
      'type': isFrom == "Privacy Policy"
          ? "2"
          : isFrom == "Terms and Conditions"
              ? "1"
              : "3"
    };
    print(body);
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (!(connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi)) {
      throw new Exception('NO INTERNET CONNECTION');
    }
    var response = await http.put(
        Uri.parse(GlobalVariable.baseUrl + GlobalVariable.getContentDetail),
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
        print("scasd  " + error);
        throw new Exception(error);
      }

      return isFrom == "Privacy Policy"
          ? res['body']['privacyPolicy']
          : isFrom == "Terms and Conditions"
              ? res['body']['terms_content']
              : res['body']['aboutUs'];
    } catch (error) {
      Fluttertoast.showToast(
          msg: error.toString().substring(
              error.toString().indexOf(':') + 1, error.toString().length),
          toastLength: Toast.LENGTH_SHORT);
      throw error.toString();
    }
  }
}
