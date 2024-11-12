import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controller/calendarnavcontroller.dart';
import '../data/monthmodel.dart';
import '../maps.dart';
import '../utilities.dart';

class EventDetailTile extends StatelessWidget {
  EventDetailTile({
    super.key,
  });

  final CalendarNavigationController navigationController =
      Get.put(CalendarNavigationController());

  @override
  Widget build(BuildContext context) {
    final holidayBSDateStyle =
        Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.red);
    final holidayAdDateStyle =
        Theme.of(context).textTheme.labelSmall!.copyWith(color: Colors.red);
    final TextStyle? nonHolidayBSDateStyle =
        Theme.of(context).textTheme.titleMedium;
    final nonHolidayAdDateStyle = Theme.of(context).textTheme.bodySmall;
    return Obx(() {
      final Month month = navigationController
          .year.value.months[navigationController.currentMonth.value];
      final today = month.days[navigationController.isSelected.value - 1];
      final isHoliday = today.isHoliday ||
          (nepaliDigitsToNumber(today.dayBS) + month.start) % 7 == 0;
      final nepaliDay = daysMapNepali[
          ((nepaliDigitsToNumber(today.dayBS) + month.start) % 7).toString()];
      final englishDay = daysMapEnglish[
          ((nepaliDigitsToNumber(today.dayBS) + month.start) % 7).toString()];
      final sum =
          interMediateMonthsDaysSum(navigationController.currentMonth.value);
      final isSelected = navigationController.isSelected.value + sum;

      return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).cardColor.withOpacity(0.3)),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Text(
                    today.dayBS,
                    style:
                        isHoliday ? holidayBSDateStyle : nonHolidayBSDateStyle,
                  ),
                  Text(
                    nepaliDay + 'बार',
                    style:
                        isHoliday ? holidayBSDateStyle : nonHolidayBSDateStyle,
                  ),
                  Text(
                    englishDay,
                    style:
                        isHoliday ? holidayAdDateStyle : nonHolidayAdDateStyle,
                  )
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat("MMM d,yyy")
                        .format(DateFormat('yyyy-M-d').parse(today.engDate)),
                    style:
                        isHoliday ? holidayBSDateStyle : nonHolidayBSDateStyle,
                  ),
                  Text(
                    today.tithi,
                    style:
                        isHoliday ? holidayAdDateStyle : nonHolidayAdDateStyle,
                  ),
                  !(today.event == '--')
                      ? Text(
                          today.event,
                          style: isHoliday
                              ? holidayAdDateStyle
                              : nonHolidayAdDateStyle,
                        )
                      : Text(''),
                  Text(
                    today.engDate,
                    style:
                        isHoliday ? holidayAdDateStyle : nonHolidayAdDateStyle,
                  )
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Text(
                    getDateString(isSelected, navigationController.today.value),
                    overflow: TextOverflow.ellipsis,
                  ),
                  getDateString(isSelected, navigationController.today.value) ==
                              ("Yesterday") ||
                          getDateString(isSelected,
                                  navigationController.today.value) ==
                              ("Tomorrow") ||
                          getDateString(isSelected,
                                  navigationController.today.value) ==
                              "Today"
                      ? const Text('')
                      : const Text("days")
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
