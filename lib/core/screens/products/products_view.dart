import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductsView extends StatelessWidget {
  const ProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(vertical: 15.h, horizontal: 10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            SearchBar(
              leading: Icon(Icons.search),
              hintText: "Search Products..",
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),
            SizedBox(height: 2),
            Text(
              "Products List",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
            ),
            Container(
              width: double.infinity,
              height: 150.h,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 228, 225, 225),
                borderRadius: BorderRadius.circular(5.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 30.h,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,

                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5.r),
                        topRight: Radius.circular(5.r),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 50, top: 5),
                      child: Text(
                        "Different KatchUp",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  Row(
                    children: [
                      PriceCard(
                        width: 230.w,
                        firstWidget: Text("1kg"),
                        lastWidget: Text("RS 100"),
                      ),
                      PriceCard(
                        width: 100.w,
                        firstWidget: Icon(Icons.edit),
                        lastWidget: Icon(Icons.delete),
                      ),
                    ],
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

class PriceCard extends StatelessWidget {
  const PriceCard({
    super.key,
    required this.width,
    required this.firstWidget,
    required this.lastWidget,
  });
  final double width;
  final Widget firstWidget;
  final Widget lastWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: EdgeInsets.all(5.w),
      height: 30.h,
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      child: Row(children: [firstWidget, lastWidget]),
    );
  }
}
