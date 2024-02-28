class ProductCategory {
  int? id;
  String? name;
  String? image;
  String? isFeatured;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? orderButton;
  List<SubCategory>? subCategory;

  ProductCategory(
      {this.id,
      this.name,
      this.image,
      this.isFeatured,
      this.orderButton,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.subCategory});

  ProductCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    orderButton = json['order_button'];
    image = json['image'];
    isFeatured = json['is_featured'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    if (json['sub_category'] != null) {
      subCategory = <SubCategory>[];
      json['sub_category'].forEach((v) {
        subCategory!.add(new SubCategory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['order_button'] = this.orderButton;
    data['is_featured'] = this.isFeatured;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    if (this.subCategory != null) {
      data['sub_category'] = this.subCategory!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubCategory {
  int? id;
  int? categoryId;
  String? name;
  String? image;
  String? isFeatured;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  SubCategory(
      {this.id,
      this.categoryId,
      this.name,
      this.image,
      this.isFeatured,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  SubCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    name = json['name'];
    image = json['image'];
    isFeatured = json['is_featured'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_id'] = this.categoryId;
    data['name'] = this.name;
    data['image'] = this.image;
    data['is_featured'] = this.isFeatured;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}

class SelectionCategory {
  final ProductCategory category;
  final SubCategory? subCategory;

  SelectionCategory(this.category, this.subCategory);
}
