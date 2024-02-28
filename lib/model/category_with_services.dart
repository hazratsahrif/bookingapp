import 'service_data_model.dart';

class CategoryWithServices {
  int? id;
  String? name;
  String? description;
  String? color;
  int? status;
  int? isFeatured;
  var deletedAt;
  String? createdAt;
  String? updatedAt;
  List<ServiceData>? services;

  CategoryWithServices(
      {this.id,
      this.name,
      this.description,
      this.color,
      this.status,
      this.isFeatured,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.services});

  CategoryWithServices.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    color = json['color'];
    status = json['status'];
    isFeatured = json['is_featured'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['services'] != null && json['services'] is List) {
      services = <ServiceData>[];
      json['services'].forEach((v) {
        services!.add(new ServiceData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['color'] = this.color;
    data['status'] = this.status;
    data['is_featured'] = this.isFeatured;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.services != null) {
      data['services'] = this.services!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
