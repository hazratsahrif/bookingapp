class WishListModel {
  int? id;
  int? productId;
  int? userId;
  Product? product;

  WishListModel({this.id, this.productId, this.userId, this.product});

  WishListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    userId = json['user_id'];
    product =
        json['product'] != null ? new Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_id'] = this.productId;
    data['user_id'] = this.userId;
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    return data;
  }
}

class Product {
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
  Null? approvalBy;
  String? approval;
  String? status;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;
  List<ProductImages>? productImages;

  Product(
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
      this.productImages});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    categoryId = json['category_id'];
    subCategoryId = json['sub_category_id'];
    title = json['title'];
    description = json['description'];
    brand = json['brand'];
    quantity = json['quantity'];
    price = json['price'];
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
