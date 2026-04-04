class Shop {
  final String shopName;
  final String shopOwner;
  final String cellPhone;
  final String shopImagUrl;
  final String address;
  final bool isVisited;

  Shop({
    required this.shopName,
    required this.shopOwner,
    required this.cellPhone,
    required this.shopImagUrl,
    required this.address,
    this.isVisited = false,
  });
}
