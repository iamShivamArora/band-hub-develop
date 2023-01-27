import 'dart:convert';
import 'dart:io';

import 'package:band_hub/routes/Routes.dart';
import 'package:band_hub/widgets/app_color.dart';
import 'package:band_hub/widgets/app_text.dart';
import 'package:band_hub/widgets/custom_text_field.dart';
import 'package:band_hub/widgets/elevated_btn.dart';
import 'package:band_hub/widgets/helper_widget.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../models/get_categories_response.dart';
import '../../../models/manager/manager_home_response.dart';
import '../../../models/success_response.dart';
import '../../../util/common_funcations.dart';
import '../../../util/global_variable.dart';
import '../../../widgets/image_picker.dart';
import '../../authentication/setup_profile_screen.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({Key? key}) : super(key: key);

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  String category = 'Select';
  String categoryId = '';
  String eventId = '';
  List<String> imagesList = [];
  bool isFromEdit = false;
  int selectedTime = 0;
  String lat = '';
  String lng = '';
  DateTime selectedDate = DateTime(2023);

  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerDes = TextEditingController();
  TextEditingController controllerStartDate = TextEditingController();
  TextEditingController controllerEndDate = TextEditingController();
  TextEditingController controllerStartTime = TextEditingController();
  TextEditingController controllerEndTime = TextEditingController();

  final locationController = TextEditingController();
  List<CategoryModel> categoryList = [];
  EventsListResponse? eventData;

  @override
  void initState() {
    super.initState();
    isFromEdit = Get.arguments['isEdit'] ?? false;
    eventData = Get.arguments['data'];
    editDataSet();
    getCategoryList();
  }

  void editDataSet() {
    if (isFromEdit) {
      eventId = eventData!.id.toString();
      controllerName.text = eventData!.name;
      locationController.text = eventData!.location;
      controllerStartDate.text =
          CommonFunctions().changeServerDateDisplayFormat(eventData!.startDate);
      controllerEndDate.text =
          CommonFunctions().changeServerDateDisplayFormat(eventData!.endDate);
      controllerStartTime.text = eventData!.startTime;
      controllerEndTime.text = eventData!.endTime;
      controllerDes.text = eventData!.description;
      lat = eventData!.lat;
      lng = eventData!.lng;
      categoryId = eventData!.categoryId.toString();
      eventData!.eventImages.forEach((element) {
        imagesList.add(element.images);
      });
    }
  }

  getCategoryList() async {
    GetCategoriesResponse result = await categoryListApi(context);
    result.body.forEach((element) {
      categoryList.add(CategoryModel(
          name: element.name, id: element.id.toString(), underLine: false));
    });
    if (categoryId.isNotEmpty) {
      categoryList.forEach((element) {
        if (element.id == categoryId) {
          category = element.name;
        }
      });
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: HelperWidget.customAppBar(
          title: isFromEdit ? "Edit Event" : 'Create Event'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusScope.of(context).requestFocus(FocusScopeNode()),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                                  imagesList[index]
                                          .contains(GlobalVariable.imageUrl)
                                      ? CommonFunctions().setNetworkImages(
                                          imageUrl: imagesList[index],
                                          circle: 5,
                                          height: 55,
                                          width: 65,
                                          boxFit: BoxFit.cover)
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          child: Image.file(
                                            File(imagesList[index]),
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
                              imagesList[index]
                                      .contains(GlobalVariable.imageUrl)
                                  ? Container()
                                  : Positioned(
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
              height: 20,
            ),
            SimpleTf(
              controller: controllerName,
              title: "Event Name",
            ),
            const SizedBox(
              height: 20,
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
                margin: const EdgeInsets.only(top: 2),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: AppColor.grayColor, width: 1),
                    borderRadius: BorderRadius.circular(12)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<CategoryModel>(
                    isExpanded: true,
                    borderRadius: BorderRadius.circular(5),
                    hint: AppText(
                        text: category,
                        textColor: AppColor.blackColor,
                        fontWeight: FontWeight.w400,
                        textSize: 13),
                    items: categoryList.map((CategoryModel value) {
                      return DropdownMenuItem<CategoryModel>(
                        value: value,
                        child: Text(value.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      category = value!.name.toString();
                      categoryId = value.id.toString();
                      setState(() {});
                    },
                  ),
                )),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () => Get.toNamed(Routes.mapScreen)!.then((value) {
                locationController.text = value['location'] ?? "";
                lat = value['lat'] ?? "";
                lng = value['lng'] ?? "";
                setState(() {});
              }),
              child: AbsorbPointer(
                absorbing: true,
                child: SimpleTf(
                  controller: locationController,
                  title: "Location",
                  lines: locationController.text.length > 70 ? 2 : 1,
                  height: locationController.text.length > 70 ? 80 : 50,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                _showDatePicker(true);
              },
              child: AbsorbPointer(
                absorbing: true,
                child: SimpleTf(
                  controller: controllerStartDate,
                  title: "Event Start Date",
                  hintWithSelected: true,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                _showDatePicker(false);
              },
              child: AbsorbPointer(
                absorbing: true,
                child: SimpleTf(
                  controller: controllerEndDate,
                  title: "Event End Date",
                  hintWithSelected: true,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () => _selectTime(true),
              child: AbsorbPointer(
                absorbing: true,
                child: SimpleTf(
                  controller: controllerStartTime,
                  title: "Start Time",
                  hintWithSelected: true,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () => _selectTime(false),
              child: AbsorbPointer(
                absorbing: true,
                child: SimpleTf(
                  controller: controllerEndTime,
                  title: "End Time",
                  hintWithSelected: true,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SimpleTf(
              controller: controllerDes,
              title: "Description",
              height: 120,
              lines: 6,
            ),
            const SizedBox(
              height: 60,
            ),
            ElevatedBtn(
              onTap: () {
                var newImage = false;
                if (validateFields().isEmpty) {
                  //api call
                  imagesList.forEach((element) {
                    if (element.contains(GlobalVariable.bundel)) {
                      newImage = true;
                    }
                  });
                  if (newImage) {
                    createEventApi(context);
                  } else {
                    createEventWithoutApi(context);
                  }
                } else {
                  Fluttertoast.showToast(msg: validateFields());
                }
              },
              text: "Submit",
            )
          ]),
        ),
      ),
    );
  }

  _showDatePicker(bool isStartDate) async {
    var date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(hours: 24)),
      firstDate: DateTime.now().add(const Duration(hours: 24)),
      lastDate: DateTime(3021, 12),
    );
    if (isStartDate) {
      selectedDate = date!;
      controllerStartDate.text =
          CommonFunctions().daeTimeToStringDateorTime(date, "");
      controllerEndTime.text = "";
    } else {
      if (selectedDate.isAfter(date!)) {
        Fluttertoast.showToast(msg: "Please select future date");
        controllerEndDate.text = "";
      } else {
        controllerEndDate.text =
            CommonFunctions().daeTimeToStringDateorTime(date, "");
      }
      controllerEndTime.text = "";
    }
  }

  Future<void> _selectTime(bool isStart) async {
    TimeOfDay? picked_s = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child!,
          );
        });
    if (isStart) {
      selectedTime = picked_s!.hour;
      controllerStartTime.text =
          addZeroBefore(picked_s.hourOfPeriod.toString()) +
              ":" +
              addZeroBefore(picked_s.minute.toString()) +
              " " +
              makeTimePmAmBig(picked_s.period.name);
    } else {
      if (controllerStartDate.text == controllerEndDate.text) {
        if (picked_s!.hour > selectedTime) {
          controllerEndTime.text =
              addZeroBefore(picked_s.hourOfPeriod.toString()) +
                  ":" +
                  addZeroBefore(picked_s.minute.toString()) +
                  " " +
                  makeTimePmAmBig(picked_s.period.name);
        } else {
          Fluttertoast.showToast(msg: "Please select future time");
          controllerEndTime.text = "";
        }
      } else {
        controllerEndTime.text =
            addZeroBefore(picked_s!.hourOfPeriod.toString()) +
                ":" +
                addZeroBefore(picked_s.minute.toString()) +
                " " +
                makeTimePmAmBig(picked_s.period.name);
      }
    }
  }

  String addZeroBefore(String number) {
    if (number.length == 1) {
      return "0" + number;
    } else {
      return number;
    }
  }

  String makeTimePmAmBig(String time) {
    if (time.toLowerCase() == "pm") {
      return 'PM';
    } else {
      return "AM";
    }
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
                  print(selectedImage);
                  imagesList.add(selectedImage!);
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
                  imagesList.add(selectedImage!);
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

  String validateFields() {
    FocusScope.of(context).requestFocus(FocusScopeNode());
    if (imagesList.isEmpty) {
      return "Please select event images";
    } else if (controllerName.text.trim().toString().isEmpty) {
      return "Please enter event name";
    } else if (categoryId.isEmpty) {
      return "Please select event category";
    } else if (locationController.text.trim().toString().isEmpty) {
      return "Please select event location";
    } else if (controllerStartDate.text.trim().toString().isEmpty) {
      return "Please select event start date";
    } else if (controllerEndDate.text.trim().toString().isEmpty) {
      return "Please select event end date";
    } else if (controllerStartTime.text.trim().toString().isEmpty) {
      return "Please select event start time";
    } else if (controllerEndTime.text.trim().toString().isEmpty) {
      return "Please select event end time";
    } else if (controllerDes.text.trim().toString().isEmpty) {
      return "Please enter event description";
    } else {
      return "";
    }
  }

  Future createEventApi(BuildContext ctx) async {
    Map<String, String> body = {
      "event_name": controllerName.text.trim().toString(),
      "categoryId": categoryId,
      "location": locationController.text.trim().toString(),
      "startDate": CommonFunctions()
          .changeDateToServerFormat(controllerStartDate.text.trim().toString()),
      "startTime": controllerStartTime.text.trim().toString(),
      "endDate": CommonFunctions()
          .changeDateToServerFormat(controllerEndDate.text.trim().toString()),
      "endTime": controllerEndTime.text.trim().toString(),
      "description": controllerDes.text.trim().toString(),
      "lat": lat,
      "lng": lng,
    };
    if (isFromEdit) {
      body['eventId'] = eventId;
    }
    List<String> imagesListData = [];
    imagesListData.clear();
    for (var element in imagesList) {
      if (element.contains(GlobalVariable.bundel)) {
        imagesListData.add(element);
      }
    }
    print(imagesListData);
    EasyLoading.show(status: 'Loading');
    var request = http.MultipartRequest(
        "POST",
        Uri.parse(isFromEdit
            ? GlobalVariable.baseUrl + GlobalVariable.editEvent
            : GlobalVariable.baseUrl + GlobalVariable.createEvent));
    request.headers.addAll(await CommonFunctions().getHeader());
    request.fields.addAll(body);
    List<http.MultipartFile> files = [];
    for (var element in imagesListData) {
      var multipartFile = await http.MultipartFile.fromPath('images', element);
      files.add(multipartFile);
    }

    request.files.addAll(files);
    print(request.fields.toString());
    try {
      var response = await request.send();

      var result = await response.stream.bytesToString();

      var res = SuccessResponse.fromJson(json.decode(result));
      if (res.code == 200) {
        Get.back();
        // Navigator.pop(ctx);
        Fluttertoast.showToast(msg: res.msg);
        EasyLoading.dismiss();
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

  Future createEventWithoutApi(BuildContext ctx) async {
    Map<String, String> body = {
      "event_name": controllerName.text.trim().toString(),
      "categoryId": categoryId,
      "location": locationController.text.trim().toString(),
      "startDate": CommonFunctions()
          .changeDateToServerFormat(controllerStartDate.text.trim().toString()),
      "startTime": controllerStartTime.text.trim().toString(),
      "endDate": CommonFunctions()
          .changeDateToServerFormat(controllerEndDate.text.trim().toString()),
      "endTime": controllerEndTime.text.trim().toString(),
      "description": controllerDes.text.trim().toString(),
      "lat": lat,
      "lng": lng,
      "eventId": eventId
    };
    print(imagesList);
    EasyLoading.show(status: 'Loading');
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (!(connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi)) {
      throw new Exception('NO INTERNET CONNECTION');
    }
    var response = await http.post(
        Uri.parse(GlobalVariable.baseUrl + GlobalVariable.editEvent),
        headers: await CommonFunctions().getHeader(),
        body: body);

    // if (response.statusCode == 201) {}
    print(response.body);
    try {
      Map<String, dynamic> res = json.decode(response.body);

      if (res['code'] != 200 || res == null) {
        String error = res['msg'];
        // Fluttertoast.showToast(msg: error, toastLength: Toast.LENGTH_SHORT);
        // Navigator.pop(ctx);
        print("scasd  " + error);
        throw new Exception(error);
      }

      Get.back();
      // Navigator.pop(ctx);
      Fluttertoast.showToast(msg: res['msg']);
      EasyLoading.dismiss();
    } catch (error) {
      EasyLoading.dismiss();

      Fluttertoast.showToast(
          msg: error.toString().substring(
              error.toString().indexOf(':') + 1, error.toString().length),
          toastLength: Toast.LENGTH_SHORT);
      throw error.toString();
    }
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
        Uri.parse(GlobalVariable.baseUrl + GlobalVariable.getManagerCategories),
        headers: await CommonFunctions().getHeader());

    // if (response.statusCode == 201) {}
    print(response.body);
    try {
      Map<String, dynamic> res = json.decode(response.body);

      if (res['code'] != 200 || res == null) {
        String error = res['msg'];
        // Fluttertoast.showToast(msg: error, toastLength: Toast.LENGTH_SHORT);
        // Navigator.pop(ctx);
        print("scasd  " + error);
        throw new Exception(error);
      }
      var result = GetCategoriesResponse.fromJson(res);
      EasyLoading.dismiss();

      return result;
    } catch (error) {
      EasyLoading.dismiss();
      Fluttertoast.showToast(
          msg: error.toString().substring(
              error.toString().indexOf(':') + 1, error.toString().length),
          toastLength: Toast.LENGTH_SHORT);
      throw error.toString();
    }
  }
}
