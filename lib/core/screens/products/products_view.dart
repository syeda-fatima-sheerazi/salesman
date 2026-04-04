import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:practices/core/widgets/add_product_button.dart';
import 'package:practices/core/widgets/product_card.dart';
import 'package:practices/core/widgets/products_search_bar.dart';

class ProductsView extends StatelessWidget {
  const ProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Sample data matching the screenshot
    final products = [
      {
        'name': 'Different Ketchup',
        'image':
            'https://www.pngmart.com/files/Ketchup-Bottle-PNG-Transparent-Image.png',
        'variants': [
          {'weight': '1 KG', 'price': 'Rs 350'},
          {'weight': '500g', 'price': 'Rs 200'},
          {'weight': '250g', 'price': 'Rs 100'},
        ],
      },
      {
        'name': 'Nihari Masala',
        'image':
            'https://www.pngall.com/wp-content/uploads/5/Masala-Powder-PNG.png',
        'variants': [
          {'weight': '250g', 'price': 'Rs 180'},
          {'weight': '100g', 'price': 'Rs 80'},
          {'weight': '50g', 'price': 'Rs 50'},
        ],
      },
      {
        'name': 'Mix Achar',
        'image':
            'https://www.pngall.com/wp-content/uploads/5/Pickle-Jar-PNG.png',
        'variants': [
          {'weight': '5 KG Bucket', 'price': 'Rs 1100'},
          {'weight': '1 KG Jar', 'price': 'Rs 240'},
          {'weight': '500g Jar', 'price': 'Rs 130'},
        ],
      },
    ];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              ProductsSearchBar(
                onChanged: (value) {
                  // Handle search
                },
              ),
              SizedBox(height: 16.h),

              // Products List Title
              Text(
                'Products List',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 12.h),

              // Products List
              Expanded(
                child: ListView.builder(
                  itemCount: products.length,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    final variants = (product['variants'] as List<dynamic>)
                        .map((v) => Map<String, String>.from(v as Map))
                        .toList();
                    return ProductCard(
                      productName: product['name'] as String,
                      productImage: product['image'] as String,
                      variants: variants,
                      onAddVariant: () {
                        // Handle add variant
                      },
                      onEditVariant: (variantIndex) {
                        // Handle edit variant
                      },
                      onDeleteVariant: (variantIndex) {
                        // Handle delete variant
                      },
                    );
                  },
                ),
              ),

              SizedBox(height: 12.h),

              // Add Product Button
              AddProductButton(
                onTap: () {
                  // Handle add product
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
