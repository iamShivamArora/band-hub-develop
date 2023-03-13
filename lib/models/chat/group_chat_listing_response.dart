class GroupChatListingResponse {
  GroupChatListingResponse({
    required this.successMessage,
    required this.groupslist,
  });

  late final String successMessage;
  late final List<Groupslist> groupslist;

  GroupChatListingResponse.fromJson(Map<String, dynamic> json) {
    successMessage = json['success_message'];
    groupslist = List.from(json['groupslist'])
        .map((e) => Groupslist.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success_message'] = successMessage;
    _data['groupslist'] = groupslist.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Groupslist {
  Groupslist({
    required this.id,
    required this.name,
    required this.totalUsers,
    required this.lastMessage,
    required this.lastMessageCreated,
    required this.messageType,
    required this.eventBookings,
    required this.userId,
    required this.groupId,
  });

  late final int id;
  late final String name;
  late final int totalUsers;
  late final String lastMessage;
  late final String lastMessageCreated;
  late final int messageType;
  late final List<EventBookings> eventBookings;
  late final String userId;
  late final int groupId;

  Groupslist.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    totalUsers = json['totalUsers'];
    lastMessage = json['lastMessage'];
    lastMessageCreated = json['lastMessageCreated'];
    messageType = json['messageType'];
    eventBookings = List.from(json['event_bookings'])
        .map((e) => EventBookings.fromJson(e))
        .toList();
    userId = json['userId'];
    groupId = json['groupId'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['totalUsers'] = totalUsers;
    _data['lastMessage'] = lastMessage;
    _data['lastMessageCreated'] = lastMessageCreated;
    _data['messageType'] = messageType;
    _data['event_bookings'] = eventBookings.map((e) => e.toJson()).toList();
    _data['userId'] = userId;
    _data['groupId'] = groupId;
    return _data;
  }
}

class EventBookings {
  EventBookings({
    required this.isOnline,
    required this.fullname,
    required this.image,
  });

  late final String isOnline;
  late final String fullname;
  late final String image;

  EventBookings.fromJson(Map<String, dynamic> json) {
    isOnline = json['isOnline'];
    fullname = json['fullname'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['isOnline'] = isOnline;
    _data['fullname'] = fullname;
    _data['image'] = image;
    return _data;
  }
}
