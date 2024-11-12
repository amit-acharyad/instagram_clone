import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/calendarnavcontroller.dart';
import '../data/YearMappingService.dart';
import '../data/monthmodel.dart';
import '../utilities.dart';
import 'calendarttile.dart';

class CalendarDaysGrid extends StatelessWidget {
   CalendarDaysGrid({
    super.key,
  });

  final CalendarNavigationController navigationController= Get.put(CalendarNavigationController());

  @override
  Widget build(BuildContext context) {
    final year = navigationController.year.value;
    return Obx(() {
      final Month month = year.months[navigationController.currentMonth.value];
      return ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 400,maxWidth: 500),
        child: GridView.builder(
          shrinkWrap: true,
          itemCount: month.days.length + month.start,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
          ),
          itemBuilder: (context, index) {
            if (index >= month.start) {
              final DayModel dayModel = month.days[index - month.start];
              return GestureDetector(
                onTap: () => navigationController.isSelected.value =
                    nepaliDigitsToNumber(dayModel.dayBS),
                child: CalendarTile(
                  day: dayModel,
                  start: month.start,
                ),
              );
            }
            return const SizedBox();
          },
        ),
      );
    });
  }
}
