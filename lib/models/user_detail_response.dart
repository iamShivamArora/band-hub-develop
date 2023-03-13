class UserDetailResponse {
  UserDetailResponse({
    required this.success,
    required this.code,
    required this.msg,
    required this.body,
  });

  late final bool success;
  late final int code;
  late final String msg;
  late final Body body;

  UserDetailResponse.fromJson(Map<String, dynamic> json) {
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
    required this.isFav,
    required this.rateCount,
    required this.ratingTo,
    required this.categries,
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
  late final String categoryId;
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
  late final int isFav;
  late final int rateCount;
  late final List<RatingTo> ratingTo;
  late final List<Categries> categries;

  Body.fromJson(Map<String, dynamic> json) {
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
    isFav = json['isFav'];
    rateCount = json['rateCount'];
    ratingTo =
        List.from(json['ratingTo']).map((e) => RatingTo.fromJson(e)).toList();
    categries =
        List.from(json['categries']).map((e) => Categries.fromJson(e)).toList();
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
    _data['isFav'] = isFav;
    _data['rateCount'] = rateCount;
    _data['ratingTo'] = ratingTo.map((e) => e.toJson()).toList();
    _data['categries'] = categries.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Categries {
  Categries({
    required this.id,
    required this.name,
    required this.type,
    required this.status,
    required this.proid,
    required this.isapprove,
    required this.createdAt,
    required this.updatedAt,
  });

  late final int id;
  late final String name;
  late final String type;
  late final int status;
  late final int proid;
  late final int isapprove;
  late final String createdAt;
  late final String updatedAt;

  Categries.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    status = json['status'];
    proid = json['proid'];
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
    _data['proid'] = proid;
    _data['isapprove'] = isapprove;
    _data['createdAt'] = createdAt;
    _data['updatedAt'] = updatedAt;
    return _data;
  }
}

class RatingTo {
  RatingTo({
    required this.id,
    required this.reviewBy,
    required this.reviewTo,
    required this.eventId,
    required this.rating,
    required this.message,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  late final int? id;
  late final int? reviewBy;
  late final int? reviewTo;
  late final int? eventId;
  late final int? rating;
  late final String? message;
  late final String? createdAt;
  late final String? updatedAt;
  late final User user;

  RatingTo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    reviewBy = json['reviewBy'];
    reviewTo = json['reviewTo'];
    eventId = json['eventId'];
    rating = json['rating'];
    message = json['message'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    user = User.fromJson(json['user']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['reviewBy'] = reviewBy;
    _data['reviewTo'] = reviewTo;
    _data['eventId'] = eventId;
    _data['rating'] = rating;
    _data['message'] = message;
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

  late final int? id;
  late final String? fullName;
  late final String? musicianName;
  late final String? profileImage;
  late final int? categoryId;
  late final String? location;
  late final String? lat;
  late final String? lng;

  User.fromJson(Map<String, dynamic> json) {
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
