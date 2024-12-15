import 'package:flutter/material.dart';

import '../../../../const/constant_colors.dart';
import '../../../../const/contant_style.dart';

class MedicineListView extends StatelessWidget {
  const MedicineListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Member List'),
        backgroundColor: kPriemryColor,
        centerTitle: true,
        titleTextStyle: kSubTitle2B.copyWith(color: kWhit),
      ),
    );
  }
}
