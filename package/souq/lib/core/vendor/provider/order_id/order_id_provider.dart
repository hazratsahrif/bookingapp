import 'package:psxmpc/core/vendor/api/common/ps_resource.dart';
import 'package:psxmpc/core/vendor/constant/ps_constants.dart';
import 'package:psxmpc/core/vendor/provider/common/ps_provider.dart';
import 'package:psxmpc/core/vendor/repository/order_id_repository.dart';
import 'package:psxmpc/core/vendor/viewobject/order_id.dart';

class OrderIdProvider extends PsProvider<OrderId> {
  OrderIdProvider({
    OrderIdRepository? repo,
    int limit = 0,
  }) : super(repo, limit, subscriptionType: PsConst.SINGLE_OBJECT_SUBSCRIPTION);

  PsResource<OrderId> get orderId => super.data;

  int _selectedValue = 0;
  bool _isSameAsShippingAddress = false;
  int get selectedValue => _selectedValue;
  // ignore: always_specify_types
  set selectedValue(val) => _selectedValue = val;
  bool get isSameAsShippingAddress => _isSameAsShippingAddress;
  // ignore: always_specify_types
  set isSameAsShippingAddress(val) => _isSameAsShippingAddress = val;

  void updateSelectedValue(int value) {
    selectedValue = value;
    notifyListeners();
  }

  bool checkisSameAsShippingAddress(bool value) {
    isSameAsShippingAddress = value;
    notifyListeners();
    return isSameAsShippingAddress;
  }
}
