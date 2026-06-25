import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Orders vs Collections pill toggle.
class ToDoTabs extends StatelessWidget {
  const ToDoTabs({
    super.key,
    required this.selectedIndex,
    required this.onSelect,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        children: [
          Expanded(
            child: _Tab(
              label: 'Orders',
              icon: Icons.shopping_bag_outlined,
              selected: selectedIndex == 0,
              onTap: () => onSelect(0),
            ),
          ),
          SizedBox(width: 6.w),
          Expanded(
            child: _Tab(
              label: 'Collections',
              icon: Icons.payments_outlined,
              selected: selectedIndex == 1,
              onTap: () => onSelect(1),
            ),
          ),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Material(
      color: selected ? cs.primary : Colors.transparent,
      borderRadius: BorderRadius.circular(8.r),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18.sp,
                color: selected ? cs.onPrimary : cs.primary,
              ),
              SizedBox(width: 6.w),
              Text(
                label,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontSize: 13.sp,
                  color: selected ? cs.onPrimary : cs.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
