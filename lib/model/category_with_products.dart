import 'package:booking_system_flutter/product_module/models/product_data.dart';

class CategoryWithProducts {
  int? id;
  String? name;
  String? image;
  String? isFeatured;
  String? status;
  String? createdAt;
  String? updatedAt;
  var deletedAt;
  List<ProductData>? products;

  CategoryWithProducts(
      {this.id,
      this.name,
      this.image,
      this.isFeatured,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.products});

  CategoryWithProducts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    isFeatured = json['is_featured'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    if (json['products'] != null && json['products'] is List) {
      products = <ProductData>[];
      json['products'].forEach((v) {
        products!.add(new ProductData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['is_featured'] = this.isFeatured;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
