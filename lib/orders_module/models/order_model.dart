import 'package:booking_system_flutter/model/user_data_model.dart';

import '../../product_module/models/product_data.dart';

class OrderModel {
  int? id;
  int? userId;
  String? orderNumber;
  String? deliveryAddress;
  String? deliveryLatitude;
  String? deliveryLongitude;
  String? deliveryDate;
  String? deliveryTime;
  String? deliveryNote;
  String? paymentMethod;
  String? totalPrice;
  String? orderStatus;
  String? createdAt;
  String? updatedAt;
  UserData? user;
  List<OrderProducts>? orderProducts;

  OrderModel(
      {this.id,
      this.userId,
      this.orderNumber,
      this.deliveryAddress,
      this.deliveryLatitude,
      this.deliveryLongitude,
      this.deliveryDate,
      this.deliveryTime,
      this.deliveryNote,
      this.paymentMethod,
      this.totalPrice,
      this.orderStatus,
      this.createdAt,
      this.updatedAt,
      this.user,
      this.orderProducts});

  OrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    orderNumber = json['order_number'];
    deliveryAddress = json['delivery_address'];
    deliveryLatitude = json['delivery_latitude'];
    deliveryLongitude = json['delivery_longitude'];
    deliveryDate = json['delivery_date'];
    deliveryTime = json['delivery_time'];
    deliveryNote = json['delivery_note'];
    paymentMethod = json['payment_method'];
    totalPrice = json['total_price'];
    orderStatus = json['order_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? new UserData.fromJson(json['user']) : null;
    if (json['order_products'] != null) {
      orderProducts = <OrderProducts>[];
      json['order_products'].forEach((v) {
        orderProducts!.add(new OrderProducts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['order_number'] = this.orderNumber;
    data['delivery_address'] = this.deliveryAddress;
    data['delivery_latitude'] = this.deliveryLatitude;
    data['delivery_longitude'] = this.deliveryLongitude;
    data['delivery_date'] = this.deliveryDate;
    data['delivery_time'] = this.deliveryTime;
    data['delivery_note'] = this.deliveryNote;
    data['payment_method'] = this.paymentMethod;
    data['total_price'] = this.totalPrice;
    data['order_status'] = this.orderStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.orderProducts != null) {
      data['order_products'] =
          this.orderProducts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderProducts {
  int? id;
  int? orderId;
  int? productId;
  String? productPrice;
  String? quantity;
  String? createdAt;
  String? updatedAt;
  ProductData? product;

  OrderProducts(
      {this.id,
      this.orderId,
      this.productId,
      this.productPrice,
      this.quantity,
      this.createdAt,
      this.updatedAt,
      this.product});

  OrderProducts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    productId = json['product_id'];
    productPrice = json['product_price'];
    quantity = json['quantity'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    product = json['product'] != null
        ? new ProductData.fromJson(json['product'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['product_id'] = this.productId;
    data['product_price'] = this.productPrice;
    data['quantity'] = this.quantity;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    return data;
  }
}
