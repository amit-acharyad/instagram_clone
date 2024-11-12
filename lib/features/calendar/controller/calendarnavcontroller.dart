import 'package:get/get.dart';
import 'package:instagram_clone/features/calendar/data/YearMappingService.dart';
import 'package:nepali_utils/nepali_utils.dart';

import '../data/monthmodel.dart';

class CalendarNavigationController extends GetxController {
  static CalendarNavigationController get instance => Get.find();
  RxInt currentMonth = (NepaliDateTime.now().month - 1).obs;
  RxInt today = NepaliDateTime.now().day.obs;
  RxInt isSelected = NepaliDateTime.now().day.obs;
  Rx<Year> year = Year.empty().obs;
  @override
  void onInit() {
    // TODO: implement onInit
    year.value = generateYearModel();
    super.onInit();
  }

  void navigateToLeftMonth() {
    if (!(currentMonth.value == 0)) {
      currentMonth.value--;
    }
  }

  void navigateToRightMonth() {
    if (!(currentMonth.value == 11)) {
      currentMonth.value++;
    }
  }
}
