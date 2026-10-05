import 'dart:async';

import 'package:get/get.dart';
import 'package:sales_man/core/models/order.dart';
import 'package:sales_man/core/models/notification_model.dart';
import 'package:sales_man/core/enums/notification_type.dart';
import 'package:sales_man/core/repositories/i_notification_repository.dart';
import 'package:sales_man/core/repositories/i_order_repository.dart';

class NotificationService extends GetxService {
  final IOrderRepository _orderRepository;
  final INotificationRepository _notificationRepository;
  StreamSubscription? _orderSubscription;
  bool _initialized = false;

  NotificationService({
    required IOrderRepository orderRepository,
    required INotificationRepository notificationRepository,
  })  : _orderRepository = orderRepository,
        _notificationRepository = notificationRepository;

  @override
  void onInit() {
    super.onInit();
    _observeOrders();
  }

  @override
  void onClose() {
    _orderSubscription?.cancel();
    super.onClose();
  }

  void _observeOrders() {
    _orderSubscription = _orderRepository.getOrders().listen(_processOrders);
  }

  List<Order> _previousOrders = [];

  void _processOrders(List<Order> currentOrders) {
    if (!_initialized) {
      _previousOrders = currentOrders;
      _initialized = true;
      return;
    }
    for (final order in currentOrders) {
      final previous = _previousOrders.where((o) => o.id == order.id).firstOrNull;
      _checkAndGenerateNotifications(order, previous);
    }
    _previousOrders = currentOrders;
  }

  Future<void> _checkAndGenerateNotifications(Order current, Order? previous) async {
    if (current.id == null) return;

    if (previous == null && current.orderDate != null) {
      await _createNotification(
        orderId: current.id!,
        type: NotificationType.order,
        eventType: 'order_created',
        title: 'New Order from ${current.shopName}',
        subtitle: '${current.items.length} items \u20B9${current.totalBill.toStringAsFixed(0)}',
      );
    }

    if (previous != null && !previous.isDelivered && current.isDelivered) {
      await _createNotification(
        orderId: current.id!,
        type: NotificationType.order,
        eventType: 'order_delivered',
        title: 'Order from ${current.shopName} delivered',
        subtitle: '${current.items.length} items',
      );
    }

    if (previous != null && !previous.isCollected && current.isCollected) {
      await _createNotification(
        orderId: current.id!,
        type: NotificationType.payment,
        eventType: 'payment_received',
        title: 'Payment of \u20B9${current.totalBill.toStringAsFixed(0)} received',
        subtitle: 'from ${current.shopName}',
      );
    }
  }

  Future<void> _createNotification({
    required String orderId,
    required NotificationType type,
    required String eventType,
    required String title,
    required String subtitle,
  }) async {
    final exists = await _notificationRepository.notificationExists(orderId, eventType);
    if (exists) return;

    final notification = NotificationModel(
      id: '',
      type: type,
      title: title,
      subtitle: subtitle,
      timestamp: DateTime.now(),
      isRead: false,
      orderId: orderId,
      eventType: eventType,
    );
    await _notificationRepository.saveNotification(notification);
  }
}
