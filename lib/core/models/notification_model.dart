import 'package:flutter/material.dart';
import 'package:sales_man/core/enums/notification_type.dart';

class NotificationModel {
  final String id;
  final NotificationType type;
  final String title;
  final String subtitle;
  final DateTime timestamp;
  bool isRead;
  final String orderId;
  final String eventType;

  String get time {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${(diff.inDays / 7).floor()}w ago';
  }

  NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.timestamp,
    this.isRead = false,
    this.orderId = '',
    this.eventType = '',
  });

  Map<String, dynamic> toFirestore() {
    return {
      'type': type.name,
      'title': title,
      'subtitle': subtitle,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'orderId': orderId,
      'eventType': eventType,
    };
  }

  factory NotificationModel.fromFirestore(String id, Map<String, dynamic> data) {
    return NotificationModel(
      id: id,
      type: NotificationType.values.firstWhere((e) => e.name == data['type']),
      title: data['title'] ?? '',
      subtitle: data['subtitle'] ?? '',
      timestamp: DateTime.parse(data['timestamp'] as String),
      isRead: data['isRead'] ?? false,
      orderId: data['orderId'] ?? '',
      eventType: data['eventType'] ?? '',
    );
  }

  IconData get iconData {
    switch (type) {
      case NotificationType.order:
        return Icons.local_shipping;
      case NotificationType.payment:
        return Icons.currency_rupee;
      case NotificationType.visit:
        return Icons.store;
      case NotificationType.meeting:
        return Icons.calendar_today;
      case NotificationType.report:
        return Icons.insert_chart;
    }
  }

  Color get iconBackgroundColor {
    switch (type) {
      case NotificationType.order:
        return const Color(0xFF4A8B9F);
      case NotificationType.payment:
        return Colors.red.shade400;
      case NotificationType.visit:
        return const Color(0xFF4A8B9F);
      case NotificationType.meeting:
        return const Color(0xFF4A8B9F);
      case NotificationType.report:
        return const Color(0xFF4A8B9F);
    }
  }
}
