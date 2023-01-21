class ManagerHomeResponse {
  ManagerHomeResponse({
    required this.success,
    required this.code,
    required this.msg,
    required this.body,
  });
  late final bool success;
  late final int code;
  late final String msg;
  late final Body body;

  ManagerHomeResponse.fromJson(Map<String, dynamic> json){
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
    required this.EventsList,
    required this.BannerList,
  });
  late final List<EventsListResponse> EventsList;
  late final List<BannerListResponse> BannerList;

  Body.fromJson(Map<String, dynamic> json){
    EventsList = List.from(json['EventsList']).map((e)=>EventsListResponse.fromJson(e)).toList();
    BannerList = List.from(json['BannerList']).map((e)=>BannerListResponse.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['EventsList'] = EventsList.map((e)=>e.toJson()).toList();
    _data['BannerList'] = BannerList.map((e)=>e.toJson()).toList();
    return _data;
  }
}
class EventsListResponse {
  EventsListResponse({
    required this.id,
    required this.managerId,
    required this.name,
    required this.categoryId,
    required this.startDate,
    required this.startTime,
    required this.endDate,
    required this.endTime,
    required this.location,
    required this.description,
    required this.image,
    required this.status,
    required this.lat,
    required this.lng,
    required this.createdAt,
    required this.updatedAt,
    required this.eventImages,
  });
  late final int id;
  late final int managerId;
  late final String name;
  late final int categoryId;
  late final String startDate;
  late final String startTime;
  late final String endDate;
  late final String endTime;
  late final String location;
  late final String description;
  late final String image;
  late final int status;
  late final String lat;
  late final String lng;
  late final String createdAt;
  late final String updatedAt;
  late final List<EventImages> eventImages;

  EventsListResponse.fromJson(Map<String, dynamic> json){
    id = json['id'];
    managerId = json['managerId'];
    name = json['name'];
    categoryId = json['categoryId'];
    startDate = json['startDate'];
    startTime = json['startTime'];
    endDate = json['endDate'];
    endTime = json['endTime'];
    location = json['location'];
    description = json['description'];
    image = json['image'];
    status = json['status'];
    lat = json['lat'];
    lng = json['lng'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    eventImages = List.from(json['event_images']).map((e)=>EventImages.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['managerId'] = managerId;
    _data['name'] = name;
    _data['categoryId'] = categoryId;
    _data['startDate'] = startDate;
    _data['startTime'] = startTime;
    _data['endDate'] = endDate;
    _data['endTime'] = endTime;
    _data['location'] = location;
    _data['description'] = description;
    _data['image'] = image;
    _data['status'] = status;
    _data['lat'] = lat;
    _data['lng'] = lng;
    _data['createdAt'] = createdAt;
    _data['updatedAt'] = updatedAt;
    _data['event_images'] = eventImages.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class EventImages {
  EventImages({
    required this.id,
    required this.eventId,
    required this.images,
    required this.createdAt,
    required this.updatedAt,
  });
  late final int id;
  late final int eventId;
  late final String images;
  late final String createdAt;
  late final String updatedAt;

  EventImages.fromJson(Map<String, dynamic> json){
    id = json['id'];
    eventId = json['eventId'];
    images = json['images'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['eventId'] = eventId;
    _data['images'] = images;
    _data['createdAt'] = createdAt;
    _data['updatedAt'] = updatedAt;
    return _data;
  }
}
class BannerListResponse {
  BannerListResponse({
    required this.id,
    required this.bannerImage,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });
  late final int id;
  late final String bannerImage;
  late final int status;
  late final String createdAt;
  late final String updatedAt;

  BannerListResponse.fromJson(Map<String, dynamic> json){
    id = json['id'];
    bannerImage = json['bannerImage'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['bannerImage'] = bannerImage;
    _data['status'] = status;
    _data['createdAt'] = createdAt;
    _data['updatedAt'] = updatedAt;
    return _data;
  }
}