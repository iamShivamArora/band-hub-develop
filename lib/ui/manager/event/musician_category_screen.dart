import 'dart:convert';

import 'package:band_hub/routes/Routes.dart';
import 'package:band_hub/widgets/app_color.dart';
import 'package:band_hub/widgets/app_text.dart';
import 'package:band_hub/widgets/custom_text_field.dart';
import 'package:band_hub/widgets/helper_widget.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../models/get_categories_response.dart';
import '../../../util/common_funcations.dart';
import '../../../util/global_variable.dart';

class MusicianCategoryScreen extends StatefulWidget {
  const MusicianCategoryScreen({Key? key}) : super(key: key);

  @override
  State<MusicianCategoryScreen> createState() => _MusicianCategoryScreenState();
}

class _MusicianCategoryScreenState extends State<MusicianCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HelperWidget.customAppBar(title: 'Categories'),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusScope.of(context).requestFocus(FocusScopeNode()),
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
                    fillColor: AppColor.whiteColor,
                    titleVisibilty: false,
                    hint: 'Search by Categoies',
                    suffix: "assets/images/ic_search_black.png")),
            const SizedBox(
              height: 25,
            ),
            FutureBuilder<GetCategoriesResponse>(
                future: categoryListApi(context),
                builder: (context, snapshot) {
              if (snapshot.hasData) {
                return GridView.builder(
                    shrinkWrap: true,
                    primary: false,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      crossAxisCount: 2,
                      childAspectRatio: MediaQuery.of(context).size.width /
                          (MediaQuery.of(context).size.height / 2.6),
                    ),
                    itemCount: snapshot.data!.body.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          InkWell(
                            onTap: () {
                              Get.toNamed(Routes.nearbyMusicianScreen,arguments: {
                                'catId':snapshot.data!.body[index].id.toString()
                              });
                            },
                            child: Container(
                              height: Get.height,
                              width: Get.width,
                              foregroundDecoration: BoxDecoration(
                                color: AppColor.blackColor.withAlpha(20),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.asset(
                                  'assets/images/ic_placeholder.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Container(
                                margin: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    AppText(
                                      text: snapshot.data!.body[index].name,
                                      textSize: 15,
                                      fontWeight: FontWeight.w600,
                                      textColor: AppColor.whiteColor,
                                    ),
                                    /*Row(children: [
                                      Image.asset(
                                        'assets/images/ic_location_mark.png',
                                        height: 12,
                                        color: AppColor.whiteColor,
                                      ),
                                      AppText(
                                        text: " New York",
                                        textSize: 12,
                                        fontWeight: FontWeight.w500,
                                        textColor: AppColor.whiteColor,
                                      ),
                                    ])*/
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
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
            })
          ]),
        ),
      ),
    );
  }

  Future<GetCategoriesResponse> categoryListApi(BuildContext ctx) async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (!(connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi)) {
      throw new Exception('NO INTERNET CONNECTION');
    }
    var response = await http.get(
        Uri.parse(GlobalVariable.baseUrl + GlobalVariable.getCategories),
        headers: await CommonFunctions().getHeader());

    print(response.body);
    try {
      Map<String, dynamic> res = json.decode(response.body);

      if (res['code'] != 200 || res == null) {
        String error = res['msg'];

        print("scasd  " + error);
        throw new Exception(error);
      }
      GetCategoriesResponse result = GetCategoriesResponse.fromJson(res);

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
