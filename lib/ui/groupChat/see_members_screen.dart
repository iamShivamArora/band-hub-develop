import 'package:band_hub/widgets/helper_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/Routes.dart';
import '../../widgets/app_text.dart';
import '../../widgets/custom_text_field.dart';

class SeeMembersScreen extends StatelessWidget {
  const SeeMembersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: HelperWidget.customAppBar(title: "See Members"),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () =>
                    FocusScope.of(context).requestFocus(FocusScopeNode()),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SimpleTf(
                        hint: 'Search',
                        fillColor: Color(0xffF2F2F2),
                        height: 45,
                        prefix: 'assets/images/ic_search.png',
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                          child: ListView.builder(
                              itemCount: 7,
                              physics: const AlwaysScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: ((context, index) {
                                return InkWell(
                                  onTap: () {},
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Row(
                                      children: [
                                        Stack(
                                          children: [
                                            Image.asset(
                                              'assets/images/ic_user.png',
                                              height: 60,
                                            ),
                                            Visibility(
                                              visible: index == 1,
                                              child: Positioned.fill(
                                                child: Align(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  child: InkWell(
                                                    onTap: () {
                                                      Get.toNamed(Routes
                                                          .userChatScreen);
                                                    },
                                                    child: Image.asset(
                                                      'assets/images/ic_message_red.png',
                                                      height: 22,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Expanded(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                AppText(
                                                  text: index == 1
                                                      ? "Jolly (Manager)"
                                                      : "Stells Stefword",
                                                  textSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                const Spacer(),
                                                // AppText(
                                                //   text: "5:30 PM",
                                                //   textSize: 10,
                                                //   fontWeight: FontWeight.w400,
                                                // ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 6,
                                            ),
                                            AppText(
                                              text: "You sent a sticker",
                                              textSize: 12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ],
                                        ))
                                      ],
                                    ),
                                  ),
                                );
                              })))
                    ]))));
  }
}
