import 'package:band_hub/models/chat/group_chat_listing_response.dart';
import 'package:band_hub/routes/Routes.dart';
import 'package:band_hub/util/socket_manger.dart';
import 'package:band_hub/widgets/app_text.dart';
import 'package:band_hub/widgets/custom_text_field.dart';
import 'package:band_hub/widgets/helper_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../../../../models/chat/person_chat_listing_response.dart';
import '../../../../util/common_funcations.dart';
import '../../../../util/socket_caller.dart';

class UserMessageScreen extends StatefulWidget {
  const UserMessageScreen({Key? key}) : super(key: key);

  @override
  State<UserMessageScreen> createState() => _UserMessageScreenState();
}

class _UserMessageScreenState extends State<UserMessageScreen> {
  List<Groupslist>? groupListing;
  List<Groupslist>? defaultGroupListing;
  List<PersonListing>? personListing;
  List<PersonListing>? defaultPersonListing;
  TextEditingController searchController = TextEditingController();
  int tabIndex = 0;

  void searchCall() {
    searchController.addListener(() {
      if (tabIndex == 0) {
        if (personListing != null && personListing!.isNotEmpty) {
          Future.delayed(const Duration(milliseconds: 800), () {
            if (searchController.text.trim().toString().isNotEmpty) {
              List<PersonListing> list = [];
              personListing = null;
              list.addAll(defaultPersonListing!.where((i) => i.userName
                  .toLowerCase()
                  .contains(
                      searchController.text.trim().toString().toLowerCase())));
              personListing = list;
              setState(() {});
              print(searchController.text.trim().toString());
            } else {
              personListing = null;
              personListing = defaultPersonListing;
              setState(() {});
            }
          });
        }
      } else {
        if (groupListing != null && groupListing!.isNotEmpty) {
          Future.delayed(const Duration(milliseconds: 800), () {
            if (searchController.text.trim().toString().isNotEmpty) {
              List<Groupslist> list = [];
              groupListing = null;
              list.addAll(defaultGroupListing!.where((i) => i.name
                  .toLowerCase()
                  .contains(
                      searchController.text.trim().toString().toLowerCase())));
              groupListing = list;
              setState(() {});
              print(searchController.text.trim().toString());
            } else {
              groupListing = null;
              groupListing = defaultGroupListing;
              setState(() {});
            }
          });
        }
      }
    });
  }

  getChatList() async {
    // person chat
    await getIt<SocketManger>().callPersonChatList();
    getIt<Socket>().on(SocketManger().personChatListingListener, (data) {
      PersonChatListingResponse result =
          PersonChatListingResponse.fromJson(data);
      personListing = result.result;
      defaultPersonListing = result.result;
      setState(() {});
    });
  }

  getGroupChatList() async {
    await getIt<SocketManger>().callGroupChatList();
    getIt<Socket>().on(SocketManger().groupChatListingListener, (data) {
      GroupChatListingResponse result = GroupChatListingResponse.fromJson(data);
      groupListing = result.groupslist;
      defaultGroupListing = result.groupslist;
      setState(() {});
    });
  }

  @override
  void initState() {
    if (getIt<Socket>().connected) {
      getChatList();
      getGroupChatList();
      getNewMessageListener();
    } else {
      getIt<Socket>().connect();
      getIt<SocketManger>().connectUserSocket();
      getNewMessageListener();
      getChatList();
      getGroupChatList();
    }

    searchCall();
    super.initState();
  }

  getNewMessageListener() {
    getIt<Socket>().on(SocketManger().receiveMessageListener, (data) {
      getChatList();
      getGroupChatList();
    });
  }

  @override
  void dispose() {
    getIt<Socket>().off(SocketManger().personChatListingListener);
    getIt<Socket>().off(SocketManger().groupChatListingListener);
    super.dispose();
  }

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
              SimpleTf(
                controller: searchController,
                hint: 'Search',
                fillColor: Color(0xffF2F2F2),
                height: 45,
                prefix: 'assets/images/ic_search.png',
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                  child: DefaultTabController(
                      length: 2,
                      child: Column(
                        children: [
                          TabBar(
                              tabs: [
                                Tab(
                                  child: AppText(text: 'Person'),
                                ),
                                Tab(child: AppText(text: 'Group'))
                              ],
                              onTap: (int value) {
                                searchController.clear();
                                tabIndex = value;

                                setState(() {});
                              }),
                          Expanded(
                            child: TabBarView(children: [
                              personListing == null
                                  ? Center(
                                      child: CommonFunctions().loadingCircle())
                                  : personListing!.isEmpty
                                      ? Center(
                                          child: AppText(
                                          text: "No Chat",
                                          fontWeight: FontWeight.w500,
                                          textSize: 16,
                                        ))
                                      : personListingWidget(),
                              groupListing == null
                                  ? Center(
                                      child: CommonFunctions().loadingCircle())
                                  : groupListing!.isEmpty
                                      ? Center(
                                          child: AppText(
                                          text: "No Chat",
                                          fontWeight: FontWeight.w500,
                                          textSize: 16,
                                        ))
                                      : groupListingWidget(),
                            ]),
                          )
                        ],
                      )))
            ]),
          ),
        ));
  }

  ListView groupListingWidget() {
    return ListView.builder(
        itemCount: groupListing!.length,
        physics: const AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: ((context, index) {
          return InkWell(
            onTap: () {
              searchController.clear();
              print(groupListing![index].id.toString());
              print(groupListing![index].eventBookings[0].fullname.toString());
              Get.toNamed(Routes.userChatScreen, arguments: {
                'groupID': groupListing![index].id.toString(),
                'groupName': groupListing![index].name.toString(),
                'groupImage':
                    groupListing![index].eventBookings[0].image.toString(),
              })!
                  .then((value) {
                getGroupChatList();
              });
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
                            text: groupListing![index].name,
                            textSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          const Spacer(),
                          AppText(
                            text: CommonFunctions().getGroupChatTime(
                                groupListing![index].lastMessageCreated),
                            textSize: 10,
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      AppText(
                        text: CommonFunctions().maxLengthCheck(
                            groupListing![index].lastMessage, 30),
                        textSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ))
                ],
              ),
            ),
          );
        }));
  }

  ListView personListingWidget() {
    return ListView.builder(
        itemCount: personListing!.length,
        physics: const AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: ((context, index) {
          return InkWell(
            onTap: () {
              searchController.clear();
              Get.toNamed(Routes.userChatScreen, arguments: {
                'personID': personListing![index].userId.toString(),
                'personName': personListing![index].userName.toString(),
                'personImage': personListing![index].userImage.toString(),
                'isBlocked': personListing![index].blockstatus != 0,
              })!
                  .then((value) {
                getChatList();
              });
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  CommonFunctions().setNetworkImages(
                      imageUrl: personListing![index].userImage,
                      height: 60,
                      width: 60,
                      circle: 40,
                      boxFit: BoxFit.cover,
                      isUser: true),
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
                            text: personListing![index].userName,
                            textSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          const Spacer(),
                          AppText(
                            text: CommonFunctions().getPersonChatTime(
                                personListing![index].createdAt),
                            textSize: 10,
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      AppText(
                        text: personListing![index].blockstatus != 0
                            ? 'User is Blocked'
                            : CommonFunctions().maxLengthCheck(
                                personListing![index].lastMessage, 30),
                        textSize: 12,
                        fontWeight: personListing![index].unreadcount > 0
                            ? FontWeight.w800
                            : FontWeight.w400,
                      ),
                    ],
                  ))
                ],
              ),
            ),
          );
        }));
  }
}
