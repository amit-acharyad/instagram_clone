import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nepali_utils/nepali_utils.dart';

import '../controller/calendarnavcontroller.dart';
import '../data/YearMappingService.dart';
import '../maps.dart';
import '../utilities.dart';

class CalendarAppbar extends StatelessWidget implements PreferredSizeWidget {
  CalendarAppbar({super.key,});
  CalendarNavigationController controller=Get.put(CalendarNavigationController());

  @override
  Widget build(BuildContext context) {
    final year = controller.year.value;
    return Obx(() {
      final nepaliMonth = nepaliMonthsMap[controller.currentMonth.toString()];
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisSize: MainAxisSize.min, // Shrink-wrap the row
            children: [
              IconButton(
                  onPressed: () => Get.back(), icon: Icon(Icons.arrow_back)),
              Expanded(
                flex: 5,
                child: Text(
                  "$nepaliMonth,${mapToNepali(NepaliDateTime.now().year)}",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Expanded(
                flex: 3,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_outlined),
                  onPressed: () {
                    controller.navigateToLeftMonth();
                  },
                ),
              ),
              Flexible(
                fit: FlexFit.loose,
                flex: 3,
                child: IconButton(
                  icon: const Icon(Icons.arrow_forward_ios_outlined),
                  onPressed: () {
                    controller.navigateToRightMonth();
                  },
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min, // Shrink-wrap the row
            children: [
              SizedBox(width: 40,),
              Expanded(
                flex: 3,
                child: Text(
                  "${nepaliToEnglishMonths[nepaliMonth]} ,${year.months[controller.currentMonth.value].days.last.engDate.split('-').first}",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ],
          )
        ]),
      );
    });
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}
