import 'package:flutter/material.dart';
import 'package:practices/core/models/order.dart';

class HistoryOrderCard extends StatelessWidget {
  const HistoryOrderCard({super.key, required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Quantity: ${order.totalQuantity}",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text("Total Bill: ${order.totalBill}"),
              ],
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(" Date : ${order.orderDate.toString()}"),
                const SizedBox(height: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(minimumSize: Size(10, 20)),
                  onPressed: () {},
                  child: const Text("Details"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
