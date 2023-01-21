import 'package:band_hub/routes/Routes.dart';
import 'package:band_hub/widgets/app_color.dart';
import 'package:band_hub/widgets/app_text.dart';
import 'package:band_hub/widgets/elevated_btn.dart';
import 'package:band_hub/widgets/elevated_stroke_btn.dart';
import 'package:band_hub/widgets/helper_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManagerSettingsScreen extends StatefulWidget {
  const ManagerSettingsScreen({Key? key}) : super(key: key);

  @override
  State<ManagerSettingsScreen> createState() => _ManagerSettingsScreenState();
}

class _ManagerSettingsScreenState extends State<ManagerSettingsScreen> {
  bool _switchValue = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: HelperWidget.customAppBar(title: "Settings"),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            InkWell(
              onTap: () {
                Get.toNamed(Routes.notificationScreen);
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(15)),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(7),
                      height: 32,
                      width: 32,
                      decoration: BoxDecoration(
                          color: Color(0xff774FFF),
                          borderRadius: BorderRadius.circular(100)),
                      child: Image.asset(
                        'assets/images/ic_bell.png',
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: AppText(
                        text: "Notifications",
                        textSize: 15,
                      ),
                    ),
                    Transform.scale(
                      scale: 0.8,
                      child: CupertinoSwitch(
                        activeColor: AppColor.blackColor,
                        value: _switchValue,
                        onChanged: (value) {
                          setState(() {
                            _switchValue = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 15,
                    )
                  ],
                ),
              ),
            ),
            Divider(
              height: 10,
              color: AppColor.grayColor.withOpacity(.20),
              thickness: 1.2,
            ),
            InkWell(
              onTap: () {
                Get.toNamed(Routes.changePasswordScreen);
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(15)),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/ic_yellow_lock.png',
                      height: 32,
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: AppText(
                        text: "Change Password",
                        textSize: 15,
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 15,
                    )
                  ],
                ),
              ),
            ),
            Divider(
              height: 10,
              color: AppColor.grayColor.withOpacity(.20),
              thickness: 1.2,
            ),
            InkWell(
              onTap: () {
                Get.toNamed(Routes.privacyTermsAboutScreen,
                    arguments: {"isFrom": "Privacy Policy"});
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(15)),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/ic_question_mark.png',
                      height: 32,
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: AppText(
                        text: "Privacy Policy",
                        textSize: 15,
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 15,
                    )
                  ],
                ),
              ),
            ),
            Divider(
              height: 10,
              color: AppColor.grayColor.withOpacity(.20),
              thickness: 1.2,
            ),
            InkWell(
              onTap: () {
                Get.toNamed(Routes.privacyTermsAboutScreen,
                    arguments: {"isFrom": "Terms and Conditions"});
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(15)),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/ic_document_purple.png',
                      height: 32,
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: AppText(
                        text: "Terms and Conditions",
                        textSize: 15,
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 15,
                    )
                  ],
                ),
              ),
            ),
            Divider(
              height: 10,
              color: AppColor.grayColor.withOpacity(.20),
              thickness: 1.2,
            ),
            InkWell(
              onTap: () {
                Get.toNamed(Routes.privacyTermsAboutScreen,
                    arguments: {"isFrom": "About"});
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(15)),
                child: Row(
                  children: [
                    Container(
                      height: 32,
                      width: 32,
                      decoration: BoxDecoration(
                          color: const Color(0xffDA7D79),
                          borderRadius: BorderRadius.circular(100)),
                      child: const Icon(
                        Icons.info,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: AppText(
                        text: "About",
                        textSize: 15,
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 15,
                    )
                  ],
                ),
              ),
            ),
            Divider(
              height: 10,
              color: AppColor.grayColor.withOpacity(.20),
              thickness: 1.2,
            ),
            InkWell(
              onTap: () {
                Get.toNamed(Routes.favouriteEventScreen);
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(15)),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/ic_favourite.png',
                      height: 32,
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: AppText(
                        text: "Favourite Musicians",
                        textSize: 15,
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 15,
                    )
                  ],
                ),
              ),
            ),
            Divider(
              height: 10,
              color: AppColor.grayColor.withOpacity(.20),
              thickness: 1.2,
            ),
            // InkWell(
            //   onTap: () {
            //     Get.toNamed(Routes.createEventScreen,arguments: {
            //       "isEdit":
            //       true
            //     });
            //   },
            //   child: Container(
            //     width: MediaQuery.of(context).size.width,
            //     padding:
            //         const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
            //     decoration:
            //         BoxDecoration(borderRadius: BorderRadius.circular(15)),
            //     child: Row(
            //       children: [
            //         Image.asset(
            //           'assets/images/ic_edit.png',
            //           height: 32,
            //         ),
            //         const SizedBox(
            //           width: 15,
            //         ),
            //         Expanded(
            //           child: AppText(
            //             text: "Edit Create Event",
            //             textSize: 15,
            //           ),
            //         ),
            //         const Icon(
            //           Icons.arrow_forward_ios,
            //           size: 15,
            //         )
            //       ],
            //     ),
            //   ),
            // ),
            // Divider(
            //   height: 10,
            //   color: AppColor.grayColor.withOpacity(.20),
            //   thickness: 1.2,
            // ),
            // InkWell(
            //   onTap: () {
            //     Get.toNamed(Routes.bookingScreen);
            //   },
            //   child: Container(
            //     width: MediaQuery.of(context).size.width,
            //     padding:
            //         const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
            //     decoration:
            //         BoxDecoration(borderRadius: BorderRadius.circular(15)),
            //     child: Row(
            //       children: [
            //         Image.asset(
            //           'assets/images/ic_document_green.png',
            //           height: 32,
            //         ),
            //         const SizedBox(
            //           width: 15,
            //         ),
            //         Expanded(
            //           child: AppText(
            //             text: "Bookings",
            //             textSize: 15,
            //           ),
            //         ),
            //         const Icon(
            //           Icons.arrow_forward_ios,
            //           size: 15,
            //         )
            //       ],
            //     ),
            //   ),
            // ),
            // Divider(
            //   height: 10,
            //   color: AppColor.grayColor.withOpacity(.20),
            //   thickness: 1.2,
            // ),
          ]),
        ));
  }
}
