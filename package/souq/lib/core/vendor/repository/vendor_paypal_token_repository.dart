import 'dart:async';

import 'package:psxmpc/core/vendor/viewobject/vendor_paypal_token.dart';

import '../api/common/ps_resource.dart';
import '../api/ps_api_service.dart';
import 'Common/ps_repository.dart';

class VendorPaypalTokenRepository extends PsRepository {
  VendorPaypalTokenRepository({
    required PsApiService psApiService,
  }) {
    _psApiService = psApiService;
  }
  String primaryKey = '';
  late PsApiService _psApiService;

  Future<PsResource<VendorPaypalToken>?> getVendorPayPalToken(
    // bool isConnectedToInternet,
    // PsStatus status,
    String loginUserId,
    String vendorId,
    String headerToken,
    // {bool isLoadFromServer = true}
  ) async {
    print('start repo');
    final PsResource<VendorPaypalToken>? _resource = await _psApiService
        .getVendorPaypalToken(loginUserId, vendorId, headerToken);
    // if (_resource.status == PsStatus.SUCCESS) {
    // print("success=>${_resource.status}");
    return _resource;
    // } else {
    //   final Completer<PsResource<VendorPaypalToken>> completer =
    //       Completer<PsResource<VendorPaypalToken>>();
    //   completer.complete(_resource);
    //   return completer.future;
    // }
  }
}
