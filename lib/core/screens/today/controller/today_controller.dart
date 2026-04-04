import 'package:get/get.dart';

class TodayController extends GetxController {
  RxInt selectedTab = 0.obs;

  void changeTab(int index) {
    selectedTab.value = index;
  }
}
