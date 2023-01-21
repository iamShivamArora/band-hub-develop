import 'package:band_hub/widgets/helper_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/Routes.dart';
import '../../../widgets/app_text.dart';
import '../../../widgets/custom_text_field.dart';

class ProviderMessageScreen extends StatelessWidget {
  const ProviderMessageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HelperWidget.customAppBar(title: "Messeges"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusScope.of(context).requestFocus(FocusScopeNode()),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                    itemCount: 5,
                    physics: const AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: ((context, index) {
                      return InkWell(
                        onTap: () {
                          Get.toNamed(index.isOdd
                              ? Routes.groupChatScreen
                              : Routes.userChatScreen);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/images/ic_user.png',
                                height: 60,
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
                                        text: index.isOdd
                                            ? "Pop Dj (Group)"
                                            : "Stells Stefword",
                                        textSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      const Spacer(),
                                      AppText(
                                        text: "5:30 PM",
                                        textSize: 10,
                                        fontWeight: FontWeight.w400,
                                      ),
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
          ]),
        ),
      ),
    );
  }
}
