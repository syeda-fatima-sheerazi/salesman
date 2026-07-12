# AGENT.md — SalesMan App

## 1. Project Overview

**Name:** SalesMan
**Type:** Offline-first Flutter workflow app for field salesmen — **not** an ecommerce app.

**Purpose:** Help a salesman track everything they must deliver, collect, and follow up on, every day, with minimum manual effort and minimum taps.

**Core modules:** Shops · Products · Orders · Deliveries · Collections · Today (daily schedule) · Notifications · Reports

---

## 2. Tech Stack

| Layer | Choice |
|---|---|
| Framework | Flutter |
| State management | **GetX only** |
| Local storage | SQLite (Repository Pattern) |
| Responsive units | flutter_screenutil |
| Backend services | Firebase (Auth + Push Notifications) |
| Maps / Location | Google Maps, Location |
| Motion | Lottie (sparingly — see §6) |

**Not allowed:** Provider, Riverpod, Bloc, Cubit, MobX.

---

## 3. Architecture — Feature-First

Every feature is self-contained. Do not let features import each other's internals.

```
lib/
  core/                    # shared: theme, constants, utils, base classes, network, DI
  screens/
    authentication/
    home/
    shops/
    products/
    orders/
    collections/
    today/
    notifications/
    reports/
    settings/
```

Each feature folder contains:

```
feature_name/
  bindings/
  controllers/
  views/
  widgets/
  models/
  repositories/
  services/
```

**Layering rule (strict, one direction only):**

```
View  →  Controller  →  Repository / Service  →  SQLite / Firebase
```

- Views only render state and forward user actions. No business logic, no direct DB calls.
- Controllers hold state and orchestrate calls. No SQLite/Firebase calls directly.
- Repositories are the only layer that touches SQLite.
- Services hold business rules/calculations (e.g. totals, remaining amount) that aren't pure data access.

---

## 4. State Management Rules

**Use:** `GetView`, `GetxController`, `Bindings`, `Get.find`/`Get.put` for DI, `Service` and `Repository` classes registered via bindings.

**Performance:**
- Wrap only the smallest widget that actually needs to react in `Obx`.
- Never nest `Obx` widgets.
- Prefer `.obs` on primitives/small models over rebuilding large widget trees.
- Avoid `StatefulWidget` unless GetX genuinely can't cover the case (e.g. `TextEditingController` lifecycle, animation controllers).

---

## 5. Responsive Design

Always use `flutter_screenutil`. Never hardcode raw pixel values.

| Don't | Do |
|---|---|
| `SizedBox(height: 20)` | `SizedBox(height: 20.h)` |
| `Container(width: 200)` | `Container(width: 200.w)` |
| `fontSize: 16` | `fontSize: 16.sp` |
| `BorderRadius.circular(12)` | `BorderRadius.circular(12.r)` |

Every screen must be tested against small phones, large phones, and tablets.

---

## 6. UI Design Principles

Style: simple, minimal, business-focused, professional, readable, fast.

- Follow the existing app theme (`core/theme`) — no ad hoc colors or text styles.
- Avoid fancy UI and unnecessary animations; Lottie only for meaningful states (empty state, success, loading), never decorative.
- Minimize taps to complete any workflow (this is a field-use app, often one-handed, often outdoors).
- No hardcoded colors or user-facing strings — pull from theme and a strings/localization file.

---

## 7. Code Style

- Follow SOLID; one widget = one responsibility; keep `build()` methods small.
- Extract reusable widgets instead of duplicating UI.
- Meaningful, descriptive names — no abbreviations that aren't obvious.
- Keep controllers focused — if a controller is doing more than one feature's job, split it.

**Naming conventions:**

| Element | Convention | Example |
|---|---|---|
| Files | snake_case | `order_repository.dart` |
| Classes | PascalCase | `OrderRepository` |
| Variables/methods | camelCase | `remainingAmount` |
| Constants | UPPER_CASE | `MAX_ORDER_ITEMS` |
| Private members | leading underscore | `_calculateTotal()` |

---

## 8. Data Models

Core models — keep each one focused on a single entity, never merge unrelated concerns:

- `UserModel`
- `ShopModel`
- `ProductModel`
- `ProductVariantModel`
- `OrderModel`
- `OrderItemModel`

Models are plain data holders (with `toMap`/`fromMap` for SQLite and `toJson`/`fromJson` for Firebase where needed) — no business logic inside models.

---

## 9. Order Workflow

**Entry points** (Place Order screen supports both):

| Entry point | Shop selection |
|---|---|
| Shop Detail screen | Pre-selected, locked |
| Today screen | User must select a shop |

**Order contains:** Shop, Products, Variants, Quantity, Order Date, Delivery Status, Payment Status, Delivery Date, Payment Date, Collected Amount, Remaining Amount, Total Bill, Notes.

**Calculated automatically (never user-entered):**
- `Total Bill` = sum of (variant price × quantity) across items
- `Remaining Amount` = `Total Bill` − `Collected Amount`

**User-entered:** `Collected Amount` only.

### Delivery Status

| Status | Delivery Date |
|---|---|
| Delivered | Auto-set to today |
| Scheduled | User picks a date (must be today or later) |

### Payment Status

| Status | Payment Date |
|---|---|
| Paid | Auto-set to today |
| Pending | User picks a date |

### Save Flow

```
Save Order
   → Validate (see §12)
   → Store in SQLite
   → Appears in Shop Detail → Orders (history)
   → Appears in Today screen automatically, grouped by Delivery Date
   → Reminder notification scheduled
   → Delivery happens → status updates
   → Collection happens → payment status updates
```

Orders are never moved between days manually — their appearance in Today is derived purely from `Delivery Date`/`Payment Date`, recomputed on read.

---

## 10. Shop Detail Screen

Three sections:
1. **Information** — shop profile, contact, location.
2. **Orders** — full order history for this shop (never delete, never truncate).
3. **Collections** — full payment history for this shop (never delete, never truncate).

---

## 11. Today Screen

Two tabs:

1. **Orders tab** — today's deliveries (by Delivery Date), with actions to mark delivered, reschedule, or edit items.
2. **Collections tab** — today's pending/expected payments (by Payment Date), with actions to record a collection, mark paid, or reschedule.

Both tabs read live from SQLite via the Order/Collection repositories — items are never manually dragged or moved between dates; editing an order's Delivery/Payment Date is what moves it.

---

## 12. Validation & Error Handling

- Validate every form before save; block save on invalid state (e.g. zero quantity, missing shop, missing date for "Scheduled"/"Pending").
- Show specific, actionable error messages (field-level, not generic "Something went wrong").
- Never persist a partially-valid order.
- Repository/service errors (SQLite, Firebase) are caught and surfaced to the controller as a typed result/exception — never let a raw exception reach the View.

---

## 13. Things to Avoid

Hardcoded colors or strings · duplicated UI · DB code inside Views · giant controllers · non-responsive units · unnecessary `StatefulWidget` · nested `Obx` · manually reordering Today items · breaking feature isolation.

---
## Security

- **Secrets never committed.** `google-services.json`, `GoogleService-Info.plist`, any `.env`, and OAuth client IDs/secrets must be in `.gitignore` — commit only `*.example` templates if needed for onboarding.
- **Password storage:** if hashing is done manually (not delegated to Firebase Auth), never use a bare hash (e.g. plain SHA-256) — use a salted, slow hash (bcrypt/argon2/PBKDF2). Flag and fix before any release build.
- **Local DB (SQLite):** treat it as unencrypted by default. Don't store payment credentials, OTPs, or tokens in it unencrypted — session tokens belong in `SharedPreferences`/secure storage, not the `users` table.
- **Firebase rules:** every Firestore/Realtime DB rule must scope reads/writes to the authenticated user's own data (`request.auth.uid == resource.data.ownerId`) — no open read/write rules, even temporarily, past local testing.
- **API keys:** Google Maps / Firebase keys go through platform-level restriction (Android package name + SHA-1, iOS bundle ID, HTTP referrer for web) — not just relying on obscurity.
- **Input validation:** every field that reaches SQLite or Firebase goes through `AppValidators` first — no raw user input in queries (use parameterized `sqflite` queries, never string-concatenated SQL).
- **Dependency hygiene:** run `flutter pub outdated` before each release; don't let auth-adjacent packages (`firebase_auth`, `crypto`, `sqflite`) drift far behind.
- **Logging:** never log passwords, tokens, or full user payloads in release builds — wrap debug prints so they're stripped/no-op in release (`if (kDebugMode)`).

---

## Testing & Docs

**Testing priorities (in order, for a solo/small-team app):**

1. **Repositories & Services** — pure logic, no widgets, cheapest to test and most likely to hide real bugs (e.g. `Total Bill`/`Remaining Amount` calculations, delivery/payment status transitions).
2. **Controllers** — state transitions (e.g. does saving an order actually update the Today list without needing a manual refresh?).
3. **Widgets** — only for complex custom widgets, not simple display components.
4. Skip exhaustive UI/golden tests until the app is stable — not worth the maintenance cost pre-1.0.

**Conventions:**
- Delete/replace the default `test/widget_test.dart` (counter test) — a failing default test is worse than no test, since it trains you to ignore red CI.
- One test file per class under test: `order_repository_test.dart` for `OrderRepository`, etc., mirroring the `lib/` feature path inside `test/`.
- Use an in-memory or temp SQLite DB for repository tests — never point tests at a real device DB file.
- Run `flutter test` and `flutter analyze` before every push, not just before release.

**Docs:**
- Every `Repository`/`Service` public method gets a one-line `///` doc comment stating what it does and any non-obvious side effect (e.g. "marks order Delivered and sets `deliveryDate` to today").
- Keep this AGENT.md as the single source of truth for architecture/conventions — if a convention changes, update it in the same PR, not "later."
- README covers: setup (`flutter pub get`, Firebase config steps), how to run, and a link to this AGENT.md for contribution rules.

---

## Git Commit Style

**Format (Conventional Commits, scoped to feature folder):**

## 14. Workflow for Adding a New Feature

1. Understand the business workflow first.
2. Design the SQLite schema.
3. Design the models.
4. Design the UI (following §6).
5. Implement the repository (DB access only).
6. Implement the service (business rules/calculations, if any).
7. Implement the controller (state + orchestration).
8. Implement the views/widgets.
9. Review against architecture rules (§3–§4) before merging.

---

## 15. AI Agent Checklist

Before generating code, confirm:

- [ ] Follows Feature-First architecture and the View → Controller → Repository/Service → DB layering
- [ ] Uses GetX only (no other state management)
- [ ] Fully responsive (`.h` / `.w` / `.sp` / `.r`, no raw pixels)
- [ ] No hardcoded colors/strings
- [ ] Minimal taps, minimal cognitive load for a field salesman
- [ ] Simple, readable, small widgets/methods
- [ ] Reusable rather than duplicated

**If any box is unchecked: stop and redesign before writing code.**

---

## 16. Goal

Production-quality salesman management app. Priorities, in order: correctness of business workflow → clean architecture/maintainability → simple, fast UI. Not visual complexity.
