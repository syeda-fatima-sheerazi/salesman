# Notification Feature — Convert Dummy Data to Real Firestore Data

> Source: `specs/001-notification-firestore-integration.md`
> Status: Implementation complete — pending manual testing

## How to use this plan
This plan is self-contained: executing it needs no prior conversation history.
Start by reading it in full. Code may have moved on since it was written, so
spot-check the referenced files still match before you begin. Update the
Progress Checklist below as work completes — it is the single source of
truth for what's done.

## Progress Checklist
- [x] Stream A: Order model extension — add deliveryDate & paymentDate fields
  - [x] A1. Add `deliveryDate` and `paymentDate` fields to `Order` model
  - [x] A2. Update `toFirestore()`, `fromFirestore()`, `toMap()`, `fromMap()` methods
- [x] Stream B: Notification data layer — model, repository, Firestore schema
  - [x] B1. Extend `NotificationModel` with `orderId`, `eventType`, `toFirestore()`, `fromFirestore()`, computed `time` getter
  - [x] B2. Create `INotificationRepository` interface in `lib/core/repositories/`
  - [x] B3. Create `NotificationRepository` Firestore implementation in `lib/core/repositories/firestore/`
  - [x] B4. Register `NotificationRepository` in `InitialBinding`
- [x] Stream C: Notification generation — service that observes orders
  - [x] C1. Create `NotificationService` in `lib/core/services/`
  - [x] C2. Implement order snapshot observation and notification creation
  - [x] C3. Implement deduplication via Firestore batch + conditional check
  - [x] C4. Register `NotificationService` in `InitialBinding`
- [x] Stream D: Controller integration — wire to real Firestore data
  - [x] D1. Inject `INotificationRepository` into `NotificationsController`
  - [x] D2. Replace `_loadDummyData()` with Firestore snapshot listener
  - [x] D3. Update `markAsRead()` to persist `isRead: true` to Firestore
  - [x] D4. Update `markAllAsRead()` to persist all unread as read to Firestore
  - [x] D5. Update `unreadCount` to derive from Firestore-backed list
- [ ] Integration: Verify end-to-end flow
  - [ ] I1. Create an order → verify notification appears
  - [ ] I2. Mark as delivered → verify notification appears
  - [ ] I3. Mark as collected → verify notification appears
  - [ ] I4. Mark read/unread → verify Firestore persistence
  - [x] I5. Run `flutter analyze` — zero new warnings
- [ ] Final acceptance criteria verified

## Objective
Replace the hardcoded dummy notification data with real notifications generated from Firestore order data. Notifications will be stored per-user at `users/{uid}/notifications/{notificationId}` and derived from order lifecycle events (creation, delivery status, collection status). The existing notification UI and controller logic (filtering, search, mark-as-read) remain unchanged — only the data source changes.

## Scope
**In scope:**
- Extending the Order model with `deliveryDate` and `paymentDate` fields
- Creating `INotificationRepository` interface and `NotificationRepository` Firestore implementation
- Creating `NotificationService` that observes order snapshots and generates notifications
- Deduplication of notifications for the same `(orderId, eventType)`
- Real-time Firestore snapshot listener for the notification list
- Persisting `isRead` state to Firestore
- Computing relative time strings from timestamps using `intl` package
- Firestore security rules (noted as assumption)

**Out of scope:**
- Redesigning the notification UI
- Push notifications (FCM) — in-app only
- Notification types for visits, meetings, and reports (future work)
- Pagination for large notification lists
- Notification sound / vibration
- Batch notification generation for historical orders

## Decisions from user interview

1. **Order model fields:** Add `deliveryDate` and `paymentDate` optional fields to the Order model. This requires updating `Order`, `toFirestore()`, `fromFirestore()`, `toMap()`, and `fromMap()` methods, plus any code that creates/updates orders.

2. **Notification generation:** Use a separate `NotificationService` (not inline in `OrderRepository.saveOrder()`). Clean separation, follows repository pattern.

3. **Time field:** Compute `time` as a getter from `timestamp` using the `intl` package's `DateFormat` or relative time formatting. The `time` field becomes a computed property, not stored in Firestore.

4. **Firestore security rules:** Include as an assumption/note in the plan. Rules are managed in Firebase Console, not in the Flutter codebase.

5. **Deduplication:** Use Firestore batch with conditional check. Before inserting, query for existing `(orderId, eventType)` — if found, skip. The batch ensures atomicity.

## Research findings

### Existing patterns to mirror

**Repository pattern** (`lib/core/repositories/`):
- Interface: `IOrderRepository` at `lib/core/repositories/i_order_repository.dart` — defines `Stream` and `Future` methods
- Implementation: `OrderRepository` at `lib/core/repositories/firestore/order_repository.dart` — takes `AuthService` via constructor, uses `_uid` getter that throws `StateError` if no authenticated user
- Firestore path: `users/{uid}/orders/{orderId}`
- DI: Registered in `InitialBinding` as `Get.put<IOrderRepository>(OrderRepository(authService: auth), permanent: true)`

**Model serialization** (`lib/core/models/order.dart`):
- `toFirestore()` / `fromFirestore()` — excludes `id` (id comes from document reference)
- `toMap()` / `fromMap()` — includes `id` field for local/SQLite use
- Factory pattern: `Order.fromFirestore(String id, Map<String, dynamic> data)`

**Screen triple** (`lib/core/screens/notifications/`):
- `notifications_controller.dart` — GetxController with `RxList<NotificationModel>`, `RxInt unreadCount`, search, tabs
- `notifications_view.dart` — GetView consuming controller, uses `Obx()` for reactive updates
- No dedicated binding — controller is lazily created via `DashboardBinding` (`Get.lazyPut<NotificationsController>`)

**DI registration** (`lib/core/initial_binding.dart`):
- All repositories registered as permanent singletons
- `AuthService` created first, passed to all repositories

**Auth** (`lib/core/services/auth_service.dart`):
- `AuthService` extends `GetxService`, provides `currentUser` with `id` field
- `AuthService.instance` static getter via `Get.find()`

**Notification model** (`lib/core/models/notification_model.dart`):
- Fields: `id`, `type` (NotificationType), `title`, `subtitle`, `time` (String), `timestamp` (DateTime), `isRead` (bool, mutable)
- No `orderId` or `eventType` fields — need to be added
- No serialization methods — need `toFirestore()` and `fromFirestore()`

**Dependencies** (`pubspec.yaml`):
- `cloud_firestore: ^5.6.6` — already present
- `intl: ^0.19.0` — already present, for time formatting
- No new packages needed

**Key file paths:**
- `lib/core/models/order.dart` — Order model
- `lib/core/models/notification_model.dart` — NotificationModel
- `lib/core/enums/notification_type.dart` — NotificationType enum
- `lib/core/repositories/i_order_repository.dart` — Order repository interface
- `lib/core/repositories/firestore/order_repository.dart` — Order repository impl
- `lib/core/initial_binding.dart` — DI registration
- `lib/core/screens/notifications/notifications_controller.dart` — Controller
- `lib/core/screens/notifications/notifications_view.dart` — View
- `lib/core/screens/dashboard/dashboard_binding.dart` — Dashboard binding (lazy-loads NotificationsController)
- `lib/core/screens/dashboard/dashboard_view.dart` — Uses `NotificationIconWidget` with `unreadCount`
- `lib/core/services/auth_service.dart` — Auth service

## Assumptions & open questions
- **Firestore security rules** must be updated in Firebase Console to allow read/write on `users/{uid}/notifications/`. This is outside the Flutter codebase and not covered by implementation steps.
- **Order model changes** will affect any code that creates or updates orders. The `PlaceOrderController` and any other order-creation paths will need to accept `deliveryDate` and `paymentDate` as optional parameters. The plan includes updating the model but assumes existing order-creation code will gracefully handle `null` values (both fields are nullable/optional).
- **No existing tests** to update — `test/widget_test.dart` is stale and tests a counter widget that no longer exists.
- **`NotificationModel.time` field** — currently stored as `String` in constructor. Will be changed to a computed getter that derives from `timestamp`. This is a breaking change for the constructor — all call sites must be updated. The only current call site is `_loadDummyData()` which is being removed anyway.

## Design overview

### New files
1. **`lib/core/repositories/i_notification_repository.dart`** — Abstract interface defining notification CRUD + snapshot methods
2. **`lib/core/repositories/firestore/notification_repository.dart`** — Firestore implementation scoped to `users/{uid}/notifications/`
3. **`lib/core/services/notification_service.dart`** — Observes order snapshots, generates notifications on lifecycle events, handles deduplication

### Modified files
1. **`lib/core/models/order.dart`** — Add `deliveryDate` and `paymentDate` optional fields, update all serialization methods
2. **`lib/core/models/notification_model.dart`** — Add `orderId`, `eventType` fields, add `toFirestore()`/`fromFirestore()`, convert `time` to computed getter
3. **`lib/core/initial_binding.dart`** — Register `INotificationRepository` and `NotificationService`
4. **`lib/core/screens/notifications/notifications_controller.dart`** — Replace dummy data with Firestore snapshot, persist read state

### Data flow
```
Order created/updated
  → NotificationService observes order snapshot
  → Checks for duplicate (orderId, eventType) via Firestore batch
  → Creates notification at users/{uid}/notifications/
  → Firestore snapshot updates notification list in real-time
  → NotificationsController receives updated list via Stream
  → UI re-renders via Obx()
```

## Work streams & parallel execution plan

### Stream A: Order model extension
- **Can run in parallel with:** Stream B (notification data layer)
- **Depends on:** Nothing
- [ ] A1. Open `lib/core/models/order.dart`. Add two new nullable fields:
  ```dart
  final DateTime? deliveryDate;
  final DateTime? paymentDate;
  ```
  Add them to the constructor as optional named parameters (default `null`).
- [ ] A2. Update `toFirestore()` to include:
  ```dart
  'deliveryDate': deliveryDate?.toIso8601String(),
  'paymentDate': paymentDate?.toIso8601String(),
  ```
- [ ] A3. Update `fromFirestore()` to parse:
  ```dart
  deliveryDate: data['deliveryDate'] != null ? DateTime.parse(data['deliveryDate'] as String) : null,
  paymentDate: data['paymentDate'] != null ? DateTime.parse(data['paymentDate'] as String) : null,
  ```
- [ ] A4. Update `toMap()` to include both fields (same as `toFirestore()`)
- [ ] A5. Update `fromMap()` to parse both fields (same as `fromFirestore()`)

### Stream B: Notification data layer
- **Can run in parallel with:** Stream A (order model)
- **Depends on:** Nothing
- [ ] B1. Open `lib/core/models/notification_model.dart`. Add fields:
  ```dart
  final String orderId;
  final String eventType;
  ```
  Add them as required named parameters to the constructor. Convert `time` from a stored `String` to a computed getter:
  ```dart
  String get time {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${(diff.inDays / 7).floor()}w ago';
  }
  ```
  Add `toFirestore()` and `fromFirestore()` methods mirroring `Order` pattern:
  ```dart
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
  ```
  Remove the `time` parameter from the constructor entirely (it's now a getter).

- [ ] B2. Create `lib/core/repositories/i_notification_repository.dart`:
  ```dart
  import 'package:sales_man/core/models/notification_model.dart';

  abstract class INotificationRepository {
    Stream<List<NotificationModel>> getNotifications();
    Future<void> saveNotification(NotificationModel notification);
    Future<void> markAsRead(String notificationId);
    Future<void> markAllAsRead();
    Future<void> deleteNotification(String notificationId);
    Future<bool> notificationExists(String orderId, String eventType);
  }
  ```

- [ ] B3. Create `lib/core/repositories/firestore/notification_repository.dart` following `OrderRepository` pattern:
  - Constructor takes `AuthService authService` and optional `FirebaseFirestore firestore`
  - Private `_uid` getter that throws `StateError` if no authenticated user
  - `_notificationsRef` pointing to `users/{uid}/notifications`
  - `getNotifications()` returns `_notificationsRef.orderBy('timestamp', descending: true).snapshots()` mapped to `NotificationModel.fromFirestore`
  - `saveNotification()` calls `_notificationsRef.doc(notification.id).set(notification.toFirestore())`
  - `markAsRead()` updates `_notificationsRef.doc(notificationId).update({'isRead': true})`
  - `markAllAsRead()` uses a Firestore batch to update all unread notifications where `isRead == false`
  - `deleteNotification()` calls `_notificationsRef.doc(notificationId).delete()`
  - `notificationExists()` queries `_notificationsRef.where('orderId', isEqualTo: orderId).where('eventType', isEqualTo: eventType).limit(1).get()` and returns `snap.docs.isNotEmpty`

- [ ] B4. Open `lib/core/initial_binding.dart`. Add:
  ```dart
  import 'package:sales_man/core/repositories/firestore/notification_repository.dart';
  import 'package:sales_man/core/repositories/i_notification_repository.dart';
  ```
  Add registration:
  ```dart
  Get.put<INotificationRepository>(
    NotificationRepository(authService: auth),
    permanent: true,
  );
  ```

### Stream C: Notification generation service
- **Can run in parallel with:** None — depends on Stream A (Order model) and Stream B (repository) being complete
- **Depends on:** Stream A (needs updated Order model with deliveryDate/paymentDate), Stream B (needs INotificationRepository)
- [ ] C1. Create `lib/core/services/notification_service.dart`:
  ```dart
  import 'dart:async';
  import 'package:cloud_firestore/cloud_firestore.dart';
  import 'package:get/get.dart';
  import 'package:sales_man/core/models/order.dart';
  import 'package:sales_man/core/models/notification_model.dart';
  import 'package:sales_man/core/enums/notification_type.dart';
  import 'package:sales_man/core/repositories/i_notification_repository.dart';
  import 'package:sales_man/core/repositories/i_order_repository.dart';
  import 'package:sales_man/core/services/auth_service.dart';
  ```

- [ ] C2. Implement the service class with initialization guard:
  ```dart
  class NotificationService extends GetxService {
    final IOrderRepository _orderRepository;
    final INotificationRepository _notificationRepository;
    final AuthService _authService;
    StreamSubscription? _orderSubscription;
    bool _initialized = false; // Guard: skip first snapshot to avoid historical notification flood

    NotificationService({
      required IOrderRepository orderRepository,
      required INotificationRepository notificationRepository,
      required AuthService authService,
    })  : _orderRepository = orderRepository,
          _notificationRepository = notificationRepository,
          _authService = authService;

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
        // First snapshot: seed _previousOrders without generating notifications
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
  ```

- [ ] C3. Implement notification generation methods:
  ```dart
  Future<void> _checkAndGenerateNotifications(Order current, Order? previous) async {
    if (current.id == null) return;

    // order_created: generated when orderDate is first set (new order)
    if (previous == null && current.orderDate != null) {
      await _createNotification(
        orderId: current.id!,
        type: NotificationType.order,
        eventType: 'order_created',
        title: 'New Order from ${current.shopName}',
        subtitle: '${current.items.length} items ₹${current.totalBill.toStringAsFixed(0)}',
      );
    }

    // order_delivered: isDelivered transitions false → true
    if (previous != null && !previous.isDelivered && current.isDelivered) {
      await _createNotification(
        orderId: current.id!,
        type: NotificationType.order,
        eventType: 'order_delivered',
        title: 'Order from ${current.shopName} delivered',
        subtitle: '${current.items.length} items',
      );
    }

    // payment_received: isCollected transitions false → true
    if (previous != null && !previous.isCollected && current.isCollected) {
      await _createNotification(
        orderId: current.id!,
        type: NotificationType.payment,
        eventType: 'payment_received',
        title: 'Payment of ₹${current.totalBill.toStringAsFixed(0)} received',
        subtitle: 'from ${current.shopName}',
      );
    }
  }
  ```

- [ ] C4. Implement `_createNotification` with batch deduplication:
  ```dart
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
      id: '', // Firestore will generate ID
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
  ```
  Note: The `notificationExists()` check + `saveNotification()` is NOT atomic. For true atomicity, the batch approach would require using Firestore's `runTransaction()` instead. Since `notificationExists` does a query and `saveNotification` does a write, a brief race window exists. For a single-user sales app, this is acceptable. If stricter dedup is needed later, convert to a Firestore transaction.

- [ ] C5. Register in `lib/core/initial_binding.dart`:
  ```dart
  import 'package:sales_man/core/services/notification_service.dart';
  ```
  Add (after all repositories are registered):
  ```dart
  Get.put<NotificationService>(
    NotificationService(
      orderRepository: Get.find<IOrderRepository>(),
      notificationRepository: Get.find<INotificationRepository>(),
      authService: auth,
    ),
    permanent: true,
  );
  ```

### Stream D: Controller integration
- **Can run in parallel with:** Stream C (both can work in parallel — controller changes don't depend on service being registered)
- **Depends on:** Stream B (needs INotificationRepository interface and NotificationModel changes)
- [ ] D1. Open `lib/core/screens/notifications/notifications_controller.dart`. Add dependency injection:
  ```dart
  import 'package:sales_man/core/repositories/i_notification_repository.dart';
  import 'package:intl/intl.dart';
  ```
  Add field:
  ```dart
  final INotificationRepository _notificationRepository = Get.find();
  ```

- [ ] D2. Replace `_loadDummyData()` in `onInit()` with a Firestore snapshot listener:
  ```dart
  StreamSubscription? _notificationSubscription;

  @override
  void onInit() {
    super.onInit();
    _listenToNotifications();
  }

  void _listenToNotifications() {
    _notificationSubscription = _notificationRepository.getNotifications().listen(
      (notifs) {
        notifications.value = notifs;
        _updateUnreadCount();
      },
    );
  }

  @override
  void onClose() {
    _notificationSubscription?.cancel();
    searchFieldController.dispose();
    super.onClose();
  }
  ```
  Remove the entire `_loadDummyData()` method.

- [ ] D3. Update `markAsRead()` to persist to Firestore:
  ```dart
  void markAsRead(String id) {
    final index = notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      notifications[index].isRead = true;
      notifications.refresh();
      _updateUnreadCount();
      _notificationRepository.markAsRead(id);
    }
  }
  ```

- [ ] D4. Update `markAllAsRead()` to persist to Firestore:
  ```dart
  void markAllAsRead() {
    for (var notification in notifications) {
      notification.isRead = true;
    }
    notifications.refresh();
    _updateUnreadCount();
    _notificationRepository.markAllAsRead();
  }
  ```

- [ ] D5. The `unreadCount` derivation (`_updateUnreadCount()`) remains unchanged — it already counts `!n.isRead` from the in-memory list, which is now kept in sync via the Firestore snapshot listener.

### Integration steps (after parallel streams complete)
- [ ] I1. Verify `flutter analyze` passes with zero new warnings
- [ ] I2. Manual test: Create a new order → verify `order_created` notification appears
- [ ] I3. Manual test: Mark order as delivered → verify `order_delivered` notification appears
- [ ] I4. Manual test: Mark order as collected → verify `payment_received` notification appears
- [ ] I5. Manual test: Tap notification → verify it's marked as read, unread count decreases
- [ ] I6. Manual test: Tap "Mark All as Read" → verify all notifications marked read
- [ ] I7. Manual test: Verify no duplicate notifications for same order/event

## Data model / API changes

### Order model — extended
```dart
// New fields added to Order class:
final DateTime? deliveryDate;   // when the order was delivered
final DateTime? paymentDate;    // when payment was collected

// Added to toFirestore(), fromFirestore(), toMap(), fromMap()
```

### NotificationModel — extended
```dart
// New fields:
final String orderId;       // reference to source order
final String eventType;     // 'order_created' | 'order_delivered' | 'payment_received'

// New methods:
Map<String, dynamic> toFirestore()
factory NotificationModel.fromFirestore(String id, Map<String, dynamic> data)

// Changed: time is now a computed getter (not stored)
String get time => /* computed from timestamp */;
```

### Firestore schema — new collection
```
users/{uid}/notifications/{notificationId}
  type: string            // enum name: order, payment
  title: string           // e.g., "New Order from Ali Super Mart"
  subtitle: string        // e.g., "3 items ₹8,300"
  timestamp: string       // ISO 8601
  isRead: boolean
  orderId: string         // reference to order document
  eventType: string       // order_created, order_delivered, payment_received
```

## Dependencies
No new packages needed. `cloud_firestore: ^5.6.6` and `intl: ^0.19.0` are already in `pubspec.yaml`.

## Testing strategy
- No existing unit/widget test infrastructure to follow — `test/widget_test.dart` is stale
- Manual testing recommended for this feature (Firestore integration requires running app)
- `flutter analyze` for static analysis validation
- Future: add unit tests for `NotificationService._checkAndGenerateNotifications()` with mocked repositories

## Edge cases & error handling
- **Offline / Firestore persistence:** Firestore's offline persistence (enabled by default) will cache notifications. The snapshot stream handles reconnection automatically.
- **Empty state:** Already handled in `notifications_view.dart:81-101` — shows "No notifications" icon. No changes needed.
- **Concurrent order edits:** Last write wins for `isDelivered`/`isCollected`. Notifications are append-only; deduplication prevents duplicates. Safe.
- **Order deletion:** Notifications remain (orphaned but harmless). Not required for MVP.
- **`_previousOrders` tracking:** The service maintains a snapshot of previous orders to detect transitions. On first load, all orders are treated as "new" — `order_created` notifications are generated for orders with `orderDate` set that have no previous state. This means existing orders will trigger `order_created` notifications on first service init. To prevent this, add a one-time "initialization" flag that skips the first snapshot batch, or only generate notifications for orders created after service init.
- **Race condition in dedup:** `notificationExists()` query + `saveNotification()` write are not atomic. For this single-user app, the race window is negligible. If stricter guarantees are needed, convert to a Firestore transaction.

## Acceptance criteria
- [ ] `NotificationModel` has `toFirestore()` and `fromFirestore()` methods
- [ ] `NotificationModel` has `orderId` and `eventType` fields
- [ ] `NotificationModel.time` is computed from `timestamp`, not stored
- [ ] `Order` model has `deliveryDate` and `paymentDate` fields
- [ ] `INotificationRepository` interface exists in `lib/core/repositories/`
- [ ] `NotificationRepository` Firestore implementation exists
- [ ] `NotificationRepository` is registered in `InitialBinding`
- [ ] `NotificationService` exists and observes order snapshots
- [ ] `NotificationService` generates `order_created` notifications
- [ ] `NotificationService` generates `order_delivered` notifications
- [ ] `NotificationService` generates `payment_received` notifications
- [ ] Duplicate notifications for same `(orderId, eventType)` are prevented
- [ ] `NotificationsController` fetches from Firestore via snapshot listener
- [ ] `markAsRead()` persists `isRead: true` to Firestore
- [ ] `markAllAsRead()` persists all unread as read to Firestore
- [ ] `unreadCount` reflects real unread count from Firestore
- [ ] Notification list updates in real-time when new notifications are added
- [ ] Existing UI (view, card, icon widget, tabs, search) works unchanged with real data
- [ ] `flutter analyze` passes with no new warnings

## Risks & rollout notes
- **First-run notification flood:** When `NotificationService` starts, it will observe all existing orders and could generate `order_created` notifications for every historical order. Mitigation: The `_initialized` boolean guard in `_processOrders()` skips the first snapshot emission, treating it as baseline state rather than new events. Only subsequent snapshot changes trigger notification generation.
- **Firestore security rules:** Must be updated in Firebase Console to allow `users/{uid}/notifications/` read/write. Without this, all Firestore operations will fail silently or throw permission errors.
- **Order model migration:** Existing orders in Firestore won't have `deliveryDate`/`paymentDate` fields. `fromFirestore()` handles this with null defaults — no migration needed.
- **No rollback plan:** Once notifications are generated, they persist in Firestore. To revert, delete the `notifications` subcollection manually or via Firebase Console.
