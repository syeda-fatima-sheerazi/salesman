import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:practices/core/models/shop.dart';
import 'package:practices/core/routes/route_names.dart';
import 'package:practices/core/widgets/app_primary_action_button.dart';

class OrderSuccessView extends StatelessWidget {
  const OrderSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final args = Get.arguments as Map<String, dynamic>;
    final orderId = args['orderId'] as String?;
    final shop = args['shop'] as Shop?;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Success icon
                Container(
                  width: 80.w,
                  height: 80.w,
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle_outline,
                    size: 48.sp,
                    color: Colors.green,
                  ),
                ),
                SizedBox(height: 24.h),

                // Title
                Text(
                  'Order Saved Successfully!',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.h),

                // Order ID
                if (orderId != null)
                  Text(
                    'Order ID: $orderId',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                SizedBox(height: 32.h),

                // Back to Shop button
                AppPrimaryActionButton(
                  label: 'Back to Shop',
                  icon: Icons.arrow_back,
                  onPressed: () {
                    // Go back to shop detail, popping all place order screens
                    Get.offAllNamed(Routes.detailed, arguments: shop);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
