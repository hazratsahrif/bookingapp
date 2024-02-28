import 'package:psxmpc/core/vendor/api/common/ps_resource.dart';
import 'package:psxmpc/core/vendor/constant/ps_constants.dart';
import 'package:psxmpc/core/vendor/provider/common/ps_provider.dart';
import 'package:psxmpc/core/vendor/repository/vendor_item_bought_repository.dart';
import 'package:psxmpc/core/vendor/viewobject/common/ps_holder.dart';
import 'package:psxmpc/core/vendor/viewobject/holder/request_path_holder.dart';
import 'package:psxmpc/core/vendor/viewobject/vendor_item_bought_status.dart';

class VendorItemBoughtProvider extends PsProvider<VendorItemBoughtApiStatus> {
  VendorItemBoughtProvider({
    required VendorItemBoughtRepository? vendorItemBoughtRepository,
    int limit = 0,
  }) : super(vendorItemBoughtRepository, limit,
            subscriptionType: PsConst.NO_SUBSCRIPTION) {
    _repo = vendorItemBoughtRepository;
  }

  VendorItemBoughtRepository? _repo;
  Future<PsResource<VendorItemBoughtApiStatus>?> vendorItemBought({
    PsHolder<dynamic>? requestBodyHolder,
    RequestPathHolder? requestPathHolder,
  }) async {
    // print('start fun');
    // print('provider=>$loginUserId');
    // print('provider=>$vendorId');
    // print('provider=>$headerToken');
    // isLoading = true;
    // isConnectedToInternet = await Utils.checkInternetConnectivity();

    final PsResource<VendorItemBoughtApiStatus>? _resource =
        await _repo!.postData(
            // isConnectedToInternet, PsStatus.SUCCESS,
            requestBodyHolder: requestBodyHolder,
            requestPathHolder: requestPathHolder);
    print('end fun');
    return _resource;
  }
}
