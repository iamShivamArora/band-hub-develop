import 'package:band_hub/routes/Routes.dart';
import 'package:band_hub/widgets/helper_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/app_color.dart';
import '../../../widgets/app_text.dart';

class NewProfileScreen extends StatefulWidget {
  const NewProfileScreen({Key? key}) : super(key: key);

  @override
  State<NewProfileScreen> createState() => _NewProfileScreenState();
}

class _NewProfileScreenState extends State<NewProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HelperWidget.customAppBar(title: "Profile"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: SizedBox(
                height: 100,
                width: 100,
                child: Stack(
                  children: [
                    Image.asset(
                      'assets/images/ic_user.png',
                      height: 100,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: () => Get.toNamed(Routes.profileScreen),
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                              color: AppColor.appColor,
                              borderRadius: BorderRadius.circular(100)),
                          child: Icon(
                            Icons.edit,
                            color: AppColor.whiteColor,
                            size: 18,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: AppText(
                text: "John Marker",
                textSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            Center(
              child: AppText(
                text: "Cooper_Kristin@gmail.com",
                textSize: 12,
              ),
            ),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/ic_star.png',
                    width: 70,
                  ),
                  AppText(
                    text: " 25 Reviews",
                    textSize: 12,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            AppText(
              text: "About",
              textSize: 15,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(
              height: 5,
            ),
            AppText(
              text:
                  "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
              textSize: 11,
              fontWeight: FontWeight.w400,
            ),
            const SizedBox(
              height: 25,
            ),
            // GridView.builder(
            //     shrinkWrap: true,
            //     primary: false,
            //     physics: const NeverScrollableScrollPhysics(),
            //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //       crossAxisSpacing: 5,
            //       mainAxisSpacing: 5,
            //       crossAxisCount: 2,
            //       childAspectRatio: MediaQuery.of(context).size.width /
            //           (MediaQuery.of(context).size.height / 3),
            //     ),
            //     itemCount: 4,
            //     itemBuilder: (context, index) {
            //       return InkWell(
            //         onTap: () {
            //           Get.toNamed(Routes.eventDetailScreen,
            //               arguments: {'isFromManager': true});
            //         },
            //         child: Stack(
            //           children: [
            //             Container(
            //               height: 120,
            //               width: Get.width,
            //               foregroundDecoration: BoxDecoration(
            //                 color: AppColor.blackColor.withAlpha(20),
            //                 borderRadius: BorderRadius.circular(12),
            //               ),
            //               child: ClipRRect(
            //                 borderRadius: BorderRadius.circular(12),
            //                 child: Image.asset(
            //                   'assets/images/ic_placeholder.png',
            //                   fit: BoxFit.cover,
            //                 ),
            //               ),
            //             ),
            //             Positioned.fill(
            //               child: Align(
            //                 alignment: Alignment.bottomLeft,
            //                 child: Container(
            //                   margin: const EdgeInsets.symmetric(
            //                       horizontal: 15, vertical: 10),
            //                   child: Column(
            //                     crossAxisAlignment: CrossAxisAlignment.start,
            //                     mainAxisSize: MainAxisSize.min,
            //                     children: [
            //                       AppText(
            //                         text: "Event 0${index + 1}",
            //                         textSize: 12,
            //                         fontWeight: FontWeight.w400,
            //                         textColor: AppColor.whiteColor,
            //                       ),
            //                       Row(children: [
            //                         Image.asset(
            //                           'assets/images/ic_location_mark.png',
            //                           height: 10,
            //                           color: AppColor.whiteColor,
            //                         ),
            //                         AppText(
            //                           text: " New York",
            //                           textSize: 10,
            //                           fontWeight: FontWeight.w400,
            //                           textColor: AppColor.whiteColor,
            //                         ),
            //                       ])
            //                     ],
            //                   ),
            //                 ),
            //               ),
            //             )
            //           ],
            //         ),
            //       );
            //     }),
            // const SizedBox(
            //   height: 20,
            // ),
            Row(
              children: [
                AppText(
                  text: "Reviews",
                  textSize: 15,
                  fontWeight: FontWeight.w600,
                ),
                const Spacer(),
                InkWell(
                  onTap: () => Get.toNamed(Routes.reviewScreen),
                  child: AppText(
                    text: "View All",
                    textSize: 12,
                    underline: true,
                    textColor: AppColor.appColor,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 2,
                shrinkWrap: true,
                itemBuilder: ((context, index) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/ic_user.png',
                            height: 50,
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  AppText(
                                    text: "Stells Stefword",
                                    textSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  const Spacer(),
                                  AppText(
                                    text: "Nov 15, 2015",
                                    textSize: 10,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              Image.asset(
                                'assets/images/ic_star.png',
                                width: 60,
                              ),
                            ],
                          ))
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      AppText(
                        text:
                            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
                        textSize: 11,
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
                    ],
                  );
                }))
          ],
        ),
      ),
    );
  }
}
