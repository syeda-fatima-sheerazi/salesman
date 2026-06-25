import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:practices/core/models/shop.dart';
import 'package:practices/core/screens/place_order/place_order_controller.dart';
import 'package:practices/core/widgets/custom_input_field.dart';

class PlaceOrderView extends GetView<PlaceOrderController> {
  const PlaceOrderView({super.key, required this.shop});
  final Shop shop;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Text("Shop Name: ${shop.shopName}"),
          Text("Order Date : ${DateTime.now().toString()}"),
          Text("Add Products"),
          CustomInputField(
            controller: controller.productNameController,
            hintText: "Enter Product Name",
            prefixIcon: Icons.search,
          ),
        ],
      ),
    );
  }
}
