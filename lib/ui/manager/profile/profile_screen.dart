import 'dart:convert';
import 'dart:io';

import 'package:band_hub/widgets/app_color.dart';
import 'package:band_hub/widgets/app_text.dart';
import 'package:band_hub/widgets/custom_phone_text_field.dart';
import 'package:band_hub/widgets/custom_text_field.dart';
import 'package:band_hub/widgets/elevated_btn.dart';
import 'package:band_hub/widgets/image_picker.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../models/auth/login_response_model.dart';
import '../../../routes/Routes.dart';
import '../../../util/common_funcations.dart';
import '../../../util/global_variable.dart';
import '../../../util/sharedPref.dart';
import '../../../widgets/country_picker/country.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // ProfileController profileController = Get.put(ProfileController());

  // File? imageFile;
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerAbout = TextEditingController();
  TextEditingController controllerNumber = TextEditingController();
  String countryCode = "";
  Country selectedCountryIsoName = Country.US;
  String imageFile = "";
  bool isEditProfile = false;
  bool gotData = false;

  @override
  void initState() {
    getProfileApi(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isEditProfile) {
          isEditProfile = false;
          setState(() {});
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
          backgroundColor: AppColor.whiteColor,
          appBar: AppBar(
              backgroundColor: AppColor.whiteColor,
              title: AppText(
                text: isEditProfile ? "Edit Profile" : 'My Profile',
                fontWeight: FontWeight.w400,
                textColor: Colors.black,
                textSize: 18,
              ),
              leading: Container(
                margin: const EdgeInsets.only(left: 10),
                child: IconButton(
                  icon: Image.asset(
                    'assets/images/ic_back.png',
                    height: 22,
                  ),
                  onPressed: () {
                    if (!EasyLoading.isShow) {
                      if (isEditProfile) {
                        isEditProfile = false;
                        setState(() {});
                      } else {
                        Get.back();
                      }
                    }
                  },
                ),
              ),
              centerTitle: true,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.white),
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.white,
                statusBarIconBrightness: Brightness.dark,
                statusBarBrightness: Brightness.light,
              )),
          body: SingleChildScrollView(
              child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => FocusScope.of(context).requestFocus(FocusScopeNode()),
            child: Stack(
              children: [
                Container(
                  color: const Color(0xffE9E9E9),
                  height: 150,
                ),
                Column(
                  children: [
                    const SizedBox(
                      height: 75,
                    ),
                    Center(
                      child: InkWell(
                        onTap: () {
                          if (!EasyLoading.isShow) {
                            if (isEditProfile) {
                              showImagePicker();
                            }
                          }
                        },
                        child: Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              boxShadow: [
                                BoxShadow(
                                    color: AppColor.grayColor.withAlpha(80),
                                    blurRadius: 10.0,
                                    offset: const Offset(0, 4)),
                              ]),
                          child: Stack(children: [
                            SizedBox(
                                height: 150,
                                width: 150,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: imageFile.isNotEmpty
                                      ? imageFile
                                              .contains(GlobalVariable.imageUrl)
                                          ? Image.network(
                                              imageFile,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.file(
                                              File(imageFile),
                                              fit: BoxFit.cover,
                                            )
                                      : Image.asset(
                                          'assets/images/ic_user.png'),
                                )),
                            Visibility(
                              visible: isEditProfile,
                              child: Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Image.asset(
                                    'assets/images/ic_camera_red.png',
                                    height: 40,
                                  )),
                            )
                          ]),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    AppText(
                      text: controllerName.text,
                      fontWeight: FontWeight.w600,
                      textSize: 18,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          isEditProfile
                              ? Container(
                                  width: Get.width,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 20),
                                  decoration: BoxDecoration(
                                      color: AppColor.whiteColor,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                            color: AppColor.grayColor
                                                .withAlpha(80),
                                            blurRadius: 10.0,
                                            offset: const Offset(0, 4)),
                                      ]),
                                  child: Column(
                                    children: [
                                      SimpleTf(
                                        controller: controllerName,
                                        title: 'Full Name',
                                        maxLength: 25,
                                        height: 45,
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      SimplePhoneTf(
                                          editabled: false,
                                          controller: controllerNumber,
                                          selectedCountry:
                                              selectedCountryIsoName,
                                          title: 'Phone Number',
                                          onChanged: (_) {
                                            countryCode = "+" + _.dialingCode;
                                            getCountryIso("+" + _.dialingCode);
                                            setState(() {});
                                          },
                                          height: 45),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      SimpleTf(
                                        editabled: false,
                                        controller: controllerEmail,
                                        title: 'Email',
                                        height: 45,
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      SimpleTf(
                                        controller: controllerAbout,
                                        title: 'About',
                                        height: 100,
                                        lines: 4,
                                      )
                                    ],
                                  ))
                              : Container(
                                  width: Get.width,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 20),
                                  decoration: BoxDecoration(
                                      color: AppColor.whiteColor,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                            color: AppColor.grayColor
                                                .withAlpha(80),
                                            blurRadius: 10.0,
                                            offset: const Offset(0, 4)),
                                      ]),
                                  child: Column(children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        AppText(
                                          text: 'Name',
                                          textSize: 13,
                                        ),
                                        AppText(
                                          text: controllerName.text,
                                          textSize: 13,
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        AppText(
                                          text: 'Email',
                                          textSize: 13,
                                        ),
                                        AppText(
                                          text: controllerEmail.text,
                                          textSize: 13,
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        AppText(
                                          text: 'Phone Number',
                                          textSize: 13,
                                        ),
                                        AppText(
                                          text: countryCode +
                                              " " +
                                              controllerNumber.text
                                                  .trim()
                                                  .toString(),
                                          textSize: 13,
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AppText(
                                          text: 'About',
                                          textSize: 13,
                                        ),
                                        const SizedBox(
                                          width: 80,
                                        ),
                                        Expanded(
                                          child: AppText(
                                            textAlign: TextAlign.right,
                                            text: controllerAbout.text,
                                            textSize: 13,
                                            textColor: AppColor.blackColor,
                                          ),
                                        )
                                      ],
                                    )
                                  ]),
                                ),
                          const SizedBox(
                            height: 30,
                          ),
                          ElevatedBtn(
                            text: isEditProfile ? "Update" : "Edit Profile",
                            onTap: () {
                              if (!EasyLoading.isShow) {
                                if (!isEditProfile) {
                                  isEditProfile = true;
                                  setState(() {});
                                } else {
                                  // api call
                                  if (validation().isEmpty) {
                                    if (imageFile
                                        .contains(GlobalVariable.imageUrl)) {
                                      editProfileApi(context);
                                    } else {
                                      editProfileApiWithImage(context);
                                    }
                                  } else {
                                    Fluttertoast.showToast(msg: validation());
                                  }
                                }
                              }
                            },
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ))),
    );
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
                  imageFile = selectedImage!;
                  setState(() {});
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
                  imageFile = selectedImage!;
                  setState(() {});
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

  Future getProfileApi(BuildContext ctx) async {
    EasyLoading.show(status: 'Loading');
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (!(connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi)) {
      throw new Exception('NO INTERNET CONNECTION');
    }
    var response = await http.get(
        Uri.parse(GlobalVariable.baseUrl + GlobalVariable.getProfile),
        headers: await CommonFunctions().getHeader());

    print(response.body);
    try {
      Map<String, dynamic> res = json.decode(response.body);
      if (res['code'] == 401) {
        String error = res['msg'];
        Get.toNamed(Routes.logInScreen);
        throw new Exception(error);
      }
      if (res['code'] != 200 || json == null) {
        String error = res['msg'];
        // Fluttertoast.showToast(msg: error, toastLength: Toast.LENGTH_SHORT);
        // Navigator.pop(ctx);
        print("scasd  " + error);
        throw new Exception(error);
      }
      // LoginResponseModel result = LoginResponseModel.fromJson(res);
      EasyLoading.dismiss();
      controllerName.text = res['body']['full_name'];
      controllerEmail.text = res['body']['email'];
      controllerNumber.text = res['body']['phone'];
      controllerAbout.text = res['body']['description'];
      countryCode = res['body']['countryCode'];
      imageFile = res['body']['profileImage'];
      getCountryIso(countryCode);
      LoginResponseModel result = LoginResponseModel.fromJson(res);
      SharedPref().setPreferenceJson(jsonEncode(result));
      gotData = true;

      setState(() {});
    } catch (error) {
      EasyLoading.dismiss();

      Fluttertoast.showToast(
          msg: error.toString().substring(
              error.toString().indexOf(':') + 1, error.toString().length),
          toastLength: Toast.LENGTH_SHORT);
      throw error.toString();
    }
  }

  Future editProfileApi(BuildContext ctx) async {
    Map<String, String> body = {
      "full_name": controllerName.text.trim().toString(),
      "email": controllerEmail.text.trim().toString(),
      "phone": controllerNumber.text.trim().toString(),
      "about": controllerAbout.text.trim().toString(),
      "countryCode": countryCode,
    };
    print(body);
    EasyLoading.show(status: 'Loading');
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (!(connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi)) {
      throw new Exception('NO INTERNET CONNECTION');
    }
    var response = await http.post(
        Uri.parse(GlobalVariable.baseUrl + GlobalVariable.editProfile),
        headers: await CommonFunctions().getHeader(),
        body: body);

    print(response.body);
    try {
      Map<String, dynamic> res = json.decode(response.body);
      if (res['code'] == 401) {
        String error = res['msg'];
        Get.toNamed(Routes.logInScreen);
        throw new Exception(error);
      }
      if (res['code'] != 200 || res == null) {
        String error = res['msg'];
        print("scasd  " + error);
        throw new Exception(error);
      }
      // LoginResponseModel result = LoginResponseModel.fromJson(res);
      EasyLoading.dismiss();
      isEditProfile = false;
      getProfileApi(ctx);
      setState(() {});
      Fluttertoast.showToast(msg: res['msg']);
    } catch (error) {
      EasyLoading.dismiss();

      Fluttertoast.showToast(
          msg: error.toString().substring(
              error.toString().indexOf(':') + 1, error.toString().length),
          toastLength: Toast.LENGTH_SHORT);
      throw error.toString();
    }
  }

  Future editProfileApiWithImage(BuildContext ctx) async {
    Map<String, String> body = {
      "full_name": controllerName.text.trim().toString(),
      "email": controllerEmail.text.trim().toString(),
      "phone": controllerNumber.text.trim().toString(),
      "description": controllerAbout.text.trim().toString(),
      "countryCode": countryCode,
    };
    print("request body : " + body.toString());
    EasyLoading.show(status: 'Loading');
    var request = http.MultipartRequest(
        "POST", Uri.parse(GlobalVariable.baseUrl + GlobalVariable.editProfile));
    request.headers.addAll(await CommonFunctions().getHeader());
    request.fields.addAll(body);
    http.MultipartFile multipartFile =
        await http.MultipartFile.fromPath('profile_image', imageFile);

    request.files.add(multipartFile);
    var time = 0;
    try {
      var response = await request.send();

      var result = await response.stream.bytesToString();
      print(result);
      var res = json.decode(result);
      if (res['code'] == 200) {
        // Navigator.pop(ctx);
        EasyLoading.dismiss();
        if (time == 0) {
          print(res);
          isEditProfile = false;
          getProfileApi(ctx);
          setState(() {});
          Fluttertoast.showToast(msg: res['msg']);
          time = time + 1;
          print("sucasdsadsadasdasdascccccc");
        } else {
          print("sucasdsadsadasdasdascccccc ++++  1111");
        }

        return;
      } else {
        EasyLoading.dismiss();
        // Navigator.pop(ctx);
        throw new Exception(res['msg']);
      }
    } catch (error) {
      EasyLoading.dismiss();
      Fluttertoast.showToast(
          msg: error.toString().substring(
              error.toString().indexOf(':') + 1, error.toString().length),
          toastLength: Toast.LENGTH_SHORT);
      print(error);
    }
  }

  void getCountryIso(String code) {
    for (var element in Country.ALL) {
      if (code == "+" + element.dialingCode) {
        selectedCountryIsoName = element;
        print(element.name);
      }
    }
  }

  String validation() {
    FocusScope.of(context).requestFocus(FocusScopeNode());
    if (imageFile.isEmpty) {
      return "Please select profile image";
    } else if (controllerName.text.trim().isEmpty) {
      return "Please enter name";
    } else if (controllerNumber.text.trim().isEmpty) {
      return "Please enter number";
    } else if (controllerNumber.text.trim().length < 10) {
      return "Please enter at least 10 digits in phone number";
    } else if (controllerEmail.text.trim().isEmpty) {
      return "Please enter email";
    } else if (!CommonFunctions()
        .isEmailValid(controllerEmail.text.trim().toString())) {
      return "Please enter valid email";
    } else if (controllerAbout.text.trim().isEmpty) {
      return "Please enter about";
    } else {
      return "";
    }
  }
}
