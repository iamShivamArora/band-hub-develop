import 'dart:convert';
import 'dart:io';

import 'package:band_hub/routes/Routes.dart';
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

import '../../../models/get_categories_response.dart';
import '../../../models/profile_response.dart';
import '../../../util/common_funcations.dart';
import '../../../util/global_variable.dart';
import '../../../widgets/country_picker/country.dart';
import '../../authentication/setup_profile_screen.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  // ProfileController profileController = Get.put(ProfileController());

  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerNumber = TextEditingController();
  TextEditingController controllerDes = TextEditingController();
  TextEditingController controllerLocation = TextEditingController();
  String lat = "";
  String lng = "";
  String category = "";
  String countryCode = "";
  Country selectedCountryIsoName = Country.US;
  String imageFile = "";
  bool isEditProfile = false;
  bool gotData = false;
  List<CategoryModel> categoryList = [];
  List<CategoryModel> selectedCategoryList = [];
  List<CategoryModel> selectedAddedCategories = [];

  @override
  void initState() {
    getProfileApi(context, true);

    super.initState();
  }

  getCategoryList() async {
    GetCategoriesResponse result = await categoryListApi(context);
    for (var element in result.body) {
      if (element.isapprove == 0) {
        categoryList.add(CategoryModel(
            name: element.name + " (Pending)",
            id: element.id.toString(),
            underLine: false,
            isSelected: category.contains(element.name)));
      } else {
        categoryList.add(CategoryModel(
            name: element.name,
            id: element.id.toString(),
            underLine: false,
            isSelected: category.contains(element.name)));
      }
    }

    selectedCategoryList
        .addAll(categoryList.where((element) => element.isSelected));

    categoryList.add(
        CategoryModel(name: 'Add Your Categories', id: "", underLine: true));
    setState(() {});
  }

  Future<GetCategoriesResponse> categoryListApi(BuildContext ctx) async {
    EasyLoading.show(status: 'Loading');
    var connectivityResult = await (Connectivity().checkConnectivity());
    // if (loader != null) {
    //   loader.changeIsShowToast(
    //       !response.request!.url.path.contains(GlobalVariable.logout));
    // }

    if (!(connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi)) {
      throw new Exception('NO INTERNET CONNECTION');
    }
    var response = await http.get(
        Uri.parse(GlobalVariable.baseUrl + GlobalVariable.getUserCategories),
        headers: await CommonFunctions().getHeader());

    // if (response.statusCode == 201) {}
    print(response.body);
    GetCategoriesResponse? result = null;
    try {
      Map<String, dynamic> res = json.decode(response.body);

      result = GetCategoriesResponse.fromJson(res);
      if (res['code'] != 200 || json == null) {
        String error = res['msg'];
        // Fluttertoast.showToast(msg: error, toastLength: Toast.LENGTH_SHORT);
        // Navigator.pop(ctx);
        print("scasd  " + error);
        throw new Exception(error);
      }

      EasyLoading.dismiss();

      return result;
    } catch (error) {
      EasyLoading.dismiss();
      if (result != null) {
        Fluttertoast.showToast(
            msg: result.msg, toastLength: Toast.LENGTH_SHORT);
        throw result.msg;
      } else {
        Fluttertoast.showToast(
            msg: error.toString().substring(
                error.toString().indexOf(':') + 1, error.toString().length),
            toastLength: Toast.LENGTH_SHORT);
        throw error.toString();
      }
    }
  }

  void showCatrgoryDialog() {
    final controllerCat = TextEditingController();
    showDialog(
        context: Get.context!,
        builder: (_) => Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            child: Container(
                width: MediaQuery.of(context).size.width,
                padding:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                decoration: BoxDecoration(
                    color: AppColor.whiteColor,
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppText(
                        text: "Add Categories",
                        fontWeight: FontWeight.w400,
                        textSize: 13),
                    SimpleTf(
                      controller: controllerCat,
                      hint: "Enter Category",
                      maxLength: 30,
                      inputType: TextInputType.text,
                      action: TextInputAction.done,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedBtn(
                        text: "Submit",
                        onTap: () {
                          if (controllerCat.text.trim().toString().isNotEmpty) {
                            print(controllerCat.text.trim().toString());
                            print(categoryList[categoryList.length - 2].name);
                            var contain = false;
                            for (var it in categoryList) {
                              if (it.name.trim() ==
                                  controllerCat.text.trim().toString()) {
                                contain = true;
                                break;
                              }
                            }
                            if (contain) {
                              Fluttertoast.showToast(
                                  msg: 'Category already added');
                            } else {
                              CategoryModel value = CategoryModel(
                                  name: controllerCat.text.trim().toString(),
                                  id: "0",
                                  isSelected: true,
                                  underLine: false);
                              categoryList.removeAt(categoryList.length - 1);
                              categoryList.add(value);
                              categoryList.add(CategoryModel(
                                  name: 'Add Your Categories',
                                  id: "",
                                  underLine: true));
                              category +=
                                  controllerCat.text.trim().toString() + ", ";
                              selectedAddedCategories.add(value);
                              Get.back();
                            }
                          } else {
                            Fluttertoast.showToast(
                                msg: 'Please enter category');
                          }
                        })
                  ],
                ))));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (!EasyLoading.isShow) {
          if (isEditProfile) {
            isEditProfile = false;
            getProfileApi(context, false);
            return false;
          } else {
            return true;
          }
        } else {
          return false;
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
                        getProfileApi(context, false);
                        // setState(() {});
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
              actions: [
                isEditProfile
                    ? Container()
                    : GestureDetector(
                        onTap: () {
                          if (!isEditProfile) {
                            isEditProfile = true;
                            setState(() {});
                          } else {
                            // api call
                            if (validation().isEmpty) {
                              if (imageFile.contains(GlobalVariable.imageUrl)) {
                                editProfileApi(context);
                              } else {
                                editProfileApiWithImage(context);
                              }
                            } else {
                              Fluttertoast.showToast(msg: validation());
                            }
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Icon(Icons.edit, color: AppColor.appColor),
                        ),
                      )
              ],
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.white,
                statusBarIconBrightness: Brightness.dark,
                statusBarBrightness: Brightness.light,
              )),
          body: SingleChildScrollView(
            child: gotData
                ? GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () =>
                        FocusScope.of(context).requestFocus(FocusScopeNode()),
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
                                            color: AppColor.grayColor
                                                .withAlpha(80),
                                            blurRadius: 10.0,
                                            offset: const Offset(0, 4)),
                                      ]),
                                  child: Stack(children: [
                                    SizedBox(
                                        height: 150,
                                        width: 150,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: imageFile.isNotEmpty
                                              ? imageFile.contains(
                                                      GlobalVariable.imageUrl)
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
                              text: controllerName.text.trim().toString(),
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
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: AppColor.grayColor
                                                        .withAlpha(80),
                                                    blurRadius: 10.0,
                                                    offset: const Offset(0, 4)),
                                              ]),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SimpleTf(
                                                controller: controllerName,
                                                title: 'Full Name',
                                                height: 45,
                                                maxLength: 25,
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
                                                    countryCode =
                                                        "+" + _.dialingCode;
                                                    getCountryIso(
                                                        "+" + _.dialingCode);
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
                                              InkWell(
                                                onTap: () => Get.toNamed(
                                                        Routes.mapScreen)!
                                                    .then((value) {
                                                  controllerLocation.text =
                                                      value['location'] ?? "";
                                                  lat = value['lat'] ?? "";
                                                  lng = value['lng'] ?? "";
                                                  setState(() {});
                                                }),
                                                child: AbsorbPointer(
                                                  absorbing: true,
                                                  child: SimpleTf(
                                                    controller:
                                                        controllerLocation,
                                                    title: "Location",
                                                    lines: controllerLocation
                                                                .text.length >
                                                            50
                                                        ? 2
                                                        : 1,
                                                    height: controllerLocation
                                                                .text.length >
                                                            50
                                                        ? 80
                                                        : 50,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              Text(
                                                'Categories',
                                                style: TextStyle(
                                                    color: AppColor.blackColor,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 13),
                                              ),
                                              Container(
                                                  height: 50,
                                                  margin: const EdgeInsets.only(
                                                      top: 2),
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 15),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border.all(
                                                          color: AppColor
                                                              .grayColor,
                                                          width: 1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12)),
                                                  child:
                                                      DropdownButtonHideUnderline(
                                                    child: DropdownButton<
                                                        CategoryModel>(
                                                      isExpanded: true,
                                                      elevation: 2,
                                                      isDense: true,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      hint: AppText(
                                                          text: category.isEmpty
                                                              ? "Select Categories"
                                                              : category,
                                                          textColor: AppColor
                                                              .blackColor,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          textSize: 13),
                                                      items: categoryList.map(
                                                          (CategoryModel
                                                              value) {
                                                        return DropdownMenuItem<
                                                            CategoryModel>(
                                                          value: value,
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                  child:
                                                                      AppText(
                                                                text:
                                                                    value.name,
                                                                textColor: value
                                                                            .underLine ??
                                                                        false
                                                                    ? AppColor
                                                                        .appColor
                                                                    : AppColor
                                                                        .blackColor,
                                                                underline: value
                                                                        .underLine ??
                                                                    false,
                                                                textSize: 14,
                                                              )),
                                                              Visibility(
                                                                visible: !(value
                                                                        .underLine ??
                                                                    false),
                                                                child: SizedBox(
                                                                  height: 16,
                                                                  width: 16,
                                                                  child: Stack(
                                                                    children: [
                                                                      Image
                                                                          .asset(
                                                                        'assets/images/ic_check_box.png',
                                                                        height:
                                                                            16,
                                                                        width:
                                                                            16,
                                                                      ),
                                                                      Visibility(
                                                                        visible:
                                                                            value.isSelected,
                                                                        child: Positioned.fill(
                                                                            child: Align(
                                                                                alignment: Alignment.center,
                                                                                child: Image.asset(
                                                                                  'assets/images/ic_tick.png',
                                                                                  height: 10,
                                                                                  width: 10,
                                                                                ))),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        );
                                                      }).toList(),
                                                      onChanged: (value) {
                                                        if ((value?.underLine ??
                                                            false)) {
                                                          showCatrgoryDialog();
                                                        } else {
                                                          if (value!.id ==
                                                              "0") {
                                                            if (value
                                                                .isSelected) {
                                                              value.isSelected =
                                                                  false;
                                                              // if (category.contains(value.name.toString())) {
                                                              category = category
                                                                  .replaceAll(
                                                                      value.name
                                                                              .toString() +
                                                                          ",",
                                                                      '');
                                                              selectedAddedCategories
                                                                  .remove(
                                                                      value);
                                                              setState(() {});
                                                              return;
                                                              // }
                                                            }
                                                            value.isSelected =
                                                                true;
                                                            category += value
                                                                    .name
                                                                    .toString() +
                                                                ",";
                                                            selectedAddedCategories
                                                                .add(value);
                                                          } else {
                                                            if (value
                                                                .isSelected) {
                                                              value.isSelected =
                                                                  false;
                                                              // if (category.contains(value.name.toString())) {
                                                              category = category
                                                                  .replaceAll(
                                                                      value.name
                                                                              .toString() +
                                                                          ",",
                                                                      '')
                                                                  .trim();
                                                              selectedCategoryList
                                                                  .remove(
                                                                      value);
                                                              setState(() {});
                                                              return;
                                                              // }
                                                            }
                                                            value.isSelected =
                                                                true;
                                                            category += (value
                                                                        .name
                                                                        .toString() +
                                                                    ",")
                                                                .trim();
                                                            selectedCategoryList
                                                                .add(value);
                                                          }
                                                        }
                                                        setState(() {});
                                                      },
                                                    ),
                                                  )),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              SimpleTf(
                                                controller: controllerDes,
                                                title: 'Description',
                                                height: 45,
                                              ),
                                            ],
                                          ))
                                      : Container(
                                          width: Get.width,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 20),
                                          decoration: BoxDecoration(
                                              color: AppColor.whiteColor,
                                              borderRadius:
                                                  BorderRadius.circular(12),
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                AppText(
                                                  text: 'Name',
                                                  textSize: 13,
                                                ),
                                                AppText(
                                                  text: controllerName.text
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                AppText(
                                                  text: 'Email',
                                                  textSize: 13,
                                                ),
                                                AppText(
                                                  text: controllerEmail.text
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                AppText(
                                                  text: 'Description',
                                                  textSize: 13,
                                                ),
                                                AppText(
                                                  text: controllerDes.text
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 8.0),
                                                  child: AppText(
                                                    text: category.contains(',')
                                                        ? 'Categories'
                                                        : 'Category',
                                                    textSize: 13,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: AppText(
                                                    textAlign: TextAlign.end,
                                                    text: category,
                                                    textSize: 13,
                                                  ),
                                                )
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 8.0),
                                                  child: AppText(
                                                    text: 'Location',
                                                    textSize: 13,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: AppText(
                                                    textAlign: TextAlign.end,
                                                    text: controllerLocation
                                                        .text
                                                        .trim()
                                                        .toString(),
                                                    textSize: 13,
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
                                    text: isEditProfile
                                        ? "Update"
                                        : "Edit Profile",
                                    onTap: () {
                                      if (!EasyLoading.isShow) {
                                        if (!isEditProfile) {
                                          isEditProfile = true;
                                          setState(() {});
                                        } else {
                                          // api call
                                          if (validation().isEmpty) {
                                            if (imageFile.contains(
                                                GlobalVariable.imageUrl)) {
                                              editProfileApi(context);
                                            } else {
                                              editProfileApiWithImage(context);
                                            }
                                          } else {
                                            Fluttertoast.showToast(
                                                msg: validation());
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
                  )
                : Container(),
          )),
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

  Future getProfileApi(BuildContext ctx, bool showLoading) async {
    if (showLoading) {
      EasyLoading.show(status: 'Loading');
    }
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
      ProfileResponse result = ProfileResponse.fromJson(res);
      if (showLoading) {
        EasyLoading.dismiss();
      }
      category = "";
      controllerName.text = res['body']['full_name'];
      controllerEmail.text = res['body']['email'];
      controllerLocation.text = res['body']['location'];
      controllerNumber.text = res['body']['phone'];
      controllerDes.text = res['body']['description'];
      // category = res['body']['categoryName'].toString() + ', ';
      countryCode = res['body']['countryCode'];
      imageFile = res['body']['profileImage'];
      if (result.body.categries.isNotEmpty) {
        for (var item in result.body.categries) {
          if (item.isapprove == 0) {
            if (category.isEmpty) {
              category = item.name + " (Pending), ";
            } else {
              category = category + item.name + " (Pending), ";
            }
          } else {
            if (category.isEmpty) {
              category = item.name + ', ';
            } else {
              category = category + item.name + ', ';
            }
          }
        }
      }
      getCountryIso(countryCode);
      if (showLoading) {
        getCategoryList();
      }

      gotData = true;

      setState(() {});
    } catch (error) {
      if (showLoading) {
        EasyLoading.dismiss();
      }

      Fluttertoast.showToast(
          msg: error.toString().substring(
              error.toString().indexOf(':') + 1, error.toString().length),
          toastLength: Toast.LENGTH_SHORT);
      throw error.toString();
    }
  }

  Future editProfileApi(BuildContext ctx) async {
    var catId = "";
    for (var element in selectedCategoryList) {
      if (catId.isEmpty) {
        catId = element.id;
      } else {
        catId = catId + "," + element.id;
      }
    }
    var addedCatId = "";
    for (var element in selectedAddedCategories) {
      if (addedCatId.isEmpty) {
        addedCatId = element.name;
      } else {
        addedCatId = addedCatId + "," + element.name;
      }
    }
    Map<String, String> body = {
      "full_name": controllerName.text.trim().toString(),
      "musician_name": controllerName.text.trim().toString(),
      "email": controllerEmail.text.trim().toString(),
      "phone": controllerNumber.text.trim().toString(),
      "countryCode": countryCode,
      "location": controllerLocation.text.trim().toString(),
      "about": controllerDes.text.trim().toString(),
      "lat": lat,
      "lng": lng
    };
    if (catId.isNotEmpty) {
      body['categoryId'] = catId;
    }
    if (addedCatId.isNotEmpty) {
      body['myCat'] = addedCatId;
    }
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
      if (res['code'] != 200 || json == null) {
        String error = res['msg'];
        // Fluttertoast.showToast(msg: error, toastLength: Toast.LENGTH_SHORT);
        // Navigator.pop(ctx);
        print("scasd  " + error);
        throw new Exception(error);
      }
      // LoginResponseModel result = LoginResponseModel.fromJson(res);
      EasyLoading.dismiss();
      Get.back();
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
    var catId = "";
    for (var element in selectedCategoryList) {
      if (catId.isEmpty) {
        catId = element.id;
      } else {
        catId = catId + "," + element.id;
      }
    }
    var addedCatId = "";
    for (var element in selectedAddedCategories) {
      if (addedCatId.isEmpty) {
        addedCatId = element.name;
      } else {
        addedCatId = addedCatId + "," + element.name;
      }
    }
    Map<String, String> body = {
      "full_name": controllerName.text.trim().toString(),
      "musician_name": controllerName.text.trim().toString(),
      "email": controllerEmail.text.trim().toString(),
      "phone": controllerNumber.text.trim().toString(),
      "countryCode": countryCode,
      "location": controllerLocation.text.trim().toString(),
      "about": controllerDes.text.trim().toString(),
      "lat": lat,
      "lng": lng
    };
    if (catId.isNotEmpty) {
      body['categoryId'] = catId;
    }
    print(body);
    EasyLoading.show(status: 'Loading');
    var request = new http.MultipartRequest(
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
          Get.back();
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
    } else if (selectedCategoryList.isEmpty &&
        selectedAddedCategories.isEmpty) {
      return "Please select atleast one category";
    } else if (controllerLocation.text.trim().isEmpty) {
      return "Please select location";
    } else if (controllerDes.text.trim().isEmpty) {
      return "Please enter description";
    } else {
      return "";
    }
  }
}
