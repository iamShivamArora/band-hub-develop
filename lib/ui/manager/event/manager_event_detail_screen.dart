import 'dart:convert';

import 'package:band_hub/routes/Routes.dart';
import 'package:band_hub/widgets/app_color.dart';
import 'package:band_hub/widgets/app_text.dart';
import 'package:band_hub/widgets/elevated_btn.dart';
import 'package:band_hub/widgets/helper_widget.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

import '../../../models/auth/login_response_model.dart';
import '../../../models/event_detail_response.dart';
import '../../../util/common_funcations.dart';
import '../../../util/global_variable.dart';
import '../../../util/sharedPref.dart';
import '../../../widgets/elevated_stroke_btn.dart';

class ManagerEventDetailScreen extends StatefulWidget {
  const ManagerEventDetailScreen({Key? key}) : super(key: key);

  @override
  State<ManagerEventDetailScreen> createState() =>
      _ManagerEventDetailScreenState();
}

class _ManagerEventDetailScreenState extends State<ManagerEventDetailScreen> {
  String eventId = "";
  String userId = "";
  String isFromCurrent = "";
  int userStatus = 0;
  PageController controller =
      PageController(viewportFraction: 1, keepPage: true);

  @override
  void initState() {
    eventId = Get.arguments['eventId'] ?? "";
    isFromCurrent = Get.arguments['isFromCurrent'] ?? "";
    getUserDetail();
    super.initState();
  }

  bool isUser = false;

  void getUserDetail() async {
    var d = await SharedPref().getPreferenceJson();
    LoginResponseModel result = LoginResponseModel.fromJson(jsonDecode(d));
    isUser = result.body.type == 1;
    userId = result.body.id.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HelperWidget.customAppBar(title: 'Details'),
      body: FutureBuilder<EventDetailResponse>(
          future: eventDetailApi(context, eventId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                  child: Column(
                children: [
                  SizedBox(
                    height: 260,
                    width: Get.width,
                    child: Stack(children: [
                      PageView.builder(
                        itemCount: snapshot.data!.body.eventImages.length,
                        controller: controller,
                        onPageChanged: (value) {
                          setState(() {});
                        },
                        itemBuilder: (BuildContext context, int itemIndex) {
                          return CommonFunctions().setNetworkImages(
                              imageUrl: snapshot
                                  .data!.body.eventImages[itemIndex].images,
                              height: 260,
                              boxFit: BoxFit.cover,
                              width: MediaQuery.of(Get.context!).size.width);
                        },
                      ),
                      snapshot.data!.body.eventImages.length == 1
                          ? Container()
                          : Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                margin: const EdgeInsets.all(10),
                                child: SmoothPageIndicator(
                                    controller: controller,
                                    // PageController
                                    count:
                                        snapshot.data!.body.eventImages.length,
                                    effect: ScrollingDotsEffect(
                                        activeDotColor: AppColor.appColor,
                                        dotColor:
                                            AppColor.grayColor.withOpacity(.50),
                                        spacing: 5,
                                        dotHeight: 7,
                                        dotWidth: 7),
                                    // your preferred effect
                                    onDotClicked: (index) {}),
                              )),
                    ]),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 3.0),
                                          child: Image.asset(
                                              'assets/images/ic_location_mark.png',
                                              height: 12),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5.0),
                                            child: AppText(
                                              text:
                                                  snapshot.data!.body.location,
                                              textSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
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
                            height: 5,
                          ),
                          AppText(
                            text: "Category : " +
                                snapshot.data!.body.category.toString(),
                            textSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: AppText(
                              text: "Description : " +
                                  snapshot.data!.body.description,
                              textSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
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
                          Visibility(
                            visible: isUser,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                                      onTap: () {
                                        Get.toNamed(Routes.managerProfileScreen,
                                            arguments: {
                                              'userId': snapshot
                                                  .data!.body.eventCreator.id
                                                  .toString(),
                                              'eventId': eventId
                                            });
                                        // Get.toNamed(Routes.managerProfileScreen);
                                      },
                                      child: CommonFunctions().setNetworkImages(
                                          imageUrl: snapshot.data!.body
                                              .eventCreator.profileImage,
                                          width: 55,
                                          height: 55,
                                          isUser: true,
                                          circle: 40),
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Expanded(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AppText(
                                          text: snapshot
                                              .data!.body.eventCreator.fullName,
                                          textSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        Visibility(
                                          visible:
                                              snapshot.data!.body.rateCount > 0,
                                          child: Row(
                                            children: [
                                              SmoothStarRating(
                                                allowHalfRating: false,
                                                starCount: 5,
                                                rating: snapshot
                                                        .data!.body.avgRating ??
                                                    1,
                                                size: 15.0,
                                                color: Colors.amber,
                                                borderColor: Colors.amber,
                                              ),
                                              AppText(
                                                text: " " +
                                                    snapshot
                                                        .data!.body.rateCount
                                                        .toString() +
                                                    " Reviews",
                                                textSize: 10,
                                              ),
                                            ],
                                          ),
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
                              ],
                            ),
                          ),
                          Visibility(
                            visible: snapshot.data!.body.status != 0,
                            child: Container(
                              margin: EdgeInsets.only(top: 20),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 15),
                              decoration: BoxDecoration(
                                  color: AppColor.whiteColor,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColor.grayColor.withAlpha(80),
                                      blurRadius: 10.0,
                                      offset: const Offset(2, 2),
                                    ),
                                  ]),
                              child: Row(
                                children: [
                                  AppText(
                                    text: "Status",
                                    textSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  const Spacer(),
                                  AppText(
                                    text: CommonFunctions().getEventStatusType(
                                        snapshot.data!.body.status),
                                    textSize: 12,
                                    fontWeight: FontWeight.w400,
                                    textColor: CommonFunctions()
                                        .getColorForStatus(
                                            snapshot.data!.body.status),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Visibility(
                            visible:
                                snapshot.data!.body.eventBookings.isNotEmpty,
                            child: AppText(
                              text: "Musicians Joined",
                              textSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
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
                                    if (!isUser) {
                                      Get.toNamed(Routes.musicianDetailScreen,
                                          arguments: {
                                            'userId': snapshot.data!.body
                                                .eventBookings[index].userId
                                                .toString(),
                                            'eventId': eventId,
                                            'isInvited': true
                                          });
                                    }
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 15),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 10),
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
                                    child: Row(
                                      children: [
                                        CommonFunctions().setNetworkImages(
                                            imageUrl: snapshot
                                                .data!
                                                .body
                                                .eventBookings[index]
                                                .user
                                                .profileImage,
                                            width: 65,
                                            height: 65,
                                            isUser: true,
                                            circle: 40),
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
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Expanded(
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 3.0),
                                                        child: Image.asset(
                                                            'assets/images/ic_location_mark.png',
                                                            height: 12),
                                                      ),
                                                      Expanded(
                                                        child: Padding(
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
                                                            maxlines: 2,
                                                            overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                            fontWeight:
                                                            FontWeight.w400,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                isUser
                                                    ? AppText(
                                                        text: (snapshot
                                                                        .data!
                                                                        .body
                                                                        .status ==
                                                                    2 &&
                                                                snapshot
                                                                        .data!
                                                                        .body
                                                                        .eventBookings[
                                                                            index]
                                                                        .status ==
                                                                    0)
                                                            ? 'Expiry'
                                                            : CommonFunctions()
                                                                .getStatusType(snapshot
                                                                    .data!
                                                                    .body
                                                                    .eventBookings[
                                                                        index]
                                                                    .status),
                                                        textSize: 12,
                                                        textColor: (snapshot
                                                                        .data!
                                                                        .body
                                                                        .status ==
                                                                    2 &&
                                                                snapshot
                                                                        .data!
                                                                        .body
                                                                        .eventBookings[
                                                                            index]
                                                                        .status ==
                                                                    0)
                                                            ? Colors.red
                                                            : CommonFunctions()
                                                                .getUserStatusColor(
                                                                    snapshot
                                                                        .data!
                                                                        .body
                                                                        .eventBookings[
                                                                            index]
                                                                        .status),
                                                      )
                                                    : (snapshot.data!.body
                                                                    .status ==
                                                                2 &&
                                                            snapshot
                                                                    .data!
                                                                    .body
                                                                    .eventBookings[
                                                                        index]
                                                                    .status ==
                                                                1)
                                                        ? Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 5.0),
                                                            child: ElevatedBtn(
                                                              text:
                                                                  'Add Review',
                                                              textSize: 10,
                                                              width: 80,
                                                              heignt: 25,
                                                              onTap: (() {
                                                                Get.toNamed(
                                                                    Routes
                                                                        .ratingScreen,
                                                                    arguments: {
                                                                      'eventId':
                                                                          eventId,
                                                                      'userName': snapshot
                                                                          .data!
                                                                          .body
                                                                          .eventBookings[
                                                                              index]
                                                                          .user
                                                                          .fullName,
                                                                      'userId': snapshot
                                                                          .data!
                                                                          .body
                                                                          .eventBookings[
                                                                              index]
                                                                          .user
                                                                          .id
                                                                          .toString(),
                                                                      'userImage': snapshot
                                                                          .data!
                                                                          .body
                                                                          .eventBookings[
                                                                              index]
                                                                          .user
                                                                          .profileImage,
                                                                      'userRating':
                                                                          '1'
                                                                    });
                                                              }),
                                                            ),
                                                          )
                                                        : snapshot
                                                                    .data!
                                                                    .body
                                                                    .eventBookings[
                                                                        index]
                                                                    .status ==
                                                                0
                                                            ? AppText(
                                                                text: 'Pending',
                                                                textSize: 12,
                                                                textColor:
                                                                    Colors
                                                                        .amber,
                                                              )
                                                            : Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            8.0),
                                                                child: InkWell(
                                                                  onTap: () {
                                                                    Get.toNamed(
                                                                        Routes
                                                                            .userChatScreen);
                                                                  },
                                                                  child: Image
                                                                      .asset(
                                                                    'assets/images/ic_message_red.png',
                                                                    height: 30,
                                                                  ),
                                                                ),
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
                            height: 30,
                          ),
                          Visibility(
                            visible: isUser && snapshot.data!.body.status == 2,
                            child: ElevatedBtn(
                              text: 'Add Review',
                              onTap: (() {
                                Get.toNamed(Routes.ratingScreen, arguments: {
                                  'eventId': eventId,
                                  'userName':
                                      snapshot.data!.body.eventCreator.fullName,
                                  'userId': snapshot.data!.body.eventCreator.id
                                      .toString(),
                                  'userImage': snapshot
                                      .data!.body.eventCreator.profileImage,
                                  'userRating': '1'
                                });
                              }),
                              heignt: 45,
                            ),
                          ),
                          Visibility(
                            visible: isUser && snapshot.data!.body.status == 1,
                            child: ElevatedBtn(
                              text: 'Cancel Booking',
                              onTap: (() {
                                showDeclineDialog(
                                    snapshot.data!.body.id.toString(), true);
                              }),
                              heignt: 45,
                            ),
                          ),
                          Visibility(
                            visible: isUser && userStatus == 0,
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 20,
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
                                    showDeclineDialog(
                                        snapshot.data!.body.id.toString(),
                                        false);
                                  }),
                                  text: "Decline",
                                  heignt: 45,
                                )),
                                const SizedBox(
                                  width: 20,
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: !isUser && snapshot.data!.body.status == 0,
                            child: ElevatedBtn(
                              text: 'Invite Musicians',
                              onTap: () async {
                                await Get.toNamed(Routes.musicianCategoryScreen,
                                    arguments: {
                                      'eventId':
                                          snapshot.data!.body.id.toString()
                                    });
                                setState(() {});
                              },
                            ),
                          )
                        ],
                      ))
                ],
              ));
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

  showDeclineDialog(String eventId, bool isCancelBooking) {
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
                        text: isCancelBooking ? "Cancel" : "Decline",
                        textColor: AppColor.blackColor,
                        textAlign: TextAlign.center,
                        textSize: 16,
                        fontWeight: FontWeight.w500),
                    const SizedBox(
                      height: 10,
                    ),
                    AppText(
                        text: isCancelBooking
                            ? "Are you sure you want to cancel\nthis booking?"
                            : "Are you sure you want to decline\nthis request?",
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
                            isCancelBooking
                                ? cancelBooking(context, eventId)
                                : eventAcceptRejectApi(context, eventId, false);
                          },
                        )),
                      ],
                    )
                  ],
                ),
              ),
            ));
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

  Future cancelBooking(BuildContext ctx, String eventId) async {
    Map<String, String> data = {'eventId': eventId};
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
        Uri.parse(GlobalVariable.baseUrl + GlobalVariable.cancelBooking),
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
    print(body);

    var response = await http.put(
        Uri.parse(GlobalVariable.baseUrl + GlobalVariable.eventDetails),
        headers: await CommonFunctions().getHeader(),
        body: body);

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
      EventDetailResponse result = EventDetailResponse.fromJson(res);

      for (var item in result.body.eventBookings) {
        if (item.userId.toString() == userId) {
          userStatus = item.status;
        }
      }

      return result;
    } catch (error) {
      Fluttertoast.showToast(
          msg: error.toString().substring(
              error.toString().indexOf(':') + 1, error.toString().length),
          toastLength: Toast.LENGTH_SHORT);
      throw error.toString();
    }
  }
}
