import 'package:flutter/material.dart';
import 'package:psxmpc/core/vendor/viewobject/holder/product_detail_and_address_intent_holder.dart';

import '../../../../vendor_ui/item/detail/view/product_detail_view.dart';

class CustomProductDetailView extends StatefulWidget {
  const CustomProductDetailView({this.productDetailAndAddress
      //   required this.productId,

      // // required this.catID,
      // required this.heroTagImage,
      // required this.heroTagTitle
      });
  final ProductDetailAndAddress? productDetailAndAddress;
  // final String? productId;
  // final String? heroTagImage;
  // final String? heroTagTitle;

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<CustomProductDetailView> {
  @override
  Widget build(BuildContext context) {
    return ProductDetailView(
      productDetailAndAddress: widget.productDetailAndAddress,
      // productId: widget.productId,
      // heroTagImage: widget.heroTagImage,
      // heroTagTitle: widget.heroTagTitle
    );
  }
}
