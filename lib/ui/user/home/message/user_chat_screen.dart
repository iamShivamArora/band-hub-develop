import 'package:band_hub/routes/Routes.dart';
import 'package:band_hub/widgets/app_color.dart';
import 'package:band_hub/widgets/app_text.dart';
import 'package:band_hub/widgets/custom_text_field.dart';
import 'package:band_hub/widgets/elevated_btn.dart';
import 'package:band_hub/widgets/elevated_stroke_btn.dart';
import 'package:band_hub/widgets/helper_widget.dart';
import 'package:band_hub/widgets/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserChatScreen extends StatefulWidget {
  const UserChatScreen({Key? key}) : super(key: key);

  @override
  State<UserChatScreen> createState() => _UserChatScreenState();
}

class _UserChatScreenState extends State<UserChatScreen> {
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
                      child: InkWell(
                    onTap: () => Get.toNamed(Routes.managerProfileScreen),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
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
                              text: "Stells Stefword",
                              textSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                            AppText(
                              text: "Online",
                              textSize: 10,
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                      ],
                    ),
                  )),
                  InkWell(
                    onTap: _showPopupMenu,
                    child: Container(
                      margin: const EdgeInsets.only(right: 20),
                      child: Image.asset(
                        'assets/images/ic_four_dot.png',
                        height: 18,
                      ),
                    ),
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
                        child: InkWell(
                          onTap: () {},
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
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  void _showPopupMenu() async {
    // double left = offset.dx;
    // double top = offset.dy;
    await showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(50, 80, 0, 20),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30)),
      ),
      items: [
        PopupMenuItem<String>(
          child: ListTile(
            leading: Image.asset(
              'assets/images/ic_block.png',
              height: 25,
            ),
            title: const Text(
              'Block',
            ),
          ),
          value: '0',
        ),
        PopupMenuItem<String>(
          child: ListTile(
            leading: Image.asset(
              'assets/images/ic_delete_black.png',
              height: 25,
            ),
            title: const Text(
              'Delete chat history',
            ),
          ),
          value: '1',
        ),
        PopupMenuItem<String>(
          child: ListTile(
            leading: Image.asset(
              'assets/images/ic_notification.png',
              height: 25,
            ),
            title: const Text(
              'Mute notification',
            ),
          ),
          value: '2',
        ),
        PopupMenuItem<String>(
          child: ListTile(
            leading: Image.asset(
              'assets/images/ic_exclamation.png',
              height: 25,
            ),
            title: const Text(
              'Report',
            ),
          ),
          value: '3',
        ),
      ],
      elevation: 10,
    ).then((value) {
      if (value == "3") {
        showReportDialog();
      } else if (value == "0" || value == "1") {
        showActionDialog(value);
      }
    });
  }

  showActionDialog(String? value) {
    String title = "";
    String image = "";
    switch (value) {
      case "0":
        title = "Are you sure you want to block\njohn?";
        image = 'assets/images/ic_report.png';
        break;
      case "1":
        title = "Are you sure you want to detete\nthis chat?";
        image = 'assets/images/ic_delete.png';
        break;
    }

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: SizedBox(
                  height: 320,
                  child: Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(
                            vertical: 30, horizontal: 20),
                        margin: const EdgeInsets.only(top: 50),
                        decoration: BoxDecoration(
                          color: AppColor.whiteColor,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              height: 40,
                            ),
                            AppText(
                                text: title,
                                textColor: AppColor.blackColor,
                                textAlign: TextAlign.center,
                                textSize: 12,
                                fontWeight: FontWeight.w500),
                            const SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: ElevatedBtn(
                                  text: 'Yes',
                                  buttonColor: AppColor.appColor,
                                  textColor: AppColor.whiteColor,
                                  onTap: () {
                                    Get.back();
                                  },
                                  width: 240),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: ElevatedStrokeBtn(
                                  text: 'No',
                                  buttonColor: AppColor.blackColor,
                                  textColor: AppColor.blackColor,
                                  onTap: () {
                                    Get.back();
                                  },
                                  width: 240),
                            )
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Image.asset(
                          image,
                          height: 100,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }

  showReportDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: SizedBox(
                  height: 500,
                  child: Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(
                            vertical: 30, horizontal: 20),
                        margin: const EdgeInsets.only(top: 50),
                        decoration: BoxDecoration(
                          color: AppColor.whiteColor,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              height: 40,
                            ),
                            AppText(
                                text: 'Why do you want to report this user?',
                                textColor: AppColor.blackColor,
                                textAlign: TextAlign.center,
                                textSize: 12,
                                fontWeight: FontWeight.w500),
                            const SimpleTf(
                              fillColor: Color(0xffF6F6F6),
                              hint: 'Write here...',
                              lines: 10,
                              height: 100,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: ElevatedBtn(
                                  text: 'OK',
                                  buttonColor: AppColor.appColor,
                                  textColor: AppColor.whiteColor,
                                  onTap: () {
                                    Get.back();
                                  },
                                )),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                    child: ElevatedStrokeBtn(
                                  text: 'Cancel',
                                  buttonColor: AppColor.blackColor,
                                  textColor: AppColor.blackColor,
                                  onTap: () {
                                    Get.back();
                                  },
                                ))
                              ],
                            )
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Image.asset(
                          'assets/images/ic_exclamation_red.png',
                          height: 100,
                        ),
                      ),
                    ],
                  ),
                ),
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
          width: MediaQuery.of(context).size.width / 1.3,
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
                onTap: () async {
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
                onTap: () async {
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
