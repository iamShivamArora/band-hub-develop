import 'dart:convert';

import 'package:band_hub/util/common_funcations.dart';
import 'package:band_hub/widgets/app_color.dart';
import 'package:band_hub/widgets/app_text.dart';
import 'package:band_hub/widgets/custom_text_field.dart';
import 'package:band_hub/widgets/elevated_btn.dart';
import 'package:band_hub/widgets/helper_widget.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

import '../../models/auth/login_response_model.dart';
import '../../util/global_variable.dart';
import '../../util/sharedPref.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({Key? key}) : super(key: key);

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  var userName = '';
  var userId = '';
  var userImage = '';
  var userRating = '';
  var eventId = '';
  var rating = 1.0;
  var controller = TextEditingController();

  @override
  void initState() {
    userName = Get.arguments['userName'] ?? "";
    userId = Get.arguments['userId'] ?? "";
    userImage = Get.arguments['userImage'] ?? "";
    eventId = Get.arguments['eventId'] ?? "";
    userRating = Get.arguments['userRating'] ?? "";
    getUserDetail();
    super.initState();
  }

  bool isUser = false;

  void getUserDetail() async {
    var d = await SharedPref().getPreferenceJson();
    LoginResponseModel result = LoginResponseModel.fromJson(jsonDecode(d));
    isUser = result.body.type == 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: HelperWidget.customAppBar(title: 'Add Review'),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () =>
                  FocusScope.of(context).requestFocus(FocusScopeNode()),
              child: Column(children: [
                Center(
                    child: CommonFunctions().setNetworkImages(
                        imageUrl: userImage,
                        height: 100,
                        width: 100,
                        circle: 60,
                        isUser: true,
                        boxFit: BoxFit.cover)),
                const SizedBox(
                  height: 20,
                ),
                AppText(
                  text: userName,
                  textSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                SmoothStarRating(
                  allowHalfRating: false,
                  starCount: 5,
                  rating: double.parse(userRating),
                  size: 20.0,
                  color: Colors.amber,
                  borderColor: Colors.amber,
                ),
                Container(
                  width: Get.width,
                  margin: const EdgeInsets.symmetric(vertical: 30),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                  decoration: BoxDecoration(
                      color: AppColor.whiteColor,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.grayColor.withAlpha(80),
                          blurRadius: 10.0,
                          offset: const Offset(2, 2),
                        ),
                      ]),
                  child: Column(children: [
                    AppText(
                      text: "Rate your overall experience",
                      textSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SmoothStarRating(
                      allowHalfRating: true,
                      starCount: 5,
                      rating: rating,
                      size: 45.0,
                      color: Colors.amber,
                      borderColor: Colors.amber,
                      onRatingChanged: (value) {
                        rating = value;
                        setState(() {});
                      },
                    ),
                    SimpleTf(
                      controller: controller,
                      hint: "Type...",
                      lines: 8,
                      height: 140,
                    )
                  ]),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedBtn(
                  text: "Update",
                  onTap: () {
                    if (validate().isEmpty) {
                      addReview(context);
                    } else {
                      Fluttertoast.showToast(msg: validate());
                    }
                  },
                )
              ]),
            )));
  }

  String validate() {
    if (rating == 0) {
      return 'Please add rating';
    } else if (controller.text.trim().toString().isEmpty) {
      return 'Please add review';
    } else {
      return '';
    }
  }

  Future addReview(BuildContext ctx) async {
    Map<String, String> data = {
      'eventId': eventId,
      'rating': rating.toString(),
      'message': controller.text.trim().toString()
    };
    if (!isUser) {
      data['musicianId'] = userId;
    }
    print(data);
    EasyLoading.show(status: 'Loading');
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (!(connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi)) {
      throw new Exception('NO INTERNET CONNECTION');
    }
    var userType = isUser ? 'user/' : 'manager/';
    var response = await http.post(
        Uri.parse(GlobalVariable.baseUrl + userType + GlobalVariable.addReview),
        headers: await CommonFunctions().getHeader(),
        body: data);

    print(response.body);
    try {
      Map<String, dynamic> res = json.decode(response.body);

      if (res['code'] != 200 || res == null) {
        String error = res['msg'];
        print("scasd  " + error);
        throw new Exception(error);
      }

      EasyLoading.dismiss();
      showRatingDialog();
    } catch (error) {
      EasyLoading.dismiss();

      Fluttertoast.showToast(
          msg: error.toString().substring(
              error.toString().indexOf(':') + 1, error.toString().length),
          toastLength: Toast.LENGTH_SHORT);
      throw error.toString();
    }
  }

  showRatingDialog() {
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
                      'assets/images/ic_green_tick.png',
                      height: 70,
                    ),
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
                        text: "Thanks for the Rating.",
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
                                Get.back();
                                Get.back();
                              },
                            )),
                      ],
                    )
                  ],
                ),
              ),
            ));
  }
}
