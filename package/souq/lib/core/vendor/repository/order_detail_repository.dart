import 'dart:async';
import 'package:psxmpc/core/vendor/db/order_detail_dao.dart';

import '../api/common/ps_resource.dart';
import '../api/ps_api_service.dart';
import '../db/common/ps_data_source_manager.dart';
import '../viewobject/common/ps_holder.dart';
import '../viewobject/holder/request_path_holder.dart';
import 'Common/ps_repository.dart';

class OrderDetailRepository extends PsRepository {
  OrderDetailRepository(
      {required PsApiService psApiService,
      required OrderDetailDao orderDetailDao}) {
    _psApiService = psApiService;
    _orderDetailDao = orderDetailDao;
  }

  // String primaryKey = 'id';
  late PsApiService _psApiService;
  late OrderDetailDao _orderDetailDao;

  // Future<dynamic> insert(AboutUs aboutUs) async {
  //   return _aboutUsDao.insert(primaryKey, aboutUs);
  // }

  // Future<dynamic> update(AboutUs aboutUs) async {
  //   return _aboutUsDao.update(aboutUs);
  // }

  // Future<dynamic> delete(AboutUs aboutUs) async {
  //   return _aboutUsDao.delete(aboutUs);
  // }

  // @override
  // Future<void> loadDataList({
  //   required StreamController<PsResource<List<dynamic>>> streamController,
  //   required int limit,
  //   required int offset,
  //   PsHolder<dynamic>? requestBodyHolder,
  //   RequestPathHolder? requestPathHolder,
  //   required DataConfiguration dataConfig,
  // }) async {
  //   await startResourceSinkingForList(
  //     dao: _aboutUsDao,
  //     streamController: streamController,
  //     dataConfig: dataConfig,
  //     serverRequestCallback: () => _psApiService
  //         .getAboutUsDataList(requestPathHolder?.loginUserId ?? 'nologinuser'),
  //   );
  // }

  @override
  Future<void> loadData({
    required StreamController<PsResource<dynamic>> streamController,
    PsHolder<dynamic>? requestBodyHolder,
    RequestPathHolder? requestPathHolder,
    required DataConfiguration dataConfig,
  }) async {
    await startResourceSinkingForOne(
      dao: _orderDetailDao,
      streamController: streamController,
      dataConfig: dataConfig,
      serverRequestCallback: () => _psApiService.getOrderSummary(
        requestPathHolder!.orderId ?? '',
        requestPathHolder.loginUserId ?? 'nologinuser',
        requestPathHolder.languageCode ?? 'en',
      ),
    );
  }
}
