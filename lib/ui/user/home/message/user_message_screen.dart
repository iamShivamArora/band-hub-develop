import 'package:band_hub/routes/Routes.dart';
import 'package:band_hub/widgets/app_color.dart';
import 'package:band_hub/widgets/app_text.dart';
import 'package:band_hub/widgets/custom_text_field.dart';
import 'package:band_hub/widgets/helper_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserMessageScreen extends StatefulWidget {
  const UserMessageScreen({Key? key}) : super(key: key);

  @override
  State<UserMessageScreen> createState() => _UserMessageScreenState();
}

class _UserMessageScreenState extends State<UserMessageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: HelperWidget.noAppBar(),
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => FocusScope.of(context).requestFocus(FocusScopeNode()),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Center(
                child: AppText(
                  text: "Messages",
                  textSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
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
        ));
  }
}
