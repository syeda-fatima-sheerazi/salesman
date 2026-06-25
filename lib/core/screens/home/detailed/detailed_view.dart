import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:practices/core/models/order.dart';
import 'package:practices/core/models/shop.dart';
import 'package:practices/core/screens/home/detailed/detailed_view_controller.dart';
import 'package:practices/core/screens/home/widgets/history_order_card.dart';

class DetailedView extends GetView<DetailedViewController> {
  const DetailedView({super.key, required this.shop});
  final Shop shop;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detailed View")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 26.0),
        child: Column(
          spacing: 20,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 10,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(shop.shopImagUrl),
                ),
                SizedBox(width: 26.w),
                Column(
                  spacing: 5,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(shop.shopName),
                    SizedBox(height: 4),
                    Text(shop.shopOwner),
                    SizedBox(height: 4),
                    Text(shop.cellPhone),
                  ],
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to edit shop screen
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Icon(Icons.location_on), Text("Location")],
              ),
            ),
            Text(
              "THis is the detailed view of the shop. You can add more information here like recent orders, collections, etc. ${shop.description}",
            ),
            Divider(),
            Text(
              "Orders History",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 8),
            Expanded(
              child: ListView.separated(
                itemCount: shop.orders.length,
                itemBuilder: (context, index) {
                  Order order = shop.orders[index];
                  return HistoryOrderCard(order: order);
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(height: 20);
                },
              ),
            ),

            // ListView.builder(
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.gotoPlaceOrderView(shop),
        child: Icon(Icons.add),
      ),
    );
  }
}
