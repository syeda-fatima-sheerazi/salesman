import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DrawerItem extends StatelessWidget {
  const DrawerItem({
    super.key,
    required this.icon,
    required this.title,
    this.iconColor,
    this.textColor,
    this.onTap,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final Color? iconColor;
  final Color? textColor;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
      leading: Icon(
        icon,
        color: iconColor ?? cs.primary,
        size: 24.sp,
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontSize: 15.sp,
          fontWeight: FontWeight.w600,
          color: textColor ?? cs.onSurface,
        ),
      ),
      trailing: trailing,
      minLeadingWidth: 24.w,
      horizontalTitleGap: 16.w,
      visualDensity: VisualDensity.compact,
    );
  }
}
