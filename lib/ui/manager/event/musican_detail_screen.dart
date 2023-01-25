import 'dart:convert';

import 'package:band_hub/routes/Routes.dart';
import 'package:band_hub/widgets/app_color.dart';
import 'package:band_hub/widgets/app_text.dart';
import 'package:band_hub/widgets/helper_widget.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

import '../../../models/user_detail_response.dart';
import '../../../util/common_funcations.dart';
import '../../../util/global_variable.dart';
import '../../../widgets/elevated_btn.dart';

class MusicianDetailScreen extends StatefulWidget {
  const MusicianDetailScreen({Key? key}) : super(key: key);

  @override
  State<MusicianDetailScreen> createState() => _MusicianDetailScreenState();
}

class _MusicianDetailScreenState extends State<MusicianDetailScreen> {
  var userId = '';
  var eventId = '';

  @override
  void initState() {
    userId = Get.arguments['userId'] ?? "";
    eventId = Get.arguments['eventId'] ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: HelperWidget.customAppBar(title: 'Details'),
        body: FutureBuilder<UserDetailResponse>(
            future: userDetailApi(context),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SingleChildScrollView(
                    child: Column(
                  children: [
                    CommonFunctions().setNetworkImages(
                        imageUrl: snapshot.data!.body.profileImage,
                        width: Get.width,
                        height: 260,
                        boxFit: BoxFit.cover),
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
                                        text: snapshot.data!.body.fullName,
                                        textSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      AppText(
                                        text: snapshot.data!.body.categoryName,
                                        textSize: 13,
                                        fontWeight: FontWeight.w400,
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
                                              fontWeight: FontWeight.w400,
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
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    changeFavStatusApi(context,
                                        snapshot.data!.body.id.toString(), "1");
                                  },
                                  child: Image.asset(
                                    'assets/images/ic_gray_heart.png',
                                    height: 35,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: snapshot.data!.body.description.isEmpty
                                  ? 0
                                  : 25,
                            ),
                            AppText(
                              text: snapshot.data!.body.description,
                              textSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                            SizedBox(
                              height: snapshot.data!.body.description.isEmpty
                                  ? 5
                                  : 15,
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
                              text: "Reviews",
                              textSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            ListView.builder(
                                shrinkWrap: true,
                                itemCount: 1,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: ((context, index) {
                                  return InkWell(
                                    onTap: () {
                                      // Get.toNamed(Routes.musicianDetailScreen);
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
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              CommonFunctions()
                                                  .setNetworkImages(
                                                      imageUrl: snapshot
                                                          .data!
                                                          .body
                                                          .ratingTo
                                                          .user
                                                          .profileImage,
                                                      height: 65,
                                                      width: 65,
                                                      circle: 40,
                                                      isUser: true),
                                              const SizedBox(
                                                width: 15,
                                              ),
                                              Expanded(
                                                  child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        child: AppText(
                                                          text: snapshot
                                                              .data!
                                                              .body
                                                              .ratingTo
                                                              .user
                                                              .fullName,
                                                          textSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 5.0),
                                                        child: AppText(
                                                            text: CommonFunctions()
                                                                .timeAgoFormat(
                                                                    snapshot
                                                                        .data!
                                                                        .body
                                                                        .ratingTo
                                                                        .createdAt),
                                                            textSize: 10),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 2,
                                                  ),
                                                  SmoothStarRating(
                                                    allowHalfRating: false,
                                                    starCount: 5,
                                                    rating: snapshot.data!.body
                                                        .ratingTo.rating
                                                        .toDouble(),
                                                    size: 15.0,
                                                    color: Colors.amber,
                                                    borderColor: Colors.amber,
                                                  ),
                                                ],
                                              ))
                                            ],
                                          ),
                                          AppText(
                                            text: snapshot
                                                .data!.body.ratingTo.message,
                                            textSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                })),
                            const SizedBox(
                              height: 20,
                            ),
                            ElevatedBtn(
                              text: ' Send Invitation ',
                              onTap: () {
                                sendInviteToUser(context, userId);
                              },
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
            }));
  }

  Future<UserDetailResponse> userDetailApi(BuildContext ctx) async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (!(connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi)) {
      throw new Exception('NO INTERNET CONNECTION');
    }
    var body = {'userId': userId};
    var response = await http.put(
        Uri.parse(GlobalVariable.baseUrl + GlobalVariable.userDetail),
        headers: await CommonFunctions().getHeader(),
        body: body);

    print(response.body);
    try {
      Map<String, dynamic> res = json.decode(response.body);

      if (res['code'] != 200 || res == null) {
        String error = res['msg'];

        print("scasd  " + error);
        throw new Exception(error);
      }
      UserDetailResponse result = UserDetailResponse.fromJson(res);

      return result;
    } catch (error) {
      Fluttertoast.showToast(
          msg: error.toString().substring(
              error.toString().indexOf(':') + 1, error.toString().length),
          toastLength: Toast.LENGTH_SHORT);
      throw error.toString();
    }
  }

  Future<bool> changeFavStatusApi(
      BuildContext ctx, String id, String status) async {
    Map<String, String> data = {
      'id': id,
      'status': status //1= favourite , 2 = unfavourite
    };
    EasyLoading.show(status: 'Loading');
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (!(connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi)) {
      throw new Exception('NO INTERNET CONNECTION');
    }
    var response = await http.post(
        Uri.parse(GlobalVariable.baseUrl + GlobalVariable.favAndUnfav),
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
      Fluttertoast.showToast(msg: res['msg'], toastLength: Toast.LENGTH_SHORT);
      return res['code'] != 200;
    } catch (error) {
      EasyLoading.dismiss();

      Fluttertoast.showToast(
          msg: error.toString().substring(
              error.toString().indexOf(':') + 1, error.toString().length),
          toastLength: Toast.LENGTH_SHORT);
      throw error.toString();
    }
  }

  Future sendInviteToUser(BuildContext ctx, String userId) async {
    Map<String, String> data = {'userId': userId, 'eventId': eventId};
    EasyLoading.show(status: 'Loading');
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (!(connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi)) {
      throw new Exception('NO INTERNET CONNECTION');
    }
    var response = await http.post(
        Uri.parse(GlobalVariable.baseUrl + GlobalVariable.inviteUsers),
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
      Fluttertoast.showToast(msg: res['msg'], toastLength: Toast.LENGTH_SHORT);
      Get.back();
      return res['code'] != 200;
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
