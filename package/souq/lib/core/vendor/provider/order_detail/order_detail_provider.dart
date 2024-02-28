import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:psxmpc/core/vendor/api/common/ps_resource.dart';
import 'package:psxmpc/core/vendor/constant/ps_constants.dart';
import 'package:psxmpc/core/vendor/provider/common/ps_init_provider.dart';
import 'package:psxmpc/core/vendor/provider/common/ps_provider.dart';
import 'package:psxmpc/core/vendor/repository/order_detail_repository.dart';
import 'package:psxmpc/core/vendor/utils/utils.dart';
import 'package:psxmpc/core/vendor/viewobject/common/ps_value_holder.dart';
import 'package:psxmpc/core/vendor/viewobject/holder/request_path_holder.dart';
import 'package:psxmpc/core/vendor/viewobject/order_summary.dart';

class OrderDetailProvider extends PsProvider<OrderSummaryModel> {
  OrderDetailProvider({
    required OrderDetailRepository repo,
    int limit = 0,
  }) : super(repo, limit,
            subscriptionType: PsConst.SINGLE_OBJECT_SUBSCRIPTION) {
    repo = repo;
  }

  PsResource<OrderSummaryModel> get orderSummaryModel => super.data;
}

SingleChildWidget initOrderDetailProvider(
  BuildContext context,
  Function function, {
  Widget? widget,
  // String? orderId,
}) {
  final OrderDetailRepository repo =
      Provider.of<OrderDetailRepository>(context);
  final PsValueHolder valueHolder = Provider.of<PsValueHolder>(context);

  return psInitProvider<OrderDetailProvider>(
      initProvider: () => OrderDetailProvider(
            repo: repo,
          ),
      onProviderReady: (OrderDetailProvider provider) {
        final String? loginUserId = Utils.checkUserLoginId(valueHolder);
        provider.loadData(
          requestPathHolder: RequestPathHolder(
              loginUserId: loginUserId,
              languageCode: valueHolder.languageCode,
              orderId: valueHolder.orderId),
        );
        function(provider);
      });
}
