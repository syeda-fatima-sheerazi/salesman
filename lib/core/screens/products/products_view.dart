import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:practices/core/models/order_item.dart';
import 'package:practices/core/models/product_model.dart';
import 'package:practices/core/screens/products/product_controller.dart';
import 'package:practices/core/screens/products/widgets/cart_item_tile.dart';
import 'package:practices/core/screens/products/widgets/selectable_product_card.dart';
import 'package:practices/core/themes/app_theme.dart';
import 'package:practices/core/widgets/app_primary_action_button.dart';
import 'package:practices/core/widgets/product_card.dart';
import 'package:practices/core/widgets/products_search_bar.dart';

class ProductsView extends GetView<ProductController> {
  const ProductsView({super.key, this.isSelectionMode = false});

  final bool isSelectionMode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: isSelectionMode
          ? AppBar(title: const Text('Select Products'))
          : null,
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
                isSelectionMode ? 'Tap a product to add' : 'Products List',
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
                        .trim()
                        .isNotEmpty;
                    final emptyCatalog = controller.products.isEmpty;
                    final message = emptyCatalog && !hasQuery
                        ? 'No products yet.'
                        : hasQuery
                            ? 'No products match your search.'
                            : 'No products yet.';
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
                    itemCount: list.length + (isSelectionMode ? controller.selectedItems.length : 0),
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      if (isSelectionMode && index >= list.length) {
                        final cartIndex = index - list.length;
                        final item = controller.selectedItems[cartIndex];
                        return CartItemTile(
                          item: item,
                          onIncrement: () =>
                              controller.updateSelectionQuantity(cartIndex, 1),
                          onDecrement: () =>
                              controller.updateSelectionQuantity(cartIndex, -1),
                          onRemove: () =>
                              controller.removeFromSelection(cartIndex),
                        );
                      }

                      final product = list[index];
                      if (isSelectionMode) {
                        return SelectableProductCard(
                          product: product,
                          onTap: () => _showProductPicker(context, product),
                        );
                      }

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
              if (isSelectionMode)
                Obx(() => AppPrimaryActionButton(
                      label: 'Done (${controller.selectedCount} Products)',
                      onPressed: controller.selectedCount > 0
                          ? controller.confirmSelection
                          : null,
                    ))
              else
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

  void _showProductPicker(BuildContext context, ProductModel product) {
    final variants = product.variants;
    if (variants.isEmpty) {
      _addToSelection(product, null);
      return;
    }

    var selectedVariant = variants.first;
    var quantity = 1;

    Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setState) => Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(height: 16.h),
              if (variants.length > 1) ...[
                Text('Select Variant',
                    style: Theme.of(context).textTheme.titleSmall),
                SizedBox(height: 8.h),
                DropdownButton<ProductVariantModel>(
                  value: selectedVariant,
                  isExpanded: true,
                  items: variants
                      .map((v) => DropdownMenuItem(
                            value: v,
                            child: Text('${v.weight} — ${v.price}'),
                          ))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) {
                      setState(() => selectedVariant = v);
                    }
                  },
                ),
                SizedBox(height: 16.h),
              ],
              Row(
                children: [
                  Text('Quantity:',
                      style: Theme.of(context).textTheme.titleSmall),
                  SizedBox(width: 12.w),
                  IconButton(
                    onPressed: () {
                      if (quantity > 1) setState(() => quantity--);
                    },
                    icon: const Icon(Icons.remove_circle_outline),
                  ),
                  Text('$quantity',
                      style: Theme.of(context).textTheme.titleMedium),
                  IconButton(
                    onPressed: () => setState(() => quantity++),
                    icon: const Icon(Icons.add_circle_outline),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _addToSelection(product, selectedVariant, quantity);
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                  ),
                  child: Text('Add to Order',
                      style: TextStyle(fontSize: 16.sp)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addToSelection(
      ProductModel product, ProductVariantModel? variant,
      [int qty = 1]) {
    final price = variant?.numericPrice ?? 0;
    controller.addToSelection(OrderItem(
      productId: product.id,
      productName: product.name,
      qty: qty,
      price: price,
      variant: variant?.weight,
      imageUrl: product.imageUrl,
    ));
  }
}
