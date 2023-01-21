import 'dart:convert';

import 'package:band_hub/routes/Routes.dart';
import 'package:band_hub/widgets/app_color.dart';
import 'package:band_hub/widgets/app_text.dart';
import 'package:band_hub/widgets/elevated_btn.dart';
import 'package:band_hub/widgets/elevated_stroke_btn.dart';
import 'package:band_hub/widgets/helper_widget.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../models/event_detail_response.dart';
import '../../../util/common_funcations.dart';
import '../../../util/global_variable.dart';

class EventDetailScreen extends StatefulWidget {
  const EventDetailScreen({Key? key}) : super(key: key);

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  bool isFromManager = false;
  String eventId = "";

  @override
  void initState() {
    super.initState();
    isFromManager = Get.arguments['isFromManager'] ?? false;
    eventId = Get.arguments['eventId'] ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HelperWidget.customAppBar(title: 'Event Details'),
      body: FutureBuilder<EventDetailResponse>(
          future: eventDetailApi(context, eventId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    // snapshot.data!.body.eventImages.isEmpty ?
                    Container(
                      width: Get.width,
                      height: 260,
                      decoration: BoxDecoration(
                          color: AppColor.grayColor,
                          image: const DecorationImage(
                              image: AssetImage(
                                  'assets/images/ic_placeholder.png'),
                              fit: BoxFit.cover)),
                    ),
                    // : CommonFunctions().setNetworkImages(
                    //     imageUrl: snapshot
                    //         .data!.body.eventImages[0].event.image,
                    //     width: Get.width,
                    //     height: 200,
                    //     circle: 15),
                    Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AppText(
                                        text: snapshot.data!.body.name,
                                        textSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      Row(
                                        children: [
                                          Image.asset(
                                              'assets/images/ic_location_mark.png',
                                              height: 12),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5.0),
                                            child: AppText(
                                              text:
                                                  snapshot.data!.body.location,
                                              textSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Get.toNamed(Routes.userChatScreen);
                                  },
                                  child: Image.asset(
                                    'assets/images/ic_message_red.png',
                                    height: 35,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            AppText(
                              text: snapshot.data!.body.description,
                              textSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Divider(
                              height: 10,
                              color: AppColor.grayColor.withOpacity(.30),
                              thickness: 1.2,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: [
                                AppText(
                                  text: "Start Date & Time",
                                  textSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                                const Spacer(),
                                AppText(
                                  text: "End Date & Time",
                                  textSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Row(
                              children: [
                                AppText(
                                  text: CommonFunctions().changeDateFormat(
                                          snapshot.data!.body.startDate) +
                                      " | " +
                                      snapshot.data!.body.startTime,
                                  textSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                                const Spacer(),
                                AppText(
                                  text: CommonFunctions().changeDateFormat(
                                          snapshot.data!.body.endDate) +
                                      " | " +
                                      snapshot.data!.body.endTime,
                                  textSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Divider(
                              height: 10,
                              color: AppColor.grayColor.withOpacity(.30),
                              thickness: 1.2,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            AppText(
                              text: "Manager",
                              textSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () =>
                                      Get.toNamed(Routes.managerProfileScreen),
                                  child: CommonFunctions().setNetworkImages(
                                      imageUrl: snapshot.data!.body.eventCreator.profileImage,
                                      width: 55,
                                      height: 55,
                                      isUser: true,
                                      circle: 40
                                  ),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppText(
                                      text: snapshot.data!.body.eventCreator.fullName,
                                      textSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/images/ic_star.png',
                                          width: 60,
                                        ),
                                        AppText(
                                          text: " 25 Reviews",
                                          textSize: 10,
                                        ),
                                      ],
                                    )
                                  ],
                                )),
                                InkWell(
                                  onTap: () {
                                    Get.toNamed(Routes.groupChatScreen);
                                  },
                                  child: Image.asset(
                                    'assets/images/ic_message_red.png',
                                    height: 30,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Divider(
                              height: 10,
                              color: AppColor.grayColor.withOpacity(.30),
                              thickness: 1.2,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            AppText(
                              text: "Musicians Joined",
                              textSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            ListView.builder(
                                shrinkWrap: true,
                                itemCount:
                                    snapshot.data!.body.eventBookings.length,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: ((context, index) {
                                  return InkWell(
                                    onTap: () {
                                      Get.toNamed(Routes.musicianDetailScreen);
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 15),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 10),
                                      decoration: BoxDecoration(
                                          color: AppColor.whiteColor,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppColor.grayColor
                                                  .withAlpha(80),
                                              blurRadius: 10.0,
                                              offset: const Offset(2, 2),
                                            ),
                                          ]),
                                      child: Row(
                                        children: [
                                          CommonFunctions().setNetworkImages(
                                            imageUrl: snapshot.data!.body.eventBookings[index]
                                              .user.profileImage,
                                            width: 65,
                                            height: 65,
                                            isUser: true,
                                            circle: 40
                                          ),

                                          const SizedBox(
                                            width: 15,
                                          ),
                                          Expanded(
                                              child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  AppText(
                                                    text: snapshot
                                                        .data!
                                                        .body
                                                        .eventBookings[index]
                                                        .user
                                                        .fullName,
                                                    textSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  const Spacer(),
                                                  AppText(
                                                    text: snapshot
                                                        .data!
                                                        .body
                                                        .eventBookings[index]
                                                        .user
                                                        .categoryName,
                                                    textSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 2,
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Image.asset(
                                                          'assets/images/ic_location_mark.png',
                                                          height: 12),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 5.0),
                                                        child: AppText(
                                                          text: snapshot
                                                              .data!
                                                              .body
                                                              .eventBookings[
                                                                  index]
                                                              .user
                                                              .location,
                                                          textSize: 12,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  // const Spacer(),
                                                  // InkWell(
                                                  //   onTap: () {
                                                  //     Get.toNamed(Routes.userChatScreen);
                                                  //   },
                                                  //   child: Image.asset(
                                                  //     'assets/images/ic_message_red.png',
                                                  //     height: 35,
                                                  //   ),
                                                  // )
                                                ],
                                              )
                                            ],
                                          ))
                                        ],
                                      ),
                                    ),
                                  );
                                })),
                            const SizedBox(
                              height: 20,
                            ),
                            isFromManager
                                ? Container()
                                : Row(
                                    children: [
                                      const SizedBox(
                                        width: 25,
                                      ),
                                      Expanded(
                                          child: ElevatedBtn(
                                        text: 'Accept',
                                        onTap: (() {
                                          eventAcceptRejectApi(
                                              context,
                                              snapshot.data!.body.id.toString(),
                                              true);
                                        }),
                                        heignt: 45,
                                      )),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                          child: ElevatedStrokeBtn(
                                        onTap: (() {
                                          showDeclineDialog(snapshot
                                              .data!.body.id
                                              .toString());
                                        }),
                                        text: "Decline",
                                        heignt: 45,
                                      )),
                                      const SizedBox(
                                        width: 25,
                                      ),
                                    ],
                                  ),
                          ],
                        ))
                  ],
                ),
              );
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
    );
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

  Future<EventDetailResponse> eventDetailApi(
      BuildContext ctx, String eventId) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    // if (loader != null) {
    //   loader.changeIsShowToast(
    //       !response.request!.url.path.contains(GlobalVariable.logout));
    // }

    if (!(connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi)) {
      throw new Exception('NO INTERNET CONNECTION');
    }
    var body = {'eventId': eventId};

    var response = await http.put(
        Uri.parse(GlobalVariable.baseUrl + GlobalVariable.eventDetails),
        headers: await CommonFunctions().getHeader(),
        body: body);

    // if (response.statusCode == 201) {}
    print(response.body);
    try {
      Map<String, dynamic> res = json.decode(response.body);

      if (res['code'] != 200 || res == null) {
        String error = res['msg'];
        // Fluttertoast.showToast(msg: error, toastLength: Toast.LENGTH_SHORT);
        // Navigator.pop(ctx);
        print("scasd  " + error);
        throw new Exception(error);
      }
      EventDetailResponse result = EventDetailResponse.fromJson(res);

      return result;
    } catch (error) {
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

      if (res['code'] != 200 || res == null) {
        String error = res['msg'];
        // Fluttertoast.showToast(msg: error, toastLength: Toast.LENGTH_SHORT);
        // Navigator.pop(ctx);
        print("scasd  " + error);
        throw new Exception(error);
      }

      EasyLoading.dismiss();
      Fluttertoast.showToast(msg: res['msg'], toastLength: Toast.LENGTH_SHORT);
      Get.back();
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
