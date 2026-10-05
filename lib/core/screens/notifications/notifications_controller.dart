import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sales_man/core/models/notification_model.dart';
import 'package:sales_man/core/repositories/i_notification_repository.dart';

class NotificationsController extends GetxController {
  final INotificationRepository _notificationRepository = Get.find();

  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;

  final RxInt unreadCount = 0.obs;
  final RxInt selectedTabIndex = 0.obs;

  final RxString searchQuery = ''.obs;
  final TextEditingController searchFieldController = TextEditingController();

  StreamSubscription? _notificationSubscription;

  @override
  void onInit() {
    super.onInit();
    _listenToNotifications();
  }

  @override
  void onClose() {
    _notificationSubscription?.cancel();
    searchFieldController.dispose();
    super.onClose();
  }

  void _listenToNotifications() {
    _notificationSubscription = _notificationRepository.getNotifications().listen(
      (notifs) {
        notifications.value = notifs;
        _updateUnreadCount();
      },
    );
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
      _notificationRepository.markAsRead(id);
    }
  }

  void markAllAsRead() {
    for (var notification in notifications) {
      notification.isRead = true;
    }
    notifications.refresh();
    _updateUnreadCount();
    _notificationRepository.markAllAsRead();
  }

  void deleteNotification(String id) {
    notifications.removeWhere((n) => n.id == id);
    _updateUnreadCount();
    _notificationRepository.deleteNotification(id);
  }

  void changeTab(int index) {
    selectedTabIndex.value = index;
  }

  List<NotificationModel> get filteredNotifications {
    final tabIndex = selectedTabIndex.value;
    final q = searchQuery.value.trim().toLowerCase();

    Iterable<NotificationModel> base = tabIndex == 0
        ? notifications
        : notifications.where((n) => !n.isRead);

    if (q.isEmpty) {
      return base.toList();
    }

    return base
        .where(
          (n) =>
              n.title.toLowerCase().contains(q) ||
              n.subtitle.toLowerCase().contains(q),
        )
        .toList();
  }

  void onSearchQueryChanged(String query) {
    searchQuery.value = query;
  }

  void clearSearch() {
    searchFieldController.clear();
    searchQuery.value = '';
  }
}
