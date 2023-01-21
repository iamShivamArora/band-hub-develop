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
import '../../../models/manager/fav_musician_response.dart';
import '../../../util/common_funcations.dart';
import '../../../util/global_variable.dart';

class FavouriteEventScreen extends StatefulWidget {
  const FavouriteEventScreen({Key? key}) : super(key: key);

  @override
  State<FavouriteEventScreen> createState() => _FavouriteEventScreenState();
}

class _FavouriteEventScreenState extends State<FavouriteEventScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: HelperWidget.customAppBar(title: "Favourite Musician"),
        body: FutureBuilder<FavMusicianResponse>(
            future: favListApi(context),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return snapshot.data!.body.isEmpty
                    ? Center(
                    child: AppText(
                      text: "No Musician Found",
                      fontWeight: FontWeight.w500,
                      textSize: 16,
                    ))
                    :Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: snapshot.data!.body.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Get.toNamed(Routes.musicianDetailScreen);
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 20),
                            decoration: BoxDecoration(
                                color: AppColor.whiteColor,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColor.grayColor.withAlpha(80),
                                    blurRadius: 5.0,
                                  ),
                                ]),
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      height: 220,
                                      width: Get.width,
                                      foregroundDecoration: BoxDecoration(
                                        color:
                                            AppColor.blackColor.withAlpha(20),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: CommonFunctions().setNetworkImages(
                                          imageUrl: snapshot.data!.body[index]
                                              .user.profileImage,
                                          circle: 15),
                                    ),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: GestureDetector(
                                        onTap: (){
                                          changeFavStatusApi(context, snapshot.data!.body[index].musicianId.toString());
                                          },
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 20, 15, 0),
                                          child: Image.asset(
                                            'assets/images/ic_red_heart.png',
                                            height: 40,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      AppText(
                                        text: snapshot
                                            .data!.body[index].user.fullName,
                                        textSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      Row(children: [
                                        Image.asset(
                                          'assets/images/ic_location_mark.png',
                                          height: 12,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 5.0),
                                          child: AppText(
                                            text: snapshot.data!.body[index]
                                                .user.location,
                                            textSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ]),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
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
            }));
  }

  Future<FavMusicianResponse> favListApi(BuildContext ctx) async {
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
        Uri.parse(GlobalVariable.baseUrl + GlobalVariable.getFav),
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
      FavMusicianResponse result = FavMusicianResponse.fromJson(res);
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
  Future changeFavStatusApi(
      BuildContext ctx, String id) async {
    Map<String, String> data = {
      'id': id,
      'status': "2"  //1= favourite , 2 = unfavourite
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
