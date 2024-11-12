import 'package:flutter/material.dart';
import '../maps.dart';

class Calendardaysrow extends StatelessWidget {
  Calendardaysrow({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(7, (index) {
          final bool isSat = index == 6;
          return Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  (daysMapEnglish[((index + 1) % 7).toString()])
                      .toString()
                      .substring(0, 3),
                  style: isSat
                      ? Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: Colors.red)
                      : Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  "${daysMapNepali[((index + 1) % 7).toString()]}",
                  style: isSat
                      ? Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: Colors.red)
                      : Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}


