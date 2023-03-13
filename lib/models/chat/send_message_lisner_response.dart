class SendMessageListenerResponse {
  SendMessageListenerResponse({
    required this.successMessage,
    required this.message,
  });

  late final String successMessage;
  late final Message message;

  SendMessageListenerResponse.fromJson(Map<String, dynamic> json) {
    successMessage = json['success_message'];
    message = Message.fromJson(json['message']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success_message'] = successMessage;
    _data['message'] = message.toJson();
    return _data;
  }
}

class Message {
  Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.chatConstantId,
    required this.groupId,
    required this.message,
    required this.readStatus,
    required this.messageType,
    required this.deletedId,
    required this.updatedAt,
    required this.createdAt,
    required this.senderName,
    required this.senderMusicianName,
    required this.senderImage,
    required this.recieverName,
    required this.recieverImage,
  });

  late final int id;
  late final int senderId;
  late final int? receiverId;
  late final int chatConstantId;
  late final int groupId;
  late final String message;
  late final int? readStatus;
  late final int messageType;
  late final int? deletedId;
  late final String updatedAt;
  late final int createdAt;
  late final String senderName;
  late final String senderMusicianName;
  late final String senderImage;
  late final String recieverName;
  late final String recieverImage;

  Message.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    chatConstantId = json['chatConstantId'];
    groupId = json['groupId'];
    message = json['message'];
    readStatus = json['readStatus'];
    messageType = json['messageType'];
    deletedId = json['deletedId'];
    updatedAt = json['updatedAt'];
    createdAt = json['createdAt'];
    senderName = json['senderName'];
    senderMusicianName = json['senderMusicianName'];
    senderImage = json['senderImage'];
    recieverName = json['recieverName'];
    recieverImage = json['recieverImage'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['senderId'] = senderId;
    _data['receiverId'] = receiverId;
    _data['chatConstantId'] = chatConstantId;
    _data['groupId'] = groupId;
    _data['message'] = message;
    _data['readStatus'] = readStatus;
    _data['messageType'] = messageType;
    _data['deletedId'] = deletedId;
    _data['updatedAt'] = updatedAt;
    _data['createdAt'] = createdAt;
    _data['senderName'] = senderName;
    _data['senderMusicianName'] = senderMusicianName;
    _data['senderImage'] = senderImage;
    _data['recieverName'] = recieverName;
    _data['recieverImage'] = recieverImage;
    return _data;
  }
}
