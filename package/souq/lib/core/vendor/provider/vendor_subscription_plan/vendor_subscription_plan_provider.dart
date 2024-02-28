import 'package:psxmpc/core/vendor/api/common/ps_resource.dart';
import 'package:psxmpc/core/vendor/constant/ps_constants.dart';
import 'package:psxmpc/core/vendor/provider/common/ps_provider.dart';
import 'package:psxmpc/core/vendor/repository/vendor_subscription_plan_repository.dart';
// import 'package:psxmpc/ui/vendor_ui/vendor_subscription/view/vendor_subscription_view.dart';

import '../../viewobject/vendor_subscription_plan.dart';

class VendorSubscriptionPlanProvider extends PsProvider<VendorSubscriptionPlan> {
  VendorSubscriptionPlanProvider({
   required VendorSubscriptionPlanRepository? repo, 
    int limit = 0, 
   }) : super(repo, limit, subscriptionType: PsConst.LIST_OBJECT_SUBSCRIPTION);

   PsResource<List<VendorSubscriptionPlan>> get subscriptionList => super.dataList;
   

}
// SingleChildWidget initVendorSubScriptionPlanProvider(
//   BuildContext context,
//   Function function, {
//   Widget? widget,
// }) {
//   final PsValueHolder valueHolder = Provider.of<PsValueHolder>(context);
//   final VendorSubscriptionPlanRepository repo = Provider.of<VendorSubscriptionPlanRepository>(context);
//   // final AppLocalization langProvider = Provider.of<AppLocalization>(context);
//   return psInitProvider<VendorSubscriptionPlanProvider>(
//       widget: widget,
//       initProvider: () {
//         return VendorSubscriptionPlanProvider(
//             repo: repo, limit: valueHolder.defaultLoadingLimit!);
//       },
//       onProviderReady: (VendorSubscriptionPlanProvider provider) {
//         provider.loadDataList(
//             requestPathHolder: RequestPathHolder(
//                 loginUserId: Utils.checkUserLoginId(valueHolder),
//                 languageCode: valueHolder.languageCode
//                 ),
//          );
         
//         function(provider);
//       });
// }