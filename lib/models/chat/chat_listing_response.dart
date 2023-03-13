class ChatListingResponse {
  ChatListingResponse({
    required this.result,
    required this.success_message,
  });

  late final List<ChatListResult> result;
  late final String success_message;

  ChatListingResponse.fromJson(Map<String, dynamic> json) {
    success_message = json['success_message'];
    result = List.from(json['result'])
        .map((e) => ChatListResult.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success_message'] = success_message;
    _data['result'] = result.map((e) => e.toJson()).toList();
    return _data;
  }
}

class ChatListResult {
  ChatListResult({
    this.chatConstantId,
    required this.id,
    this.deletedId,
    this.groupId,
    required this.SenderName,
    required this.message,
    required this.SenderId,
    required this.SenderImage,
    this.ReceiverName,
    required this.ReceiverId,
    this.ReceiverImage,
    this.senderMusicianName,
    required this.messageType,
    required this.createdAt,
    required this.updatedAt,
  });

  late final int? chatConstantId;
  late final int id;
  late final int? deletedId;
  late final int? groupId;
  late final String SenderName;
  late final String message;
  late final int SenderId;
  late final String SenderImage;
  late final String? ReceiverName;
  late final int ReceiverId;
  late final String? senderMusicianName;
  late final String? ReceiverImage;
  late final int messageType;
  late final int createdAt;
  late final String updatedAt;

  ChatListResult.fromJson(Map<String, dynamic> json) {
    chatConstantId = json['chatConstantId'];
    id = json['id'];
    deletedId = json['deletedId'];
    groupId = json['groupId'];
    SenderName = json['senderFullName'];
    message = json['message'];
    SenderId = json['senderId'];
    SenderImage = json['senderImage'];
    ReceiverName = json['ReceiverName'];
    ReceiverId = json['receiverId'];
    ReceiverImage = json['receiverImage'];
    senderMusicianName = json['senderMusicianName'];
    messageType = json['messageType'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['chatConstantId'] = chatConstantId;
    _data['id'] = id;
    _data['deletedId'] = deletedId;
    _data['groupId'] = groupId;
    _data['senderFullName'] = SenderName;
    _data['message'] = message;
    _data['senderId'] = SenderId;
    _data['senderImage'] = SenderImage;
    _data['ReceiverName'] = ReceiverName;
    _data['receiverId'] = ReceiverId;
    _data['senderMusicianName'] = senderMusicianName;
    _data['receiverImage'] = ReceiverImage;
    _data['messageType'] = messageType;
    _data['createdAt'] = createdAt;
    _data['updatedAt'] = updatedAt;
    return _data;
  }
}
