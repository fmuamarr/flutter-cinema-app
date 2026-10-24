import 'package:get/get.dart';

import '../controllers/reminder_controller.dart';

class ReminderBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ReminderController>()) {
      Get.lazyPut<ReminderController>(() => ReminderController());
    }
  }
}
