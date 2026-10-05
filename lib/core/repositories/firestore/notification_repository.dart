import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sales_man/core/models/notification_model.dart';
import 'package:sales_man/core/repositories/i_notification_repository.dart';
import 'package:sales_man/core/services/auth_service.dart';

class NotificationRepository implements INotificationRepository {
  final FirebaseFirestore _firestore;
  final AuthService _authService;

  NotificationRepository({
    FirebaseFirestore? firestore,
    required AuthService authService,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _authService = authService;

  String get _uid {
    final user = _authService.currentUser;
    if (user == null) throw StateError('No authenticated user');
    return user.id;
  }

  CollectionReference get _notificationsRef =>
      _firestore.collection('users').doc(_uid).collection('notifications');

  @override
  Stream<List<NotificationModel>> getNotifications() {
    return _notificationsRef.orderBy('timestamp', descending: true).snapshots().map(
      (snap) => snap.docs
          .map((doc) => NotificationModel.fromFirestore(
              doc.id, doc.data() as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Future<void> saveNotification(NotificationModel notification) async {
    final ref = notification.id.isNotEmpty
        ? _notificationsRef.doc(notification.id)
        : _notificationsRef.doc();
    await ref.set(notification.toFirestore());
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    await _notificationsRef.doc(notificationId).update({'isRead': true});
  }

  @override
  Future<void> markAllAsRead() async {
    final batch = _firestore.batch();
    final unreadDocs = await _notificationsRef
        .where('isRead', isEqualTo: false)
        .get();
    for (final doc in unreadDocs.docs) {
      batch.update(doc.reference, {'isRead': true});
    }
    await batch.commit();
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    await _notificationsRef.doc(notificationId).delete();
  }

  @override
  Future<bool> notificationExists(String orderId, String eventType) async {
    final snap = await _notificationsRef
        .where('orderId', isEqualTo: orderId)
        .where('eventType', isEqualTo: eventType)
        .limit(1)
        .get();
    return snap.docs.isNotEmpty;
  }
}
