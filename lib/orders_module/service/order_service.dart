import 'dart:async';

import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/orders_module/models/order_model.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../network/network_utils.dart';

class OrderService {
  static Future<List<OrderModel>> getUserOwnOrders() async {
    Completer<List<OrderModel>> completer = Completer<List<OrderModel>>();
    final endPoint = 'order/list';
    try {
      final response =
          await buildHttpResponse(endPoint, method: HttpMethodType.GET);
      final bidListResponse = await handleResponse(response);

      if (bidListResponse != null && (bidListResponse is List)) {
        List<OrderModel> cartItemList =
            bidListResponse.map((e) => OrderModel.fromJson(e)).toList();
        completer.complete(cartItemList);
      } else {
        completer.complete([]);
      }
    } catch (e) {
      completer.complete([]);
    }
    return completer.future;
  }

  static Future<List<OrderModel>> getUserProductsOrders() async {
    Completer<List<OrderModel>> completer = Completer<List<OrderModel>>();
    final endPoint = 'order/seller/list';
    try {
      final response =
          await buildHttpResponse(endPoint, method: HttpMethodType.GET);
      final bidListResponse = await handleResponse(response);

      if (bidListResponse != null && (bidListResponse is List)) {
        List<OrderModel> cartItemList =
            bidListResponse.map((e) => OrderModel.fromJson(e)).toList();
        completer.complete(cartItemList);
      } else {
        completer.complete([]);
      }
    } catch (e) {
      completer.complete([]);
    }
    return completer.future;
  }

  static Future<OrderModel?> getOrderDetails(final int orderId) async {
    Completer<OrderModel> completer = Completer<OrderModel>();
    final endPoint = 'order/show?id=$orderId';
    try {
      final response =
          await buildHttpResponse(endPoint, method: HttpMethodType.GET);
      final bidListResponse = await handleResponse(response);

      if (bidListResponse != null &&
          (bidListResponse is Map<String, dynamic>)) {
        OrderModel cartItemList = OrderModel.fromJson(bidListResponse);
        completer.complete(cartItemList);
      } else {
        completer.complete(null);
      }
    } catch (e) {
      completer.complete(null);
    }
    return completer.future;
  }

  static Future<bool> changeStatus({
    required String orderId,
    required String status,
  }) async {
    appStore.setLoading(true);

    MultipartRequest request = await getMultiPartRequest('order/change_status');
    request.fields.addAll({
      'id': orderId,
      'status': status,
    });

    request.headers.addAll(buildHeaderTokens());
    bool success = false;

    await sendMultiPartRequest(
      request,
      onSuccess: (data) async {
        log('Chnage Status Order $orderId');
        log(data);
        appStore.setLoading(false);
        success = true;
      },
      onError: (error) {
        toast(error.toString(), print: true);
        appStore.setLoading(false);
      },
    ).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
    return success;
  }
}
