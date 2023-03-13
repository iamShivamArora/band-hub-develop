class PersonChatListingResponse {
  PersonChatListingResponse({
    required this.result,
  });

  late final List<PersonListing> result;

  PersonChatListingResponse.fromJson(Map<String, dynamic> json) {
    result = List.from(json['result'])
        .map((e) => PersonListing.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['result'] = result.map((e) => e.toJson()).toList();
    return _data;
  }
}

class PersonListing {
  PersonListing({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.groupId,
    required this.lastMessageId,
    required this.deletedId,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    required this.lastMessage,
    required this.userName,
    required this.userEmail,
    required this.usertype,
    required this.onlinestatus,
    required this.userImage,
    required this.created,
    required this.msgType,
    required this.unreadcount,
    required this.blockstatus,
  });

  late final int id;
  late final int senderId;
  late final int receiverId;
  late final int groupId;
  late final int lastMessageId;
  late final int deletedId;
  late final String createdAt;
  late final String updatedAt;
  late final int userId;
  late final String lastMessage;
  late final String userName;
  late final String userEmail;
  late final int usertype;
  late final int onlinestatus;
  late final String userImage;
  late final String created;
  late final int msgType;
  late final int unreadcount;
  late final int blockstatus;

  PersonListing.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    groupId = json['groupId'];
    lastMessageId = json['lastMessageId'];
    deletedId = json['deletedId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    userId = json['user_id'];
    lastMessage = json['lastMessage'];
    userName = json['userName'];
    userEmail = json['userEmail'];
    usertype = json['usertype'];
    onlinestatus = json['onlinestatus'];
    userImage = json['userImage'];
    created = json['created'];
    msgType = json['msgType'];
    unreadcount = json['unreadcount'];
    blockstatus = json['blockstatus'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['senderId'] = senderId;
    _data['receiverId'] = receiverId;
    _data['groupId'] = groupId;
    _data['lastMessageId'] = lastMessageId;
    _data['deletedId'] = deletedId;
    _data['createdAt'] = createdAt;
    _data['updatedAt'] = updatedAt;
    _data['user_id'] = userId;
    _data['lastMessage'] = lastMessage;
    _data['userName'] = userName;
    _data['userEmail'] = userEmail;
    _data['usertype'] = usertype;
    _data['onlinestatus'] = onlinestatus;
    _data['userImage'] = userImage;
    _data['created'] = created;
    _data['msgType'] = msgType;
    _data['unreadcount'] = unreadcount;
    _data['blockstatus'] = blockstatus;
    return _data;
  }
}
