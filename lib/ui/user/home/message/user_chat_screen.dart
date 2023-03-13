import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:band_hub/models/chat/chat_listing_response.dart';
import 'package:band_hub/routes/Routes.dart';
import 'package:band_hub/widgets/app_color.dart';
import 'package:band_hub/widgets/app_text.dart';
import 'package:band_hub/widgets/custom_text_field.dart';
import 'package:band_hub/widgets/elevated_btn.dart';
import 'package:band_hub/widgets/elevated_stroke_btn.dart';
import 'package:band_hub/widgets/helper_widget.dart';
import 'package:band_hub/widgets/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../../../../models/auth/login_response_model.dart';
import '../../../../models/chat/send_message_lisner_response.dart';
import '../../../../util/common_funcations.dart';
import '../../../../util/sharedPref.dart';
import '../../../../util/socket_caller.dart';
import '../../../../util/socket_manger.dart';

class UserChatScreen extends StatefulWidget {
  const UserChatScreen({Key? key}) : super(key: key);

  @override
  State<UserChatScreen> createState() => _UserChatScreenState();
}

class _UserChatScreenState extends State<UserChatScreen> {
  var userId = "";

  var groupID = "";
  var groupName = "";
  var groupImage = "";

  var personID = "";
  var personName = "";
  var personImage = "";
  bool isBlocked = false;
  TextEditingController msgController = TextEditingController();
  List<ChatListResult>? listing = null;
  final ScrollController _sc = ScrollController();

  getUserData() async {
    var d = await SharedPref().getPreferenceJson();
    LoginResponseModel result = LoginResponseModel.fromJson(jsonDecode(d));
    userId = result.body.id.toString();
  }

  @override
  void initState() {
    personID = Get.arguments['personID'] ?? "";
    personName = Get.arguments['personName'] ?? "";
    personImage = Get.arguments['personImage'] ?? "";
    isBlocked = Get.arguments['isBlocked'] ?? false;

    groupID = Get.arguments['groupID'] ?? "";
    groupName = Get.arguments['groupName'] ?? "";
    groupImage = Get.arguments['groupImage'] ?? "";
    getUserData();
    getMsgList();
    getSendMessageListener();
    blockUser();
    receiveSendMessageListenerCall();

    super.initState();
  }

  @override
  void dispose() {
    getIt<Socket>().off(SocketManger().getPersonMessagesListener);
    getIt<Socket>().off(SocketManger().getGroupMessagesListener);
    getIt<Socket>().off(SocketManger().sendMessageListener);
    getIt<Socket>().off(SocketManger().deleteChatListener);
    getIt<Socket>().off(SocketManger().receiveMessageListener);
    getIt<Socket>().off(SocketManger().blockUnblockUserListener);

    super.dispose();
  }

  blockUser() async {
    getIt<Socket>().on(SocketManger().blockUnblockUserListener, (data) {
      print(data);
      // if (data['blockStatus'].toString() == '0') {
      if (data['success_message'].toString().contains('unblock')) {
        isBlocked = false;
      } else {
        isBlocked = true;
      }
      // isBlocked = data['success_message'].toString().contains('unblock')?false:true;
      setState(() {});
    });
  }

  deleteChat() async {
    await getIt<SocketManger>().callDeleteChat(personID);
    getIt<Socket>().on(SocketManger().deleteChatListener, (data) {
      print(data);
      if (listing != null) {
        listing!.clear();
      }
      setState(() {});
    });
  }

  getMsgList() async {
    if (groupID.isEmpty) {
      await getIt<SocketManger>().callMsgList(personID);
      getIt<Socket>().on(SocketManger().getPersonMessagesListener, (data) {
        ChatListingResponse result = ChatListingResponse.fromJson(data);
        if (listing != null) {
          listing!.clear();
        }
        listing = result.result;
        scrollBottom();
        setState(() {});
      });
    } else {
      await getIt<SocketManger>().callGroupMsgList(groupID);
      getIt<Socket>().on(SocketManger().getGroupMessagesListener, (data) {
        ChatListingResponse result = ChatListingResponse.fromJson(data);
        if (listing != null) {
          listing!.clear();
        }
        listing = result.result;
        scrollBottom();
        setState(() {});
      });
    }
  }

  scrollBottom() {
    // Future.delayed(const Duration(milliseconds: 180), () {
    //   _sc.jumpTo(_sc.position.maxScrollExtent);
    // });
    // if (_sc.hasClients) {
    Timer(Duration(milliseconds: 300), () {
      _sc.jumpTo(_sc.position.maxScrollExtent);
    });
    // }
  }

  getSendMessageListener() async {
    getIt<Socket>().on(SocketManger().sendMessageListener, (data) {
      print(data);
      msgController.text = "";
      SendMessageListenerResponse result =
          SendMessageListenerResponse.fromJson(data);
      if (listing!.contains(result.message.id)) {
        print('true');
      }
      listing!.add(ChatListResult(
          id: result.message.id,
          SenderName: result.message.senderName,
          message: result.message.message,
          SenderId: result.message.senderId,
          SenderImage: result.message.senderImage,
          ReceiverName: result.message.recieverName,
          ReceiverId: result.message.receiverId ?? 0,
          ReceiverImage: result.message.recieverImage,
          messageType: result.message.messageType,
          createdAt: result.message.createdAt,
          updatedAt: result.message.updatedAt.toString()));
      setState(() {});
    });
    scrollBottom();
  }

  receiveSendMessageListenerCall() async {
    getIt<Socket>().on(SocketManger().receiveMessageListener, (data) {
      print(data);
      msgController.text = "";
      SendMessageListenerResponse result =
          SendMessageListenerResponse.fromJson(data);
      if (listing!.contains(result.message.id)) {
        print('true');
      }
      listing!.add(ChatListResult(
          id: result.message.id,
          SenderName: result.message.senderName,
          message: result.message.message,
          SenderId: result.message.senderId,
          SenderImage: result.message.senderImage,
          ReceiverName: result.message.recieverName,
          ReceiverId: result.message.receiverId ?? 0,
          ReceiverImage: result.message.recieverImage,
          messageType: result.message.messageType,
          createdAt: result.message.createdAt,
          updatedAt: result.message.updatedAt.toString()));
      setState(() {});
    });
    scrollBottom();
  }

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
                      child: GestureDetector(
                    onTap: () {
                      if (groupID.isEmpty) {
                        Get.toNamed(Routes.managerProfileScreen,
                            arguments: {'userId': personID});
                      } else {}
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CommonFunctions().setNetworkImages(
                            imageUrl:
                                groupImage.isEmpty ? personImage : groupImage,
                            height: 40,
                            width: 40,
                            circle: 40,
                            boxFit: BoxFit.cover,
                            isUser: true),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              text: groupName.isEmpty ? personName : groupName,
                              textSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                            /*AppText(
                              text: "Online",
                              textSize: 10,
                              fontWeight: FontWeight.w400,
                            ),*/
                          ],
                        ),
                      ],
                    ),
                  )),
                  groupID.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: InkWell(
                            onTap: () => Get.toNamed(Routes.seeMembersScreen),
                            child: AppText(
                              text: "See Members",
                              textSize: 12,
                              underline: true,
                              fontWeight: FontWeight.w600,
                              textColor: AppColor.appColor,
                            ),
                          ),
                        )
                      : InkWell(
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
                  child: listing == null
                      ? Center(child: CommonFunctions().loadingCircle())
                      : listing!.isEmpty
                          ? Container()
                          : Align(
                              alignment: Alignment.bottomCenter,
                              child: ListView.builder(
                                  controller: _sc,
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: listing!.length,
                                  itemBuilder: (context, index) {
                                    if (listing![index].SenderId.toString() !=
                                        userId) {
                                      return Container(
                                        margin: const EdgeInsets.only(
                                            top: 5, right: 35),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 10,
                                              ),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  CommonFunctions()
                                                      .setNetworkImages(
                                                          imageUrl: personImage,
                                                          height: 40,
                                                          width: 40,
                                                          circle: 40,
                                                          boxFit: BoxFit.cover,
                                                          isUser: true),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 15),
                                                        child: AppText(
                                                          text: CommonFunctions()
                                                              .maxLengthCheck(
                                                                  listing![
                                                                          index]
                                                                      .SenderName,
                                                                  20),
                                                          textSize: 8.5,
                                                          textColor: AppColor
                                                              .grayColor,
                                                        ),
                                                      ),
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 20,
                                                                vertical: 15),
                                                        margin: EdgeInsets.only(
                                                            left: 5),
                                                        decoration:
                                                            BoxDecoration(
                                                                color: AppColor
                                                                    .appColor,
                                                                borderRadius:
                                                                    const BorderRadius
                                                                        .only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          30),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          30),
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          2),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          30),
                                                                )),
                                                        child: AppText(
                                                          text: listing![index]
                                                              .message,
                                                          textColor: AppColor
                                                              .whiteColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 3,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 56),
                                              child: AppText(
                                                text: CommonFunctions()
                                                    .getMsgTime(listing![index]
                                                        .updatedAt),
                                                textSize: 11,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                          ],
                                        ),
                                      );
                                    } else {
                                      return Container(
                                        margin: const EdgeInsets.only(
                                            top: 5, left: 35),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Flexible(
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20,
                                                        vertical: 15),
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 15,
                                                ),
                                                decoration: const BoxDecoration(
                                                    color: Color(0xffF6F6F6),
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(30),
                                                      topRight:
                                                          Radius.circular(30),
                                                      bottomLeft:
                                                          Radius.circular(30),
                                                      bottomRight:
                                                          Radius.circular(2),
                                                    )),
                                                child: AppText(
                                                  text: listing![index].message,
                                                  textAlign: TextAlign.end,
                                                  textColor:
                                                      AppColor.blackColor,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 3,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 18),
                                              child: AppText(
                                                text: CommonFunctions()
                                                    .getMsgTime(listing![index]
                                                        .updatedAt),
                                                textSize: 11,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  }),
                            )),
              isBlocked
                  ? Container(
                      margin: EdgeInsets.symmetric(vertical: 15),
                      width: double.infinity,
                      height: 40,
                      decoration: BoxDecoration(color: AppColor.grayColor),
                      child: Center(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppText(text: 'User Blocked. '),
                          GestureDetector(
                              onTap: () {
                                showActionDialog('0');
                              },
                              child:
                                  AppText(text: 'UnBlocked', underline: true)),
                        ],
                      )),
                    )
                  : selectedImage != null && selectedImage!.isNotEmpty
                      ? Container(
                          decoration: BoxDecoration(
                              color: AppColor.grayColor.withOpacity(0.6)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(width: 35),
                              Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Image.file(File(selectedImage!),
                                        width: 150,
                                        height: 150,
                                        fit: BoxFit.cover),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      selectedImage = "";
                                      setState(() {});
                                    },
                                    child: Container(
                                        margin: EdgeInsets.only(top: 3),
                                        decoration: BoxDecoration(
                                            color: AppColor.whiteColor,
                                            borderRadius:
                                                BorderRadius.circular(40)),
                                        child: Icon(
                                          Icons.cancel,
                                          color: AppColor.appColor,
                                        )),
                                  )
                                ],
                              ),
                              InkWell(
                                onTap: () {
                                  // if (selectedImage!.isNotEmpty) {
                                  //   FocusScope.of(context)
                                  //       .requestFocus(FocusScopeNode());
                                  //
                                  //   getSendMessageListener();
                                  // }
                                },
                                child: Container(
                                    height: 35,
                                    width: 35,
                                    margin: const EdgeInsets.only(
                                        bottom: 10, right: 10),
                                    decoration: BoxDecoration(
                                        color: AppColor.appColor,
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    child: Center(
                                      child: Icon(
                                        Icons.send_rounded,
                                        color: AppColor.whiteColor,
                                        size: 20,
                                      ),
                                    )),
                              )
                            ],
                          ),
                        )
                      : Container(
                          margin: const EdgeInsets.fromLTRB(20, 2, 20, 20),
                          child: Stack(
                            children: [
                              SimpleTf(
                                controller: msgController,
                                titleVisibilty: false,
                                fillColor: Color(0xffF6F6F6),
                                hint: 'Type your message...',
                                inputType: TextInputType.text,
                                action: TextInputAction.done,
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
                                        margin: const EdgeInsets.only(
                                            bottom: 10, right: 50),
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
                                    onTap: () async {
                                      if (msgController.text
                                          .trim()
                                          .isNotEmpty) {
                                        FocusScope.of(context)
                                            .requestFocus(FocusScopeNode());

                                        Map userMap = groupID.isEmpty
                                            ? {
                                                "messageType": 0,
                                                "message": msgController.text
                                                    .trim()
                                                    .toString(),
                                                "receiverId": personID,
                                                "senderId": userId
                                              }
                                            : {
                                                "messageType": 0,
                                                "message": msgController.text
                                                    .trim()
                                                    .toString(),
                                                "groupId": groupID,
                                                "senderId": userId
                                              };

                                        await getIt<SocketManger>()
                                            .sendTextMessage(userMap);
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: 'Please enter message');
                                      }
                                    },
                                    child: Container(
                                        height: 35,
                                        width: 35,
                                        margin: const EdgeInsets.only(
                                            bottom: 10, right: 10),
                                        decoration: BoxDecoration(
                                            color: AppColor.appColor,
                                            borderRadius:
                                                BorderRadius.circular(100)),
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
            title: Text(
              isBlocked ? 'UnBlock' : 'Block',
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
      } else if (value == "0") {
        //block
        // if (isBlocked) {
        //   blockUser();
        // } else {
        showActionDialog(value);
        // }
      } else if (value == "1") {
        showActionDialog(value);
      }
    });
  }

  showActionDialog(String? value) {
    String title = "";
    String image = "";
    switch (value) {
      case "0":
        title = isBlocked
            ? "Are you sure you want to unblock\n$personName?"
            : "Are you sure you want to block\n$personName?";
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
                                  onTap: () async {
                                    if (value == '1') {
                                      deleteChat();
                                    } else {
                                      await getIt<SocketManger>()
                                          .callBlockUser(personID, !isBlocked);
                                    }
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

  String? selectedImage = null;

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
                  selectedImage = await ImagePickerUtility()
                      .pickImageFromCamera(isCropping: true);
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
                  selectedImage = await ImagePickerUtility()
                      .pickImageFromGallery(isCropping: true);
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
}
