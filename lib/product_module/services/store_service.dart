import 'dart:async';
import 'dart:convert';

import 'package:booking_system_flutter/product_module/models/bid_item_model.dart';
import 'package:booking_system_flutter/product_module/models/cart_item_model.dart';
import 'package:booking_system_flutter/product_module/models/product_category.dart';
import 'package:booking_system_flutter/product_module/models/product_data.dart';
import 'package:booking_system_flutter/product_module/models/wish_list_model.dart';
import 'package:booking_system_flutter/product_module/provider/wish_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../main.dart';
import '../../network/network_utils.dart';
import '../models/order_product_model.dart';
import 'package:dio/dio.dart' as dio;

class StoreService {
  static Future<void> editProduct({
    required List<XFile> images,
    required List<int> existingImagesIds,
    required int productId,
    required String title,
    required String description,
    required String brand,
    required String lat,
    required String long,
    required String quantity,
    required String price,
    required String type,
    required String condition,
    required String address,
    required String catId,
    required String? subCatId,
    required BuildContext context,
  }) async {
    // try {
    //   appStore.setLoading(true);
    //   final headers = buildHeaderTokens();
    //   final data = dio.FormData.fromMap({
    //     'files': [
    //       for (final file in images)
    //         (await dio.MultipartFile.fromFile(file.path, filename: file.name))
    //     ],
    //     'images[]': [
    //       for (final file in images)
    //         (await dio.MultipartFile.fromFile(file.path, filename: file.name))
    //     ],
    //     'title': title,
    //     'id': productId.toString(),
    //     'category_id': catId,
    //     'description': description,
    //     'address': address,
    //     'latitude': lat,
    //     'longitude': long,
    //     'sub_category_id': subCatId ?? '',
    //     'quantity': quantity,
    //     'price': price,
    //     'brand': brand,
    //     'type': type,
    //     'condition': condition,
    //     // 'existing_images': "${existingImagesIds.toString()}",
    //     'existing_images': existingImagesIds,
    //   });

    //   var caller = dio.Dio();
    //   var response = await caller.request(
    //     buildBaseUrl('update_products').toString(),
    //     options: dio.Options(
    //       method: 'POST',
    //       headers: headers,
    //     ),
    //     data: data,
    //   );
    //   apiPrint(
    //       url: buildBaseUrl('update_products').toString(),
    //       headers: jsonEncode(headers),
    //       request: jsonEncode(data),
    //       hasRequest: true,
    //       statusCode: response.statusCode ?? 0,
    //       responseBody: response.data,
    //       methodtype: "POST");

    //   if ((response.statusCode ?? 0) >= 200 &&
    //       (response.statusCode ?? 0) < 300) {
    //     appStore.setLoading(false);
    //     toast(jsonDecode(response.data)['message'], print: true);
    //     finish(context, true);
    //   } else {
    //     toast(response.statusMessage.toString(), print: true);
    //     appStore.setLoading(false);
    //   }
    // } on dio.DioException catch (e) {
    //   appStore.setLoading(false);
    //   log(e);
    //   log(e.response?.data);
    //   toast(language.somethingWentWrong, print: true);
    // }

    appStore.setLoading(true);

    MultipartRequest request = await getMultiPartRequest('update_products');
    request.fields.addAll({
      'title': title,
      'id': productId.toString(),
      'category_id': catId,
      'description': description,
      'address': address,
      'latitude': lat,
      'longitude': long,
      'sub_category_id': subCatId ?? '',
      'quantity': quantity,
      'price': price,
      'brand': brand,
      'type': type,
      'condition': condition,
      // 'existing_images': "${existingImagesIds.toString()}",
      'existing_images': existingImagesIds.join(','),
    });

    for (final file in images) {
      request.files.add(await MultipartFile.fromPath('images[]', file.path,
          filename: file.name));
    }

    request.headers.addAll(buildHeaderTokens());

    sendMultiPartRequest(
      request,
      onSuccess: (data) async {
        appStore.setLoading(false);
        toast(jsonDecode(data)['message'], print: true);
        finish(context, true);
      },
      onError: (error) {
        // toast(error.toString(), print: true);
        appStore.setLoading(false);
      },
    ).catchError((e) {
      appStore.setLoading(false);
      // toast(e.toString(), print: true);
    });
  }

  static Future<ProductsPaginationModel> getProducts({
    String? categoryId,
    String? subCategoryId,
    String? searchText,
    LatLng? latLng,
    int perPage = 10,
    double? minPrice,
    double? maxPrice,
    String? type,
    String? condition,
    int page = 1,
    bool? isFeatured,
  }) async {
    Map<String, dynamic> request = {};
    if (isFeatured != null) {
      final isFeaturedString = !isFeatured ? 'No' : 'Yes';
      request.addAll({'is_featured': isFeaturedString});
    }
    request.addAll({'per_page': perPage});
    if (categoryId != null) request.addAll({'category_id': categoryId});
    if (minPrice != null) request.addAll({'min_price': minPrice});
    if (maxPrice != null) request.addAll({'max_price': maxPrice});
    if (subCategoryId != null)
      request.addAll({'sub_category_id': subCategoryId});
    if (searchText != null) request.addAll({'search': searchText});
    if (type != null) request.addAll({'type': type});
    if (condition != null) request.addAll({'condition': condition});
    if (latLng != null)
      request.addAll({
        'longitude': latLng.longitude.toString(),
        'latitude': latLng.latitude.toString()
      });

    log("Get products Request $request");
    Completer<ProductsPaginationModel> completer =
        Completer<ProductsPaginationModel>();
    final endPoint = 'get_products?page=$page';
    try {
      final response = await buildHttpResponse(endPoint,
          method: HttpMethodType.GET, request: request);
      final productsResponse = await handleResponse(response);
      if (productsResponse == null ||
          !(productsResponse is Map<String, dynamic>)) {
        throw Exception('Invalid data for products');
      }
      final productsList = ProductsPaginationModel.fromJson(productsResponse);
      completer.complete(productsList);
    } catch (e) {
      completer.completeError(e);
    }
    return completer.future;
  }

  static Future<ProductData> getProductById(String id) async {
    Completer<ProductData> completer = Completer<ProductData>();
    final endPoint = 'get_product?id=$id';
    try {
      appStore.setLoading(true);
      final response =
          await buildHttpResponse(endPoint, method: HttpMethodType.GET);
      final productsResponse = await handleResponse(response);

      if (productsResponse == null ||
          !(productsResponse is Map<String, dynamic>)) {
        throw Exception('Invalid data for product');
      }
      final product = ProductData.fromJson(productsResponse);
      completer.complete(product);
    } catch (e) {
      completer.completeError(e);
    }
    appStore.setLoading(false);

    return completer.future;
  }

  static Future<void> addProduct({
    required List<XFile> images,
    required String title,
    required String description,
    required String brand,
    required String lat,
    required String long,
    required String quantity,
    required String price,
    required String type,
    required String condition,
    required String address,
    required String catId,
    required String? subCatId,
    required BuildContext context,
  }) async {
    appStore.setLoading(true);

    MultipartRequest request = await getMultiPartRequest('products');
    request.fields.addAll({
      'title': title,
      'category_id': catId,
      'description': description,
      'address': address,
      'latitude': lat,
      'longitude': long,
      'sub_category_id': subCatId ?? '',
      'quantity': quantity,
      'price': price,
      'brand': brand,
      'type': type,
      'condition': condition,
    });
    for (final file in images) {
      request.files.add(await MultipartFile.fromPath('images[]', file.path,
          filename: file.name));
    }
    request.headers.addAll(buildHeaderTokens());

    sendMultiPartRequest(
      request,
      onSuccess: (data) async {
        appStore.setLoading(false);
        toast(jsonDecode(data)['message'], print: true);
        finish(context);
      },
      onError: (error) {
        // toast(error.toString(), print: true);
        appStore.setLoading(false);
      },
    ).catchError((e) {
      appStore.setLoading(false);
      // toast(e.toString(), print: true);
    });
  }

  static Future<List<ProductCategory>> getProductCategories() async {
    Completer<List<ProductCategory>> completer =
        Completer<List<ProductCategory>>();
    final endPoint = 'get_sub_category_list';
    try {
      final response =
          await buildHttpResponse(endPoint, method: HttpMethodType.GET);
      final categoriesResponse = await handleResponse(response);
      if (categoriesResponse == null || !(categoriesResponse is List)) {
        throw Exception('Invalid data for categories');
      }
      final categoriesList =
          categoriesResponse.map((e) => ProductCategory.fromJson(e)).toList();
      completer.complete(categoriesList);
    } catch (e) {
      completer.completeError(e);
    }
    return completer.future;
  }

  static Future<List<WishListModel>> getWishList() async {
    Completer<List<WishListModel>> completer = Completer<List<WishListModel>>();
    final endPoint = 'wishlist_product_list';
    try {
      final response =
          await buildHttpResponse(endPoint, method: HttpMethodType.GET);
      final categoriesResponse = await handleResponse(response);

      if (categoriesResponse != null && (categoriesResponse is List)) {
        List<WishListModel> categoriesList =
            categoriesResponse.map((e) => WishListModel.fromJson(e)).toList();
        completer.complete(categoriesList);
      } else {
        completer.complete([]);
      }
    } catch (e) {
      completer.complete([]);
    }
    return completer.future;
  }

  static Future<bool> _wishListAddDelete(int productId) async {
    Completer<bool> completer = Completer<bool>();
    final endPoint = 'wishlist_product';
    try {
      final response = await buildHttpResponse(endPoint,
          method: HttpMethodType.POST, request: {'product_id': productId});
      final categoriesResponse = await handleResponse(response);
      if (categoriesResponse == null) {
        completer.complete(false);
      }
      completer.complete(true);
    } catch (e) {
      completer.complete(false);
    }
    return completer.future;
  }

  static Future<bool> toogleItem(int productId) async {
    final success = await _wishListAddDelete(productId);
    if (success)
      await getWishList().then((value) => WishListProvider().fillValue(value));
    return success;
  }

  //cart
  static Future<void> addToCart({
    required String productId,
    required String status,
    required String quantity,
    required String price,
    required BuildContext context,
  }) async {
    appStore.setLoading(true);

    MultipartRequest request = await getMultiPartRequest('add_to_cart_product');
    request.fields.addAll({
      'product_id': productId,
      'status': status,
      'price': price,
      'quantity': quantity,
    });

    request.headers.addAll(buildHeaderTokens());

    sendMultiPartRequest(
      request,
      onSuccess: (data) async {
        appStore.setLoading(false);
        toast(jsonDecode(data), print: true);
        finish(context);
      },
      onError: (error) {
        // toast(error.toString(), print: true);
        appStore.setLoading(false);
      },
    ).catchError((e) {
      appStore.setLoading(false);
      // toast(e.toString(), print: true);
    });
  }

  static Future<List<CartItemModel>> getCart() async {
    Completer<List<CartItemModel>> completer = Completer<List<CartItemModel>>();
    final endPoint = 'add_to_cart_product_list';
    try {
      final response =
          await buildHttpResponse(endPoint, method: HttpMethodType.GET);
      final cartResponse = await handleResponse(response);

      if (cartResponse != null && (cartResponse is List)) {
        List<CartItemModel> cartItemList =
            cartResponse.map((e) => CartItemModel.fromJson(e)).toList();
        completer.complete(cartItemList);
      } else {
        completer.complete([]);
      }
    } catch (e) {
      completer.complete([]);
    }
    return completer.future;
  }

  static Future<bool> _updateItemInCart({
    required String productId,
    required String quantity,
  }) async {
    appStore.setLoading(true);

    MultipartRequest request =
        await getMultiPartRequest('add_to_cart_product_update');
    request.fields.addAll({
      'product_id': productId,
      'quantity': quantity,
    });

    request.headers.addAll(buildHeaderTokens());
    bool success = false;

    await sendMultiPartRequest(
      request,
      onSuccess: (data) async {
        appStore.setLoading(false);
        success = true;
      },
      onError: (error) {
        // toast(error.toString(), print: true);
        appStore.setLoading(false);
      },
    ).catchError((e) {
      appStore.setLoading(false);
      // toast(e.toString(), print: true);
    });
    return success;
  }

  static Future<bool> incrementItemInCart({
    required String productId,
    required int quantity,
  }) async {
    return _updateItemInCart(
        productId: productId, quantity: (quantity + 1).toString());
  }

  static Future<bool> decrementItemInCart({
    required String productId,
    required int quantity,
  }) async {
    return _updateItemInCart(
        productId: productId, quantity: (quantity - 1).toString());
  }

  static Future<bool> deleteItemInCart({
    required String productId,
  }) async {
    appStore.setLoading(true);

    MultipartRequest request =
        await getMultiPartRequest('add_to_cart_product_delete');
    request.fields.addAll({
      'product_id': productId,
    });

    request.headers.addAll(buildHeaderTokens());
    bool success = false;

    await sendMultiPartRequest(
      request,
      onSuccess: (data) async {
        appStore.setLoading(false);
        success = true;
      },
      onError: (error) {
        // toast(error.toString(), print: true);
        appStore.setLoading(false);
      },
    ).catchError((e) {
      appStore.setLoading(false);
      // toast(e.toString(), print: true);
    });
    return success;
  }

  //bidding
  static Future<bool> bidOnProduct({
    required String productId,
    required String bidPrice,
  }) async {
    appStore.setLoading(true);

    MultipartRequest request = await getMultiPartRequest('bidding_product');
    request.fields.addAll({
      'product_id': productId,
      'bid_price': bidPrice,
    });

    request.headers.addAll(buildHeaderTokens());
    bool success = false;

    await sendMultiPartRequest(
      request,
      onSuccess: (data) async {
        appStore.setLoading(false);
        toast(jsonDecode(data), print: true);

        success = true;
      },
      onError: (error) {
        // toast(error.toString(), print: true);
        appStore.setLoading(false);
      },
    ).catchError((e) {
      appStore.setLoading(false);
      // toast(e.toString(), print: true);
    });
    return success;
  }

  static Future<List<BidItemModel>> getBidList() async {
    Completer<List<BidItemModel>> completer = Completer<List<BidItemModel>>();
    final endPoint = 'bidding_product_list';
    try {
      final response =
          await buildHttpResponse(endPoint, method: HttpMethodType.GET);
      final bidListResponse = await handleResponse(response);

      if (bidListResponse != null && (bidListResponse is List)) {
        List<BidItemModel> cartItemList =
            bidListResponse.map((e) => BidItemModel.fromJson(e)).toList();
        completer.complete(cartItemList);
      } else {
        completer.complete([]);
      }
    } catch (e) {
      completer.complete([]);
    }
    return completer.future;
  }

//products
  static Future<List<ProductData>> getMyProducts() async {
    Completer<List<ProductData>> completer = Completer<List<ProductData>>();
    final endPoint = 'product_list';
    try {
      final response =
          await buildHttpResponse(endPoint, method: HttpMethodType.GET);
      final myProductsResponse = await handleResponse(response);

      if (myProductsResponse != null && (myProductsResponse is List)) {
        List<ProductData> myProductsList =
            myProductsResponse.map((e) => ProductData.fromJson(e)).toList();
        completer.complete(myProductsList);
      } else {
        completer.complete([]);
      }
    } catch (e) {
      completer.complete([]);
    }
    return completer.future;
  }

  static Future<bool> deleteProduct({
    required String productId,
  }) async {
    appStore.setLoading(true);

    MultipartRequest request = await getMultiPartRequest('product_delete');
    request.fields.addAll({
      'id': productId,
    });

    request.headers.addAll(buildHeaderTokens());
    bool success = false;

    await sendMultiPartRequest(
      request,
      onSuccess: (data) async {
        appStore.setLoading(false);
        success = true;
      },
      onError: (error) {
        // toast(error.toString(), print: true);
        appStore.setLoading(false);
      },
    ).catchError((e) {
      appStore.setLoading(false);
      // toast(e.toString(), print: true);
    });
    return success;
  }

  //orders
  static Future<bool> placeOrder({
    required String note,
    required String date,
    required String lat,
    required String long,
    required String time,
    String paymentMethod = "COD",
    required String total,
    required String address,
    required List<OrderProductModel> orderProducts,
  }) async {
    // Completer<List<BidItemModel>> completer = Completer<List<BidItemModel>>();

    final endPoint = 'orders';
    final request = {
      "delivery_address": address,
      "delivery_latitude": lat,
      "delivery_longitude": long,
      "delivery_date": date,
      "delivery_time": time,
      "delivery_note": note,
      "payment_method": paymentMethod,
      "total_price": total,
      "order_products": orderProducts.map((e) => e.toJson()).toList()
    };
    log(request);
    try {
      final response = await buildHttpResponse(endPoint,
          method: HttpMethodType.POST, request: request);
      final placeOrderResponse = await handleResponse(response);

      toast(placeOrderResponse?['message'] ?? 'Error');

      return placeOrderResponse?['success'] ?? true;
    } catch (e) {
      // toast(e.toString());
    }
    return false;
  }
}
