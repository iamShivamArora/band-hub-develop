import 'dart:convert';

import 'package:band_hub/routes/Routes.dart';
import 'package:band_hub/widgets/app_color.dart';
import 'package:band_hub/widgets/app_text.dart';
import 'package:band_hub/widgets/elevated_btn.dart';
import 'package:band_hub/widgets/helper_widget.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../models/event_detail_response.dart';
import '../../../util/common_funcations.dart';
import '../../../util/global_variable.dart';
class ManagerEventDetailScreen extends StatefulWidget {
  const ManagerEventDetailScreen({Key? key}) : super(key: key);

  @override
  State<ManagerEventDetailScreen> createState() =>
      _ManagerEventDetailScreenState();
}

class _ManagerEventDetailScreenState extends State<ManagerEventDetailScreen> {
  String eventId = "";
  String isFromCurrent = "";
  PageController controller =
      PageController(viewportFraction: 1, keepPage: true);

  @override
  void initState() {
    eventId = Get.arguments['eventId'] ?? "";
    isFromCurrent = Get.arguments['isFromCurrent'] ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HelperWidget.customAppBar(title: 'Details'),
      body:
      FutureBuilder<EventDetailResponse>(
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
                            itemCount: snapshot
                                .data!.body.eventImages.length,
                            controller: controller,
                            onPageChanged: (value) {
                              setState(() {});
                            },
                            itemBuilder: (BuildContext context,
                                int itemIndex) {
                              return CommonFunctions()
                                  .setNetworkImages(
                                  imageUrl:
                                  snapshot
                                      .data!
                                      .body
                                      .eventImages[itemIndex]
                                      .images,
                                  height: 260,
                                  boxFit: BoxFit.cover,
                                  width: MediaQuery.of(
                                      Get.context!)
                                      .size
                                      .width);
                            },
                          ),
                          snapshot.data!.body.eventImages.length == 1
                              ? Container()
                              : Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                margin:
                                const EdgeInsets.all(10),
                                child: SmoothPageIndicator(
                                    controller: controller,
                                    // PageController
                                    count: snapshot.data!.body
                                        .eventImages.length,
                                    effect: ScrollingDotsEffect(
                                        activeDotColor:
                                        AppColor.appColor,
                                        dotColor: AppColor
                                            .grayColor
                                            .withOpacity(.50),
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
                                          children: [
                                            Image.asset(
                                                'assets/images/ic_location_mark.png',
                                                height: 12),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 5.0),
                                                child: AppText(
                                                  text: snapshot.data!.body.location,
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
                                height: 25,
                              ),
                              AppText(
                                text:
                                snapshot.data!.body.description,
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
                                    text: CommonFunctions().getStatusType(
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
                            height: 40,
                          ),
                          ElevatedBtn(
                            text: 'Invite Musicians',
                            onTap: () => Get.toNamed(
                                Routes.musicianCategoryScreen,
                                arguments: {
                                  'eventId': snapshot.data!.body.id.toString()
                                }),
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
}
