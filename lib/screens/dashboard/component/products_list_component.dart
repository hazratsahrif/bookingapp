import 'package:booking_system_flutter/component/view_all_label_component.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/model/service_data_model.dart';
import 'package:booking_system_flutter/product_module/models/product_data.dart';
import 'package:booking_system_flutter/product_module/screens/view_all_products_screen.dart';
import 'package:booking_system_flutter/screens/service/component/product_component.dart';
import 'package:booking_system_flutter/screens/service/component/service_component.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../component/empty_error_state_widget.dart';
import '../../../product_module/models/product_category.dart';
import '../../service/view_all_service_screen.dart';

class ProductsListComponent extends StatelessWidget {
  final List<ProductData> productsList;
  final int? categoryId;
  final String? categoryName;

  ProductsListComponent(
      {required this.productsList,
      required this.categoryId,
      this.categoryName});

  @override
  Widget build(BuildContext context) {
    if (productsList.isEmpty) return Offstage();

    return Container(
      // padding: EdgeInsets.only(bottom: 16),
      width: context.width(),
      decoration: BoxDecoration(
        color: appStore.isDarkMode
            ? context.cardColor
            : context.primaryColor.withOpacity(0.1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (categoryId != null)
            ViewAllLabel(
              label: categoryName ?? '',
              list: productsList,
              onTap: () {
                ViewAllProductsScreen(
                  isFeatured: categoryId == null ? true : null,
                  category: productsList.isNotEmpty
                      ? productsList.first.productCategory
                      : null,
                ).launch(context);
              },
            ).paddingSymmetric(horizontal: 16),
          if (productsList.isNotEmpty)
            HorizontalList(
              itemCount: productsList.length,
              spacing: 16,
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              itemBuilder: (context, index) => ProductComponent(
                productData: productsList[index],
                width: 164,
              ),
            )
          else
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 32),
              child: NoDataWidget(
                title: language.lblNoServicesFound,
                imageWidget: EmptyStateWidget(),
              ),
            ).center(),
        ],
      ),
    );
  }
}
