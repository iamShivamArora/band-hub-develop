import 'dart:convert';

import 'package:band_hub/routes/Routes.dart';
import 'package:band_hub/widgets/app_color.dart';
import 'package:band_hub/widgets/app_text.dart';
import 'package:band_hub/widgets/helper_widget.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../models/manager/manager_home_response.dart';
import '../../../util/common_funcations.dart';
import '../../../util/global_variable.dart';
import '../../../widgets/elevated_btn.dart';
import '../../../widgets/elevated_stroke_btn.dart';

class ViewAllEventsScreen extends StatefulWidget {
  const ViewAllEventsScreen({Key? key}) : super(key: key);

  @override
  State<ViewAllEventsScreen> createState() => _ViewAllEventsScreenState();
}

class _ViewAllEventsScreenState extends State<ViewAllEventsScreen> {
  // List<EventsListResponse> eventsList = [];

  @override
  void initState() {
    // eventsList = Get.arguments['eventList'] ?? [];
    // print(eventsList.toString());
    super.initState();
  }

  Future deleteEventApi(BuildContext ctx, String eventId) async {
    EasyLoading.show(status: 'Loading');
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (!(connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi)) {
      throw new Exception('NO INTERNET CONNECTION');
    }
    var body = {'eventId': eventId};
    var response = await http.put(
        Uri.parse(GlobalVariable.baseUrl + GlobalVariable.deleteEvent),
        headers: await CommonFunctions().getHeader(),
        body: body);

    print(response.body);
    try {
      Map<String, dynamic> res = json.decode(response.body);
      if (res['code'] == 403) {
        String error = res['msg'];
        Get.toNamed(Routes.logInScreen);
        throw new Exception(error);
      }
      if (res['code'] != 200 || res == null) {
        String error = res['msg'];
        print("scasd  " + error);
        throw new Exception(error);
      }
      EasyLoading.dismiss();

      Fluttertoast.showToast(msg: res['msg'], toastLength: Toast.LENGTH_SHORT);
      // eventsList.removeWhere((element) => element.id.toString() == eventId);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: HelperWidget.customAppBar(title: "All Events"),
        backgroundColor: AppColor.whiteColor,
        body: FutureBuilder<ManagerHomeResponse>(
            future: homeApi(context),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return snapshot.data!.body.EventsList.isEmpty
                    ? Center(
                        child: AppText(
                        text: "No Event added",
                        fontWeight: FontWeight.w500,
                        textSize: 16,
                      ))
                    : Padding(
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: ListView.builder(
                            shrinkWrap: true,
                            primary: false,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: snapshot.data!.body.EventsList.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  Stack(
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          await Get.toNamed(
                                              Routes.managerEventDetailScreen,
                                              arguments: {
                                                'eventId': snapshot.data!.body
                                                    .EventsList[index].id
                                                    .toString()
                                              });
                                          setState(() {});
                                        },
                                        child: Container(
                                          height: 220,
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 8),
                                          width: Get.width,
                                          foregroundDecoration: BoxDecoration(
                                            color: AppColor.blackColor
                                                .withAlpha(20),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: CommonFunctions()
                                              .setNetworkImages(
                                                  imageUrl: snapshot
                                                      .data!
                                                      .body
                                                      .EventsList[index]
                                                      .eventImages[0]
                                                      .images,
                                                  height: 220,
                                                  width: double.infinity,
                                                  circle: 15,
                                                  boxFit: BoxFit.cover),
                                        ),
                                      ),
                                      Positioned.fill(
                                        child: Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Container(
                                            margin: const EdgeInsets.all(20),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      AppText(
                                                        text: snapshot
                                                            .data!
                                                            .body
                                                            .EventsList[index]
                                                            .name,
                                                        textSize: 15,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        textColor:
                                                            AppColor.whiteColor,
                                                      ),
                                                      Row(children: [
                                                        Image.asset(
                                                          'assets/images/ic_location_mark.png',
                                                          height: 12,
                                                          color: AppColor
                                                              .whiteColor,
                                                        ),
                                                        Expanded(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 5.0,
                                                                    right: 8),
                                                            child: AppText(
                                                              maxlines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              text: snapshot
                                                                  .data!
                                                                  .body
                                                                  .EventsList[
                                                                      index]
                                                                  .location,
                                                              textSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              textColor: AppColor
                                                                  .whiteColor,
                                                            ),
                                                          ),
                                                        ),
                                                      ]),
                                                    ],
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    InkWell(
                                                      onTap: () async {
                                                        await Get.toNamed(
                                                            Routes
                                                                .createEventScreen,
                                                            arguments: {
                                                              "isEdit": true,
                                                              'data': snapshot
                                                                      .data!
                                                                      .body
                                                                      .EventsList[
                                                                  index]
                                                            });
                                                        setState(() {});
                                                      },
                                                      child: SizedBox(
                                                        height: 20,
                                                        child: Center(
                                                          child: AppText(
                                                            text: "Edit  ",
                                                            textSize: 12,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            textColor: AppColor
                                                                .whiteColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 10,
                                                      width: 1,
                                                      color:
                                                          AppColor.whiteColor,
                                                    ),
                                                    InkWell(
                                                      onTap: () =>
                                                          showActionDialog(
                                                              snapshot
                                                                  .data!
                                                                  .body
                                                                  .EventsList[
                                                                      index]
                                                                  .id
                                                                  .toString()),
                                                      child: SizedBox(
                                                        height: 20,
                                                        child: AppText(
                                                          text: "   Delete",
                                                          textSize: 12,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          textColor: AppColor
                                                              .whiteColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Align(
                                      //   alignment: Alignment.topRight,
                                      //   child: Padding(
                                      //     padding:
                                      //         const EdgeInsets.fromLTRB(
                                      //             0, 20, 15, 0),
                                      //     child: Image.asset(
                                      //       'assets/images/ic_gray_heart.png',
                                      //       height: 40,
                                      //     ),
                                      //   ),
                                      // )
                                    ],
                                  ),
                                  SizedBox(
                                    height: index == 2 ? 20 : 0,
                                  ),
                                ],
                              );
                            }));
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

  Future<ManagerHomeResponse> homeApi(BuildContext ctx) async {
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
        Uri.parse(GlobalVariable.baseUrl + GlobalVariable.managerHome),
        headers: await CommonFunctions().getHeader());

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
      ManagerHomeResponse result = ManagerHomeResponse.fromJson(res);
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

  showActionDialog(String eventId) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: SizedBox(
                  height: 320,
                  child: Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(
                            vertical: 30, horizontal: 20),
                        margin: const EdgeInsets.only(top: 50),
                        decoration: BoxDecoration(
                          color: AppColor.whiteColor,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              height: 40,
                            ),
                            AppText(
                                text:
                                'Are you sure you want to detete\nthis event?',
                                textColor: AppColor.blackColor,
                                textAlign: TextAlign.center,
                                textSize: 12,
                                fontWeight: FontWeight.w500),
                            const SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: ElevatedBtn(
                                  text: 'Yes',
                                  buttonColor: AppColor.appColor,
                                  textColor: AppColor.whiteColor,
                                  onTap: () {
                                    Get.back();
                                    deleteEventApi(context, eventId);
                                  },
                                  width: 240),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: ElevatedStrokeBtn(
                                  text: 'No',
                                  buttonColor: AppColor.blackColor,
                                  textColor: AppColor.blackColor,
                                  onTap: () {
                                    Get.back();
                                  },
                                  width: 240),
                            )
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Image.asset(
                          'assets/images/ic_delete.png',
                          height: 100,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }
}
