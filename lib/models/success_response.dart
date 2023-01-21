class SuccessResponse {
  SuccessResponse({
    required this.success,
    required this.code,
    required this.msg,
    required this.body,
  });
  late final bool success;
  late final int code;
  late final String msg;
  late final Body body;

  SuccessResponse.fromJson(Map<String, dynamic> json){
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
  Body();

  Body.fromJson(Map json);

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    return _data;
  }
}