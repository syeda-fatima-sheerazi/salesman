import 'package:flutter/material.dart';

enum NotificationType {
  order,
  payment,
  visit,
  meeting,
  report,
}

class NotificationModel {
  final String id;
  final NotificationType type;
  final String title;
  final String subtitle;
  final String time;
  final DateTime timestamp;
  bool isRead;

  NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.timestamp,
    this.isRead = false,
  });

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
