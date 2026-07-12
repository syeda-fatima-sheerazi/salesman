import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:practices/core/screens/place_order/place_order_controller.dart';
import 'package:practices/core/themes/app_theme.dart';
import 'package:practices/core/widgets/app_primary_action_button.dart';

class QuickOrderView extends GetView<PlaceOrderController> {
  const QuickOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quick Order'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          // Total Bill
          _buildFieldRow(
            context,
            label: 'Total Bill',
            controller: controller.quickOrderTotalController,
            prefix: 'PKR',
            onChanged: (v) {
              controller.setQuickOrderTotal(int.tryParse(v) ?? 0);
            },
          ),
          SizedBox(height: 16.h),

          // Collected Amount
          _buildFieldRow(
            context,
            label: 'Collected Amount',
            controller: controller.collectedAmountController,
            prefix: 'PKR',
            onChanged: controller.onCollectedAmountChanged,
          ),
          SizedBox(height: 16.h),

          // Remaining Amount (auto-calculated)
          _buildStaticRow(
            context,
            label: 'Remaining Amount',
            value: 'PKR ${controller.remainingAmount}',
            valueColor: controller.remainingAmount > 0
                ? AppTheme.error
                : Colors.green,
          ),
          SizedBox(height: 32.h),

          // Continue button
          AppPrimaryActionButton(
            label: 'Continue',
            icon: Icons.arrow_forward,
            onPressed: controller.totalBill > 0
                ? () {
                    controller.enterQuickOrderMode(controller.totalBill);
                    Get.back();
                  }
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildFieldRow(
    BuildContext context, {
    required String label,
    required TextEditingController controller,
    required String prefix,
    required ValueChanged<String> onChanged,
  }) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 6.h),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: onChanged,
          decoration: InputDecoration(
            prefixText: '$prefix ',
            prefixStyle: TextStyle(
              fontSize: 14.sp,
              color: cs.onSurface,
              fontWeight: FontWeight.w500,
            ),
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
            contentPadding:
                EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
          ),
        ),
      ],
    );
  }

  Widget _buildStaticRow(
    BuildContext context, {
    required String label,
    required String value,
    required Color valueColor,
  }) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 6.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: cs.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: cs.outlineVariant),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              color: valueColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
