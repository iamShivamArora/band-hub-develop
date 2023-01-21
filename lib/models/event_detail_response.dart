class EventDetailResponse {
  EventDetailResponse({
    required this.success,
    required this.code,
    required this.msg,
    required this.body,
  });
  late final bool success;
  late final int code;
  late final String msg;
  late final Body body;

  EventDetailResponse.fromJson(Map<String, dynamic> json){
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
    required this.eventCreator,
    required this.eventImages,
    required this.eventBookings,
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
  late final EventCreator eventCreator;
  late final List<EventImages> eventImages;
  late final List<EventBookings> eventBookings;

  Body.fromJson(Map<String, dynamic> json){
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
    eventCreator = EventCreator.fromJson(json['eventCreator']);
    eventImages = List.from(json['event_images']).map((e)=>EventImages.fromJson(e)).toList();
    eventBookings = List.from(json['event_bookings']).map((e)=>EventBookings.fromJson(e)).toList();
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
    _data['eventCreator'] = eventCreator.toJson();
    _data['event_images'] = eventImages.map((e)=>e.toJson()).toList();
    _data['event_bookings'] = eventBookings.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class EventCreator {
  EventCreator({
    required this.id,
    required this.type,
    required this.fullName,
    required this.musicianName,
    required this.profileImage,
    required this.countryCode,
    required this.phone,
    required this.otp,
    required this.emailOtp,
    required this.verifyOtp,
    required this.categoryId,
    required this.isProfileAdd,
    required this.email,
    required this.password,
    required this.forgotPassword,
    required this.location,
    required this.description,
    required this.isApproved,
    required this.notificationStatus,
    required this.lat,
    required this.lng,
    required this.authKey,
    required this.deviceType,
    required this.deviceToken,
    required this.loginType,
    required this.socialId,
    required this.socialType,
    required this.createdAt,
    required this.status,
    required this.updatedAt,
  });
  late final int id;
  late final int type;
  late final String fullName;
  late final String musicianName;
  late final String profileImage;
  late final String countryCode;
  late final String phone;
  late final int otp;
  late final int emailOtp;
  late final int verifyOtp;
  late final int categoryId;
  late final int isProfileAdd;
  late final String email;
  late final String password;
  late final String forgotPassword;
  late final String location;
  late final String description;
  late final int isApproved;
  late final int notificationStatus;
  late final String lat;
  late final String lng;
  late final String authKey;
  late final int deviceType;
  late final String deviceToken;
  late final int loginType;
  late final String socialId;
  late final int socialType;
  late final String createdAt;
  late final int status;
  late final String updatedAt;

  EventCreator.fromJson(Map<String, dynamic> json){
    id = json['id'];
    type = json['type'];
    fullName = json['full_name'];
    musicianName = json['musician_name'];
    profileImage = json['profileImage'];
    countryCode = json['countryCode'];
    phone = json['phone'];
    otp = json['otp'];
    emailOtp = json['emailOtp'];
    verifyOtp = json['verify_otp'];
    categoryId = json['category_id'];
    isProfileAdd = json['is_profile_add'];
    email = json['email'];
    password = json['password'];
    forgotPassword = json['forgotPassword'];
    location = json['location'];
    description = json['description'];
    isApproved = json['isApproved'];
    notificationStatus = json['notificationStatus'];
    lat = json['lat'];
    lng = json['lng'];
    authKey = json['authKey'];
    deviceType = json['deviceType'];
    deviceToken = json['deviceToken'];
    loginType = json['loginType'];
    socialId = json['socialId'];
    socialType = json['socialType'];
    createdAt = json['createdAt'];
    status = json['status'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['type'] = type;
    _data['full_name'] = fullName;
    _data['musician_name'] = musicianName;
    _data['profileImage'] = profileImage;
    _data['countryCode'] = countryCode;
    _data['phone'] = phone;
    _data['otp'] = otp;
    _data['emailOtp'] = emailOtp;
    _data['verify_otp'] = verifyOtp;
    _data['category_id'] = categoryId;
    _data['is_profile_add'] = isProfileAdd;
    _data['email'] = email;
    _data['password'] = password;
    _data['forgotPassword'] = forgotPassword;
    _data['location'] = location;
    _data['description'] = description;
    _data['isApproved'] = isApproved;
    _data['notificationStatus'] = notificationStatus;
    _data['lat'] = lat;
    _data['lng'] = lng;
    _data['authKey'] = authKey;
    _data['deviceType'] = deviceType;
    _data['deviceToken'] = deviceToken;
    _data['loginType'] = loginType;
    _data['socialId'] = socialId;
    _data['socialType'] = socialType;
    _data['createdAt'] = createdAt;
    _data['status'] = status;
    _data['updatedAt'] = updatedAt;
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

class EventBookings {
  EventBookings({
    required this.id,
    required this.userId,
    required this.eventId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });
  late final int id;
  late final int userId;
  late final int eventId;
  late final int status;
  late final String createdAt;
  late final String updatedAt;
  late final User user;

  EventBookings.fromJson(Map<String, dynamic> json){
    id = json['id'];
    userId = json['userId'];
    eventId = json['eventId'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    user = User.fromJson(json['user']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['userId'] = userId;
    _data['eventId'] = eventId;
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
    required this.categoryName,
  });
  late final int id;
  late final String fullName;
  late final String musicianName;
  late final String profileImage;
  late final int categoryId;
  late final String location;
  late final String lat;
  late final String lng;
  late final String categoryName;

  User.fromJson(Map<String, dynamic> json){
    id = json['id'];
    fullName = json['full_name'];
    musicianName = json['musician_name'];
    profileImage = json['profileImage'];
    categoryId = json['category_id'];
    location = json['location'];
    lat = json['lat'];
    lng = json['lng'];
    categoryName = json['categoryName'];
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
    _data['categoryName'] = categoryName;
    return _data;
  }
}