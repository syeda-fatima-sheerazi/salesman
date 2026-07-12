import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:practices/core/themes/app_theme.dart';

class OrderSummarySection extends StatelessWidget {
  const OrderSummarySection({
    super.key,
    required this.totalBill,
    required this.collectedAmount,
    required this.remainingAmount,
    required this.onCollectedAmountChanged,
  });

  final int totalBill;
  final int collectedAmount;
  final int remainingAmount;
  final ValueChanged<String> onCollectedAmountChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        children: [
          // Total Bill
          Expanded(
            child: _SummaryColumn(
              icon: Icons.receipt_long_outlined,
              label: 'Total Bill',
              value: 'Rs $totalBill',
              valueColor: AppTheme.primaryColor,
              theme: theme,
            ),
          ),

          // Divider
          Container(
            width: 1,
            height: 50.h,
            color: cs.outlineVariant,
          ),

          // Collected Amount (editable)
          Expanded(
            child: _EditableColumn(
              icon: Icons.money_outlined,
              label: 'Collected Amount',
              value: collectedAmount.toString(),
              onChanged: onCollectedAmountChanged,
              theme: theme,
            ),
          ),

          // Divider
          Container(
            width: 1,
            height: 50.h,
            color: cs.outlineVariant,
          ),

          // Remaining Amount
          Expanded(
            child: _SummaryColumn(
              icon: Icons.account_balance_wallet_outlined,
              label: 'Remaining Amount',
              value: 'Rs $remainingAmount',
              valueColor: remainingAmount > 0 ? AppTheme.error : Colors.green,
              theme: theme,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryColumn extends StatelessWidget {
  const _SummaryColumn({
    required this.icon,
    required this.label,
    required this.value,
    required this.valueColor,
    required this.theme,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color valueColor;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 20.sp, color: theme.colorScheme.onSurfaceVariant),
        SizedBox(height: 6.h),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}

class _EditableColumn extends StatelessWidget {
  const _EditableColumn({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.theme,
  });

  final IconData icon;
  final String label;
  final String value;
  final ValueChanged<String> onChanged;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final cs = theme.colorScheme;

    return Column(
      children: [
        Icon(icon, size: 20.sp, color: cs.onSurfaceVariant),
        SizedBox(height: 6.h),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: cs.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 4.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: cs.primaryContainer.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: Text(
            'Rs $value',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppTheme.primaryColor,
            ),
          ),
        ),
        SizedBox(height: 4.h),
        SizedBox(
          width: 80.w,
          child: TextField(
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12.sp),
            decoration: InputDecoration(
              isDense: true,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
              hintText: 'Enter',
              hintStyle: TextStyle(
                fontSize: 11.sp,
                color: cs.onSurfaceVariant,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.r),
                borderSide: BorderSide(color: cs.outlineVariant),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.r),
                borderSide: BorderSide(color: cs.outlineVariant),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.r),
                borderSide: BorderSide(color: cs.primary),
              ),
            ),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
