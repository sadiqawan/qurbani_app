import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:image_picker/image_picker.dart';
import 'package:medally_pro/views/nave_view/profile_view/profile_controller.dart';
import '../../../componants/custom_button.dart';
import '../../../const/constant_colors.dart';
import '../../../const/contant_style.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return _screen(context);
  }
}

Widget _screen(BuildContext context) {
  ProfileViewController profileViewController =
      Get.put(ProfileViewController());
  final format = DateFormat('MMMM dd yyyy');
  return Scaffold(
    appBar: AppBar(
      centerTitle: true,
      title: Text('Profile', style: kSubTitle2B,),
      backgroundColor: kPriemryColor,
    ),
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 20.h,
        ),
        Text(
          'PROFILE',
          style: kHeading2B,
        ),
        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: profileViewController.getUserDataStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Column(children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.h),
                  child: Center(
                    child: SizedBox(
                      height: 200.h,
                      width: 200.w,
                      child: Image.asset('assets/images/icon_profile.png'),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Get.bottomSheet(
                        backgroundColor: kWhit,
                        SizedBox(
                          height: 200,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Update Your Pic',
                                  style: kHeading2B,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Flexible(
                                        child: CustomButton(
                                            title: 'Select Camera',
                                            onTap: () {
                                              profileViewController
                                                  .pickImageFrom(
                                                      ImageSource.camera);
                                            })),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    Flexible(
                                      child: CustomButton(
                                          title: 'Select Gallery',
                                          onTap: () {
                                            profileViewController.pickImageFrom(
                                                ImageSource.gallery);
                                          }),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Update Pic',
                        style: kSubTitle2B,
                      ),
                      const Icon(Icons.edit_outlined),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),
                _widget(Icons.person_outline, 'Name'),
                _widget(Icons.email_outlined, 'Email'),
                _widget(Icons.watch_later_outlined, 'Time'),
              ]);
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData ||
                snapshot.data == null ||
                !snapshot.data!.exists) {
              return const Center(child: Text('No data available'));
            }

            var userData = snapshot.data!.data();
            // Convert the Firestore Timestamp to DateTime
            DateTime? time = userData?['time'] != null
                ? (userData?['time'] as Timestamp).toDate()
                : null;

            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.h),
                  child: userData!['picture'] == null
                      ? Center(
                          child: SizedBox(
                            height: 200.h,
                            width: 200.w,
                            child:
                                Image.asset('assets/images/icon_person.png'),
                          ),
                        )
                      : Center(
                          child: Container(
                            decoration: BoxDecoration(
                                color: kBlack,
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: NetworkImage(userData!['picture']),
                                    fit: BoxFit.cover),
                                border: Border.all(color: kBlack, width: 5)),
                            height: 200.h,
                            width: 200.w,
                            // child: Image.network(userData!['picture'])
                          ),
                        ),
                ),
                InkWell(
                  onTap: () {
                    Get.bottomSheet(
                        backgroundColor: kWhit,
                        SizedBox(
                          height: 200,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Update Your Pic',
                                  style: kHeading2B,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Flexible(
                                      child: CustomButton(
                                          title: 'Select Camera',
                                          onTap: () {
                                            profileViewController.pickImageFrom(
                                                ImageSource.camera);
                                            Get.back();
                                          }),
                                    ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    Flexible(
                                      child: CustomButton(
                                          title: 'Select Gallery',
                                          onTap: () {
                                            profileViewController.pickImageFrom(
                                                ImageSource.gallery);
                                            Get.back();
                                          }),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Update Pic',
                        style: kSubTitle2B,
                      ),
                      const Icon(Icons.edit_outlined),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),
                _widget(Icons.person_outline, userData?['name'] ?? 'No Name'),
                _widget(Icons.email_outlined, userData?['email'] ?? 'No Email'),
                _widget(Icons.watch_later_outlined,
                    time != null ? format.format(time) : 'No Time'),
              ],
            );
          },
        ),
        InkWell(
          onTap: () {
            Get.dialog(
              AlertDialog(
                backgroundColor: Colors.black,
                // Set the background color of the dialog
                title: Text(
                  'Logout Confirmation',
                  style: kSubTitle1.copyWith(color: kWhit),
                ),
                content: Text(
                  'Are you sure you want to log out?',
                  style: kSmallTitle1.copyWith(color: kWhit),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text(
                      'Cancel',
                      style: kSmallTitle1.copyWith(color: kWhit),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      profileViewController.logout();
                    },
                    child: Text(
                      'Logout',
                      style: kSmallTitle1.copyWith(color: Colors.red),
                    ),
                  ),
                ],
              ),
            );
          },
          child: _widget(Icons.login_outlined, 'Logout'),
        ),
      ],
    ),
  );
}

Widget _widget(IconData icon, String value) {
  return ListTile(
    leading: Icon(
      icon,
      size: 40,
    ),
    title: Text(
      value,
      style: kSubTitle2B,
    ),
  );
}
