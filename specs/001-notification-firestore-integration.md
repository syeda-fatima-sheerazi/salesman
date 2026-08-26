# Notification Feature — Convert Dummy Data to Real Firestore Data

> **Status:** Draft
> **Author:** AI-generated from prompt
> **Date:** 2026-08-25
> **Related:** N/A

## Summary

Replace the hardcoded dummy notification data in `NotificationsController` with real notifications generated from Firestore order data. Notifications will be stored per-user at `users/{uid}/notifications/{notificationId}` and derived from order lifecycle events (creation, delivery status, collection status). The existing notification UI and controller logic (filtering, search, mark-as-read) remain unchanged.

## Problem Statement

The notification screen currently displays static dummy data that does not reflect actual business activity. Users cannot see real order-related events, making the notification feature non-functional for actual use. This change connects notifications to real Firestore order data so users receive meaningful, timely alerts about their orders.

## Goals

- Notifications are generated from real order data stored in Firestore
- Notifications are persisted per-user under `users/{uid}/notifications/{notificationId}`
- Duplicate notifications for the same order/event are prevented
- Read/unread state is persisted in Firestore and reflected in the existing UI
- The notification list updates in real-time via Firestore snapshots

## Non-goals

- Redesigning the notification UI
- Adding push notifications (FCM) — this spec covers in-app notifications only
- Adding notification types beyond order-related events (visit, meeting, report remain as future work)
- Modifying the Order model to add `deliveryDate` or `paymentDate` fields — see Assumptions & Open Questions

## User Stories / Use Cases

- As a salesperson, I want to see a notification when a new order is placed, so I know activity is happening
- As a salesperson, I want to see a notification when an order is marked as delivered, so I can track fulfillment
- As a salesperson, I want to see a notification when payment is collected (remainingAmount becomes 0), so I know the order is complete
- As a salesperson, I want to mark notifications as read so I can focus on new ones
- As a salesperson, I want to see an accurate unread count badge on the notification icon

## Functional Requirements

1. The system must fetch notifications from `users/{uid}/notifications/` on the authenticated user's Firestore document
2. The system must generate an `order_created` notification when a new order is saved (orderDate is set)
3. The system must generate an `order_delivered` notification when `isDelivered` transitions from `false` to `true`
4. The system must generate an `payment_received` notification when `isCollected` transitions from `false` to `true` or when `collectedAmount` increases
5. The system must prevent duplicate notifications for the same order and event type (e.g., two `order_created` notifications for order X)
6. The system must persist `isRead` state to Firestore when a notification is marked as read
7. The system must support `markAllAsRead` by updating all unread notifications' `isRead` field
8. The system must use Firestore snapshots (real-time listeners) so the notification list updates without requiring a pull-to-refresh
9. The system must generate notification `title` and `subtitle` text from order data (shop name, item count, total bill)
10. The system must compute a human-readable `time` string (e.g., "2 hours ago", "Yesterday") from the notification's `timestamp`

## UX / UI Requirements

N/A — the UI is already implemented and will not be modified. The existing `NotificationsView`, `NotificationCard`, `NotificationIconWidget`, `NotificationTabButton`, and `MarkAllReadButton` widgets remain as-is.

The controller's `filteredNotifications` getter, `markAsRead()`, `markAllAsRead()`, `deleteNotification()`, search, and tab filtering logic will continue to work unchanged — only the data source changes from in-memory list to Firestore-backed list.

## Technical Context & Constraints

- **Architecture:** GetX with repository pattern. Abstract interfaces in `lib/core/repositories/` (e.g., `IOrderRepository`), Firestore implementations in `lib/core/repositories/firestore/`. Controllers depend on repository interfaces via `Get.find()`.
- **State management:** `GetxController` with `RxList<NotificationModel>` and `RxInt unreadCount`. Reactive updates via `.obs` and `Obx()` widgets.
- **Existing notification files:**
  - `lib/core/models/notification_model.dart` — `NotificationModel` class with `id`, `type`, `title`, `subtitle`, `time`, `timestamp`, `isRead`
  - `lib/core/enums/notification_type.dart` — `NotificationType` enum: `order`, `payment`, `visit`, `meeting`, `report`
  - `lib/core/screens/notifications/notifications_controller.dart` — controller with `_loadDummyData()`, `markAsRead()`, `markAllAsRead()`, `filteredNotifications`
  - `lib/core/screens/notifications/notifications_view.dart` — UI consuming controller
  - `lib/core/widgets/notification_card.dart` — card widget
  - `lib/core/widgets/notification_icon_widget.dart` — badge icon widget
- **Order model:** `lib/core/models/order.dart` — fields: `id`, `shopId`, `shopName`, `ownerName`, `cell`, `items`, `orderDate`, `isDelivered`, `isCollected`, `totalBill`, `collectedAmount`, `remainingAmount`. Has `toFirestore()` and `fromFirestore()` methods.
- **Order repository:** `lib/core/repositories/i_order_repository.dart` (interface) and `lib/core/repositories/firestore/order_repository.dart` (implementation). Uses `users/{uid}/orders/{orderId}` path.
- **Auth:** `lib/core/services/auth_service.dart` — `AuthService` extends `GetxService`, provides `currentUser` with `id` field.
- **DI registration:** `lib/core/initial_binding.dart` — registers repositories as permanent singletons. `DashboardBinding` lazy-loads `NotificationsController`.
- **Firestore dependencies:** `cloud_firestore: ^5.6.6` already in `pubspec.yaml`
- **Conventions:** Imports use `package:sales_man/...`. Screen triples pattern. `UserModel` has `password` field excluded from JSON.

## Data Model / API Contract

### NotificationModel — Extended for Firestore

The existing `NotificationModel` needs `toFirestore()` and `fromFirestore()` methods added (mirroring the `Order` model pattern):

```
NotificationModel {
  id: String              // Firestore document ID
  type: NotificationType  // order | payment | visit | meeting | report
  title: String           // e.g., "New Order from Ali Super Mart"
  subtitle: String        // e.g., "3 items ₹8,300"
  time: String            // computed human-readable time (not stored)
  timestamp: DateTime     // when the notification was created
  isRead: bool            // default false, persisted to Firestore
  orderId: String         // reference to the source order
  eventType: String       // order_created | order_delivered | payment_received
}
```

### Firestore Schema

```
users/{uid}/notifications/{notificationId}
  - type: string (enum value)
  - title: string
  - subtitle: string
  - timestamp: string (ISO 8601)
  - isRead: boolean
  - orderId: string
  - eventType: string
```

### Deduplication Key

A unique constraint combination of `(orderId, eventType)` prevents duplicate notifications. Before creating a notification, query `users/{uid}/notifications/` where `orderId == X` and `eventType == Y`. If a match exists, skip creation.

## Dependencies & Integrations

- **Firestore** — already integrated; no new packages needed
- **Order data** — notifications are derived from orders in `users/{uid}/orders/`. The controller or a service will need to observe order changes to generate notifications.
- **Existing `IOrderRepository`** — may need extension or a new `INotificationRepository` interface

## Edge Cases & Error Handling

- **Offline / network failure:** Firestore's offline persistence (enabled by default in FlutterFire) will cache notifications. The controller should handle the snapshot stream naturally — Firestore handles reconnection.
- **Empty state:** When no notifications exist, the existing empty state UI (`Icons.notifications_off_outlined` + "No notifications") is already handled in `notifications_view.dart:81-101`.
- **Concurrent order edits:** If two devices update the same order simultaneously, the last write wins for `isDelivered`/`isCollected`. Notifications are append-only, so concurrent generation is safe — deduplication prevents duplicates.
- **Order deletion:** If an order is deleted, its notifications remain (orphaned but harmless). Could optionally clean up, but not required for MVP.
- **Timestamp formatting:** The `time` field is computed from `timestamp` at display time. Use `intl` package (already in dependencies) for relative time formatting.
- **Large notification lists:** No pagination needed for MVP — Firestore snapshots handle this efficiently for typical user scales. Add pagination if notification count exceeds ~500.

## Non-functional Requirements

- **Performance:** Firestore snapshot listener provides real-time updates without polling. Notification list renders via `ListView.builder` (already implemented) for efficient list rendering.
- **Security:** Notifications are stored under the authenticated user's document path (`users/{uid}/notifications/`). Firestore security rules must enforce that users can only read/write their own notifications. The `_uid` getter in `OrderRepository` pattern (throwing `StateError` if no authenticated user) should be replicated.
- **Accessibility:** N/A — no UI changes.
- **Scalability:** Per-user subcollection scales naturally. No cross-user queries needed.
- **Internationalization:** N/A — notification text is in English, matching existing app language.
- **Observability:** Firestore operations will log errors via existing `AppSnackbarService` pattern.

## Acceptance Criteria

- [ ] `NotificationModel` has `toFirestore()` and `fromFirestore()` methods
- [ ] A new `INotificationRepository` interface and `NotificationRepository` Firestore implementation exist
- [ ] `NotificationRepository` is registered in `InitialBinding`
- [ ] `NotificationsController` fetches notifications from Firestore via the repository
- [ ] Notifications are generated when orders are created, delivered, or collected
- [ ] Duplicate notifications for the same `(orderId, eventType)` are prevented
- [ ] `markAsRead()` persists `isRead: true` to Firestore
- [ ] `markAllAsRead()` persists `isRead: true` for all unread notifications
- [ ] `unreadCount` reflects the real unread notification count from Firestore
- [ ] The notification list updates in real-time when new notifications are added
- [ ] Existing UI (view, card, icon widget, tabs, search) works unchanged with real data
- [ ] `flutter analyze` passes with no new warnings

## Assumptions & Open Questions

1. **Order model lacks `deliveryDate` and `paymentDate` fields.** The prompt mentions these fields, but the actual `Order` model (`lib/core/models/order.dart`) only has `orderDate`, `isDelivered` (bool), and `isCollected` (bool). **Decision needed:** Should we (a) add `deliveryDate` and `paymentDate` fields to the Order model, (b) use `orderDate` + status booleans to infer notification timing, or (c) treat `isDelivered`/`isCollected` transitions as the notification triggers without specific dates?

2. **Notification generation trigger.** Notifications must be generated when orders change. Two approaches: (a) generate notifications in the `OrderRepository.saveOrder()` method (tightly coupled), or (b) create a separate `NotificationService` that observes order snapshots and generates notifications reactively. Recommendation: approach (b) for separation of concerns, consistent with the repository pattern.

3. **Existing `time` field semantics.** The current `NotificationModel.time` is a `String` (e.g., "10:45 AM", "Yesterday"). When moving to Firestore, this should be computed from `timestamp` at display time, not stored. The `time` field can remain as a computed getter or be removed in favor of direct `timestamp` formatting in the UI.

4. **Firestore security rules.** The spec assumes Firestore rules will be updated to allow read/write on `users/{uid}/notifications/`. This is an infrastructure concern outside the Flutter codebase.

5. **Scope of notification types.** The prompt focuses on order-related notifications. The `NotificationType` enum includes `visit`, `meeting`, and `report` — these remain as future work and are not generated from real data in this spec.

## Out of Scope / Future Considerations

- Push notifications via Firebase Cloud Messaging (FCM)
- Notification types for visits, meetings, and reports
- Notification preferences / settings (e.g., "don't notify me about X")
- Pagination for large notification lists
- Notification sound / vibration
- Batch notification generation for historical orders
- Admin/system notifications (e.g., "Your monthly report is ready")
