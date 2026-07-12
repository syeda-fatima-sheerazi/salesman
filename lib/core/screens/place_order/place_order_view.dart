import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:practices/core/screens/place_order/place_order_controller.dart';
import 'package:practices/core/screens/place_order/widgets/add_product_button.dart';
import 'package:practices/core/screens/place_order/widgets/attachments_section.dart';
import 'package:practices/core/screens/place_order/widgets/order_cart_item.dart';
import 'package:practices/core/screens/place_order/widgets/order_summary_section.dart';
import 'package:practices/core/screens/place_order/widgets/shop_info_section.dart';
import 'package:practices/core/screens/place_order/widgets/status_selector.dart';
import 'package:practices/core/themes/app_theme.dart';
import 'package:practices/core/widgets/app_primary_action_button.dart';

class PlaceOrderView extends GetView<PlaceOrderController> {
  const PlaceOrderView({super.key, required this.shop});

  final dynamic shop;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Place Order'), centerTitle: true),
      body: SafeArea(
        child: Obx(() {
          if (!controller.hasProducts) {
            return _buildEmptyState(context);
          }
          return _buildProductState(context);
        }),
      ),
    );
  }

  // ─── Empty State (Step 2: Initial) ───────────────────────────
  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return ListView(
      padding: EdgeInsets.all(16.w),
      children: [
        ShopInfoSection(shop: controller.shop, orderDate: controller.orderDate),
        SizedBox(height: 32.h),

        ElevatedButton(
          onPressed: controller.goToSelectProductView,

          child: Text("Select Product"),
        ),

        SizedBox(height: 16.h),

        // OR divider
        Row(
          children: [
            const Expanded(child: Divider()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                'OR',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: cs.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Expanded(child: Divider()),
          ],
        ),
        SizedBox(height: 16.h),

        // Quick Order Button
        GestureDetector(
          onTap: controller.goToQuickOrder,
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: cs.primary),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.flash_on_outlined,
                  size: 24.sp,
                  color: AppTheme.primaryColor,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Quick Order',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Create order without adding products',
                        style: theme.textTheme.bodyMedium?.copyWith(),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: cs.onSurfaceVariant),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ─── With Products State (Step 4) ────────────────────────────
  Widget _buildProductState(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return ListView(
      padding: EdgeInsets.all(16.w),
      children: [
        ShopInfoSection(shop: controller.shop, orderDate: controller.orderDate),
        SizedBox(height: 16.h),

        // Products header
        Row(
          children: [
            Text(
              'Products (${controller.selectedItems.length})',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: controller.goToEditProducts,
              child: Text(
                'Edit',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.primaryColor,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),

        // Product list
        ...List.generate(controller.selectedItems.length, (index) {
          final item = controller.selectedItems[index];
          return OrderCartItem(
            item: item,
            onIncrement: () => controller.updateQuantity(index, 1),
            onDecrement: () => controller.updateQuantity(index, -1),
            onRemove: () => controller.removeFromCart(index),
          );
        }),
        SizedBox(height: 12.h),

        // Add Another Product
        AddProductButton(onTap: controller.goToSelectProductView),
        SizedBox(height: 16.h),

        // Order Summary
        GetBuilder<PlaceOrderController>(
          init: controller,
          builder: (ctrl) => OrderSummarySection(
            totalBill: ctrl.totalBill,
            collectedAmount: ctrl.collectedAmount,
            remainingAmount: ctrl.remainingAmount,
            onCollectedAmountChanged: ctrl.onCollectedAmountChanged,
          ),
        ),
        SizedBox(height: 16.h),

        // Payment Status
        Obx(
          () => StatusSelector(
            label: 'Payment Status',
            value: controller.paymentStatus.value,
            options: const ['Paid', 'Pending'],
            onChanged: controller.onPaymentStatusChanged,
            dateValue: controller.paymentDate.value,
            onDateChanged: controller.onPaymentDateChanged,
            showDate: controller.paymentStatus.value == 'Pending',
            dateLabel: 'Payment Date',
          ),
        ),
        SizedBox(height: 12.h),

        // Delivery Status
        Obx(
          () => StatusSelector(
            label: 'Delivery Status',
            value: controller.deliveryStatus.value,
            options: const ['Delivered', 'Scheduled'],
            onChanged: controller.onDeliveryStatusChanged,
            dateValue: controller.deliveryDate.value,
            onDateChanged: controller.onDeliveryDateChanged,
            showDate: controller.deliveryStatus.value == 'Scheduled',
            dateLabel: 'Delivery Date',
          ),
        ),
        SizedBox(height: 16.h),

        // Notes
        Text(
          'Note (Agar koi khas baat ho)',
          style: theme.textTheme.bodySmall?.copyWith(
            color: cs.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 6.h),
        TextField(
          controller: controller.notesController,
          maxLines: 3,
          maxLength: 150,
          decoration: InputDecoration(
            hintText: 'Yahan likhen...',
            counterText: '',
            filled: true,
            fillColor: cs.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: cs.outlineVariant),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: cs.outlineVariant),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: cs.primary),
            ),
            contentPadding: EdgeInsets.all(12.w),
          ),
          onChanged: (_) => controller.update(['notes_counter']),
        ),
        SizedBox(height: 4.h),
        Align(
          alignment: Alignment.centerRight,
          child: GetBuilder<PlaceOrderController>(
            init: controller,
            id: 'notes_counter',
            builder: (ctrl) => Text(
              '${ctrl.notesController.text.length} / 150',
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
          ),
        ),
        SizedBox(height: 16.h),

        // Attachments
        AttachmentsSection(
          attachments: controller.attachments,
          onAdd: controller.addAttachment,
          onRemove: controller.removeAttachment,
        ),
        SizedBox(height: 24.h),

        // Save Order Button
        Obx(
          () => AppPrimaryActionButton(
            label: 'SAVE ORDER',
            icon: Icons.save,
            onPressed: controller.canSave ? controller.saveOrder : null,
          ),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }
}
