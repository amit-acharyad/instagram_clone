import 'dart:core';

class Month {
  String monthName;
  int start;
  List<DayModel> days;
  Month({required this.monthName, required this.days, required this.start});
  factory Month.fromMap(
      String monthName, Map<String, dynamic> days, int start) {
    try {
      List<DayModel> dayModels = [];
      days.forEach(
        (key, value) {
          dayModels.add(DayModel.fromMap(key, value));
        },
      );
      return Month(monthName: monthName, days: dayModels, start: start);
    } catch (e) {
      throw "Error encountered in monthModeling ${e.toString()}";
    }
  }
}

class Year {
  String yearName;
  List<Month> months;
  Year({required this.yearName, required this.months});
  static Year empty() => Year(yearName: "2081", months: []);
  factory Year.fromMap(String yearName, Map<String, dynamic> months) {
    try {
      List<Month> monthModels = [];

      months.forEach((key, value) {
        if (monthModels.isEmpty) {
          monthModels.add(Month.fromMap(key, value, 6));
        } else {
          final lastIndex = monthModels.length - 1;
          monthModels.add(Month.fromMap(
              key,
              value,
              (monthModels[lastIndex].start +
                      monthModels[lastIndex].days.length) %
                  7));
        }
      });
      return Year(yearName: yearName, months: monthModels);
    } catch (e) {
      throw "error in yearModeling ${e.toString()}";
    }
  }
}

class DayModel {
  final String dayBS;
  final String tithi;
  final String engDate;
  final String event;
  final bool isHoliday;
  DayModel(
      {required this.dayBS,
      required this.tithi,
      required this.engDate,
      required this.event,
      required this.isHoliday});
  factory DayModel.fromMap(String dayBS, Map<String, dynamic> day) {
    try {
      return DayModel(
          dayBS: dayBS,
          tithi: day['tithi'],
          engDate: day['engDate'],
          event: day['event'],
          isHoliday: day['isHoliday']);
    } catch (e) {
      throw "Error in dayModeling${e.toString()}";
    }
  }
}
