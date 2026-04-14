import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A lightweight, reusable dropdown used across multiple screens.
class CustomDropdown extends StatelessWidget {
  const CustomDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.hint = 'Select',
    this.underline = false,
  });

  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String hint;
  final bool underline;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(left: 5.sp),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(5.r),
        boxShadow: [
          BoxShadow(
            color: cs.surfaceContainerHigh,
            //blurRadius: 10,
            // offset: Offset(0, 10),
          ),
        ],
        border: Border.all(color: cs.outlineVariant),
      ),
      child: DropdownButton<String>(
        iconEnabledColor: cs.primary,
        underline: underline ? null : const SizedBox.shrink(),
        hint: Text(hint, style: Theme.of(context).textTheme.bodySmall),
        value: value,
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
