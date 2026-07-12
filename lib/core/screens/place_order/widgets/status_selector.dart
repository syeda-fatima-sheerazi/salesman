import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';


class StatusSelector extends StatelessWidget {
  const StatusSelector({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
    this.dateValue,
    this.onDateChanged,
    this.showDate = false,
    this.dateLabel,
  });

  final String label;
  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;
  final DateTime? dateValue;
  final ValueChanged<DateTime>? onDateChanged;
  final bool showDate;
  final String? dateLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Status dropdown
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      decoration: BoxDecoration(
                        color: cs.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(6.r),
                        border: Border.all(color: cs.outlineVariant),
                      ),
                      child: DropdownButton<String>(
                        value: value,
                        isExpanded: true,
                        underline: const SizedBox.shrink(),
                        style: theme.textTheme.bodyMedium,
                        items: options
                            .map((o) => DropdownMenuItem(
                                  value: o,
                                  child: Text(o),
                                ))
                            .toList(),
                        onChanged: (v) {
                          if (v != null) onChanged(v);
                        },
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: 12.w),

              // Date picker (conditional)
              Expanded(
                child: showDate
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dateLabel ?? '${label.split(' ').first} Date',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          GestureDetector(
                            onTap: () => _pickDate(context),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12.w, vertical: 12.h),
                              decoration: BoxDecoration(
                                color: cs.surfaceContainerHigh,
                                borderRadius: BorderRadius.circular(6.r),
                                border: Border.all(color: cs.outlineVariant),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today_outlined,
                                    size: 16.sp,
                                    color: cs.onSurfaceVariant,
                                  ),
                                  SizedBox(width: 8.w),
                                  Expanded(
                                    child: Text(
                                      dateValue != null
                                          ? DateFormat('d MMMM yyyy')
                                              .format(dateValue!)
                                          : 'Select Date',
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        color: dateValue != null
                                            ? null
                                            : cs.onSurfaceVariant,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dateLabel ?? '${label.split(' ').first} Date',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.w, vertical: 12.h),
                            decoration: BoxDecoration(
                              color: cs.surfaceContainerHigh,
                              borderRadius: BorderRadius.circular(6.r),
                              border: Border.all(color: cs.outlineVariant),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check_circle_outline,
                                  size: 16.sp,
                                  color: Colors.green,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  'Today',
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: dateValue ?? now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null && onDateChanged != null) {
      onDateChanged!(picked);
    }
  }
}
