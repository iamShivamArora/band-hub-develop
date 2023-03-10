import 'dart:convert';

import 'package:band_hub/routes/Routes.dart';
import 'package:band_hub/widgets/app_color.dart';
import 'package:band_hub/widgets/app_text.dart';
import 'package:band_hub/widgets/custom_text_field.dart';
import 'package:band_hub/widgets/helper_widget.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../models/manager/musician_listing_response.dart';
import '../../../util/common_funcations.dart';
import '../../../util/global_variable.dart';
import '../../../widgets/elevated_btn.dart';
import '../../../widgets/elevated_stroke_btn.dart';

class NearbyMusicianScreen extends StatefulWidget {
  const NearbyMusicianScreen({Key? key}) : super(key: key);

  @override
  State<NearbyMusicianScreen> createState() => _NearbyMusicianScreenState();
}

class _NearbyMusicianScreenState extends State<NearbyMusicianScreen> {
  var catId = "";
  var eventId = "";
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    catId = Get.arguments['catId'] ?? "";
    eventId = Get.arguments['eventId'] ?? "";

    searchCall();
    listingApi();
    super.initState();
  }

  MusicianListingResponse? resultData;
  List<MusicianBody> musicianList = [];

  void searchCall() {
    searchController.addListener(() {
      if (musicianList.isNotEmpty) {
        Future.delayed(const Duration(milliseconds: 800), () {
          if (searchController.text.trim().toString().isNotEmpty) {
            resultData!.body.clear();
            resultData!.body.addAll(musicianList.where((i) => i.fullName
                .toLowerCase()
                .contains(
                    searchController.text.trim().toString().toLowerCase())));
            setState(() {});
            print(searchController.text.trim().toString());
          } else {
            resultData!.body.clear();
            resultData!.body.addAll(musicianList);
            setState(() {});
          }
        });
      }
    });
  }

  void listingApi() async {
    resultData = await musicianListApi(context);
    musicianList.addAll(resultData!.body);
    loading = false;
    setState(() {});
  }

  var errorMsg = '';
  var loading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: HelperWidget.customAppBar(title: 'Nearby Musicians'),
        body: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () =>
                  FocusScope.of(context).requestFocus(FocusScopeNode()),
              child: SingleChildScrollView(
                child: Column(children: [
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                                color: AppColor.grayColor.withAlpha(40),
                                blurRadius: 10.0,
                                offset: const Offset(2, 2)),
                          ]),
                      child: SimpleTf(
                          controller: searchController,
                          fillColor: AppColor.whiteColor,
                          titleVisibilty: false,
                          hint: 'Search',
                          suffix: "assets/images/ic_search_black.png")),
                  const SizedBox(
                    height: 25,
                  ),
                  errorMsg.isNotEmpty
                      ? Center(
                          child: AppText(
                          text: errorMsg,
                          fontWeight: FontWeight.w500,
                          textSize: 16,
                        ))
                      : loading
                          ? Center(child: CommonFunctions().loadingCircle())
                          : resultData!.body.isEmpty
                              ? Center(
                                  child: AppText(
                                  text: "No Musician Found",
                                  fontWeight: FontWeight.w500,
                                  textSize: 16,
                                ))
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: resultData!.body.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: ((context, index) {
                                    return InkWell(
                                      onTap: () async {
                                        if (!EasyLoading.isShow) {
                                          await Get.toNamed(
                                              Routes.musicianDetailScreen,
                                              arguments: {
                                                'userId': resultData!
                                                    .body[index].id
                                                    .toString(),
                                                'eventId': eventId,
                                                'isInvited': resultData!
                                                        .body[index]
                                                        .isInvited ==
                                                    1
                                              });
                                          listingApi();
                                          setState(() {});
                                        }
                                      },
                                      child: Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 15),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 10),
                                        decoration: BoxDecoration(
                                            color: AppColor.whiteColor,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            boxShadow: [
                                              BoxShadow(
                                                color: AppColor.grayColor
                                                    .withAlpha(40),
                                                blurRadius: 10.0,
                                                offset: const Offset(2, 2),
                                              ),
                                            ]),
                                        child: Row(
                                          children: [
                                            CommonFunctions().setNetworkImages(
                                                imageUrl: resultData!
                                                    .body[index].profileImage,
                                                height: 65,
                                                width: 65),
                                            const SizedBox(
                                              width: 15,
                                            ),
                                            Expanded(
                                                child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                AppText(
                                                  text: resultData!
                                                      .body[index].fullName,
                                                  textSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                const SizedBox(
                                                  height: 2,
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    resultData!.body[index]
                                                                .distance ==
                                                            null
                                                        ? Container()
                                                        : Row(
                                                            children: [
                                                              Image.asset(
                                                                  'assets/images/ic_location_mark.png',
                                                                  height: 12),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            8.0),
                                                                child: AppText(
                                                                  text: resultData!
                                                                              .body[
                                                                                  index]
                                                                              .distance ==
                                                                          null
                                                                      ? ""
                                                                      : resultData!
                                                                          .body[
                                                                              index]
                                                                          .distance
                                                                          .toString(),
                                                                  textSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                  ],
                                                )
                                              ],
                                            )),
                                            Column(
                                              children: [
                                                GestureDetector(
                                                  onTap: () async {
                                                    if (!EasyLoading.isShow) {
                                                      var success =
                                                          await changeFavStatusApi(
                                                              context,
                                                              resultData!
                                                                  .body[index]
                                                                  .id
                                                                  .toString(),
                                                              //resultData!.body[index].isFav ? "2":
                                                              "1");
                                                      // if(success){
                                                      //  resultData!.body[index].isFav = !snapshot.data!.body[index].isFav;
                                                      // }
                                                      setState(() {});
                                                    }
                                                  },
                                                  child: Image.asset(
                                                    //resultData!.body[index].isFav?
                                                    // 'assets/images/ic_red_heart.png':
                                                    'assets/images/ic_gray_heart.png',
                                                    height: 35,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                resultData!.body[index]
                                                            .isInvited ==
                                                        0
                                                    ? GestureDetector(
                                                        onTap: () {
                                                          if (!EasyLoading
                                                              .isShow) {
                                                            showDeclineDialog(
                                                                resultData!
                                                                    .body[index]
                                                                    .fullName,
                                                                resultData!
                                                                    .body[index]
                                                                    .id
                                                                    .toString());
                                                          }
                                                        },
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5),
                                                          decoration: BoxDecoration(
                                                              color: AppColor
                                                                  .appColor,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5)),
                                                          child: AppText(
                                                            text:
                                                                ' Send Invitation ',
                                                            textSize: 8,
                                                            textColor: AppColor
                                                                .whiteColor,
                                                          ),
                                                        ),
                                                      )
                                                    : Container()
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  }))
                ]),
              ),
            )));
  }

  Future<MusicianListingResponse> musicianListApi(BuildContext ctx) async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (!(connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi)) {
      throw new Exception('NO INTERNET CONNECTION');
    }
    var body = {'categoryId': catId, 'eventId': eventId};
    var response = await http.put(
        Uri.parse(GlobalVariable.baseUrl + GlobalVariable.userListByCat),
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
      MusicianListingResponse result = MusicianListingResponse.fromJson(res);

      return result;
    } catch (error) {
      errorMsg = error.toString().substring(
          error.toString().indexOf(':') + 1, error.toString().length);
      Fluttertoast.showToast(
          msg: error.toString().substring(
              error.toString().indexOf(':') + 1, error.toString().length),
          toastLength: Toast.LENGTH_SHORT);
      setState(() {});
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
      listingApi();
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

  showDeclineDialog(String username, String userId) {
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
                      'assets/images/ic_question_mark.png',
                      height: 70,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    AppText(
                        text:
                            "Are you sure you want to send\ninvite to $username?",
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
                            sendInviteToUser(context, userId);
                          },
                        )),
                      ],
                    )
                  ],
                ),
              ),
            ));
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
      listingApi();
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
