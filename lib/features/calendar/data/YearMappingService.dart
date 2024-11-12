import 'dart:core';
import 'package:get/get.dart';

import 'calendardata.dart';
import 'monthmodel.dart';

Year generateYearModel() {
  try {
    final Map<String, dynamic> yearMap = {};
    print("Data types is${year2081["2081"].runtimeType}");
    for (var map in year2081["2081"]) {
      yearMap.addAll(map);
    }
    Year _year = Year.fromMap("2081", yearMap);

    return _year;
  } catch (e) {
    throw "Error could not generate year Models ${e.toString()}";
  }
}
