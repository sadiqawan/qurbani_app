import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:medally_pro/views/nave_view/chat/chat_view.dart';
import 'package:medally_pro/views/nave_view/profile_view/profile_view.dart';
import 'package:medally_pro/views/nave_view/search_view/search_view.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import '../../const/constant_colors.dart';
import '../../controller/app_controller.dart';
import 'home_view/home_view.dart';

class BottomNavbarScreen extends StatelessWidget {
  const BottomNavbarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppController appController = Get.put(AppController());
    List screens = const [HomeView(), ChatView(),SearchView(), ProfileView(), ];

    return Obx(
      () => Scaffold(
        body: screens[appController.currentIndex.value],
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(left: 7.w, right: 7.w, bottom: 10.h),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13),
              color: kPriemryColor,
            ),
            child: SalomonBottomBar(
              duration: const Duration(milliseconds: 900),
              selectedColorOpacity: .3,
              selectedItemColor: Colors.black,
              unselectedItemColor: Colors.white,
              onTap: (index) {
                appController.currentIndex.value = index;
              },
              currentIndex: appController.currentIndex.value,
              items: [
                SalomonBottomBarItem(
                  icon: const Icon(
                    Icons.home_outlined,
                    size: 27,
                  ),
                  title: const Text("Home"),
                ),
                SalomonBottomBarItem(
                  icon: const Icon(
                    Icons.chat,
                    size: 27,
                  ),
                  title: const Text("chat"),
                ),
                SalomonBottomBarItem(
                  icon: const Icon(
                    Icons.search_outlined,
                    size: 27,
                  ),
                  title: const Text("Search"),
                ),
                SalomonBottomBarItem(
                  icon: const Icon(
                    Icons.person_outline,
                    size: 27,
                  ),
                  title: const Text("Profile"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
