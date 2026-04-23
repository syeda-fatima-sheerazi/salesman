import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:practices/core/themes/app_theme.dart';
import 'package:practices/core/widgets/app_primary_action_button.dart';

class ShopLocationSection extends StatelessWidget {
  final double latitude;
  final double longitude;
  final bool isGettingLocation;
  final VoidCallback onGetLocation;

  const ShopLocationSection({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.isGettingLocation,
    required this.onGetLocation,
  });

  bool get hasLocation => latitude != 0.0 && longitude != 0.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.my_location_outlined,
                size: 18.w,
                color: AppTheme.primaryColor,
              ),
              SizedBox(width: 8.w),
              Text(
                'Current Location *',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (hasLocation) ...[
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: AppTheme.primaryColor,
                        size: 20.w,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          'Lat: ${latitude.toStringAsFixed(4)}\nLng: ${longitude.toStringAsFixed(4)}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 12.h),
              ],

              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: isGettingLocation
                    ? Container(
                        height: 48.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: SizedBox(
                          width: 24.w,
                          height: 24.w,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : AppPrimaryActionButton(
                        label: hasLocation
                            ? 'Update Location'
                            : 'Get Current Location',
                        icon: Icons.location_searching,
                        onPressed: onGetLocation,
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
