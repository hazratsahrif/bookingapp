import 'dart:async';

import 'package:psxmpc/core/vendor/api/common/ps_resource.dart';
import 'package:psxmpc/core/vendor/api/ps_api_service.dart';
import 'package:psxmpc/core/vendor/db/common/ps_data_source_manager.dart';
import 'package:psxmpc/core/vendor/db/vendor_subscription_plan_dao.dart';
import 'package:psxmpc/core/vendor/repository/Common/ps_repository.dart';
import 'package:psxmpc/core/vendor/viewobject/api_status.dart';
import 'package:psxmpc/core/vendor/viewobject/common/ps_holder.dart';
import 'package:psxmpc/core/vendor/viewobject/holder/request_path_holder.dart';

import '../api/common/ps_status.dart';
import '../viewobject/vendor_subscription_plan.dart';

class VendorSubscriptionPlanRepository extends PsRepository {
VendorSubscriptionPlanRepository({
required PsApiService psApiService, required VendorSubscriptionPlanDao vendorSubscriptionPlanDao

}){
  _psApiService = psApiService;
  _vendorSubscriptionPlanDao = vendorSubscriptionPlanDao;
}
String primaryKey = 'id';
  late PsApiService _psApiService;
  late VendorSubscriptionPlanDao _vendorSubscriptionPlanDao;

 Future<dynamic> insert(VendorSubscriptionPlan package) async {
    return _vendorSubscriptionPlanDao.insert(primaryKey, package);
  }

  Future<dynamic> update(VendorSubscriptionPlan package) async {
    return _vendorSubscriptionPlanDao.update(package);
  }

  Future<dynamic> delete(VendorSubscriptionPlan package) async {
    return _vendorSubscriptionPlanDao.delete(package);
  }
  @override
  Future<void> loadDataList({
    required StreamController<PsResource<List<dynamic>>> streamController, 
    required int limit,
    required int offset,
    PsHolder<dynamic>? requestBodyHolder,
    RequestPathHolder? requestPathHolder, 
     required DataConfiguration dataConfig}) async{
    await startResourceSinkingForList(
      dao: _vendorSubscriptionPlanDao, 
      streamController: streamController, 
      dataConfig: dataConfig,
      serverRequestCallback: ()=> _psApiService.getvendorSubscriptionPlan(
      limit,offset, requestPathHolder?.loginUserId ?? 'nologinuser', requestPathHolder?.languageCode ?? 'en')
      );
    
  }

   @override
  Future<PsResource<ApiStatus>> postData({
    required PsHolder<dynamic>? requestBodyHolder,
    required RequestPathHolder? requestPathHolder,
  }) async {
    
    final PsResource<ApiStatus> _resource = await _psApiService.postVendorSubscriptionBought(
        requestBodyHolder!.toMap(),
        requestPathHolder?.loginUserId ?? 'nologinuser',
        requestPathHolder!.headerToken!,
        requestPathHolder.languageCode ?? 'en');
    if (_resource.status == PsStatus.SUCCESS) {
      return _resource;
    } else {
      final Completer<PsResource<ApiStatus>> completer =
          Completer<PsResource<ApiStatus>>();
      completer.complete(_resource);
      return completer.future;
    }
  }
    

}