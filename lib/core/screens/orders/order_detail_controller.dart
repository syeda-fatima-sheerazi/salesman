import 'package:get/get.dart';
import 'package:practices/core/models/order.dart';
import 'package:practices/core/models/order_attachment.dart';
import 'package:practices/core/screens/orders/repositories/order_repository.dart';
import 'package:practices/core/services/snackbar/app_snackbar_service.dart';

class OrderDetailController extends GetxController {
  final String orderId;
  final OrderRepository _repository = OrderRepository();

  final Rx<Order?> order = Rx<Order?>(null);
  final RxList<OrderAttachment> attachments = <OrderAttachment>[].obs;
  final RxBool isLoading = true.obs;

  OrderDetailController({required this.orderId});

  @override
  void onInit() {
    super.onInit();
    loadOrder();
  }

  Future<void> loadOrder() async {
    isLoading.value = true;
    try {
      final loaded = await _repository.getOrderById(orderId);
      order.value = loaded;
      if (loaded != null) {
        final atts = await _repository.getAttachmentsByOrderId(orderId);
        attachments.assignAll(atts);
      }
    } catch (e) {
      AppSnackbarService.error('Failed to load order', title: 'Error');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markDelivered() async {
    final o = order.value;
    if (o == null) return;
    o.isDelivered = true;
    o.deliveryDate = DateTime.now();
    await _repository.updateOrder(o);
    order.refresh();
    AppSnackbarService.success('Order marked as delivered', title: 'Success');
  }

  Future<void> markPaid() async {
    final o = order.value;
    if (o == null) return;
    o.isCollected = true;
    o.paymentDate = DateTime.now();
    await _repository.updateOrder(o);
    order.refresh();
    AppSnackbarService.success('Order marked as paid', title: 'Success');
  }

  Future<void> deleteOrder() async {
    await _repository.deleteOrder(orderId);
    AppSnackbarService.success('Order deleted', title: 'Success');
    Get.back(result: true);
  }
}
