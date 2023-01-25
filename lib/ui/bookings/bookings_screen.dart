import 'dart:convert';

import 'package:band_hub/routes/Routes.dart';
import 'package:band_hub/widgets/app_color.dart';
import 'package:band_hub/widgets/app_text.dart';
import 'package:band_hub/widgets/helper_widget.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../models/manager/event_listing_response.dart';
import '../../util/common_funcations.dart';
import '../../util/global_variable.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({Key? key}) : super(key: key);

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int current_mon = 0;

  List<DayModel> dateList = [];
  List<String> dayList = ['Sun', 'Mon', 'Tue', 'Wed', "Thu", 'Fri', "Sat"];

  String selectedyearMonth = '';
  int selectedYear = 0;
  int selectedMonth = 0;
  String selectedDate = "";
  String selectedFullDate = "";

  @override
  void initState() {
    super.initState();

    setDatesInCalender(DateTime.now().year, DateTime.now().month);
  }

  setDatesInCalender(int year, int month) {
    dateList = [];
    int lastday = DateTime(year, month + 1, 0).day;
    selectedYear = year;
    selectedMonth = month;

    selectedyearMonth = DateFormat('MMM').format(DateTime(year, month, 1)) +
        " " +
        year.toString();

    switch (DateFormat('EE').format(DateTime(year, month, 1))) {
      case 'Mon':
        dateList.add(DayModel());
        break;
      case 'Tue':
        dateList.add(DayModel());
        dateList.add(DayModel());
        break;
      case 'Wed':
        dateList.add(DayModel());
        dateList.add(DayModel());
        dateList.add(DayModel());
        break;
      case 'Thu':
        dateList.add(DayModel());
        dateList.add(DayModel());
        dateList.add(DayModel());
        dateList.add(DayModel());
        break;
      case 'Fri':
        dateList.add(DayModel());
        dateList.add(DayModel());
        dateList.add(DayModel());
        dateList.add(DayModel());
        dateList.add(DayModel());
        break;
      case 'Sat':
        dateList.add(DayModel());
        dateList.add(DayModel());
        dateList.add(DayModel());
        dateList.add(DayModel());
        dateList.add(DayModel());
        dateList.add(DayModel());
        break;
    }

    for (int i = 0; i < lastday; i++) {
      bool isSelected = selectedYear != DateTime.now().year ||
          selectedMonth != DateTime.now().month
          ? false
          : DateTime(selectedYear, selectedMonth, i).day ==
          DateTime.now().day - 1;
      dateList.add(DayModel(date: (i + 1).toString(), isSelected: isSelected));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: HelperWidget.customAppBar(title: 'Calendar'),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () =>
                  FocusScope.of(context).requestFocus(FocusScopeNode()),
              child: Column(children: [
                Row(
                  children: [
                    const SizedBox(
                      width: 30,
                    ),
                    InkWell(
                      onTap: () {
                        if (selectedMonth == 1) {
                          selectedYear--;
                          selectedMonth = 12;
                        } else {
                          selectedMonth--;
                        }
                        setDatesInCalender(selectedYear, selectedMonth);
                        setState(() {});
                      },
                      child: const SizedBox(
                        height: 35,
                        width: 35,
                        child: Icon(
                          Icons.arrow_back_ios,
                          size: 20,
                        ),
                      ),
                    ),
                    Expanded(
                        child: Center(
                          child: AppText(
                            text: selectedyearMonth,
                            textSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        )),
                    InkWell(
                        onTap: () {
                          if (selectedMonth == 12) {
                            selectedYear++;
                            selectedMonth = 1;
                          } else {
                            selectedMonth++;
                          }
                          setDatesInCalender(selectedYear, selectedMonth);
                          setState(() {});
                        },
                        child: const SizedBox(
                            height: 35,
                            width: 35,
                            child: Icon(Icons.arrow_forward_ios, size: 20))),
                    const SizedBox(
                      width: 30,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                GridView.builder(
                    shrinkWrap: true,
                    primary: false,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                      crossAxisCount: 7,
                    ),
                    itemCount: dayList.length,
                    itemBuilder: (context, index) {
                      return Center(
                        child: AppText(
                          text: dayList[index].toString(),
                          textSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      );
                    }),
                Divider(
                  height: 10,
                  color: AppColor.grayColor.withOpacity(.30),
                  thickness: 1.2,
                ),
                GridView.builder(
                    shrinkWrap: true,
                    primary: false,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                      crossAxisCount: 7,
                    ),
                    itemCount: dateList.length,
                    itemBuilder: (context, index) {
                      DayModel dayModel = dateList[index];
                      return InkWell(
                        onTap: () {
                          if ((dayModel.date ?? '').isEmpty) {
                            return;
                          }
                          dateList.forEach((element) {
                            element.isSelected = false;
                          });
                          dayModel.isSelected = true;
                          selectedDate = dayModel.date!;
                          //yyyy-MM-dd
                          selectedFullDate = selectedYear.toString() +
                              '-' +
                              CommonFunctions().zeroBeforeIfNeeded(
                                  selectedMonth.toString()) +
                              '-' +
                              CommonFunctions()
                                  .zeroBeforeIfNeeded(selectedDate);

                          setState(() {});
                        },
                        child: Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                            color: (dayModel.isSelected ?? false)
                                ? AppColor.appColor
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Center(
                            child: AppText(
                              text: (dayModel.date ?? '').isEmpty
                                  ? ""
                                  : (dayModel.date ?? ''),
                              textSize: 12,
                              fontWeight: FontWeight.w400,
                              textColor: (dayModel.isSelected ?? false)
                                  ? AppColor.whiteColor
                                  : AppColor.blackColor,
                            ),
                          ),
                        ),
                      );
                    }),
                const SizedBox(
                  height: 10,
                ),
                Divider(
                  height: 10,
                  color: AppColor.grayColor.withOpacity(.30),
                  thickness: 1.2,
                ),
                const SizedBox(
                  height: 20,
                ),
                FutureBuilder<EventListingResponse>(
                    future: eventListingApi(context, selectedFullDate),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return snapshot.data!.body.isEmpty
                            ? Center(
                                child: AppText(
                                text: "No event found",
                                fontWeight: FontWeight.w500,
                                textSize: 16,
                              ))
                            : GridView.builder(
                                shrinkWrap: true,
                                primary: false,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 5,
                                  crossAxisCount: 2,
                                  childAspectRatio: MediaQuery.of(context)
                                          .size
                                          .width /
                                      (MediaQuery.of(context).size.height / 3),
                                ),
                                itemCount: snapshot.data!.body.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () async {
                                      // Get.toNamed(Routes.bookingDetailScreen,
                                      //     arguments: {"isFromCurrent": 'false'});
                                      await Get.toNamed(
                                          Routes.managerEventDetailScreen,
                                          arguments: {
                                            'eventId': snapshot
                                                .data!.body[index].id
                                                .toString()
                                          });
                                      setState(() {});
                                    },
                                    child: Stack(
                                      children: [
                                        Container(
                                            height: 120,
                                            width: Get.width,
                                            foregroundDecoration: BoxDecoration(
                                              color: AppColor.blackColor
                                                  .withAlpha(20),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: CommonFunctions()
                                                .setNetworkImages(
                                              imageUrl: snapshot
                                                      .data!
                                                      .body[index]
                                                      .eventImages
                                                      .isEmpty
                                                  ? ""
                                                  : snapshot.data!.body[index]
                                                      .eventImages[0].images,
                                              circle: 20,
                                              boxFit: BoxFit.cover,
                                            )),
                                    Positioned.fill(
                                      child: Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Container(
                                              margin: const EdgeInsets.only(
                                                  left: 15,
                                                  top: 10,
                                                  bottom: 10,
                                                  right: 8),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  AppText(
                                                    text: snapshot
                                                        .data!.body[index].name,
                                                    textSize: 15,
                                                    fontWeight: FontWeight.w400,
                                                    textColor:
                                                        AppColor.whiteColor,
                                                  ),
                                              Row(children: [
                                                    Image.asset(
                                                      'assets/images/ic_location_mark.png',
                                                      height: 12,
                                                      color:
                                                          AppColor.whiteColor,
                                                    ),
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 5.0),
                                                        child: AppText(
                                                          maxlines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          text: snapshot
                                                              .data!
                                                              .body[index]
                                                              .location,
                                                          textSize: 12,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          textColor: AppColor
                                                              .whiteColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ])
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
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
            )));
  }

  Future<EventListingResponse> eventListingApi(
      BuildContext ctx, String date) async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (!(connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi)) {
      throw new Exception('NO INTERNET CONNECTION');
    }

    String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    String sendDate = date.isEmpty ? currentDate : date;
    print(sendDate);
    var response = await http.get(
        Uri.parse(GlobalVariable.baseUrl +
            GlobalVariable.bookingsCalendar +
            sendDate),
        headers: await CommonFunctions().getHeader());

    print(response.body);
    try {
      Map<String, dynamic> res = json.decode(response.body);

      if (res['code'] != 200 || res == null) {
        String error = res['msg'];
        print("scasd  " + error);
        throw new Exception(error);
      }
      EventListingResponse result = EventListingResponse.fromJson(res);

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

class DayModel {
  String? date;
  bool? isSelected;

  DayModel({this.date, this.isSelected});
}
