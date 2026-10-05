import 'package:get/get.dart';
import 'package:sales_man/core/repositories/firestore/notification_repository.dart';
import 'package:sales_man/core/repositories/firestore/order_repository.dart';
import 'package:sales_man/core/repositories/firestore/product_repository.dart';
import 'package:sales_man/core/repositories/firestore/shop_repository.dart';
import 'package:sales_man/core/repositories/firestore/user_repository.dart';
import 'package:sales_man/core/repositories/i_notification_repository.dart';
import 'package:sales_man/core/repositories/i_order_repository.dart';
import 'package:sales_man/core/repositories/i_product_repository.dart';
import 'package:sales_man/core/repositories/i_shop_repository.dart';
import 'package:sales_man/core/repositories/i_user_repository.dart';
import 'package:sales_man/core/services/auth_service.dart';
import 'package:sales_man/core/services/notification_service.dart';
import 'package:sales_man/core/services/storage_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    final auth = AuthService();
    Get.put<AuthService>(auth, permanent: true);

    Get.put<StorageService>(StorageService(), permanent: true);
    Get.put<IShopRepository>(ShopRepository(authService: auth), permanent: true);
    Get.put<IProductRepository>(
      ProductRepository(authService: auth),
      permanent: true,
    );
    Get.put<IOrderRepository>(OrderRepository(authService: auth), permanent: true);
    Get.put<IUserRepository>(UserRepository(authService: auth), permanent: true);
    Get.put<INotificationRepository>(
      NotificationRepository(authService: auth),
      permanent: true,
    );

    Get.put<NotificationService>(
      NotificationService(
        orderRepository: Get.find<IOrderRepository>(),
        notificationRepository: Get.find<INotificationRepository>(),
      ),
      permanent: true,
    );
  }
}
