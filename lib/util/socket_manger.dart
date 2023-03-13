import 'dart:convert';

import 'package:band_hub/util/global_variable.dart';
import 'package:band_hub/util/sharedPref.dart';
import 'package:band_hub/util/socket_caller.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../models/auth/login_response_model.dart';

Future<IO.Socket> initSocket() async {
  var socket = IO.io(
      GlobalVariable.socketUrl,
      IO.OptionBuilder()
          .disableReconnection()
          .setTransports(['websocket']) // for Flutter or Dart VM
          .disableAutoConnect() // disable auto-connection
          .build());
  socket.connect();
  socket.onConnect((_) {
    // connectUserSocket();
    print('Connection established');
  });
  socket.onDisconnect((_) => print('Connection Disconnection'));
  socket.onConnectError((err) => print(err));
  socket.onError((err) => print(err));
  return socket;
}

class SocketManger {
  String userId = "";

// Emitter
  final connectUserEmitter = "connect_user";

  final sendMessageEmitter = "send_message";
  final groupChatListingEmitter = "group_chat_listing";
  final personChatListingEmitter = "get_chat_list";
  final getGroupMessagesEmitter = "get_group_messages";
  final getPersonMessagesEmitter = "get_chat";
  final deleteChatEmitter = "delete_chat";
  final blockUnblockUserEmitter = "blockUnblock_user";

  // Listener

  final connectUserListener = "connect_listener";
  final sendMessageListener = "get_data";
  final receiveMessageListener = "new_message";
  final groupChatListingListener = "get_list";
  final personChatListingListener = "get_list_user";
  final getGroupMessagesListener = "get_chat";
  final getPersonMessagesListener = "my_chat";
  final deleteChatListener = "delete_data";
  final blockUnblockUserListener = "block_data";

  connectUserSocket() async {
    var d = await SharedPref().getPreferenceJson();
    LoginResponseModel result = LoginResponseModel.fromJson(jsonDecode(d));
    userId = result.body.id.toString();

    print(userId);
    Map userMap = {"userid": userId};
    getIt<IO.Socket>().emit(connectUserEmitter, userMap);
    getIt<IO.Socket>().on(connectUserListener, (data) {
      print(data);
    });
  }

  callBlockUser(String personId, bool block) async {
    print(userId);

    Map userMap = {
      "userId": userId,
      "user2Id": personId,
      "type": block ? 1 : 2 //2 unblock and 1 block
    };
    getIt<IO.Socket>().emit(blockUnblockUserEmitter, userMap);
  }

  callGroupChatList() async {
    print(userId);
    Map userMap = {"userId": userId};
    getIt<IO.Socket>().emit(groupChatListingEmitter, userMap);
  }

  callPersonChatList() async {
    print(userId);
    Map userMap = {"userId": userId};
    getIt<IO.Socket>().emit(personChatListingEmitter, userMap);
  }

  callMsgList(String personId) async {
    Map userMap = {
      "userId": userId,
      "user2Id": personId,
    };
    print(userMap);
    getIt<IO.Socket>().emit(getPersonMessagesEmitter, userMap);
  }

  callGroupMsgList(String groupId) async {
    Map userMap = {"groupId": groupId};
    print(userMap);
    getIt<IO.Socket>().emit(getGroupMessagesEmitter, userMap);
  }

  callDeleteChat(String personId) async {
    Map userMap = {
      "userId": userId,
      "user2Id": personId,
    };
    print(userMap);
    getIt<IO.Socket>().emit(deleteChatEmitter, userMap);
  }

  sendTextMessage(Map userMap) async {
    print(userId);

    getIt<IO.Socket>().emit(SocketManger().sendMessageEmitter, userMap);
  }
}
