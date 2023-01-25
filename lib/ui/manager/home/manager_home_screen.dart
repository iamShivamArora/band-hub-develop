import 'dart:convert';

import 'package:band_hub/routes/Routes.dart';
import 'package:band_hub/widgets/app_color.dart';
import 'package:band_hub/widgets/app_text.dart';
import 'package:band_hub/widgets/custom_text_field.dart';
import 'package:band_hub/widgets/elevated_btn.dart';
import 'package:band_hub/widgets/elevated_stroke_btn.dart';
import 'package:band_hub/widgets/helper_widget.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../models/auth/login_response_model.dart';
import '../../../models/manager/manager_home_response.dart';
import '../../../util/common_funcations.dart';
import '../../../util/global_variable.dart';
import '../../../util/sharedPref.dart';

class ManagerHomeScreen extends StatefulWidget {
  const ManagerHomeScreen({Key? key}) : super(key: key);

  @override
  State<ManagerHomeScreen> createState() => _ManagerHomeScreenState();
}

class _ManagerHomeScreenState extends State<ManagerHomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  PageController controller =
      PageController(viewportFraction: 1, keepPage: true);
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    searchCall();
    listingApi();
    getUserData();
    super.initState();
  }

  List<EventsListResponse> eventList = [];

  var userName = '';
  var userEmail = '';
  var userImage = '';

  void getUserData() async {
    var d = await SharedPref().getPreferenceJson();
    LoginResponseModel user = LoginResponseModel.fromJson(jsonDecode(d));
    userName = user.body.fullName;
    userEmail = user.body.email;
    userImage = user.body.profileImage;
    setState(() {});
    print('sdzx = =  ' + userName);
  }

  void searchCall() {
    searchController.addListener(() {
      if (eventList.isNotEmpty) {
        Future.delayed(const Duration(milliseconds: 800), () {
          if (searchController.text.trim().toString().isNotEmpty) {
            resultData!.body.EventsList.clear();
            resultData!.body.EventsList.addAll(eventList.where((i) => i.name
                .toLowerCase()
                .contains(
                    searchController.text.trim().toString().toLowerCase())));
            setState(() {});
            print(searchController.text.trim().toString());
          } else {
            resultData!.body.EventsList.clear();
            resultData!.body.EventsList.addAll(eventList);
            setState(() {});
          }
        });
      }
    });
  }

  ManagerHomeResponse? resultData;

  void listingApi() async {
    loading = true;
    resultData = await homeApi(context);
    eventList.addAll(resultData!.body.EventsList);
    loading = false;
    setState(() {});
  }

  var errorMsg = '';
  var loading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: HelperWidget.noAppBar(color: AppColor.appColor),
        backgroundColor: AppColor.whiteColor,
        floatingActionButton: InkWell(
          onTap: () async {
            await Get.toNamed(Routes.createEventScreen,
                arguments: {"isEdit": false});
            listingApi();
            setState(() {});
          },
          child: Image.asset(
            'assets/images/ic_red_plus.png',
            height: 55,
          ),
        ),
        drawer: Drawer(
          child: _drawerWidget(),
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusScope.of(context).requestFocus(FocusScopeNode()),
          child: Stack(
            children: [
              Container(color: AppColor.appColor, height: 95),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () => _scaffoldKey.currentState!.openDrawer(),
                          child: Container(
                              height: 35,
                              padding: const EdgeInsets.all(10),
                              child: Image.asset(
                                'assets/images/ic_menu.png',
                              )),
                        ),
                        AppText(
                          text: 'Home',
                          textColor: AppColor.whiteColor,
                          fontWeight: FontWeight.w600,
                        ),
                        InkWell(
                          onTap: () async {
                            await Get.toNamed(Routes.notificationScreen);
                            setState(() {});
                          },
                          child: Container(
                              height: 40,
                              padding: const EdgeInsets.all(10),
                              child: Image.asset(
                                'assets/images/ic_notification_white.png',
                              )),
                        ),
                      ],
                    ),
                    Container(
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: AppColor.grayColor.withAlpha(80),
                                blurRadius: 5.0,
                              ),
                            ]),
                        child: SimpleTf(
                            controller: searchController,
                            fillColor: AppColor.whiteColor,
                            titleVisibilty: false,
                            hint: 'Search...',
                            suffix: "assets/images/ic_search_black.png")),
                    Expanded(
                      child: errorMsg.isNotEmpty
                          ? Center(
                              child: AppText(
                              text: errorMsg,
                              fontWeight: FontWeight.w500,
                              textSize: 16,
                            ))
                          : loading
                              ? Center(child: CommonFunctions().loadingCircle())
                              : SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 220,
                                        width: Get.width,
                                        child: Stack(children: [
                                          PageView.builder(
                                            itemCount: resultData!
                                                .body.BannerList.length,
                                            controller: controller,
                                            onPageChanged: (value) {
                                              setState(() {});
                                            },
                                            itemBuilder: (BuildContext context,
                                                int itemIndex) {
                                              return CommonFunctions()
                                                  .setNetworkImages(
                                                      imageUrl: resultData!
                                                          .body
                                                          .BannerList[itemIndex]
                                                          .bannerImage,
                                                      height: 220,
                                                      width: MediaQuery.of(
                                                              Get.context!)
                                                          .size
                                                          .width,
                                                      circle: 15);
                                            },
                                          ),
                                          resultData!.body.BannerList.length ==
                                                  1
                                              ? Container()
                                              : Align(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  child: Container(
                                                    margin:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child: SmoothPageIndicator(
                                                        controller: controller,
                                                        // PageController
                                                        count: resultData!.body
                                                            .BannerList.length,
                                                        effect: ScrollingDotsEffect(
                                                            activeDotColor:
                                                                AppColor
                                                                    .appColor,
                                                            dotColor: AppColor
                                                                .grayColor
                                                                .withOpacity(
                                                                    .50),
                                                            spacing: 5,
                                                            dotHeight: 7,
                                                            dotWidth: 7),
                                                        // your preferred effect
                                                        onDotClicked:
                                                            (index) {}),
                                                  )),
                                        ]),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  AppText(
                                                    text: "Events",
                                                    textSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  const Spacer(),
                                                  resultData!.body.EventsList
                                                              .length >=
                                                          3
                                                      ? InkWell(
                                                          onTap: () async {
                                                            await Get.toNamed(Routes
                                                                .viewAllEventsScreen);
                                                            listingApi();
                                                            setState(() {});
                                                          },
                                                          child: AppText(
                                                            text: "View All",
                                                            textSize: 12,
                                                            textColor: AppColor
                                                                .appColor,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            underline: true,
                                                          ),
                                                        )
                                                      : Container()
                                                ],
                                              ),
                                              resultData!
                                                      .body.EventsList.isEmpty
                                                  ? Padding(
                                                      padding: EdgeInsets.only(
                                                          top: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.14),
                                                      child: Center(
                                                          child: AppText(
                                                        text: "No Event added",
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        textSize: 16,
                                                      )),
                                                    )
                                                  : ListView.builder(
                                                      shrinkWrap: true,
                                                      primary: false,
                                                      physics:
                                                          const NeverScrollableScrollPhysics(),
                                                      itemCount: resultData!
                                                                  .body
                                                                  .EventsList
                                                                  .length >=
                                                              3
                                                          ? 3
                                                          : resultData!
                                                              .body
                                                              .EventsList
                                                              .length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 10),
                                                          child: Column(
                                                            children: [
                                                              Stack(
                                                                children: [
                                                                  InkWell(
                                                                    onTap:
                                                                        () async {
                                                                      await Get.toNamed(
                                                                          Routes
                                                                              .managerEventDetailScreen,
                                                                          arguments: {
                                                                            'eventId':
                                                                                resultData!.body.EventsList[index].id.toString()
                                                                          });
                                                                      setState(
                                                                          () {});
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          220,
                                                                      margin: const EdgeInsets
                                                                              .symmetric(
                                                                          vertical:
                                                                              8),
                                                                      width: Get
                                                                          .width,
                                                                      foregroundDecoration:
                                                                          BoxDecoration(
                                                                        color: AppColor
                                                                            .blackColor
                                                                            .withAlpha(20),
                                                                        borderRadius:
                                                                            BorderRadius.circular(15),
                                                                      ),
                                                                      child: CommonFunctions().setNetworkImages(
                                                                          imageUrl: resultData!
                                                                              .body
                                                                              .EventsList[
                                                                                  index]
                                                                              .eventImages[
                                                                                  0]
                                                                              .images,
                                                                          height:
                                                                              220,
                                                                          width: double
                                                                              .infinity,
                                                                          circle:
                                                                              15,
                                                                          boxFit:
                                                                              BoxFit.cover),
                                                                    ),
                                                                  ),
                                                                  Positioned
                                                                      .fill(
                                                                    child:
                                                                        Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .bottomLeft,
                                                                      child:
                                                                          Container(
                                                                        margin:
                                                                            const EdgeInsets.all(20),
                                                                        child:
                                                                            Row(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.end,
                                                                          children: [
                                                                            Expanded(
                                                                              child: Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                children: [
                                                                                  AppText(
                                                                                    text: resultData!.body.EventsList[index].name,
                                                                                    textSize: 15,
                                                                                    fontWeight: FontWeight.w600,
                                                                                    textColor: AppColor.whiteColor,
                                                                                  ),
                                                                                  Row(children: [
                                                                                    Image.asset(
                                                                                      'assets/images/ic_location_mark.png',
                                                                                      height: 12,
                                                                                      color: AppColor.whiteColor,
                                                                                    ),
                                                                                    Expanded(
                                                                                      child: Padding(
                                                                                        padding: const EdgeInsets.only(left: 5.0, right: 8),
                                                                                        child: AppText(
                                                                                          overflow: TextOverflow.ellipsis,
                                                                                          text: resultData!.body.EventsList[index].location,
                                                                                          textSize: 12,
                                                                                          maxlines: 2,
                                                                                          fontWeight: FontWeight.w500,
                                                                                          textColor: AppColor.whiteColor,
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
                                                                                    await Get.toNamed(Routes.createEventScreen, arguments: {
                                                                                      "isEdit": true,
                                                                                      'data': resultData!.body.EventsList[index]
                                                                                    });
                                                                                    listingApi();
                                                                                    setState(() {});
                                                                                  },
                                                                                  child: SizedBox(
                                                                                    height: 20,
                                                                                    child: Center(
                                                                                      child: AppText(
                                                                                        text: "Edit  ",
                                                                                        textSize: 12,
                                                                                        fontWeight: FontWeight.w500,
                                                                                        textColor: AppColor.whiteColor,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Container(
                                                                                  height: 10,
                                                                                  width: 1,
                                                                                  color: AppColor.whiteColor,
                                                                                ),
                                                                                InkWell(
                                                                                  onTap: () => showActionDialog(resultData!.body.EventsList[index].id.toString()),
                                                                                  child: SizedBox(
                                                                                    height: 20,
                                                                                    child: AppText(
                                                                                      text: "   Delete",
                                                                                      textSize: 12,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      textColor: AppColor.whiteColor,
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
                                                                height:
                                                                    index == 2
                                                                        ? 70
                                                                        : 0,
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      })
                                            ],
                                          ))
                                    ],
                                  ),
                                ),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
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

  _drawerWidget() {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            CommonFunctions().setNetworkImages(
                imageUrl: userImage,
                height: 120,
                width: 120,
                circle: 70,
                boxFit: BoxFit.cover),
            const SizedBox(
              height: 15,
            ),
            AppText(
              text: userName,
              textSize: 18,
              fontWeight: FontWeight.w500,
            ),
            AppText(
              text: userEmail,
              textSize: 12,
            ),
            const SizedBox(
              height: 55,
            ),
            InkWell(
              onTap: () {
                Get.back();
              },
              child: Row(
                children: [
                  Image.asset('assets/images/ic_home_black.png', height: 18),
                  const SizedBox(
                    width: 25,
                  ),
                  AppText(
                    text: "Home",
                    textSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 35,
            ),
            InkWell(
              onTap: () async {
                Get.back();
                await Get.toNamed(Routes.profileScreen);
                getUserData();
              },
              child: Row(
                children: [
                  Image.asset('assets/images/ic_profile.png', height: 18),
                  const SizedBox(
                    width: 28,
                  ),
                  AppText(
                    text: "My Profile",
                    textSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 35,
            ),
            InkWell(
              onTap: () {
                Get.back();
                Get.toNamed(Routes.myOrdersScreen);
              },
              child: Row(
                children: [
                  Image.asset('assets/images/ic_orders.png', height: 18),
                  const SizedBox(
                    width: 25,
                  ),
                  AppText(
                    text: "My Orders",
                    textSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 35,
            ),
            InkWell(
              onTap: () {
                Get.back();
                Get.toNamed(Routes.managerSettingsScreen);
              },
              child: Row(
                children: [
                  Image.asset('assets/images/ic_settings.png', height: 18),
                  const SizedBox(
                    width: 25,
                  ),
                  AppText(
                    text: "Settings",
                    textSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 35,
            ),
            InkWell(
              onTap: () {
                Get.back();
                Get.toNamed(Routes.bookingScreen);
              },
              child: Row(
                children: [
                  Image.asset('assets/images/ic_calender.png', height: 18),
                  const SizedBox(
                    width: 25,
                  ),
                  AppText(
                    text: "Calendar",
                    textSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 35,
            ),
            InkWell(
              onTap: () {
                Get.back();
                Get.toNamed(Routes.providerMessageScreen);
              },
              child: Row(
                children: [
                  Image.asset('assets/images/ic_message.png', height: 18),
                  const SizedBox(
                    width: 25,
                  ),
                  AppText(
                    text: "Messages",
                    textSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 35,
            ),
            InkWell(
              onTap: () {
                Get.back();
                showLogoutDialog();
              },
              child: Row(
                children: [
                  Image.asset('assets/images/ic_logout_red.png', height: 18),
                  const SizedBox(
                    width: 25,
                  ),
                  AppText(
                      text: "Logout",
                      textSize: 16,
                      fontWeight: FontWeight.w500,
                      textColor: AppColor.appColor),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  showLogoutDialog() {
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
                      'assets/images/ic_logout.png',
                      height: 70,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    AppText(
                        text: "Logout",
                        textColor: AppColor.blackColor,
                        textAlign: TextAlign.center,
                        textSize: 16,
                        fontWeight: FontWeight.w500),
                    const SizedBox(
                      height: 10,
                    ),
                    AppText(
                        text: "Are you sure you want to logout?",
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
                            callLogoutApi(context);
                          },
                        )),
                      ],
                    )
                  ],
                ),
              ),
            ));
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

  Future callLogoutApi(BuildContext ctx) async {
    EasyLoading.show(status: 'Loading');
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (!(connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi)) {
      throw new Exception('NO INTERNET CONNECTION');
    }
    var response = await http.put(
        Uri.parse(GlobalVariable.baseUrl + GlobalVariable.logout),
        headers: await CommonFunctions().getHeader());

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
        // Fluttertoast.showToast(msg: error, toastLength: Toast.LENGTH_SHORT);
        // Navigator.pop(ctx);
        print("scasd  " + error);
        throw new Exception(error);
      }
      logoutCall();
      EasyLoading.dismiss();

      // return ApiSignUpDataModel.fromJson(json.decode(response.body));
    } catch (error) {
      EasyLoading.dismiss();

      Fluttertoast.showToast(
          msg: error.toString().substring(
              error.toString().indexOf(':') + 1, error.toString().length),
          toastLength: Toast.LENGTH_SHORT);
      throw error.toString();
    }
  }

  void logoutCall() {
    SharedPref().setToken("");
    Get.offAllNamed(Routes.logInScreen);
  }
}
