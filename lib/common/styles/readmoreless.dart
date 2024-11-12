import 'package:flutter/cupertino.dart';
import 'package:readmore/readmore.dart';

class ReadMoreLess extends StatelessWidget {
  ReadMoreLess({super.key, required this.data});

  String data;
  @override
  Widget build(BuildContext context) {
    return ReadMoreText(
      data,
      moreStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      lessStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      trimCollapsedText: 'Show More',
      trimExpandedText: 'Less',
      trimMode: TrimMode.Line,
    );
  }
}
