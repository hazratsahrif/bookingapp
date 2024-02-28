import 'package:psxmpc/core/vendor/viewobject/product.dart';

import '../../basket_selected_add_on.dart';
import '../../basket_selected_attribute.dart';

class ProductDetailIntentHolder {
  ProductDetailIntentHolder(
      {this.id,
      this.productId,
      this.heroTagImage,
      this.heroTagTitle,
      this.intentBasketSelectedAddOnList,
      this.intentBasketSelectedAttributeList,
      this.intentQty,
      this.stockQty,
      this.userQty,
      this.currentPrice,
      this.product,
      this.orderId});

  final String? id;
  final String? productId;
  final String? heroTagImage;
  final String? heroTagTitle;
  final List<BasketSelectedAttribute>? intentBasketSelectedAttributeList;
  final List<BasketSelectedAddOn>? intentBasketSelectedAddOnList;
  final String? intentQty;
  final int? stockQty;
  int? userQty;
  final String? currentPrice;
  final Product? product;
  String? orderId;
}
