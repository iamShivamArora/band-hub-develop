class GetCategoriesResponse {
  GetCategoriesResponse({
    required this.success,
    required this.code,
    required this.msg,
    required this.body,
  });

  late final bool success;
  late final int code;
  late final String msg;
  late final List<CategoriesBody> body;

  GetCategoriesResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    msg = json['msg'];
    body =
        List.from(json['body']).map((e) => CategoriesBody.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['code'] = code;
    _data['msg'] = msg;
    _data['body'] = body.map((e) => e.toJson()).toList();
    return _data;
  }
}

class CategoriesBody {
  CategoriesBody({
    required this.id,
    required this.name,
    required this.type,
    required this.status,
    required this.isapprove,
    required this.createdAt,
    required this.updatedAt,
  });

  late final int id;
  late final String name;
  late final String type;
  late final int status;
  late final int isapprove;
  late final String createdAt;
  late final String updatedAt;

  CategoriesBody.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    status = json['status'];
    isapprove = json['isapprove'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['type'] = type;
    _data['status'] = status;
    _data['isapprove'] = isapprove;
    _data['createdAt'] = createdAt;
    _data['updatedAt'] = updatedAt;
    return _data;
  }
}
