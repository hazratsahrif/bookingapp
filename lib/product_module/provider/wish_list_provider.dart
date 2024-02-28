import 'package:booking_system_flutter/product_module/models/wish_list_model.dart';
import 'package:flutter/foundation.dart';

class WishListProvider {
  WishListProvider._();
  static final _internal = WishListProvider._();
  factory WishListProvider() {
    return _internal;
  }
  ValueNotifier<List<WishListModel>> wishList =
      ValueNotifier<List<WishListModel>>([]);

  List<WishListModel> fillValue(List<WishListModel> wishes) {
    _internal.wishList.value = wishes;
    _internal.wishList.notifyListeners();
    return _internal.wishList.value;
  }
}
