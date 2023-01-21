import 'dart:convert';
import 'dart:io';

import 'package:band_hub/models/success_response.dart';
import 'package:band_hub/routes/Routes.dart';
import 'package:band_hub/widgets/app_color.dart';
import 'package:band_hub/widgets/app_text.dart';
import 'package:band_hub/widgets/custom_text_field.dart';
import 'package:band_hub/widgets/elevated_btn.dart';
import 'package:band_hub/widgets/helper_widget.dart';
import 'package:band_hub/widgets/image_picker.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../models/get_categories_response.dart';
import '../../models/auth/login_response_model.dart';
import '../../util/common_funcations.dart';
import '../../util/global_variable.dart';
import '../../util/sharedPref.dart';

class SetupProfileScreen extends StatefulWidget {
  const SetupProfileScreen({Key? key}) : super(key: key);

  @override
  State<SetupProfileScreen> createState() => _SetupProfilescreenState();
}

class _SetupProfilescreenState extends State<SetupProfileScreen> {
  List<File> imagesList = [];
  String category = '';

  // String signUpImage = '';
  List<CategoryModel> selectedCategoryList = [];
  List<CategoryModel> selectedAddedCategories = [];

  // Map<String, String> signUpBody = Map();

  List<CategoryModel> categoryList = [];
  var musicianName = "";

  // TextEditingController controllerMusicianName = TextEditingController();
  TextEditingController controllerLocation = TextEditingController();
  TextEditingController controllerDes = TextEditingController();

  @override
  void initState() {
    musicianName = Get.arguments['userName'] ?? "";
    getCategoryList();
    // signUpBody = Get.arguments['bodySignup'];
    // signUpImage = Get.arguments['signUpImage'];
    super.initState();
  }

  getCategoryList() async {
    GetCategoriesResponse result = await categoryListApi(context);
    result.body.forEach((element) {
      categoryList.add(CategoryModel(
          name: element.name, id: element.id.toString(), underLine: false));
    });
    categoryList.add(
        CategoryModel(name: 'Add Your Categories', id: "", underLine: true));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.whiteColor,
        appBar: HelperWidget.customAppBar(title: 'Setup Profile'),
        body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () =>
                  FocusScope.of(context).requestFocus(FocusScopeNode()),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () => showImagePicker(),
                      child: Container(
                          margin: const EdgeInsets.only(top: 3),
                          height: 210,
                          width: Get.width,
                          decoration: BoxDecoration(
                              color: AppColor.whiteColor,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColor.grayColor.withAlpha(70),
                                  blurRadius: 5.0,
                                ),
                              ]),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/ic_black_camera.png',
                                height: 30,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              AppText(
                                text: 'Upload Photo',
                                fontWeight: FontWeight.w400,
                                textColor: AppColor.blackColor,
                                textSize: 12,
                              ),
                            ],
                          )),
                    ),
                    imagesList.isNotEmpty
                        ? Container(
                            margin: const EdgeInsets.only(top: 10),
                            height: 62,
                            child: ListView.builder(
                                itemCount: imagesList.length,
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return Stack(
                                    children: [
                                      Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            child: Image.file(
                                              imagesList[index],
                                              height: 55,
                                              fit: BoxFit.cover,
                                              width: 65,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                        ],
                                      ),
                                      Positioned(
                                        right: 0,
                                        child: InkWell(
                                          onTap: (() {
                                            imagesList.removeAt(index);
                                            setState(() {});
                                          }),
                                          child: const Icon(
                                            Icons.cancel,
                                            size: 20,
                                            color: Colors.red,
                                          ),
                                        ),
                                      )
                                    ],
                                  );
                                }),
                          )
                        : Container(),
                    const SizedBox(
                      height: 10,
                    ),
                    /*SimpleTf(
                      controller: controllerMusicianName,
                      title: "Musician Name",
                      action: TextInputAction.next,
                    ),
                    const SizedBox(
                      height: 20,
                    ),*/
                    AppText(text: 'Categories', textSize: 13),
                    Container(
                        height: 50,
                        margin: const EdgeInsets.only(top: 2),
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border:
                                Border.all(color: AppColor.grayColor, width: 1),
                            borderRadius: BorderRadius.circular(12)),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<CategoryModel>(
                            isExpanded: true,
                            elevation: 2,
                            isDense: true,
                            borderRadius: BorderRadius.circular(12),
                            hint: AppText(
                                text: category.isEmpty
                                    ? "Select Categories"
                                    : category,
                                textColor: AppColor.blackColor,
                                fontWeight: FontWeight.w400,
                                textSize: 13),
                            items: categoryList.map((CategoryModel value) {
                              return DropdownMenuItem<CategoryModel>(
                                value: value,
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: AppText(
                                      text: value.name,
                                      textColor: value.underLine ?? false
                                          ? AppColor.appColor
                                          : AppColor.blackColor,
                                      underline: value.underLine ?? false,
                                      textSize: 14,
                                    )),
                                    Visibility(
                                      visible: !(value.underLine ?? false),
                                      child: SizedBox(
                                        height: 16,
                                        width: 16,
                                        child: Stack(
                                          children: [
                                            Image.asset(
                                              'assets/images/ic_check_box.png',
                                              height: 16,
                                              width: 16,
                                            ),
                                            Visibility(
                                              visible: value.isSelected,
                                              child: Positioned.fill(
                                                  child: Align(
                                                      alignment:
                                                          Alignment.center,
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
                              if ((value?.underLine ?? false)) {
                                showCatrgoryDialog();
                              } else {
                                if (value!.id == "0") {
                                  if (value.isSelected) {
                                    value.isSelected = false;
                                    // if (category.contains(value.name.toString())) {
                                    category = category.replaceAll(
                                        value.name.toString() + ", ", '');
                                    selectedAddedCategories.remove(value);
                                    setState(() {});
                                    return;
                                    // }
                                  }
                                  value.isSelected = true;
                                  category += value.name.toString() + ", ";
                                  selectedAddedCategories.add(value);
                                } else {
                                  if (value.isSelected) {
                                    value.isSelected = false;
                                    // if (category.contains(value.name.toString())) {
                                    category = category.replaceAll(
                                        value.name.toString() + ", ", '');
                                    selectedCategoryList.remove(value);
                                    setState(() {});
                                    return;
                                    // }
                                  }
                                  value.isSelected = true;
                                  category += value.name.toString() + ", ";
                                  selectedCategoryList.add(value);
                                }
                              }
                              setState(() {});
                            },
                          ),
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                    SimpleTf(
                      controller: controllerLocation,
                      title: "Location",
                      action: TextInputAction.next,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SimpleTf(
                      controller: controllerDes,
                      title: "Description",
                      action: TextInputAction.done,
                      lines: 6,
                      height: 100,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    ElevatedBtn(
                        onTap: (() {
                          if (validation().isEmpty) {
                            signUpProfile(context);
                          } else {
                            Fluttertoast.showToast(msg: validation());
                          }

                          // Get.toNamed(Routes.managerHomeScreen);
                        }),
                        text: 'Submit'),
                    const SizedBox(
                      height: 20,
                    ),
                  ]),
            )));
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
                      inputType: TextInputType.text,
                      action: TextInputAction.done,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedBtn(
                        text: "Submit",
                        onTap: () {
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
                        })
                  ],
                ))));
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
                  imagesList.add(File(selectedImage!));
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
                  imagesList.add(File(selectedImage!));

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
        Uri.parse(GlobalVariable.baseUrl + GlobalVariable.getCategories),
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

  Future signUpProfile(BuildContext ctx) async {
    var catId = "";
    selectedCategoryList.forEach((element) {
      if (catId.isEmpty) {
        catId = element.id;
      } else {
        catId = catId + "," + element.id;
      }
    });
    var addedCatId = "";
    selectedAddedCategories.forEach((element) {
      if (addedCatId.isEmpty) {
        addedCatId = element.name;
      } else {
        addedCatId = addedCatId + "," + element.name;
      }
    });
    Map<String, String> body = {
      // "musician_name": controllerMusicianName.text.trim().toString(),
      "musician_name": musicianName,
      "location": controllerLocation.text.trim().toString(),
      "description": controllerDes.text.trim().toString(),
      "lat": "0.0",
      "lng": "0.0",
    };
    if (catId.isNotEmpty) {
      body['categoryId'] = catId;
    }
    // if (addedCatId.isNotEmpty) {
    //   body['newCategory'] = addedCatId;
    // }
    EasyLoading.show(status: 'Loading');
    var request = http.MultipartRequest("POST",
        Uri.parse(GlobalVariable.baseUrl + GlobalVariable.setUpProfile));
    request.headers.addAll(await CommonFunctions().getHeader());
    request.fields.addAll(body);
    List<http.MultipartFile> files = [];
    for(var element in imagesList) {
      var multipartFile = await http.MultipartFile.fromPath('images', element.path);
      files.add(multipartFile);
    }
    request.files.addAll(files);
    try {
      var response = await request.send();

      var result = await response.stream.bytesToString();

      var res = SuccessResponse.fromJson(json.decode(result));
      if (res.code == 200) {
        // Navigator.pop(ctx);
        EasyLoading.dismiss();
        SharedPref().setToken("");
        showSuccessDialog();
        return;
      } else {
        EasyLoading.dismiss();
        // Navigator.pop(ctx);
        throw new Exception(res.msg);
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

  showSuccessDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => WillPopScope(
          onWillPop: () async => false,
          child: Dialog(
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
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle_rounded,
                          color: AppColor.greenColor, size: 80),
                      const SizedBox(
                        height: 20,
                      ),
                      AppText(
                          text: "Thanks",
                          textColor: AppColor.blackColor,
                          textAlign: TextAlign.center,
                          textSize: 16,
                          fontWeight: FontWeight.w500),
                      const SizedBox(
                        height: 10,
                      ),
                      AppText(
                          text:
                              "Your signed in successfully done\nwaiting to admin approval.",
                          textColor: AppColor.blackColor,
                          textAlign: TextAlign.center,
                          textSize: 12,
                          fontWeight: FontWeight.w400),
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
                              Get.offAllNamed(Routes.logInScreen);
                              // Get.toNamed(Routes.verificationScreen, arguments: {
                              //   "isFromLogin": false,
                              //   "userType": isSelectUser
                              // });
                            },
                          )),
                        ],
                      )
                    ],
                  ),
                ),
              ),
        ));
  }

  String validation() {
    FocusScope.of(context).requestFocus(FocusScopeNode());
    if (imagesList.isEmpty) {
      return "Please select atleast one image";
    }
    /* else if (controllerMusicianName.text.trim().isEmpty) {
      return "Please enter musician name";
    }*/
    else if (selectedCategoryList.isEmpty /*&& selectedAddedCategories.isEmpty*/) {
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

class CategoryModel {
  String name = "";
  String id = "";
  bool isSelected = false;
  bool? underLine = false;

  CategoryModel(
      {this.name = "", this.id = "", this.isSelected = false, this.underLine});
}
