import 'package:band_hub/routes/Routes.dart';
import 'package:band_hub/widgets/app_color.dart';
import 'package:band_hub/widgets/app_text.dart';
import 'package:band_hub/widgets/elevated_btn.dart';
import 'package:band_hub/widgets/elevated_stroke_btn.dart';
import 'package:band_hub/widgets/helper_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookingDetailScreen extends StatefulWidget {
  const BookingDetailScreen({Key? key}) : super(key: key);

  @override
  State<BookingDetailScreen> createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  bool isFromCurrent = true;
  bool isFromUser = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isFromCurrent = Get.arguments['isFromCurrent'] == "true";
    isFromUser = Get.arguments['isFromUser'] ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HelperWidget.customAppBar(
          title: isFromCurrent ? 'Current Details' : "Past Details"),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Container(
            width: Get.width,
            height: 260,
            decoration: BoxDecoration(
                color: AppColor.grayColor,
                image: const DecorationImage(
                    image: AssetImage('assets/images/ic_placeholder.png'),
                    fit: BoxFit.cover)),
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
                              text: "Event 01",
                              textSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Row(
                              children: [
                                Image.asset(
                                    'assets/images/ic_location_mark.png',
                                    height: 12),
                                AppText(
                                  text: " New York",
                                  textSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: isFromCurrent,
                        child: InkWell(
                          onTap: () {
                            Get.toNamed(Routes.groupChatScreen);
                          },
                          child: Image.asset(
                            'assets/images/ic_message_red.png',
                            height: 35,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  AppText(
                    text:
                        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
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
                        text: "13.07.2022 | 12:30PM",
                        textSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                      const Spacer(),
                      AppText(
                        text: "13.07.2022 | 12:30PM",
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
                  const SizedBox(
                    height: 15,
                  ),
                  Visibility(
                    visible: isFromUser,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          text: "Manager",
                          textSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: () =>
                                  Get.toNamed(Routes.managerProfileScreen),
                              child: Image.asset(
                                'assets/images/ic_user.png',
                                height: 55,
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  text: "John Marker",
                                  textSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/ic_star.png',
                                      width: 60,
                                    ),
                                    AppText(
                                      text: " 25 Reviews",
                                      textSize: 10,
                                    ),
                                  ],
                                )
                              ],
                            )),
                            InkWell(
                              onTap: () {
                                Get.toNamed(Routes.userChatScreen);
                              },
                              child: Image.asset(
                                'assets/images/ic_message_red.png',
                                height: 30,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Divider(
                          height: 10,
                          color: AppColor.grayColor.withOpacity(.30),
                          thickness: 1.2,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                  Container(
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
                          text: "State",
                          textSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                        const Spacer(),
                        AppText(
                          text: isFromCurrent ? "Ongoing" : "Completed",
                          textSize: 12,
                          fontWeight: FontWeight.w400,
                          textColor:
                              isFromCurrent ? Colors.amber : Colors.green,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  AppText(
                    text: "Musicians Joined",
                    textSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: 2,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: ((context, index) {
                        return InkWell(
                          onTap: () {
                            Get.toNamed(Routes.musicianDetailScreen);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 15),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            decoration: BoxDecoration(
                                color: AppColor.whiteColor,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColor.grayColor.withAlpha(80),
                                    blurRadius: 10.0,
                                    offset: const Offset(2, 2),
                                  ),
                                ]),
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/ic_user.png',
                                  height: 65,
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                    child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        AppText(
                                          text: "John Marker",
                                          textSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        const Spacer(),
                                        AppText(
                                          text: "Gutierest",
                                          textSize: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 2,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset(
                                                'assets/images/ic_location_mark.png',
                                                height: 12),
                                            AppText(
                                              text: " New York",
                                              textSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        isFromUser
                                            ? InkWell(
                                                onTap: () {
                                                  Get.toNamed(
                                                      Routes.userChatScreen);
                                                },
                                                child: Image.asset(
                                                  'assets/images/ic_message_red.png',
                                                  height: 35,
                                                ),
                                              )
                                            : InkWell(
                                                onTap: () => Get.toNamed(
                                                    Routes.ratingScreen),
                                                child: Container(
                                                  height: 25,
                                                  width: 80,
                                                  decoration: BoxDecoration(
                                                      color: AppColor.appColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6)),
                                                  child: Center(
                                                    child: AppText(
                                                      text: " Add Review ",
                                                      textSize: 9,
                                                      textColor:
                                                          AppColor.whiteColor,
                                                    ),
                                                  ),
                                                ),
                                              )
                                      ],
                                    )
                                  ],
                                ))
                              ],
                            ),
                          ),
                        );
                      })),
                  const SizedBox(
                    height: 20,
                  ),
                  Visibility(
                    visible: isFromUser,
                    child: Center(
                      child: ElevatedBtn(
                        text: isFromCurrent ? 'Cancel Booking' : "Add Review",
                        width: 250,
                        onTap: () => isFromCurrent
                            ? showDeclineDialog()
                            : Get.toNamed(Routes.eventRatingScreen),
                        heignt: 45,
                      ),
                    ),
                  ),
                ],
              ))
        ],
      )),
    );
  }

  showDeclineDialog() {
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
                      'assets/images/ic_cross_red.png',
                      height: 70,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    AppText(
                        text: "Cancel Booking",
                        textColor: AppColor.blackColor,
                        textAlign: TextAlign.center,
                        textSize: 16,
                        fontWeight: FontWeight.w500),
                    const SizedBox(
                      height: 10,
                    ),
                    AppText(
                        text: "Are you sure you want to cancel\nthis booking?",
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
                            Get.back();
                          },
                        )),
                      ],
                    )
                  ],
                ),
              ),
            ));
  }
}
