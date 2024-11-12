import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';

import '../controller/calendarnavcontroller.dart';
import '../data/monthmodel.dart';
import '../maps.dart';
import '../utilities.dart';

class EvestsList extends StatelessWidget {
   EvestsList({
    super.key,
  });

  final CalendarNavigationController controller=Get.put(CalendarNavigationController());

  @override
  Widget build(BuildContext context) {
    final Year year = controller.year.value;
    return Obx(() {
      final Month month = year.months[controller.currentMonth.value];
      return Container(
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: month.days.length,
            itemBuilder: (context, index) {
              final today = month.days[index];
              final String event = today.event;
              if (!(event == '--')) {
                final nepaliDay = daysMapNepali[
                    ((nepaliDigitsToNumber(today.dayBS) + month.start) % 7)
                        .toString()];
                final englishDay = daysMapEnglish[
                    ((nepaliDigitsToNumber(today.dayBS) + month.start) % 7)
                        .toString()];
                final isHoliday = today.isHoliday ||
                    (nepaliDigitsToNumber(today.dayBS) + month.start) % 7 == 0;
                return ListTile(
                  leading: Column(
                    children: [
                      Text(
                        today.dayBS,
                        style: isHoliday
                            ? Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(color: Colors.red)
                            : Theme.of(context).textTheme.titleSmall,
                      ),
                      Text(
                        "${nepaliDay}बार",
                        style: isHoliday
                            ? Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(color: Colors.red)
                            : Theme.of(context).textTheme.titleSmall,
                      )
                    ],
                  ),
                  title: Text(
                    event,
                    style: isHoliday
                        ? Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(color: Colors.red)
                        : Theme.of(context).textTheme.titleSmall,
                  ),
                  trailing: Column(
                    children: [
                      Text(
                          '${DateFormat("MMM d,yyy").format(DateFormat('yyyy-M-d').parse(today.engDate))}'
                              .split(',')
                              .first,
                          style: isHoliday
                              ? Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(color: Colors.red)
                              : Theme.of(context).textTheme.titleSmall),
                      Text(englishDay,
                          style: isHoliday
                              ? Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(color: Colors.red)
                              : Theme.of(context).textTheme.titleSmall),
                    ],
                  ),
                );
              } else {
                return SizedBox();
              }
            }),
      );
    });
  }
}
