import 'package:get/get.dart';
import 'package:practices/core/models/notification_model.dart';

class NotificationsController extends GetxController {
  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  final RxInt unreadCount = 0.obs;
  final RxInt selectedTabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadDummyData();
    _updateUnreadCount();
  }

  void _loadDummyData() {
    final now = DateTime.now();
    notifications.value = [
      NotificationModel(
        id: '1',
        type: NotificationType.order,
        title: 'New Order from Ali Super Mart',
        subtitle: '3 items ₹8,300',
        time: '10:45 AM',
        timestamp: now.subtract(const Duration(hours: 2)),
        isRead: false,
      ),
      NotificationModel(
        id: '2',
        type: NotificationType.payment,
        title: 'Payment of ₹7,000 received',
        subtitle: 'from Noman General Store',
        time: '10:05 AM',
        timestamp: now.subtract(const Duration(hours: 3)),
        isRead: false,
      ),
      NotificationModel(
        id: '3',
        type: NotificationType.visit,
        title: 'Iqbal Traders marked as visited',
        subtitle: '',
        time: 'Today',
        timestamp: now.subtract(const Duration(hours: 5)),
        isRead: true,
      ),
      NotificationModel(
        id: '4',
        type: NotificationType.meeting,
        title: 'Meeting scheduled with Ali Super Mart',
        subtitle: 'at 2:00 PM tomorrow.',
        time: 'Yesterday',
        timestamp: now.subtract(const Duration(days: 1)),
        isRead: true,
      ),
      NotificationModel(
        id: '5',
        type: NotificationType.report,
        title: 'Monthly sales report for March',
        subtitle: 'is ready to view.',
        time: 'Yesterday',
        timestamp: now.subtract(const Duration(days: 1, hours: 3)),
        isRead: true,
      ),
    ];
  }

  void _updateUnreadCount() {
    unreadCount.value = notifications.where((n) => !n.isRead).length;
  }

  void markAsRead(String id) {
    final index = notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      notifications[index].isRead = true;
      notifications.refresh();
      _updateUnreadCount();
    }
  }

  void markAllAsRead() {
    for (var notification in notifications) {
      notification.isRead = true;
    }
    notifications.refresh();
    _updateUnreadCount();
  }

  void deleteNotification(String id) {
    notifications.removeWhere((n) => n.id == id);
    _updateUnreadCount();
  }

  void changeTab(int index) {
    selectedTabIndex.value = index;
  }

  List<NotificationModel> get filteredNotifications {
    if (selectedTabIndex.value == 0) {
      return notifications;
    } else {
      return notifications.where((n) => !n.isRead).toList();
    }
  }
}
