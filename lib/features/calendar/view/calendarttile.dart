import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nepali_utils/nepali_utils.dart';

import '../controller/calendarnavcontroller.dart';
import '../data/monthmodel.dart';
import '../utilities.dart';

class CalendarTile extends StatelessWidget {
  CalendarTile({
    super.key,
    required this.day,
    required this.start,
  });
  DayModel day;
  int start;
  final CalendarNavigationController calendarNavigationController =
      Get.put(CalendarNavigationController());

  @override
  Widget build(BuildContext context) {
    final holidayBSDateStyle =
        Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.red);
    final holidayAdDateStyle =
        Theme.of(context).textTheme.labelSmall!.copyWith(color: Colors.red);
    final nonHolidayBSDateStyle = Theme.of(context).textTheme.titleLarge;
    final nonHolidayAdDateStyle = Theme.of(context).textTheme.bodySmall;
    return Obx(() {
      final isTodaySelected =
          (calendarNavigationController.currentMonth.value + 1 ==
                  NepaliDateTime.now().month &&
              calendarNavigationController.today.value ==
                  NepaliDateTime.now().day &&
              nepaliDigitsToNumber(day.dayBS) ==
                  calendarNavigationController.today.value);
      return Container(
        decoration: BoxDecoration(
            // Color.fromARGB(255, 4, 48, 70)
            color: isTodaySelected
                ? Color.fromARGB(255, 2, 40, 107)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
                width: 2,
                color: (nepaliDigitsToNumber(day.dayBS) ==
                        calendarNavigationController.isSelected.value)
                    ? Color(0xFF006400)
                    : Colors.transparent)),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topCenter, // First Text centered at the top
              child: Text(
                day.dayBS,
                style: isTodaySelected
                    ? Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: Colors.white)
                    : day.isHoliday ||
                            (nepaliDigitsToNumber(day.dayBS) + start) % 7 == 0
                        ? holidayBSDateStyle
                        : nonHolidayBSDateStyle,
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                day.engDate.split('-').last,
                style: isTodaySelected
                    ? Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.white)
                    : (day.isHoliday ||
                            (nepaliDigitsToNumber(day.dayBS) + start) % 7 == 0)
                        ? holidayAdDateStyle
                        : nonHolidayAdDateStyle,
              ),
            ),
          ],
        ),
      );
    });
  }
}
