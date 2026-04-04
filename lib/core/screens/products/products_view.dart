import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:practices/core/screens/products/product_controller.dart';
import 'package:practices/core/widgets/add_product_button.dart';
import 'package:practices/core/widgets/product_card.dart';
import 'package:practices/core/widgets/products_search_bar.dart';

class ProductsView extends StatelessWidget {
  const ProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductController());
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProductsSearchBar(
                onChanged: controller.onSearchChanged,
              ),
              SizedBox(height: 16.h),
              Text(
                'Products List',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 12.h),
              Expanded(
                child: Obx(() {
                  final list = controller.filteredProducts;
                  return ListView.builder(
                    itemCount: list.length,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      final product = list[index];
                      final variants = product.variants
                          .map(
                            (v) => {
                              'weight': v.weight,
                              'price': v.price,
                            },
                          )
                          .toList();
                      return ProductCard(
                        productName: product.name,
                        productImage: product.imageUrl,
                        variants: variants,
                        onAddVariant: () =>
                            controller.addVariant(product.id),
                        onEditVariant: (variantIndex) => controller
                            .editVariant(product.id, variantIndex),
                        onDeleteVariant: (variantIndex) => controller
                            .deleteVariant(product.id, variantIndex),
                      );
                    },
                  );
                }),
              ),
              SizedBox(height: 12.h),
              AddProductButton(
                onTap: controller.addProduct,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
