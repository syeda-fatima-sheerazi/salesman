import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:practices/core/screens/todo/todo_controller.dart';
import 'package:practices/core/screens/todo/widgets/todo_card.dart';
import 'package:practices/core/screens/todo/widgets/tab_data_builder.dart';

class TodoView extends GetView<TodoController> {
  const TodoView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Obx(() {
            final tab = controller.mainTabIndex.value;

            if (tab == 1) {
              final collections = controller.collections.toList();
              return TabDataBuilder(
                theme: theme,
                cs: cs,
                selectedIndex: tab,
                onTap: controller.onChangeTabIndex,
                title: 'Collections',
                itemCount: collections.length,
                emptyMessage: 'No pending collections',
                itemBuilder: (context, index) {
                  final item = collections[index];

                  return ToDoCard(
                    shopName: item.shopName,
                    image: item.displayShopPhotoAsset,
                    subtitle: 'Rs ',
                    subtitleValue: item.remainingAmount.toString(),
                    isCompleted: item.isCollected,
                    inCompletedText: 'Collect',
                    completedText: 'Collected',
                    onTap: item.isCollected
                        ? null
                        : () => controller.updateCollectionState(item),
                    onTrailingTap: () => controller.onEditCollection(item),
                    trailingLabel: 'Edit',
                    trailingTooltip: 'Edit collection',
                    theme: theme,
                    cs: cs,
                  );
                },
              );
            }

            final ordersList = controller.orders.toList();
            return TabDataBuilder(
              theme: theme,
              cs: cs,
              selectedIndex: tab,
              onTap: controller.onChangeTabIndex,
              title: 'Orders',
              itemCount: ordersList.length,
              emptyMessage: 'No pending orders',
              itemBuilder: (context, index) {
                final item = ordersList[index];
                return ToDoCard(
                  shopName: item.shopName,
                  image: item.displayShopPhotoAsset,
                  subtitle: 'Quantity: ',
                  subtitleValue: '${item.totalQuantity}',
                  isCompleted: item.isDelivered,
                  inCompletedText: 'Deliver',
                  completedText: 'Delivered',
                  onTap: item.isDelivered
                      ? null
                      : () => controller.updateOrderState(item),
                  onTrailingTap: () => controller.onEditOrder(item),
                  trailingLabel: 'Edit',
                  trailingTooltip: 'Edit order',
                  theme: theme,
                  cs: cs,
                );
              },
            );
          }),
        ),
      ),
    );
  }
}
