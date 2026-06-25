import 'package:flutter/material.dart';

class EditProfileWidget extends StatelessWidget {
  const EditProfileWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 200,
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          CircleAvatar(
            maxRadius: 18,
            child: Icon(Icons.check, color: Colors.white),
          ),
          SizedBox(width: 10),
          Text(
            "Sales Maneger",
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
