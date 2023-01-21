class NotificationListingResponse {
  NotificationListingResponse({
    required this.success,
    required this.code,
    required this.msg,
    required this.body,
  });
  late final bool success;
  late final int code;
  late final String msg;
  late final List<Body> body;

  NotificationListingResponse.fromJson(Map<String, dynamic> json){
    success = json['success'];
    code = json['code'];
    msg = json['msg'];
    body = List.from(json['body']).map((e)=>Body.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['code'] = code;
    _data['msg'] = msg;
    _data['body'] = body.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Body {
  Body({
    required this.id,
    required this.senderId,
    required this.recieverId,
    required this.message,
    required this.isRead,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });
  late final int id;
  late final int senderId;
  late final int recieverId;
  late final String message;
  late final int isRead;
  late final String createdAt;
  late final String updatedAt;
  late final User user;

  Body.fromJson(Map<String, dynamic> json){
    id = json['id'];
    senderId = json['senderId'];
    recieverId = json['recieverId'];
    message = json['message'];
    isRead = json['isRead'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    user = User.fromJson(json['user']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['senderId'] = senderId;
    _data['recieverId'] = recieverId;
    _data['message'] = message;
    _data['isRead'] = isRead;
    _data['createdAt'] = createdAt;
    _data['updatedAt'] = updatedAt;
    _data['user'] = user.toJson();
    return _data;
  }
}

class User {
  User({
    required this.id,
    required this.fullName,
    required this.musicianName,
    required this.profileImage,
  });
  late final int id;
  late final String fullName;
  late final String musicianName;
  late final String profileImage;

  User.fromJson(Map<String, dynamic> json){
    id = json['id'];
    fullName = json['full_name'];
    musicianName = json['musician_name'];
    profileImage = json['profileImage'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['full_name'] = fullName;
    _data['musician_name'] = musicianName;
    _data['profileImage'] = profileImage;
    return _data;
  }
}