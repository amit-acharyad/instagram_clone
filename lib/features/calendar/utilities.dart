import 'package:instagram_clone/features/calendar/controller/calendarnavcontroller.dart';
import 'package:nepali_utils/nepali_utils.dart';

import 'data/YearMappingService.dart';
import 'maps.dart';

String mapToNepali(int dayBs) {
  List<String> list = [];
  while (dayBs > 0) {
    int rem = dayBs % 10;
    dayBs = dayBs ~/ 10;
    list.add(rem.toString());
  }
  String dateInNepali = '';
  for (String day in list.reversed.toList()) {
    final dat = nepaliDigitsMapStrings[day];
    dateInNepali = dateInNepali + dat.toString();
  }
  return dateInNepali;
}

String getDateString(int isSelected, int today) {
  final difference = isSelected - today;

  if (difference == 0) {
    return "Today";
  } else if (difference == -1) {
    return "Yesterday";
  } else if (difference == 1) {
    return "Tomorrow";
  } else if (difference < 0) {
    return "${-difference} days ago";
  } else {
    return "After $difference";
  }
}

int interMediateMonthsDaysSum(int currentMonth) {
  try {
    final year = CalendarNavigationController.instance.year.value;
    int sum = 0;
    int monthNow = NepaliDateTime.now().month - 1;
    for (int i = currentMonth < monthNow ? currentMonth : monthNow;
        i < (currentMonth < monthNow ? monthNow : currentMonth);
        i++) {
      sum += year.months[i].days.length;
    }
    currentMonth < monthNow ? sum = (-sum) : sum = sum;
    return sum;
  } catch (e) {
    print("Error is ${e.toString()}");
    return 0;
  }
}

int nepaliDigitsToNumber(String nepaliString) {
  int result = 0;

  // Iterate through each character in the Nepali digit string
  for (int i = 0; i < nepaliString.length; i++) {
    String digit = nepaliString[i];
    // Check if the character is in the map and accumulate the result
    if (nepaliDigitsMap.containsKey(digit)) {
      result = result * 10 + nepaliDigitsMap[digit]!;
    } else {
      throw FormatException('Invalid character: $digit');
    }
  }

  return result;
}
