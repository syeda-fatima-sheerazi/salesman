import 'package:get/get.dart';
import 'package:practices/core/screens/statement/statement_view_controller.dart';

class StatementBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: Add Statement controller when available.
    Get.lazyPut<StatementViewController>(() => StatementViewController());
  }
}
