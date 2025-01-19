import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:alarm/model/notification_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medally_pro/views/nave_view/home_view/add_stock_views/add_stock_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:medally_pro/views/nave_view/home_view/home_controller.dart';
import '../../../../componants/medicin_card.dart';
import '../../../../const/constant_colors.dart';
import '../../../../const/contant_style.dart';
import '../add_medicine_view/edit_contant_view.dart';

class MedicineListView extends StatelessWidget {
  const MedicineListView({super.key});

  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.put(HomeController());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Active Medicine',
          style: kSubTitle2B.copyWith(color: kWhit),
        ),
        backgroundColor: kPriemryColor,
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: homeController.getUserMedicationStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Error loading medication data'),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No Active Medicine added yet'),
            );
          }
          final medications = snapshot.data!.docs;
          return ListView.builder(
            itemCount: medications.length,
            itemBuilder: (context, index) {
              final medicationData = medications[index].data();
              final medicineName = medicationData['medicineName'] ?? 'Unknown';
              final doctorName = medicationData['doctorName'] ?? 'N/A';
              final reminderTime = medicationData['reminderTime'] ?? 'N/A';
              final strength = medicationData['strength'] ?? 'N/A';
              final durationTime =
                  medicationData['duration']?.toString() ?? 'N/A';
              final remainingDose = int.tryParse(
                    medicationData['remainingDose']?.toString() ?? '0',
                  ) ??
                  0;
              final memberName = medicationData['memberName'] ?? 'N/A';
              final stockReminder = medicationData['stockReminder'] ?? false;
              final stockReminderPills = int.tryParse(
                    medicationData['stockReminderPills']?.toString() ?? '0',
                  ) ??
                  0; // Fallback to 0 if parsing fails
              final medicineImage =
                  medicationData['picture'] ?? Icons.dangerous_outlined;

              if (stockReminder == true &&
                  remainingDose == stockReminderPills) {
                // Set an alarm reminder
                final alarmSettings = AlarmSettings(
                  id: 1,
                  dateTime: DateTime.now(),
                  assetAudioPath: 'assets/alarm.mp3',
                  loopAudio: true,
                  vibrate: true,
                  volume: 0.8,
                  fadeDuration: 3.0,
                  androidFullScreenIntent: true,
                  notificationSettings: const NotificationSettings(
                    title: 'Medicine Stock Reminder',
                    body: 'It’s time to refill your medicine.',
                    stopButton: 'STOP',
                    icon: 'notification_icon',
                  ),
                );

                Alarm.set(alarmSettings: alarmSettings);
              }

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: MedicineCard(
                  onTap: () async {
                    final url = 'https://google.com/search?q=$medicineName';
                    final uri = Uri.parse(url);

                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri,
                          mode: LaunchMode.externalApplication);
                    } else {
                      Get.snackbar(
                        "Error",
                        "Cannot launch $url",
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: Colors.red,
                      );
                    }
                  },
                  medicineName: medicineName,
                  doctorName: doctorName,
                  durationTime: durationTime,
                  time: reminderTime,
                  remainingDose: remainingDose.toString(),
                  memberName: memberName,
                  image: medicineImage,
                  editOnTap: () {
                    Get.to(
                      () => EditMedicineView(
                        documentId: medications[index].id,
                      ),
                    );
                  },
                  medTakenOnTap: () async {
                    try {
                      final docSnapshot = await FirebaseFirestore.instance
                          .collection('usersMemberList')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection('medication')
                          .doc(medications[index].id)
                          .get();

                      if (docSnapshot.exists) {
                        int currentIntake = int.tryParse(
                              docSnapshot['remainingDose']?.toString() ?? '0',
                            ) ??
                            0;
                        int updatedIntake = currentIntake - 1;

                        await FirebaseFirestore.instance
                            .collection('usersMemberList')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection('medication')
                            .doc(medications[index].id)
                            .update(
                                {'remainingDose': updatedIntake.toString()});

                        Get.snackbar(
                          "Success",
                          "Medication successfully taken",
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: Colors.green,
                        );
                      } else {
                        Get.snackbar(
                          "Error",
                          "Document does not exist",
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: Colors.red,
                        );
                      }
                    } catch (e) {
                      Get.snackbar(
                        "Error",
                        "Failed, something went wrong: $e",
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: Colors.red,
                      );
                    }
                  },
                  deleteOnTap: () async {
                    try {
                      await FirebaseFirestore.instance
                          .collection('usersMemberList')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection('medication')
                          .doc(medications[index].id)
                          .delete();

                      Get.snackbar(
                        "Success",
                        "Medication deleted successfully",
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: Colors.green,
                      );
                    } catch (e) {
                      Get.snackbar(
                        "Error",
                        "Failed to delete medication: $e",
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: Colors.red,
                      );
                    }
                  },
                  stockReminderOnTap: () => Get.to(
                    AddStockView(
                      docId: medications[index].id,
                    ),
                  ),
                  stockText:
                      stockReminder == true ? 'Update Remi' : 'Stock Remi',
                  strength: strength,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
