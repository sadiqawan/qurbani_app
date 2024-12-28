import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:medally_pro/const/constant_colors.dart';
import 'package:medally_pro/views/nave_view/home_view/add_membar/add_membar.dart';
import 'package:medally_pro/views/nave_view/home_view/add_membar/member_list_view.dart';
import 'package:medally_pro/views/nave_view/home_view/home_controller.dart';
import 'package:medally_pro/views/nave_view/home_view/medicine_list_views/medicine_history_view.dart';
import 'package:medally_pro/views/nave_view/home_view/medicine_list_views/medicine_list_view.dart';
import 'package:radial_button/widget/circle_floating_button.dart';
import '../../../componants/constant_container.dart';
import '../../../const/contant_style.dart';
import '../../../main.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeController homeController = Get.put(HomeController());


@override
  void initState() {
  // chickMedication();
  // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CircleFloatingButton.floatingActionButton(
        items: homeController.itemsActionBar,
        color: kPriemryColor,
        icon: Icons.add,
        duration: const Duration(milliseconds: 200),
        curveAnim: Curves.ease,
        useOpacity: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 50.h),
              child: Row(
                children: [
                  userImage(),

                  SizedBox(width: 5.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Welcome To 👋", style: kSubTitle2B),
                      Text(
                        "MedallyPro",
                        style: kSubTitle2B.copyWith(fontSize: 18.sp),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: Row(
                children: [
                  Expanded(
                      child: ConstantContainer(
                    text: 'Active Medicine',
                    iconData: Icons.access_time,
                    onTap: () => Get.to(MedicineListView()),
                  )),
                  SizedBox(
                    width: 5.w,
                  ),
                  Expanded(
                      child: ConstantContainer(
                    text: 'Medicine History',
                    iconData: Icons.history,
                    onTap: () => Get.to(MedicineHistoryView()),
                  )),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                    child: ConstantContainer(
                        text: 'Member List',
                        iconData: Icons.person,
                        onTap: () => Get.to(MemberListView()))),
                SizedBox(
                  width: 5.w,
                ),
                Expanded(
                    child: ConstantContainer(
                  text: 'Add New Member',
                  iconData: Icons.new_label_outlined,
                  onTap: () {
                    Get.to(AddMember());
                  },
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


Widget userImage() {
  HomeController controller = Get.put(HomeController());
  return StreamBuilder(
      stream: controller.getCurrentUserDataStream(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircleAvatar(
            maxRadius: 30.sp,
            backgroundColor: Colors.transparent,
            backgroundImage: const AssetImage("assets/images/icon_person.png"),
          );
        }
        var userData = snapshot.data?.data();
        if (userData == null || userData['picture'] == null) {
          return CircleAvatar(
            maxRadius: 30.sp,
            backgroundColor: Colors.transparent,
            backgroundImage: const AssetImage("assets/images/icon_person.png"),
          );

        } else {
          return CircleAvatar(
            maxRadius: 30.sp,
            backgroundImage: NetworkImage(userData!['picture']),
          );
        }
      });
}
