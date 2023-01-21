class NotificationStatusResponse {
  NotificationStatusResponse({
    required this.success,
    required this.code,
    required this.msg,
    required this.body,
  });
  late final bool success;
  late final int code;
  late final String msg;
  late final Body body;

  NotificationStatusResponse.fromJson(Map<String, dynamic> json){
    success = json['success'];
    code = json['code'];
    msg = json['msg'];
    body = Body.fromJson(json['body']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['code'] = code;
    _data['msg'] = msg;
    _data['body'] = body.toJson();
    return _data;
  }
}

class Body {
  Body({
    required this.notificationStatus,
  });
  late final String notificationStatus;

  Body.fromJson(Map<String, dynamic> json){
    notificationStatus = json['notification_status'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['notification_status'] = notificationStatus;
    return _data;
  }
}