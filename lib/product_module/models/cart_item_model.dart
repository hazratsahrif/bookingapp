import 'package:booking_system_flutter/product_module/models/product_data.dart';

class CartItemModel {
  int? id;
  int? productId;
  int? userId;
  String? quantity;
  String? price;
  String? status;
  String? createdAt;
  String? updatedAt;
  ProductData? products;
  BuyerUser? buyerUser;

  CartItemModel(
      {this.id,
      this.productId,
      this.userId,
      this.quantity,
      this.price,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.products,
      this.buyerUser});

  CartItemModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    userId = json['user_id'];
    quantity = json['quantity'];
    price = json['price'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    products = json['products'] != null
        ? new ProductData.fromJson(json['products'])
        : null;
    buyerUser = json['buyer_user'] != null
        ? new BuyerUser.fromJson(json['buyer_user'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_id'] = this.productId;
    data['user_id'] = this.userId;
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.products != null) {
      data['products'] = this.products!.toJson();
    }
    if (this.buyerUser != null) {
      data['buyer_user'] = this.buyerUser!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? username;
  String? firstName;
  String? lastName;
  String? email;
  String? userType;
  String? contactNumber;
  var countryId;
  var stateId;
  var cityId;
  var providerId;
  var address;
  String? playerId;
  int? status;
  String? displayName;
  var providertypeId;
  int? isFeatured;
  String? timeZone;
  var lastNotificationSeen;
  var emailVerifiedAt;
  var deletedAt;
  String? createdAt;
  String? updatedAt;
  var loginType;
  var serviceAddressId;
  var uid;
  var handymantypeId;
  int? isSubscribe;
  var socialImage;
  int? isAvailable;
  var designation;
  var lastOnlineTime;
  int? slotsForAllServices;
  var knownLanguages;
  var skills;
  var description;
  var categoryId;
  var otp;
  String? verifyOtp;

  User(
      {this.id,
      this.username,
      this.firstName,
      this.lastName,
      this.email,
      this.userType,
      this.contactNumber,
      this.countryId,
      this.stateId,
      this.cityId,
      this.providerId,
      this.address,
      this.playerId,
      this.status,
      this.displayName,
      this.providertypeId,
      this.isFeatured,
      this.timeZone,
      this.lastNotificationSeen,
      this.emailVerifiedAt,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.loginType,
      this.serviceAddressId,
      this.uid,
      this.handymantypeId,
      this.isSubscribe,
      this.socialImage,
      this.isAvailable,
      this.designation,
      this.lastOnlineTime,
      this.slotsForAllServices,
      this.knownLanguages,
      this.skills,
      this.description,
      this.categoryId,
      this.otp,
      this.verifyOtp});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    userType = json['user_type'];
    contactNumber = json['contact_number'];
    countryId = json['country_id'];
    stateId = json['state_id'];
    cityId = json['city_id'];
    providerId = json['provider_id'];
    address = json['address'];
    playerId = json['player_id'];
    status = json['status'];
    displayName = json['display_name'];
    providertypeId = json['providertype_id'];
    isFeatured = json['is_featured'];
    timeZone = json['time_zone'];
    lastNotificationSeen = json['last_notification_seen'];
    emailVerifiedAt = json['email_verified_at'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    loginType = json['login_type'];
    serviceAddressId = json['service_address_id'];
    uid = json['uid'];
    handymantypeId = json['handymantype_id'];
    isSubscribe = json['is_subscribe'];
    socialImage = json['social_image'];
    isAvailable = json['is_available'];
    designation = json['designation'];
    lastOnlineTime = json['last_online_time'];
    slotsForAllServices = json['slots_for_all_services'];
    knownLanguages = json['known_languages'];
    skills = json['skills'];
    description = json['description'];
    categoryId = json['category_id'];
    otp = json['otp'];
    verifyOtp = json['verify_otp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['user_type'] = this.userType;
    data['contact_number'] = this.contactNumber;
    data['country_id'] = this.countryId;
    data['state_id'] = this.stateId;
    data['city_id'] = this.cityId;
    data['provider_id'] = this.providerId;
    data['address'] = this.address;
    data['player_id'] = this.playerId;
    data['status'] = this.status;
    data['display_name'] = this.displayName;
    data['providertype_id'] = this.providertypeId;
    data['is_featured'] = this.isFeatured;
    data['time_zone'] = this.timeZone;
    data['last_notification_seen'] = this.lastNotificationSeen;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['login_type'] = this.loginType;
    data['service_address_id'] = this.serviceAddressId;
    data['uid'] = this.uid;
    data['handymantype_id'] = this.handymantypeId;
    data['is_subscribe'] = this.isSubscribe;
    data['social_image'] = this.socialImage;
    data['is_available'] = this.isAvailable;
    data['designation'] = this.designation;
    data['last_online_time'] = this.lastOnlineTime;
    data['slots_for_all_services'] = this.slotsForAllServices;
    data['known_languages'] = this.knownLanguages;
    data['skills'] = this.skills;
    data['description'] = this.description;
    data['category_id'] = this.categoryId;
    data['otp'] = this.otp;
    data['verify_otp'] = this.verifyOtp;
    return data;
  }
}

class BuyerUser {
  int? id;
  String? username;
  String? firstName;
  String? lastName;
  String? email;
  String? userType;
  String? contactNumber;
  var countryId;
  var stateId;
  var cityId;
  var providerId;
  var address;
  String? playerId;
  int? status;
  String? displayName;
  var providertypeId;
  int? isFeatured;
  String? timeZone;
  String? lastNotificationSeen;
  var emailVerifiedAt;
  var deletedAt;
  String? createdAt;
  String? updatedAt;
  var loginType;
  var serviceAddressId;
  var uid;
  var handymantypeId;
  int? isSubscribe;
  var socialImage;
  int? isAvailable;
  var designation;
  var lastOnlineTime;
  int? slotsForAllServices;
  var knownLanguages;
  var skills;
  var description;
  var categoryId;
  var otp;
  String? verifyOtp;

  BuyerUser(
      {this.id,
      this.username,
      this.firstName,
      this.lastName,
      this.email,
      this.userType,
      this.contactNumber,
      this.countryId,
      this.stateId,
      this.cityId,
      this.providerId,
      this.address,
      this.playerId,
      this.status,
      this.displayName,
      this.providertypeId,
      this.isFeatured,
      this.timeZone,
      this.lastNotificationSeen,
      this.emailVerifiedAt,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.loginType,
      this.serviceAddressId,
      this.uid,
      this.handymantypeId,
      this.isSubscribe,
      this.socialImage,
      this.isAvailable,
      this.designation,
      this.lastOnlineTime,
      this.slotsForAllServices,
      this.knownLanguages,
      this.skills,
      this.description,
      this.categoryId,
      this.otp,
      this.verifyOtp});

  BuyerUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    userType = json['user_type'];
    contactNumber = json['contact_number'];
    countryId = json['country_id'];
    stateId = json['state_id'];
    cityId = json['city_id'];
    providerId = json['provider_id'];
    address = json['address'];
    playerId = json['player_id'];
    status = json['status'];
    displayName = json['display_name'];
    providertypeId = json['providertype_id'];
    isFeatured = json['is_featured'];
    timeZone = json['time_zone'];
    lastNotificationSeen = json['last_notification_seen'];
    emailVerifiedAt = json['email_verified_at'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    loginType = json['login_type'];
    serviceAddressId = json['service_address_id'];
    uid = json['uid'];
    handymantypeId = json['handymantype_id'];
    isSubscribe = json['is_subscribe'];
    socialImage = json['social_image'];
    isAvailable = json['is_available'];
    designation = json['designation'];
    lastOnlineTime = json['last_online_time'];
    slotsForAllServices = json['slots_for_all_services'];
    knownLanguages = json['known_languages'];
    skills = json['skills'];
    description = json['description'];
    categoryId = json['category_id'];
    otp = json['otp'];
    verifyOtp = json['verify_otp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['user_type'] = this.userType;
    data['contact_number'] = this.contactNumber;
    data['country_id'] = this.countryId;
    data['state_id'] = this.stateId;
    data['city_id'] = this.cityId;
    data['provider_id'] = this.providerId;
    data['address'] = this.address;
    data['player_id'] = this.playerId;
    data['status'] = this.status;
    data['display_name'] = this.displayName;
    data['providertype_id'] = this.providertypeId;
    data['is_featured'] = this.isFeatured;
    data['time_zone'] = this.timeZone;
    data['last_notification_seen'] = this.lastNotificationSeen;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['login_type'] = this.loginType;
    data['service_address_id'] = this.serviceAddressId;
    data['uid'] = this.uid;
    data['handymantype_id'] = this.handymantypeId;
    data['is_subscribe'] = this.isSubscribe;
    data['social_image'] = this.socialImage;
    data['is_available'] = this.isAvailable;
    data['designation'] = this.designation;
    data['last_online_time'] = this.lastOnlineTime;
    data['slots_for_all_services'] = this.slotsForAllServices;
    data['known_languages'] = this.knownLanguages;
    data['skills'] = this.skills;
    data['description'] = this.description;
    data['category_id'] = this.categoryId;
    data['otp'] = this.otp;
    data['verify_otp'] = this.verifyOtp;
    return data;
  }
}
