class OrderProductModel {
  final String productId;
  final String price;
  final String quantity;

  OrderProductModel(this.productId, this.price, this.quantity);
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data["product_id"] = productId;
    data["product_price"] = price;
    data["quantity"] = quantity;
    return data;
  }
}
