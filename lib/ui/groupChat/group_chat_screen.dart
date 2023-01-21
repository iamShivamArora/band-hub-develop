import 'package:band_hub/routes/Routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/app_color.dart';
import '../../widgets/app_text.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/helper_widget.dart';
import '../../widgets/image_picker.dart';

class GroupChatScreen extends StatelessWidget {
  const GroupChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.whiteColor,
        appBar: HelperWidget.noAppBar(),
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusScope.of(context).requestFocus(FocusScopeNode()),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: IconButton(
                      icon: Image.asset(
                        'assets/images/ic_back.png',
                        height: 22,
                      ),
                      onPressed: () => Get.back(),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                      child: Row(
                    children: [
                      Image.asset(
                        'assets/images/ic_user.png',
                        height: 40,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            text: "Pop Dj (Group)",
                            textSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ],
                  )),
                  InkWell(
                    onTap: () => Get.toNamed(Routes.seeMembersScreen),
                    child: AppText(
                      text: "See Members",
                      textSize: 12,
                      underline: true,
                      fontWeight: FontWeight.w600,
                      textColor: AppColor.appColor,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: 2,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(top: 5),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  AppText(
                                    text: 'Wed. 20:32',
                                    textSize: 12,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Flexible(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 15),
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 15,
                                      ),
                                      decoration: const BoxDecoration(
                                          color: Color(0xffF6F6F6),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(30),
                                            topRight: Radius.circular(30),
                                            bottomLeft: Radius.circular(30),
                                            bottomRight: Radius.circular(8),
                                          )),
                                      child: AppText(
                                        text:
                                            "Hi, son, how are you doing? Today, my father and I went to buy a car, bought a cool car.",
                                        textColor: AppColor.blackColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  Flexible(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 15),
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 15,
                                      ),
                                      decoration: BoxDecoration(
                                          color: AppColor.appColor,
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(30),
                                            topRight: Radius.circular(30),
                                            bottomLeft: Radius.circular(8),
                                            bottomRight: Radius.circular(30),
                                          )),
                                      child: AppText(
                                        text: "Will we arrive tomorrow?",
                                        textColor: AppColor.whiteColor,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  AppText(
                                    text: 'Wed. 20:32',
                                    textSize: 12,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      })),
              Container(
                margin: const EdgeInsets.fromLTRB(20, 2, 20, 20),
                child: Stack(
                  children: [
                    const SimpleTf(
                      titleVisibilty: false,
                      fillColor: Color(0xffF6F6F6),
                      hint: 'Type your message...',
                      padding: EdgeInsets.only(left: 15, right: 80),
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: InkWell(
                          onTap: () {
                            showImagePicker();
                          },
                          child: Container(
                              height: 35,
                              width: 35,
                              margin:
                                  const EdgeInsets.only(bottom: 10, right: 50),
                              child: Center(
                                  child: Image.asset(
                                "assets/images/ic_attachment.png",
                                height: 20,
                              ))),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                            height: 35,
                            width: 35,
                            margin:
                                const EdgeInsets.only(bottom: 10, right: 10),
                            decoration: BoxDecoration(
                                color: AppColor.appColor,
                                borderRadius: BorderRadius.circular(100)),
                            child: Center(
                              child: Icon(
                                Icons.send_rounded,
                                color: AppColor.whiteColor,
                                size: 20,
                              ),
                            )),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  void showImagePicker() {
    showDialog(
      context: Get.context!,
      builder: (_) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        insetPadding: EdgeInsets.zero,
        content: Container(
          margin: const EdgeInsets.symmetric(vertical: 20),
          width: Get.width / 1.3,
          height: 200,
          decoration: BoxDecoration(
              color: AppColor.whiteColor,
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              AppText(
                text: 'Select Image',
                textColor: AppColor.blackColor,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(
                height: 40,
              ),
              InkWell(
                onTap: ()async {
                  Get.back();
                  String? selectedImage = await ImagePickerUtility()
                      .pickImageFromCamera(isCropping: true);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera_alt,
                      color: AppColor.blackColor,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    AppText(
                      text: 'Select image from camera',
                      textSize: 12,
                      textColor: AppColor.blackColor,
                    ),
                  ],
                ),
              ),
              Container(
                height: 1,
                margin: const EdgeInsets.symmetric(vertical: 15),
                width: 200,
                color: AppColor.grayColor.withOpacity(.40),
              ),
              InkWell(
                onTap: () async{
                  Get.back();
                  String? selectedImage = await ImagePickerUtility()
                      .pickImageFromGallery(isCropping: true);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.photo,
                      color: AppColor.blackColor,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    AppText(
                      text: 'Select image from gallery',
                      textSize: 12,
                      textColor: AppColor.blackColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
