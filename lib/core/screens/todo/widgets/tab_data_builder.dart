import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:practices/core/screens/todo/widgets/todo_tabs.dart';

/// Shared shell for Todo **Orders** and **Collections**: segment tabs + title +
/// scrollable list (or empty state). Props/callbacks only — no controller,
/// no [Obx], no Rx types.
class TabDataBuilder extends StatelessWidget {
  const TabDataBuilder({
    super.key,
    required this.theme,
    required this.cs,
    required this.selectedIndex,
    required this.onTap,
    required this.title,
    required this.itemCount,
    required this.itemBuilder,
    required this.emptyMessage,
    this.listSeparatorHeight,
  });

  final ThemeData theme;
  final ColorScheme cs;
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final String title;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final String emptyMessage;
  final double? listSeparatorHeight;

  @override
  Widget build(BuildContext context) {
    final gap = listSeparatorHeight ?? 10.h;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ToDoTabs(selectedIndex: selectedIndex, onSelect: onTap),
        SizedBox(height: 14.h),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 10.h),
        Expanded(
          child: itemCount == 0
              ? Center(
                  child: Text(
                    emptyMessage,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                )
              : ListView.separated(
                  itemCount: itemCount,
                  separatorBuilder: (_, _) => SizedBox(height: gap),
                  itemBuilder: itemBuilder,
                ),
        ),
      ],
    );
  }
}
