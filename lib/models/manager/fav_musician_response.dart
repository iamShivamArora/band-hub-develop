class FavMusicianResponse {
  FavMusicianResponse({
    required this.success,
    required this.code,
    required this.msg,
    required this.body,
  });
  late final bool success;
  late final int code;
  late final String msg;
  late final List<Body> body;

  FavMusicianResponse.fromJson(Map<String, dynamic> json){
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
    required this.managerId,
    required this.musicianId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });
  late final int id;
  late final int managerId;
  late final int musicianId;
  late final int status;
  late final String createdAt;
  late final String updatedAt;
  late final User user;

  Body.fromJson(Map<String, dynamic> json){
    id = json['id'];
    managerId = json['managerId'];
    musicianId = json['musicianId'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    user = User.fromJson(json['user']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['managerId'] = managerId;
    _data['musicianId'] = musicianId;
    _data['status'] = status;
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
    required this.categoryId,
    required this.location,
    required this.lat,
    required this.lng,
  });
  late final int id;
  late final String fullName;
  late final String musicianName;
  late final String profileImage;
  late final int categoryId;
  late final String location;
  late final String lat;
  late final String lng;

  User.fromJson(Map<String, dynamic> json){
    id = json['id'];
    fullName = json['full_name'];
    musicianName = json['musician_name'];
    profileImage = json['profileImage'];
    categoryId = json['category_id'];
    location = json['location'];
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['full_name'] = fullName;
    _data['musician_name'] = musicianName;
    _data['profileImage'] = profileImage;
    _data['category_id'] = categoryId;
    _data['location'] = location;
    _data['lat'] = lat;
    _data['lng'] = lng;
    return _data;
  }
}