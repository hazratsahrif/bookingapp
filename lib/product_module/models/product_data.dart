import 'package:booking_system_flutter/model/user_data_model.dart';
import 'package:booking_system_flutter/product_module/models/product_category.dart';

class ProductsPaginationModel {
  Data? data;

  ProductsPaginationModel({this.data});

  ProductsPaginationModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? currentPage;
  List<ProductData>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Links>? links;
  var nextPageUrl;
  String? path;
  int? perPage;
  var prevPageUrl;
  int? to;
  int? total;

  Data(
      {this.currentPage,
      this.data,
      this.firstPageUrl,
      this.from,
      this.lastPage,
      this.lastPageUrl,
      this.links,
      this.nextPageUrl,
      this.path,
      this.perPage,
      this.prevPageUrl,
      this.to,
      this.total});

  Data.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <ProductData>[];
      json['data'].forEach((v) {
        data!.add(new ProductData.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(new Links.fromJson(v));
      });
    }
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = this.firstPageUrl;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    data['last_page_url'] = this.lastPageUrl;
    if (this.links != null) {
      data['links'] = this.links!.map((v) => v.toJson()).toList();
    }
    data['next_page_url'] = this.nextPageUrl;
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['prev_page_url'] = this.prevPageUrl;
    data['to'] = this.to;
    data['total'] = this.total;
    return data;
  }
}

class ProductData {
  int? id;
  int? userId;
  int? categoryId;
  int? subCategoryId;
  String? title;
  String? description;
  String? brand;
  String? quantity;
  String? price;
  String? type;
  String? condition;
  String? isFeatured;
  String? address;
  String? latitude;
  String? longitude;
  var approvalBy;
  String? approval;
  String? status;
  String? createdAt;
  String? updatedAt;
  var deletedAt;
  List<ProductImages>? productImages;
  UserData? user;
  ProductCategory? productCategory;
  SubCategory? productSubCategory;

  ProductData(
      {this.id,
      this.userId,
      this.categoryId,
      this.subCategoryId,
      this.title,
      this.description,
      this.brand,
      this.quantity,
      this.price,
      this.type,
      this.condition,
      this.isFeatured,
      this.address,
      this.latitude,
      this.longitude,
      this.approvalBy,
      this.approval,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.productImages,
      this.user,
      this.productCategory,
      this.productSubCategory});

  ProductData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    categoryId = json['category_id'];
    subCategoryId = json['sub_category_id'];
    title = json['title'];
    description = json['description'];
    brand = json['brand'];
    quantity = json['quantity'];
    final String? priceTemp = json['price'];
    price = priceTemp?.replaceAll(',', '');
    type = json['type'];
    condition = json['condition'];
    isFeatured = json['is_featured'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    approvalBy = json['approval_by'];
    approval = json['approval'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    if (json['product_images'] != null) {
      productImages = <ProductImages>[];
      json['product_images'].forEach((v) {
        productImages!.add(new ProductImages.fromJson(v));
      });
    }
    user = json['user'] != null ? new UserData.fromJson(json['user']) : null;
    productCategory = json['product_category'] != null
        ? new ProductCategory.fromJson(json['product_category'])
        : null;
    productSubCategory = json['product_sub_category'] != null
        ? new SubCategory.fromJson(json['product_sub_category'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['category_id'] = this.categoryId;
    data['sub_category_id'] = this.subCategoryId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['brand'] = this.brand;
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    data['type'] = this.type;
    data['condition'] = this.condition;
    data['is_featured'] = this.isFeatured;
    data['address'] = this.address;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['approval_by'] = this.approvalBy;
    data['approval'] = this.approval;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    if (this.productImages != null) {
      data['product_images'] =
          this.productImages!.map((v) => v.toJson()).toList();
    }
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.productCategory != null) {
      data['product_category'] = this.productCategory!.toJson();
    }
    if (this.productSubCategory != null) {
      data['product_sub_category'] = this.productSubCategory!.toJson();
    }
    return data;
  }
}

class ProductImages {
  int? id;
  int? productId;
  String? images;
  String? createdAt;
  String? updatedAt;

  ProductImages(
      {this.id, this.productId, this.images, this.createdAt, this.updatedAt});

  ProductImages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    images = json['images'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_id'] = this.productId;
    data['images'] = this.images;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
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

// class ProductData {
//   int? id;
//   int? userId;
//   int? categoryId;
//   int? subCategoryId;
//   String? title;
//   String? description;
//   String? brand;
//   String? quantity;
//   String? price;
//   String? type;
//   String? condition;
//   String? isFeatured;
//   String? address;
//   String? latitude;
//   String? longitude;
//   var approvalBy;
//   String? approval;
//   String? status;
//   String? createdAt;
//   String? updatedAt;
//   var deletedAt;
//   List<ProductImages>? productImages;
//   ProductCategory? productCategory;
//   SubCategory? productSubCategory;

//   ProductData(
//       {this.id,
//       this.userId,
//       this.categoryId,
//       this.subCategoryId,
//       this.title,
//       this.description,
//       this.brand,
//       this.quantity,
//       this.price,
//       this.type,
//       this.condition,
//       this.isFeatured,
//       this.address,
//       this.latitude,
//       this.longitude,
//       this.approvalBy,
//       this.approval,
//       this.status,
//       this.createdAt,
//       this.updatedAt,
//       this.deletedAt,
//       this.productImages,
//       this.productCategory,
//       this.productSubCategory});

//   ProductData.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     userId = json['user_id'];
//     categoryId = json['category_id'];
//     subCategoryId = json['sub_category_id'];
//     title = json['title'];
//     description = json['description'];
//     brand = json['brand'];
//     quantity = json['quantity'];
//     price = json['price'];
//     type = json['type'];
//     condition = json['condition'];
//     isFeatured = json['is_featured'];
//     address = json['address'];
//     latitude = json['latitude'];
//     longitude = json['longitude'];
//     approvalBy = json['approval_by'];
//     approval = json['approval'];
//     status = json['status'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     deletedAt = json['deleted_at'];
//     if (json['product_images'] != null) {
//       productImages = <ProductImages>[];
//       json['product_images'].forEach((v) {
//         productImages!.add(new ProductImages.fromJson(v));
//       });
//     }
//     productCategory = json['product_category'] != null
//         ? new ProductCategory.fromJson(json['product_category'])
//         : null;
//     productSubCategory = json['product_sub_category'] != null
//         ? new SubCategory.fromJson(json['product_sub_category'])
//         : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['user_id'] = this.userId;
//     data['category_id'] = this.categoryId;
//     data['sub_category_id'] = this.subCategoryId;
//     data['title'] = this.title;
//     data['description'] = this.description;
//     data['brand'] = this.brand;
//     data['quantity'] = this.quantity;
//     data['price'] = this.price;
//     data['type'] = this.type;
//     data['condition'] = this.condition;
//     data['is_featured'] = this.isFeatured;
//     data['address'] = this.address;
//     data['latitude'] = this.latitude;
//     data['longitude'] = this.longitude;
//     data['approval_by'] = this.approvalBy;
//     data['approval'] = this.approval;
//     data['status'] = this.status;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     data['deleted_at'] = this.deletedAt;
//     if (this.productImages != null) {
//       data['product_images'] =
//           this.productImages!.map((v) => v.toJson()).toList();
//     }
//     if (this.productCategory != null) {
//       data['product_category'] = this.productCategory!.toJson();
//     }
//     if (this.productSubCategory != null) {
//       data['product_sub_category'] = this.productSubCategory!.toJson();
//     }
//     return data;
//   }
// }

// class ProductImages {
//   int? id;
//   int? productId;
//   String? images;
//   String? createdAt;
//   String? updatedAt;

//   ProductImages(
//       {this.id, this.productId, this.images, this.createdAt, this.updatedAt});

//   ProductImages.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     productId = json['product_id'];
//     images = json['images'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['product_id'] = this.productId;
//     data['images'] = this.images;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     return data;
//   }
// }

class Links {
  String? url;
  String? label;
  bool? active;

  Links({this.url, this.label, this.active});

  Links.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    label = json['label'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['label'] = this.label;
    data['active'] = this.active;
    return data;
  }
}
