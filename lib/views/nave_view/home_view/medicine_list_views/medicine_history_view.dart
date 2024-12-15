import 'package:flutter/material.dart';

import '../../../../const/constant_colors.dart';
import '../../../../const/contant_style.dart';

class MedicineHistoryView extends StatelessWidget {
  const MedicineHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
        title: Text('Medicine History'),
    backgroundColor: kPriemryColor,
    centerTitle: true,
    titleTextStyle: kSubTitle2B.copyWith(color: kWhit),
    ),
    );
  }
}
