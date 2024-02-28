import 'package:booking_system_flutter/component/base_scaffold_widget.dart';
import 'package:booking_system_flutter/component/loader_widget.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/model/notification_model.dart';
import 'package:booking_system_flutter/network/rest_apis.dart';
import 'package:booking_system_flutter/screens/booking/booking_detail_screen.dart';
import 'package:booking_system_flutter/screens/notification/components/notification_widget.dart';
import 'package:booking_system_flutter/utils/constant.dart';
import 'package:booking_system_flutter/utils/model_keys.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../component/empty_error_state_widget.dart';
import '../../orders_module/screens/order_details_screen.dart';
import '../../orders_module/service/order_service.dart';
import '../../product_module/screens/my_product_screens.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  Future<List<NotificationData>>? future;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init({Map? req}) async {
    future = getNotification(request: req);
  }

  Future<void> readNotification({String? id}) async {
    Map<String, dynamic> request = {CommonKeys.bookingId: id};

    getBookingDetail(request).then((value) {}).catchError(onError);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: language.lblNotification,
      actions: [
        IconButton(
          icon: Icon(Icons.clear_all_rounded, color: Colors.white),
          onPressed: () async {
            appStore.setLoading(true);

            init(req: {NotificationKey.type: MARK_AS_READ});

            setState(() {});
          },
        ),
      ],
      child: SnapHelperWidget<List<NotificationData>>(
        future: future,
        initialData: cachedNotificationList,
        loadingWidget: LoaderWidget(),
        errorBuilder: (error) {
          return NoDataWidget(
            title: error,
            imageWidget: ErrorStateWidget(),
            retryText: language.reload,
            onRetry: () {
              appStore.setLoading(true);

              init();
              setState(() {});
            },
          );
        },
        onSuccess: (list) {
          return AnimatedListView(
            shrinkWrap: true,
            itemCount: list.length,
            slideConfiguration: sliderConfigurationGlobal,
            listAnimationType: ListAnimationType.FadeIn,
            fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
            emptyWidget: NoDataWidget(
              title: language.noNotifications,
              subTitle: language.noNotificationsSubTitle,
              imageWidget: EmptyStateWidget(),
            ),
            itemBuilder: (context, index) {
              NotificationData data = list[index];
              print(data.toJson());

              return GestureDetector(
                onTap: () async {
                  if (data.data!.notificationType.validate() ==
                      NOTIFICATION_TYPE_BOOKING) {
                    readNotification(id: data.data!.id.toString());
                    await BookingDetailScreen(
                            bookingId: data.data!.id.validate())
                        .launch(context);

                    init();
                    setState(() {});
                  } else if (data.data!.notificationType.validate() ==
                      NOTIFICATION_TYPE_POST_JOB) {
                    //
                  } else if (data.data!.notificationType.validate() ==
                      NOTIFICATION_TYPE_ORDER) {
                    final id = data.data?.id;
                    if (id != null) {
                      final order = await OrderService.getOrderDetails(id);
                      if (order != null)
                        OrderDetailsScreen(
                          orderModel: order,
                          isMyOrders: order?.user?.email == appStore.userEmail,
                        ).launch(context);
                    }
                    return;
                  } else if (data.data!.notificationType.validate() ==
                      NOTIFICATION_TYPE_BID) {
                    final id = data.data?.id;
                    if (id != null) {
                      MyProductListScreen().launch(context);
                    }
                    return;
                  } else {
                    //
                  }
                },
                child: NotificationWidget(data: data),
              );
            },
          );
        },
      ),
    );
  }
}
