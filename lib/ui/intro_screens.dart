import 'package:band_hub/routes/Routes.dart';
import 'package:band_hub/widgets/app_color.dart';
import 'package:band_hub/widgets/app_text.dart';
import 'package:band_hub/widgets/elevated_btn.dart';
import 'package:band_hub/widgets/elevated_stroke_btn.dart';
import 'package:band_hub/widgets/helper_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  PageController controller =
      PageController(viewportFraction: 1, keepPage: true);

  int pageIndex = 0;

  bool buttonsVisible = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: HelperWidget.noAppBar(),
      body: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: (() {
                if (pageIndex == 2) {
                  return;
                }
                Get.offAllNamed(Routes.logInScreen);
              }),
              child: Container(
                margin: const EdgeInsets.all(20),
                child: AppText(
                  text: pageIndex != 2 ? 'Skip' : '',
                  fontWeight: FontWeight.w400,
                  textSize: 12,
                  textColor: const Color(0xff858597),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: PageView.builder(
              itemCount: 3,
              controller: controller,
              onPageChanged: (value) {
                pageIndex = value;
                if (pageIndex == 2) {
                  buttonsVisible = true;
                }
                setState(() {});
              },
              itemBuilder: (BuildContext context, int itemIndex) {
                return itemsPageView(itemIndex);
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Stack(
              children: [
                Align(
                    alignment: Alignment.topCenter,
                    child: SmoothPageIndicator(
                        controller: controller,
                        // PageController
                        count: 3,
                        effect: ExpandingDotsEffect(
                            activeDotColor: AppColor.appColor,
                            dotColor: AppColor.grayColor.withOpacity(.50),
                            spacing: 5,
                            dotHeight: 5,
                            dotWidth: 8),
                        // your preferred effect
                        onDotClicked: (index) {})),
                Align(
                  alignment: Alignment.center,
                  child: Visibility(
                    visible: pageIndex==2,
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                            child: ElevatedBtn(
                          text: 'Sign Up',
                          onTap: (() {
                            Get.offAllNamed(Routes.signUpScreen);
                          }),
                        )),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                            child: ElevatedStrokeBtn(
                          onTap: (() {
                            Get.offAllNamed(Routes.logInScreen);
                          }),
                          text: "Log in",
                        )),
                        const SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  itemsPageView(int index) {
    String title = '';
    String description =
        'Lorem Ipsum is simply dummy text\nof the printing and typesetting\nindustry.';
    String imagePath = '';

    switch (index) {
      case 0:
        title = 'Musician 01';
        imagePath = 'assets/images/ic_intro_1.png';
        break;
      case 1:
        title = 'Musician 02';
        imagePath = 'assets/images/ic_intro_2.png';
        break;
      case 2:
        title = 'Musician 03';
        imagePath = 'assets/images/ic_intro_3.png';
        break;
    }

    return Container(
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Center(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    imagePath,
                    height: 300,
                  )),
            ),
            const SizedBox(
              height: 10,
            ),
            AppText(
              text: title,
              fontWeight: FontWeight.w600,
              textColor: AppColor.blackColor,
              textSize: 22,
            ),
            const SizedBox(
              height: 10,
            ),
            AppText(
              text: description,
              textAlign: TextAlign.center,
              fontWeight: FontWeight.w400,
              textSize: 14,
              textColor: AppColor.blackColor,
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
