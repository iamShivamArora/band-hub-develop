import 'package:band_hub/widgets/app_color.dart';
import 'package:band_hub/widgets/app_text.dart';
import 'package:band_hub/widgets/helper_widget.dart';
import 'package:flutter/material.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({Key? key}) : super(key: key);

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: HelperWidget.customAppBar(title: 'Reviews'),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 8,
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
                })
                )
                ));
  }
}
