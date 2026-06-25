import 'package:get/get.dart';
import 'package:practices/core/screens/todo/todo_controller.dart';

class TodoBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<TodoController>(TodoController());
  }
}
