import 'package:band_hub/routes/Routes.dart';
import 'package:band_hub/widgets/app_color.dart';
import 'package:band_hub/widgets/app_text.dart';
import 'package:band_hub/widgets/helper_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MusicianDetailScreen extends StatefulWidget {
  const MusicianDetailScreen({Key? key}) : super(key: key);

  @override
  State<MusicianDetailScreen> createState() => _MusicianDetailScreenState();
}

class _MusicianDetailScreenState extends State<MusicianDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HelperWidget.customAppBar(title: 'Details'),
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
                              text: "Salsa Dance",
                              textSize: 15,
                              fontWeight: FontWeight.w600,
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
                                  text: " 1 Miles",
                                  textSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Get.toNamed(Routes.userChatScreen);
                        },
                        child: Image.asset(
                          'assets/images/ic_message_red.png',
                          height: 35,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Image.asset(
                        'assets/images/ic_gray_heart.png',
                        height: 35,
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
                  AppText(
                    text: "Musician Joined",
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
                            // Get.toNamed(Routes.musicianDetailScreen);
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
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        InkWell(
                                          onTap: () {
                                            Get.toNamed(Routes.userChatScreen);
                                          },
                                          child: Image.asset(
                                            'assets/images/ic_message_red.png',
                                            height: 35,
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
                ],
              ))
        ],
      )),
    );
  }
}
