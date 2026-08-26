import 'package:sales_man/core/models/notification_model.dart';

abstract class INotificationRepository {
  Stream<List<NotificationModel>> getNotifications();
  Future<void> saveNotification(NotificationModel notification);
  Future<void> markAsRead(String notificationId);
  Future<void> markAllAsRead();
  Future<void> deleteNotification(String notificationId);
  Future<bool> notificationExists(String orderId, String eventType);
}
