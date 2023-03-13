import 'dart:async';
import 'dart:convert';

import 'package:band_hub/models/auth/login_response_model.dart';
import 'package:band_hub/routes/Routes.dart';
import 'package:band_hub/util/sharedPref.dart';
import 'package:band_hub/widgets/app_color.dart';
import 'package:band_hub/widgets/app_text.dart';
import 'package:band_hub/widgets/elevated_btn.dart';
import 'package:band_hub/widgets/elevated_stroke_btn.dart';
import 'package:band_hub/widgets/helper_widget.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../models/user/event_requests_listing_response.dart';
import '../../../util/common_funcations.dart';
import '../../../util/global_variable.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({Key? key}) : super(key: key);

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  @override
  void initState() {
    dbNameSet();
    super.initState();
  }

  dbNameSet() async {
    var d = await SharedPref().getPreferenceJson();
    LoginResponseModel user = LoginResponseModel.fromJson(jsonDecode(d));
    userName = user.body.fullName;
    userImage = user.body.profileImage;
    setState(() {});
    print('sdzx = =  ' + userName);
  }

  String userName = "";
  String userImage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: HelperWidget.noAppBar(color: AppColor.appColor),
        backgroundColor: AppColor.whiteColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: AppColor.appColor,
              padding: const EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        AppText(
                          text: "Hi, " + userName,
                          textSize: 22,
                          fontWeight: FontWeight.w700,
                          textColor: AppColor.whiteColor,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        AppText(
                          text: "Let's start learning",
                          textSize: 13,
                          fontWeight: FontWeight.w500,
                          textColor: AppColor.whiteColor,
                        ),
                      ])),
                  InkWell(
                      onTap: () {
                        if (!EasyLoading.isShow) {
                          Get.toNamed(Routes.userProfileScreen);
                        }
                      },
                      child: userImage.isEmail
                          ? Image.asset(
                              'assets/images/ic_user.png',
                              height: 60,
                            )
                          : CommonFunctions().setNetworkImages(
                              imageUrl: userImage,
                              isUser: true,
                              height: 60,
                              width: 60,
                              circle: 30))
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 15, 20, 0),
              child: AppText(
                text: "Requests",
                textSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  setState(() {});
                },
                color: AppColor.appColor,
                child: FutureBuilder<EventRequestsListingResponse>(
                    future: eventListApi(context),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return snapshot.data!.body.isEmpty
                            ? Center(
                                child: AppText(
                                text: "No active requests",
                                fontWeight: FontWeight.w500,
                                textSize: 16,
                              ))
                            : ListView.builder(
                                physics: const AlwaysScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: snapshot.data!.body.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: const EdgeInsets.fromLTRB(
                                        20, 10, 20, 10),
                                    decoration: BoxDecoration(
                                        color: AppColor.whiteColor,
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColor.grayColor
                                                .withAlpha(80),
                                            blurRadius: 10.0,
                                            offset: const Offset(2, 2),
                                          ),
                                        ]),
                                    child: Column(children: [
                                      InkWell(
                                        onTap: () async {
                                          // await Get.toNamed(Routes.eventDetailScreen,
                                          //     arguments: {
                                          //       'isFromManager': false,
                                          //       'eventId': snapshot
                                          //           .data!.body[index].eventId
                                          //           .toString()
                                          //     });
                                          //
                                          //       setState(() {});

                                          if (!EasyLoading.isShow) {
                                            await Get.toNamed(
                                                Routes.managerEventDetailScreen,
                                                arguments: {
                                                  'eventId': snapshot
                                                      .data!.body[index].eventId
                                                      .toString(),
                                                  'isFromCurrent': ''
                                                });
                                            setState(() {});
                                          }
                                        },
                                        child: CommonFunctions()
                                            .setNetworkImages(
                                                imageUrl: snapshot.data!
                                                    .body[index].event.image,
                                                width: Get.width,
                                                height: 200,
                                                circle: 15),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 15),
                                        child: Column(children: [
                                          Row(
                                            children: [
                                              AppText(
                                                text: snapshot.data!.body[index]
                                                    .event.name,
                                                textSize: 15,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              const Spacer(),
                                              AppText(
                                                text: "Date & Time",
                                                textSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ],
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 3.0),
                                                child: Image.asset(
                                                    'assets/images/ic_location_mark.png',
                                                    height: 12),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 8.0),
                                                  child: AppText(
                                                    text: " " +
                                                        snapshot
                                                            .data!
                                                            .body[index]
                                                            .event
                                                            .location,
                                                    maxlines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              AppText(
                                                text: CommonFunctions()
                                                        .changeDateFormat(
                                                            snapshot
                                                                .data!
                                                                .body[index]
                                                                .event
                                                                .startDate) +
                                                    " | " +
                                                    snapshot.data!.body[index]
                                                        .event.startTime,
                                                textSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              const SizedBox(
                                                width: 15,
                                              ),
                                              Expanded(
                                                  child: ElevatedBtn(
                                                text: 'Accept',
                                                onTap: (() {
                                                  if (!EasyLoading.isShow) {
                                                    eventAcceptRejectApi(
                                                        context,
                                                        snapshot
                                                            .data!
                                                            .body[index]
                                                            .event
                                                            .id
                                                            .toString(),
                                                        true);
                                                  }
                                                }),
                                                heignt: 45,
                                              )),
                                              const SizedBox(
                                                width: 15,
                                              ),
                                              Expanded(
                                                  child: ElevatedStrokeBtn(
                                                onTap: (() {
                                                  if (!EasyLoading.isShow) {
                                                    showDeclineDialog(snapshot
                                                        .data!
                                                        .body[index]
                                                        .event
                                                        .id
                                                        .toString());
                                                  }
                                                }),
                                                text: "Decline",
                                                heignt: 45,
                                              )),
                                              const SizedBox(
                                                width: 15,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                        ]),
                                      )
                                    ]),
                                  );
                                });
                      } else if (snapshot.hasError) {
                        return Center(
                            child: AppText(
                          text: snapshot.error.toString(),
                          fontWeight: FontWeight.w500,
                          textSize: 16,
                        ));
                      }
                      return Center(child: CommonFunctions().loadingCircle());
                    }),
              ),
            )
          ],
        ));
  }

  showDeclineDialog(String eventId) {
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
                      'assets/images/ic_cross_red.png',
                      height: 70,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    AppText(
                        text: "Decline",
                        textColor: AppColor.blackColor,
                        textAlign: TextAlign.center,
                        textSize: 16,
                        fontWeight: FontWeight.w500),
                    const SizedBox(
                      height: 10,
                    ),
                    AppText(
                        text: "Are you sure you want to decline\nthis request?",
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
                            child: ElevatedStrokeBtn(
                          text: 'No',
                          onTap: () {
                            Get.back();
                          },
                        )),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: ElevatedBtn(
                          text: 'Yes',
                          buttonColor: AppColor.appColor,
                          textColor: AppColor.whiteColor,
                          onTap: () {
                            Get.back();
                            eventAcceptRejectApi(context, eventId, false);
                          },
                        )),
                      ],
                    )
                  ],
                ),
              ),
            ));
  }

  Future<EventRequestsListingResponse> eventListApi(BuildContext ctx) async {
    // EasyLoading.show(status: 'Loading');
    var connectivityResult = await (Connectivity().checkConnectivity());
    // if (loader != null) {
    //   loader.changeIsShowToast(
    //       !response.request!.url.path.contains(GlobalVariable.logout));
    // }

    if (!(connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi)) {
      throw new Exception('NO INTERNET CONNECTION');
    }
    var response = await http.get(
        Uri.parse(GlobalVariable.baseUrl + GlobalVariable.eventRequests),
        headers: await CommonFunctions().getHeader());

    // if (response.statusCode == 201) {}
    print(response.body);
    try {
      Map<String, dynamic> res = json.decode(response.body);
      CommonFunctions().invalideAuth(res);
      if (res['code'] != 200 || res == null) {
        String error = res['msg'];
        // Fluttertoast.showToast(msg: error, toastLength: Toast.LENGTH_SHORT);
        // Navigator.pop(ctx);
        print("scasd  " + error);
        throw new Exception(error);
      }
      EventRequestsListingResponse result =
          EventRequestsListingResponse.fromJson(res);
      // EasyLoading.dismiss();

      return result;
    } catch (error) {
      // EasyLoading.dismiss();
      Fluttertoast.showToast(
          msg: error.toString().substring(
              error.toString().indexOf(':') + 1, error.toString().length),
          toastLength: Toast.LENGTH_SHORT);
      throw error.toString();
    }
  }

  Future eventAcceptRejectApi(
      BuildContext ctx, String eventId, bool accept) async {
    Map<String, String> data = {
      'eventId': eventId,
      'status': accept ? "1" : "2"
    };
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
        Uri.parse(GlobalVariable.baseUrl + GlobalVariable.eventRequestsStatus),
        headers: await CommonFunctions().getHeader(),
        body: data);

    // if (response.statusCode == 201) {}
    print(response.body);
    try {
      Map<String, dynamic> res = json.decode(response.body);
      CommonFunctions().invalideAuth(res);
      if (res['code'] != 200 || res == null) {
        String error = res['msg'];
        // Fluttertoast.showToast(msg: error, toastLength: Toast.LENGTH_SHORT);
        // Navigator.pop(ctx);
        print("scasd  " + error);
        throw new Exception(error);
      }

      EasyLoading.dismiss();
      Fluttertoast.showToast(msg: res['msg'], toastLength: Toast.LENGTH_SHORT);
      setState(() {});
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
