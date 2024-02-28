import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:psxmpc/core/vendor/provider/common/ps_init_provider.dart';
import 'package:psxmpc/core/vendor/repository/vendor_search_repository.dart';
import 'package:psxmpc/core/vendor/utils/utils.dart';
import 'package:psxmpc/core/vendor/viewobject/holder/request_path_holder.dart';
import 'package:psxmpc/core/vendor/viewobject/holder/vendor_search_parameter_holder.dart';
import 'package:psxmpc/core/vendor/viewobject/vendor_user.dart';

import '../../api/common/ps_resource.dart';
import '../../constant/ps_constants.dart';
import '../../viewobject/common/ps_value_holder.dart';
import '../common/ps_provider.dart';

class VendorSearchProvider extends PsProvider<VendorUser> {
  VendorSearchProvider({
    required VendorSearchRepository? repo,
    this.psValueHolder,
    int limit = 0,
  }) : super(repo, limit, subscriptionType: PsConst.LIST_OBJECT_SUBSCRIPTION);

  PsValueHolder? psValueHolder;
  PsResource<List<VendorUser>> get vendorList => super.dataList;

  VendorSearchParameterHolder vendorSearchParameterHolder = VendorSearchParameterHolder();
  VendorSearchParameterHolder getAllVendorParameterHolder = VendorSearchParameterHolder().getAllVendor();

}

SingleChildWidget initVendorSearchProvider(
    BuildContext context, Function function,
    {Widget? widget,
    required VendorSearchParameterHolder? vendorSearchParameterHolder}) {
  final VendorSearchRepository repo =
      Provider.of<VendorSearchRepository>(context);
  final PsValueHolder valueHolder = Provider.of<PsValueHolder>(context);
  return psInitProvider<VendorSearchProvider>(initProvider: () {
    return VendorSearchProvider(
        repo: repo,
        psValueHolder: valueHolder,
        limit: valueHolder.defaultLoadingLimit!);
  }, onProviderReady: (VendorSearchProvider provider) {
    function(provider);
    final String? loginUserId = Utils.checkUserLoginId(valueHolder);
    provider.loadDataList(
      requestPathHolder: RequestPathHolder(
          loginUserId: loginUserId, languageCode: valueHolder.languageCode),
      requestBodyHolder: vendorSearchParameterHolder,
    );
    provider.vendorSearchParameterHolder = vendorSearchParameterHolder!;
    return provider;
  });
}
