import 'package:band_hub/routes/Routes.dart';
import 'package:band_hub/ui/user/home/booking/user_booking_screen.dart';
import 'package:band_hub/widgets/app_color.dart';
import 'package:band_hub/widgets/app_text.dart';
import 'package:band_hub/widgets/elevated_btn.dart';
import 'package:band_hub/widgets/elevated_stroke_btn.dart';
import 'package:band_hub/widgets/helper_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({Key? key}) : super(key: key);

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  bool isSelectCurrent = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.whiteColor,
        appBar: HelperWidget.customAppBar(title: 'My Orders'),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 30,
                ),
                Expanded(
                    child: isSelectCurrent
                        ? ElevatedBtn(
                            text: 'Current',
                            onTap: (() {
                              isSelectCurrent = true;
                              setState(() {});
                            }),
                            heignt: 50,
                          )
                        : ElevatedStrokeBtn(
                            onTap: (() {
                              isSelectCurrent = true;
                              setState(() {});
                            }),
                            text: "Current",
                            heignt: 50,
                          )),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: isSelectCurrent
                        ? ElevatedStrokeBtn(
                            onTap: (() {
                              isSelectCurrent = false;
                              setState(() {});
                            }),
                            text: "Past",
                            heignt: 50,
                          )
                        : ElevatedBtn(
                            text: 'Past',
                            onTap: (() {
                              isSelectCurrent = false;
                              setState(() {});
                            }),
                            heignt: 50,
                          )),
                const SizedBox(
                  width: 30,
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
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
                        InkWell(
                            onTap: () {
                              Get.toNamed(Routes.bookingDetailScreen,
                                  arguments: {
                                    "isFromCurrent": isSelectCurrent.toString(),
                                    "isFromUser": false
                                  });
                            },
                            child: Container(
                              width: Get.width,
                              height: 200,
                              decoration: BoxDecoration(
                                  color: AppColor.grayColor,
                                  borderRadius: BorderRadius.circular(15),
                                  image: const DecorationImage(
                                      image: AssetImage(
                                          'assets/images/ic_placeholder.png'),
                                      fit: BoxFit.cover)),
                            )),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          child: Column(children: [
                            Row(
                              children: [
                                AppText(
                                  text: "Event 0${index + 1}",
                                  textSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                                const Spacer(),
                                AppText(
                                  text: "State",
                                  textSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ],
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
                                const Spacer(),
                                AppText(
                                  text:
                                      isSelectCurrent ? "Ongoing" : "Completed",
                                  textSize: 12,
                                  fontWeight: FontWeight.w400,
                                  textColor: isSelectCurrent
                                      ? Colors.amber
                                      : Colors.green,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                          ]),
                        )
                      ]),
                    );
                  }),
            )
          ],
        ));
  }
}
