class Shop {
  final String shopName;
  final String shopOwner;
  final String cellPhone;
  final String shopImagUrl;
  final String address;
  final bool isVisited;
  final String? description;

  Shop({
    required this.shopName,
    required this.shopOwner,
    required this.cellPhone,
    required this.address,
    this.isVisited = false,
    this.shopImagUrl = 'assets/images/shop.png',
    this.description,
  });
}
