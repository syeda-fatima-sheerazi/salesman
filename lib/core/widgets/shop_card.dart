import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:practices/core/models/shop.dart';

class ShopCard extends StatelessWidget {
  const ShopCard({super.key, this.onTap, required this.shop});

  final void Function()? onTap;
  final Shop shop;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: const Color.fromARGB(255, 232, 228, 228),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: [
                Container(
                  height: 50.h,
                  width: 50.w,
                  decoration: BoxDecoration(),
                  child: Image.network(
                    "https://img.freepik.com/premium-vector/shops-stores-icons-set-flat-design-style-vector-illustration_498048-1862.jpg?semt=ais_hybrid&w=740&q=80",
                  ),
                ),
                SizedBox(width: 10.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shop.shopName,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    Text(
                      "Owner : ${shop.shopOwner}",
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    Text(
                      "Cell : ${shop.cellPhone}",
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    Text(
                      shop.address,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(8.h),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                    ),
                    child: Text("Visited"),
                  ),

                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.location_on, color: Colors.red),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
