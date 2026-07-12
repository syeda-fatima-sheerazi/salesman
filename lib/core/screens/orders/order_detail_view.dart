import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:practices/core/screens/orders/order_detail_controller.dart';
import 'package:practices/core/themes/app_theme.dart';

class OrderDetailView extends GetView<OrderDetailController> {
  const OrderDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Order Details')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final order = controller.order.value;
        if (order == null) {
          return const Center(child: Text('Order not found'));
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildShopInfo(theme, order),
              SizedBox(height: 16.h),
              _buildOrderInfo(theme, order),
              SizedBox(height: 16.h),
              _buildProductList(theme, order),
              SizedBox(height: 16.h),
              _buildSummary(theme, order),
              SizedBox(height: 16.h),
              _buildStatusCards(theme, order),
              if (order.notes != null && order.notes!.isNotEmpty) ...[
                SizedBox(height: 16.h),
                _buildNotesSection(theme, order),
              ],
              if (controller.attachments.isNotEmpty) ...[
                SizedBox(height: 16.h),
                _buildAttachmentsSection(theme),
              ],
              SizedBox(height: 24.h),
              _buildActionButtons(context, order),
              SizedBox(height: 32.h),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildShopInfo(ThemeData theme, dynamic order) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24.r,
              backgroundImage: AssetImage(order.displayShopPhotoAsset),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(order.shopName,
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  Text(order.ownerName,
                      style: theme.textTheme.bodySmall),
                  Text(order.cell,
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: AppTheme.textSecondary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderInfo(ThemeData theme, dynamic order) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order Information',
                style: theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold)),
            SizedBox(height: 8.h),
            if (order.orderNo != null)
              _infoRow('Order No', order.orderNo!, theme),
            _infoRow(
                'Order Date', _formatDate(order.orderDate ?? DateTime.now()), theme),
          ],
        ),
      ),
    );
  }

  Widget _buildProductList(ThemeData theme, dynamic order) {
    if (order.items.isEmpty) {
      return Card(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Text('No products in this order (Quick Order)',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: AppTheme.textSecondary)),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Products',
                style: theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold)),
            SizedBox(height: 8.h),
            ...order.items.map<Widget>((item) => Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.productName,
                                style: theme.textTheme.bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.w600)),
                            if (item.variant != null)
                              Text(item.variant!,
                                  style: theme.textTheme.bodySmall
                                      ?.copyWith(
                                          color: AppTheme.textSecondary)),
                          ],
                        ),
                      ),
                      Text('${item.qty} × Rs ${item.price.toStringAsFixed(0)}',
                          style: theme.textTheme.bodyMedium),
                      SizedBox(width: 12.w),
                      Text(
                          'Rs ${(item.price * item.qty).toStringAsFixed(0)}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor)),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildSummary(ThemeData theme, dynamic order) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            _summaryRow('Total Bill', 'Rs ${order.totalBill}', theme),
            SizedBox(height: 8.h),
            _summaryRow('Collected Amount', 'Rs ${order.collectedAmount}', theme),
            SizedBox(height: 8.h),
            _summaryRow('Remaining Amount', 'Rs ${order.remainingAmount}', theme,
                highlight: true),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCards(ThemeData theme, dynamic order) {
    return Column(
      children: [
        Card(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Icon(Icons.payment,
                    color: order.isCollected ? Colors.green : Colors.orange),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(order.isCollected ? 'Paid' : 'Payment Due',
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      if (order.paymentDate != null)
                        Text(
                            'Date: ${_formatDate(order.paymentDate!)}',
                            style: theme.textTheme.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Card(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Icon(Icons.local_shipping,
                    color: order.isDelivered ? Colors.green : Colors.orange),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(order.isDelivered ? 'Delivered' : 'Scheduled Delivery',
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      if (order.deliveryDate != null)
                        Text(
                            'Date: ${_formatDate(order.deliveryDate!)}',
                            style: theme.textTheme.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotesSection(ThemeData theme, dynamic order) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Notes',
                style: theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold)),
            SizedBox(height: 8.h),
            Text(order.notes!, style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentsSection(ThemeData theme) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Attachments',
                style: theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold)),
            SizedBox(height: 8.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: controller.attachments.map((att) {
                return GestureDetector(
                  onTap: () => _viewFullImage(att.filePath),
                  child: Container(
                    width: 80.w,
                    height: 80.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      image: DecorationImage(
                        image: FileImage(File(att.filePath)),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, dynamic order) {
    return Column(
      children: [
        if (!order.isDelivered)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: controller.markDelivered,
              icon: const Icon(Icons.check_circle),
              label: const Text('Mark Delivered'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 14.h),
              ),
            ),
          ),
        if (!order.isDelivered && !order.isCollected)
          SizedBox(height: 8.h),
        if (!order.isCollected)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: controller.markPaid,
              icon: const Icon(Icons.payment),
              label: const Text('Mark Paid'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 14.h),
              ),
            ),
          ),
        SizedBox(height: 16.h),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => _confirmDelete(context),
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            label: const Text('Delete Order',
                style: TextStyle(color: Colors.red)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.red),
              padding: EdgeInsets.symmetric(vertical: 14.h),
            ),
          ),
        ),
      ],
    );
  }

  void _viewFullImage(String path) {
    Get.dialog(
      Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Center(
          child: InteractiveViewer(
            child: Image.file(File(path)),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Delete Order'),
        content: const Text('Are you sure you want to delete this order?'),
        actions: [
          TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Get.back(result: true),
              child: const Text('Delete', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirmed == true) {
      controller.deleteOrder();
    }
  }

  Widget _infoRow(String label, String value, ThemeData theme) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Row(
        children: [
          Text('$label: ',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: AppTheme.textSecondary)),
          Text(value, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, ThemeData theme,
      {bool highlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: theme.textTheme.bodyMedium),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: highlight ? AppTheme.primaryColor : null,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
