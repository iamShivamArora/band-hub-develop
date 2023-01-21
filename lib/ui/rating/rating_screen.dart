import 'package:band_hub/routes/Routes.dart';
import 'package:band_hub/widgets/app_color.dart';
import 'package:band_hub/widgets/app_text.dart';
import 'package:band_hub/widgets/custom_text_field.dart';
import 'package:band_hub/widgets/elevated_btn.dart';
import 'package:band_hub/widgets/helper_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({Key? key}) : super(key: key);

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: HelperWidget.customAppBar(title: 'Add Review'),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () =>
                  FocusScope.of(context).requestFocus(FocusScopeNode()),
              child: Column(children: [
                Center(
                  child: Image.asset(
                    'assets/images/ic_user.png',
                    height: 100,
                    width: 100,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                AppText(
                  text: "Musician 01",
                  textSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                Image.asset(
                  'assets/images/ic_star.png',
                  width: 80,
                ),
                Container(
                  width: Get.width,
                  margin: const EdgeInsets.symmetric(vertical: 30),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
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
                  child: Column(children: [
                    AppText(
                      text: "Rate your overall experience",
                      textSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Image.asset(
                      'assets/images/ic_star.png',
                      width: 180,
                    ),
                    const SimpleTf(
                      hint: "Type...",
                      lines: 8,
                      height: 140,
                    )
                  ]),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedBtn(
                  text: "Update",
                  onTap: () {
                    showRatingDialog();
                  },
                )
              ]),
            )));
  }

  showRatingDialog() {
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
                      'assets/images/ic_green_tick.png',
                      height: 70,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    AppText(
                        text: "Success",
                        textColor: AppColor.blackColor,
                        textAlign: TextAlign.center,
                        textSize: 16,
                        fontWeight: FontWeight.w500),
                    const SizedBox(
                      height: 10,
                    ),
                    AppText(
                        text: "Thanks for the Rating.",
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
                            child: ElevatedBtn(
                          text: 'Done',
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
