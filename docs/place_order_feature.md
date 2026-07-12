We are developing a Flutter SalesMan Management Application using GetX, SQLite and flutter_screenutil.

This feature should follow our existing project architecture, AGENT.md,

Do not create a new architecture.

Use our existing theme and reusable widgets.

The UI should be minimal, business-oriented, clean and easy to understand.

The target users are field salesmen, therefore the workflow must require minimum taps.

-------------------------------------------------------------------

FEATURE

Implement "Place Order" workflow.

This feature starts from Shop Detail Screen.

Current Status:

The Shop Detail screen is already completed.

A Floating Action Button (FAB) already exists.

When the user taps the FAB, navigate to Place Order Screen.

-------------------------------------------------------------------

STEP 1

PLACE ORDER SCREEN

When this screen opens:

Automatically display

• Shop Name (Read Only)

• Current Order Date (Read Only)

These values are passed from Shop Detail.

The user should not edit them.

-------------------------------------------------------------------

STEP 2

INITIAL STATE

Initially no products are selected.

Display an empty state.

Show two options.

Primary Action

Add Products

Secondary Action

Quick Order (Without Selecting Products)

Display the word "OR" between these two actions.

The Primary Action should be visually more prominent than the Secondary Action.

-------------------------------------------------------------------

STEP 3

ADD PRODUCTS FLOW

When the user taps

"Add Products"

Navigate to Product Selection Screen.

This screen already contains all available products.

The user can:

• Search Products

• Select Products

• Select Product Variants

• Increase Quantity

• Decrease Quantity

As products are selected they should immediately appear inside an internal cart.

Do NOT create a separate Cart Screen.

Keep everything inside Product Selection Screen.

Display a sticky bottom button.

Example

Done (3 Products)

When Done is pressed

Return to Place Order Screen.

-------------------------------------------------------------------

STEP 4

PLACE ORDER AFTER PRODUCT SELECTION

When the user returns:

Hide the empty state.

Display selected products.

Each selected product should contain

Product Name

Variant

Quantity Controls (+ -)

Price

Remove Button

The user can edit quantities directly from this screen.

All calculations must update automatically.

-------------------------------------------------------------------

STEP 5

ORDER SUMMARY

Below the product list display

Total Bill

Collected Amount

Remaining Amount

Rules

Total Bill

Automatically calculated.

Collected Amount

Editable.

Default value = 0.

Remaining Amount

Automatically calculated.

Remaining = Total - Collected.

The user must never manually enter Remaining Amount.

-------------------------------------------------------------------

STEP 6

PAYMENT STATUS

Display Payment Status.

Use a clean dropdown or segmented selector.

Options

Paid

Peyment Date

If user select Paid:

Automatically save Payment Date as Today.

Hide Payment Due Date.

If user select Payment Date:

Show

a neat and clean celnader (mini calander) 

The user selects a future payment date.

-------------------------------------------------------------------

STEP 7

DELIVERY STATUS

Display Delivery Status.

Options

Delivered

Delivery Date

If Delivered

Automatically use Today's Date.

Hide Delivery Date picker.

If Scheduled Delivery

Display

Delivery Date Picker.

The user selects the future delivery date.

-------------------------------------------------------------------
STEP 8

NOTES & ATTACHMENTS

Before saving the order, allow the user to add additional information.

Display an optional Notes field.

The salesman can write any remarks related to the order.

Examples:

• Customer requested fresh stock.
• Deliver after 2 PM.
• Payment will be made on Friday.
• Owner was unavailable.
• Call before delivery.

Below the Notes field, display an Attachments section.

The user should be able to:

• Capture photos using the camera.
• Select multiple images from the gallery.
• Preview selected images.
• Remove unwanted images before saving.

These attachments become part of the order and are permanently linked to it.

Attachments are used as proof and business references, such as:

• Handwritten order slip
• Customer invoice
• Shop shelf photo
• Payment receipt
• Delivery proof
• Product display photo
• Any image related to the order

Each order may contain multiple attachments.

Do not store images directly in the Order table.

Use a separate OrderAttachment model and database table linked to the Order using orderId.

On the Order Detail screen, display all attachments in a grid. The user should be able to tap any image to view it in full screen.

Attachments are optional but should be securely stored as part of the order record.

STEP 8.5

SAVE ORDER

Display one large button.

Save Order

Validate

Shop exists.

If using products

At least one product selected.

Collected Amount <= Total Bill.

If validation passes

Save Order into SQLite.

-------------------------------------------------------------------

STEP 9

AFTER ORDER IS SAVED

The order should immediately become available in TWO places.

FIRST

Inside Shop Detail.

There should be an Orders History section.

Every order placed for this shop should permanently appear there.

Each order card should display

Order Date

Delivery Status

Payment Status

Total Bill

View Details Button

This history should never disappear.

Even if delivery is after 10 days.

SECOND

The order should automatically appear inside Today Module according to Delivery Date.

Examples

Delivery Date = Today

→ Show in Today filter.

Delivery Date = Tomorrow

→ Show in Tomorrow filter.

Delivery Date = Future

→ Automatically appear on the correct date.

Do NOT manually move orders.

The application should manage this automatically using Delivery Date.

-------------------------------------------------------------------

STEP 10

ORDER DETAIL SCREEN

When View Details is pressed

Open Order Detail Screen.

Display

Shop Information

Order Information

Product List

Total Bill

Collected Amount

Remaining Amount

Payment Status

Delivery Status

Payment Date

Delivery Date

Notes

Display action buttons depending on status.

Examples

Edit Order

Mark Delivered

Mark Paid

Delete Order

The UI should remain clean.

Do not overload the screen.

-------------------------------------------------------------------

QUICK ORDER FLOW

If the user selects

Quick Order

Do NOT open Product Selection.

Instead

Display

Total Bill

Collected Amount

Remaining Amount

Payment Status

Delivery Status

Notes

Allow saving the order without selecting products.


One Shop can have many Orders.

One Order can contain many Products.

Products are optional only in Quick Order mode.

Order History must always remain inside Shop Detail.

Today Screen is only a dynamic reminder screen.

Shop Detail is the permanent history screen.

Delivery Date controls which tab (Today, Tomorrow, Future) the order appears in.

Never duplicate business logic.

Keep UI simple.
This workflow exists because in some real business cases the salesman only knows the total amount and does not need to record individual products.

-------------------------------------------------------------------

IMPORTANT BUSINESS RULES

Keep wording easy.

Avoid technical language.

Avoid fancy animations.

Target users are field salesmen.

Always follow existing project theme, architecture and coding standards.