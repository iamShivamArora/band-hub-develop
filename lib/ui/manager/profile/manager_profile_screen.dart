import 'dart:convert';

import 'package:band_hub/routes/Routes.dart';
import 'package:band_hub/widgets/helper_widget.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

import '../../../models/user_detail_response.dart';
import '../../../util/common_funcations.dart';
import '../../../util/global_variable.dart';
import '../../../widgets/app_color.dart';
import '../../../widgets/app_text.dart';

class ManagerProfileScreen extends StatefulWidget {
  const ManagerProfileScreen({Key? key}) : super(key: key);

  @override
  State<ManagerProfileScreen> createState() => _ManagerProfileScreenState();
}

class _ManagerProfileScreenState extends State<ManagerProfileScreen> {
  var userId = '';
  var eventId = '';
  var avyRating = 0.0;

  @override
  void initState() {
    userId = Get.arguments['userId'] ?? "";
    eventId = Get.arguments['eventId'] ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HelperWidget.customAppBar(title: "Manager's Profile"),
      body: FutureBuilder<UserDetailResponse>(
          future: userDetailApi(context),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: CommonFunctions().setNetworkImages(
                          imageUrl: snapshot.data!.body.profileImage,
                          width: 100,
                          height: 100,
                          isUser: true,
                          circle: 60,
                          boxFit: BoxFit.cover),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: AppText(
                        text: snapshot.data!.body.fullName,
                        textSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Center(
                      child: AppText(
                        text: snapshot.data!.body.email,
                        textSize: 12,
                      ),
                    ),
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          snapshot.data!.body.rateCount == 0
                              ? Container()
                              : SmoothStarRating(
                                  allowHalfRating: false,
                                  starCount: 5,
                                  rating: avyRating,
                                  size: 15.0,
                                  color: Colors.amber,
                                  borderColor: Colors.amber,
                                ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: AppText(
                              text: snapshot.data!.body.rateCount == 0
                                  ? "No Review"
                                  : snapshot.data!.body.rateCount.toString() +
                                      " Review",
                              textSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                text: "About",
                                textSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              AppText(
                                text: snapshot.data!.body.description,
                                textSize: 11,
                                fontWeight: FontWeight.w400,
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: eventId.isNotEmpty,
                          child: InkWell(
                            onTap: () {
                              Get.toNamed(Routes.userChatScreen);
                            },
                            child: Image.asset(
                              'assets/images/ic_message_red.png',
                              height: 35,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    snapshot.data!.body.ratingTo.isNotEmpty
                        ? Row(
                            children: [
                              AppText(
                                text: "Reviews",
                                textSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                              const Spacer(),
                              Visibility(
                                visible:
                                    snapshot.data!.body.ratingTo.length > 3,
                                child: InkWell(
                                  onTap: () => Get.toNamed(Routes.reviewScreen),
                                  child: AppText(
                                    text: "View All",
                                    textSize: 12,
                                    underline: true,
                                    textColor: AppColor.appColor,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Container(),
                    const SizedBox(
                      height: 10,
                    ),
                    ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.body.ratingTo.length,
                        shrinkWrap: true,
                        itemBuilder: ((context, index) {
                          return snapshot.data!.body.ratingTo[index].id == null
                              ? Container()
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        CommonFunctions().setNetworkImages(
                                            imageUrl: snapshot
                                                .data!
                                                .body
                                                .ratingTo[index]
                                                .user
                                                .profileImage!,
                                            height: 50,
                                            width: 50,
                                            circle: 40,
                                            isUser: true),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Expanded(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                AppText(
                                                  text: snapshot
                                                      .data!
                                                      .body
                                                      .ratingTo[index]
                                                      .user
                                                      .fullName!,
                                                  textSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                const Spacer(),
                                                AppText(
                                                  text: CommonFunctions()
                                                      .timeAgoFormat(snapshot
                                                          .data!
                                                          .body
                                                          .ratingTo[index]
                                                          .createdAt!),
                                                  textSize: 10,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 3,
                                            ),
                                            SmoothStarRating(
                                              allowHalfRating: false,
                                              starCount: 5,
                                              rating: snapshot.data!.body
                                                  .ratingTo[index].rating!
                                                  .toDouble(),
                                              size: 15.0,
                                              color: Colors.amber,
                                              borderColor: Colors.amber,
                                            ),
                                          ],
                                        ))
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    AppText(
                                      text: snapshot
                                          .data!.body.ratingTo[index].message!,
                                      textSize: 11,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Divider(
                                      height: 10,
                                      color:
                                          AppColor.grayColor.withOpacity(.30),
                                      thickness: 1.2,
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                  ],
                                );
                        }))
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
      var total = 0.0;
      for (var item in result.body.ratingTo) {
        total = total + item.rating!;
      }
      avyRating = total / result.body.ratingTo.length;

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
