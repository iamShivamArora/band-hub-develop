import 'dart:convert';

import 'package:band_hub/util/global_variable.dart';
import 'package:band_hub/widgets/app_color.dart';
import 'package:band_hub/widgets/app_text.dart';
import 'package:band_hub/widgets/helper_widget.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

import '../../models/auth/notification_listing_response.dart';
import '../../util/common_funcations.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: HelperWidget.customAppBar(title: 'Notifications'),
        body:
        FutureBuilder<NotificationListingResponse>(
            future: notificationListApi(context),
            builder: (context, snapshot) {
          if (snapshot.hasData) {
            return
              snapshot.data!.body.isEmpty
                  ? Center(
                  child: AppText(
                    text: "No Notification Found",
                    fontWeight: FontWeight.w500,
                    textSize: 16,
                  ))
                  :SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.body.length,
                    shrinkWrap: true,
                    itemBuilder: ((context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 15),
                        decoration: BoxDecoration(
                            color: AppColor.whiteColor,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: AppColor.grayColor.withAlpha(80),
                                blurRadius: 5.0,
                                offset: const Offset(2, 2),
                              ),
                            ]),
                        child: Column(
                          children: [
                            Row(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CommonFunctions().setNetworkImages(
                                    imageUrl: snapshot.data!.body[index]
                                        .user.profileImage,
                                    circle: 30,height: 60,width: 60),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      mainAxisAlignment: MainAxisAlignment
                                          .center,
                                      children: [
                                        Row(
                                          children: [
                                            AppText(
                                              text: snapshot.data!.body[index]
                                                  .user.fullName,
                                              textSize: 13,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            const Spacer(),
                                            AppText(
                                              text: CommonFunctions().timeAgoFormat(snapshot.data!.body[index].createdAt),
                                              textSize: 10,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 2,
                                            ),
                                            AppText(
                                              text: snapshot
                                                  .data!.body[index].message,
                                              textSize: 13,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            const SizedBox(
                                              height: 3,
                                            ),
                                            SmoothStarRating(
                                              allowHalfRating: false,
                                              starCount: 5,
                                              rating: 2,
                                              size: 15.0,
                                              color: Colors.amber,
                                              borderColor: Colors.amber,
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            /* Row(
                                          children: [
                                            AppText(
                                              text: "Start Date & Time",
                                              textSize: 10,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            const Spacer(),
                                            AppText(
                                              text: "End Date & Time",
                                              textSize: 10,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            AppText(
                                              text: "13.07.2022 | 12:30PM",
                                              textSize: 9,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            const Spacer(),
                                            AppText(
                                              text: "13.07.2022 | 12:30PM",
                                              textSize: 9,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ],
                                        ),*/
                                          ],
                                    ))
                              ],
                            ),
                          ],
                        ),
                      );
                    })));
          }
          else if (snapshot.hasError) {
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
  Future<NotificationListingResponse> notificationListApi(BuildContext ctx) async {

    var connectivityResult = await (Connectivity().checkConnectivity());

    if (!(connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi)) {
      throw new Exception('NO INTERNET CONNECTION');
    }
    var response = await http.get(
        Uri.parse(GlobalVariable.baseUrl + GlobalVariable.notificationList),
        headers: await CommonFunctions().getHeader());

    print(response.body);
    try {
      Map<String, dynamic> res = json.decode(response.body);

      if (res['code'] != 200 || res == null) {
        String error = res['msg'];

        print("scasd  " + error);
        throw new Exception(error);
      }
      NotificationListingResponse result = NotificationListingResponse.fromJson(res);

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
