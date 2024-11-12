import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:core';

import 'package:intl/intl.dart';
import 'package:nepali_utils/nepali_utils.dart';

import '../controller/calendarnavcontroller.dart';
import '../data/YearMappingService.dart';
import '../data/monthmodel.dart';
import '../maps.dart';
import 'calendarAppBar.dart';
import 'calendarDaysrow.dart';
import 'calendardaysGrid.dart';
import 'eventslist.dart';
import 'eventtile.dart';

class CalendarScreen extends StatelessWidget {
  CalendarScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final CalendarNavigationController calendarNavigationController =
        Get.put(CalendarNavigationController(), tag: UniqueKey().toString());
    final year = calendarNavigationController.year.value;
    return SafeArea(
        child: Scaffold(
            appBar: CalendarAppbar(),
            body: PageView.builder(
              itemCount: year.months.length,
              scrollDirection: Axis.horizontal,
              onPageChanged: (value) => calendarNavigationController
                  .currentMonth.value = value, // Prevent scrolling in ListView
              itemBuilder: (context, index) {
                final Month month = year
                    .months[calendarNavigationController.currentMonth.value];
                return Calendar(
                  month: month,
                );
              },
            )));
  }
}

class Calendar extends StatelessWidget {
  Calendar(
      {super.key, required this.month,});
  Month month;
  CalendarNavigationController navigationController=Get.put(CalendarNavigationController());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Calendardaysrow(),
            CalendarDaysGrid(),
            EventDetailTile(
              
            ),
            Text(
              "Month Events",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            EvestsList()
          ],
        ),
      ),
    );
  }
}
