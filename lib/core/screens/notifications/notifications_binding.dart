import 'package:get/get.dart';
import 'package:practices/core/screens/notifications/notifications_controller.dart';

class NotificationsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationsController>((() => NotificationsController()));
  }
}
