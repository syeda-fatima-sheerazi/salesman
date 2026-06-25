import 'package:flutter/material.dart';

class ManageWidget extends StatelessWidget {
  const ManageWidget({
    super.key,
    required this.icon,
    required this.text,
    this.button,
  });
  final Icon icon;
  final String text;
  final TextButton? button;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              icon,
              SizedBox(width: 10),
              Text(
                text,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.white),
              ),
            ],
          ),

          Icon(Icons.arrow_right_sharp, color: Colors.white),
        ],
      ),
    );
  }
}
