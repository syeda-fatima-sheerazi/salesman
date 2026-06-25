import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:practices/core/screens/products/product_controller.dart';
import 'package:practices/core/widgets/app_primary_action_button.dart';
import 'package:practices/core/widgets/product_card.dart';
import 'package:practices/core/widgets/products_search_bar.dart';

class ProductsView extends GetView<ProductController> {
  const ProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProductsSearchBar(
                controller: controller.searchFieldController,
                onChanged: controller.onSearchChanged,
                onClear: controller.clearSearch,
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
                  if (list.isEmpty) {
                    final hasQuery = controller.searchQuery.value
                        .toLowerCase()
                        .trim() // remove extra spaces from the start and end of the search value
                        .isNotEmpty; // check if the search value is not empty
                    final emptyCatalog = controller.products.isEmpty;
                    final message =
                        emptyCatalog &&
                            !hasQuery // if the catalog is empty and the search value is empty, show the message 'No products yet.'
                        ? 'No products yet.'
                        : hasQuery // if the catalog is not empty and the search value is not empty, show the message 'No products match your search.'
                        ? 'No products match your search.'
                        : 'No products yet.'; // if the catalog is empty and the search value is not empty, show the message 'No products yet.'
                    return Center(
                      child: Text(
                        message,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: list.length,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      final product = list[index];
                      final variants = product.variants
                          .map(
                            (variant) => {
                              'weight': variant.weight,
                              'price': variant.price,
                            },
                          )
                          .toList();
                      return ProductCard(
                        productName: product.name,
                        productImage: product.imageUrl,
                        variants: variants,
                        onAddVariant: () =>
                            controller.showVariantSheet(product.id),
                        onEditVariant: (variantIndex) =>
                            controller.editVariant(product.id, variantIndex),
                        onDeleteVariant: (variantIndex) =>
                            controller.deleteVariant(product.id, variantIndex),
                      );
                    },
                  );
                }),
              ),
              SizedBox(height: 12.h),
              AppPrimaryActionButton(
                label: 'Add Product',
                onPressed: controller.addProduct,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
