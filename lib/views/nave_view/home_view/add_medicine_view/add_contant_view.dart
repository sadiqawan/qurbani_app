import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medally_pro/views/nave_view/home_view/add_medicine_view/text_scan_view.dart';
import 'package:medally_pro/views/nave_view/home_view/home_controller.dart';
import '../../../../componants/custom_button.dart';
import '../../../../componants/custom_text_feild.dart';
import '../../../../const/constant_colors.dart';
import '../../../../const/contant_style.dart';
import 'add_contant_view_controller.dart';

class AddMedicineView extends StatefulWidget {
  const AddMedicineView({super.key});

  @override
  State<AddMedicineView> createState() => _AddMedicineViewState();
}

class _AddMedicineViewState extends State<AddMedicineView> {
  final AddMedicineController controller = Get.put(AddMedicineController());
  final HomeController homeController = Get.put(HomeController());
  final TextEditingController medicineController = TextEditingController();
  final TextEditingController strengthController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController doctorController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController doseController = TextEditingController();
  final TextEditingController memController = TextEditingController();
  TimeOfDay? selectedTime;
  TimeOfDay? secondSelectedTime;
  TimeOfDay? thirdSelectedTime;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Medicine'),
        backgroundColor: kPriemryColor,
        centerTitle: true,
        titleTextStyle: kSubTitle2B.copyWith(color: kWhit),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Enter Medicine name:',
                  style: kSmallTitle1.copyWith(color: Colors.black)),
              SizedBox(height: 10.h),


              CustomTextFeild(
                hint: 'Medicine Name',
                controller: medicineController,
                icon: Icons.medical_information_outlined,
                surfixicon: Icons.qr_code_scanner,
                surfixiconOntap: () async {
                  final extractedText = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TextScannerView(
                        onTextExtracted: (text) {},
                      ),
                    ),
                  );
                  if (extractedText != null && extractedText is String) {
                    medicineController.text = extractedText;
                  }
                },
              ),

              // CustomTextFeild(
              //   hint: 'Medicine Name',
              //   controller: medicineController,
              //   icon: Icons.medical_information_outlined,
              //   surfixicon: Icons.qr_code_scanner,
              //   surfixiconOntap: () {
              //
              //   },
              // ),
              SizedBox(height: 15.h),

              _buildInputField(
                'Enter Strength:',
                strengthController,
                'Strength',
                Icons.format_list_numbered,
              ),
              _buildInputField(
                'Enter Note (Optional):',
                noteController,
                'Medicine Note',
                Icons.note_alt_outlined,
                maxLines: 3,
              ),
              _buildInputField(
                'Suggested by (Optional):',
                doctorController,
                'Doctor Name',
                Icons.person,
              ),
              _buildInputField(
                'Duration (in days):',
                durationController,
                'Duration',
                Icons.format_list_numbered_rounded,
                isNumber: true,
              ),
              _buildInputField(
                'Dose/Intake per day:',
                doseController,
                'Dose',
                Icons.format_list_numbered_rounded,
                isNumber: true,
              ),
              SizedBox(height: 5.h),
              Text(
                'Select Member',
                style: kSmallTitle1,
              ),
              SizedBox(height: 10.h),
              memberWidget(),
              SizedBox(height: 10.h),
              Text(
                'Select Remainder',
                style: kSmallTitle1,
              ),
              SizedBox(height: 10.h),
              // Time Picker
              InkWell(
                onTap: () async {
                  TimeOfDay? time = await showTimePicker(
                    context: context,
                    initialTime: selectedTime ?? TimeOfDay.now(),
                  );
                  if (time != null) {
                    setState(() {
                      selectedTime = time;
                    });
                  }
                },
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 15.h),
                  decoration: BoxDecoration(
                    color: kPriemryColor,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedTime != null
                            ? selectedTime!.format(context)
                            : 'Select Time',
                        style: kSmallTitle1.copyWith(color: Colors.black),
                      ),
                      Icon(Icons.access_time, color: Colors.black),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15.h),

              // second time alarm
              Text(
                'Select other 2nd Remainder (Optional)',
                style: kSmallTitle1,
              ),
              SizedBox(height: 15.h),
              InkWell(
                onTap: () async {
                  TimeOfDay? time = await showTimePicker(
                    context: context,
                    initialTime: secondSelectedTime ?? TimeOfDay.now(),
                  );
                  if (time != null) {
                    setState(() {
                      secondSelectedTime = time;
                    });
                  }
                },
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 15.h),
                  decoration: BoxDecoration(
                    color: kPriemryColor,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        secondSelectedTime != null
                            ? secondSelectedTime!.format(context)
                            : 'Select Time',
                        style: kSmallTitle1.copyWith(color: Colors.black),
                      ),
                      Icon(Icons.access_time, color: Colors.black),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15.h),

              // third remainder
              Text(
                'Select other 3rd Remainder (Optional)',
                style: kSmallTitle1,
              ),
              SizedBox(height: 15.h),

              InkWell(
                onTap: () async {
                  TimeOfDay? time = await showTimePicker(
                    context: context,
                    initialTime: thirdSelectedTime ?? TimeOfDay.now(),
                  );
                  if (time != null) {
                    setState(() {
                      thirdSelectedTime = time;
                    });
                  }
                },
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 15.h),
                  decoration: BoxDecoration(
                    color: kPriemryColor,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        thirdSelectedTime != null
                            ? thirdSelectedTime!.format(context)
                            : 'Select Time',
                        style: kSmallTitle1.copyWith(color: Colors.black),
                      ),
                      Icon(Icons.access_time, color: Colors.black),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 15.h),
              // Text(
              //   'Set Stock Remainder (Optional)',
              //   style: kSmallTitle1,
              // ),
              // SizedBox(height: 15.h),

              /* InkWell(
                onTap: () => Get.to(AddStockView()),
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 15.h),
                  decoration: BoxDecoration(
                    color: kPriemryColor,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Stock Reminder',
                        style: kSmallTitle1.copyWith(color: Colors.black),
                      ),
                      Icon(Icons.add, color: Colors.black),
                    ],
                  ),
                ),
              ),*/

              // third remainder

              SizedBox(height: 15.h),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 15.h),
                child: Center(
                  child: SizedBox(
                    height: 200.h,
                    width: 200.w,
                    child: Obx(() {
                      return controller.image.value == null
                          ? Icon(
                              Icons.medical_services_outlined,
                              size: 200,
                            )
                          : Image.file(
                              controller.image.value!,
                              fit: BoxFit.fill,
                            );
                    }),
                  ),
                ),
              ),

              InkWell(
                onTap: () {
                  Get.bottomSheet(
                      backgroundColor: kWhit,
                      SizedBox(
                        height: 180,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Upload Pic',
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
                                        controller
                                            .pickImageFrom(ImageSource.camera);
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  Flexible(
                                    child: CustomButton(
                                        title: 'Select Gallery',
                                        onTap: () {
                                          controller.pickImageFrom(
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
                    const Icon(
                      Icons.upload,
                      size: 30,
                    ),
                    Text(
                      'Upload Pic',
                      style: kSubTitle2B,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Center(
                child: Obx(
                  () {
                    return CustomButton(
                      title: controller.isLoading.value
                          ? 'Submitting...'
                          : 'Submit',
                      onTap: () {
                        if (!controller.isLoading.value) {
                          if (selectedTime != null) {
                            final now = DateTime.now();

                            // Convert selected TimeOfDay to DateTime for the first alarm
                            final alarmDateTime = DateTime(
                              now.year,
                              now.month,
                              now.day,
                              selectedTime!.hour,
                              selectedTime!.minute,
                            );

                            // Define AlarmSettings for the first alarm
                            final alarmSettings = AlarmSettings(
                              id: 1,
                              dateTime: alarmDateTime,
                              assetAudioPath: 'assets/alarm.mp3',
                              loopAudio: true,
                              vibrate: true,
                              volume: 0.8,
                              fadeDuration: 3.0,
                              androidFullScreenIntent: true,
                              notificationSettings: const NotificationSettings(
                                title: 'Medicine Reminder',
                                body: 'It’s time to take your medicine',
                                stopButton: 'STOP',
                                icon: 'notification_icon',
                              ),
                            );

                            // Define AlarmSettings for the second alarm if time is selected
                            AlarmSettings? secondAlarmSettings;
                            if (secondSelectedTime != null) {
                              final secondAlarmDateTime = DateTime(
                                now.year,
                                now.month,
                                now.day,
                                secondSelectedTime!.hour,
                                secondSelectedTime!.minute,
                              );

                              secondAlarmSettings = AlarmSettings(
                                id: 2,
                                dateTime: secondAlarmDateTime,
                                assetAudioPath: 'assets/alarm.mp3',
                                loopAudio: true,
                                vibrate: true,
                                volume: 0.8,
                                fadeDuration: 3.0,
                                androidFullScreenIntent: true,
                                notificationSettings:
                                    const NotificationSettings(
                                  title: 'Second Medicine Reminder',
                                  body: 'It’s time to take your medicine.',
                                  stopButton: 'Stop the alarm',
                                  icon: 'notification_icon',
                                ),
                              );
                            }

                            // Define AlarmSettings for the third alarm if time is selected
                            AlarmSettings? thirdAlarmSettings;
                            if (thirdSelectedTime != null) {
                              final thirdAlarmDateTime = DateTime(
                                now.year,
                                now.month,
                                now.day,
                                thirdSelectedTime!.hour,
                                thirdSelectedTime!.minute,
                              );

                              thirdAlarmSettings = AlarmSettings(
                                id: 3,
                                dateTime: thirdAlarmDateTime,
                                assetAudioPath: 'assets/alarm.mp3',
                                loopAudio: true,
                                vibrate: true,
                                volume: 0.8,
                                fadeDuration: 3.0,
                                androidFullScreenIntent: true,
                                notificationSettings:
                                    const NotificationSettings(
                                  title: 'Third Medicine Reminder',
                                  body: 'It’s time to take your medicine.',
                                  stopButton: 'Stop the alarm',
                                  icon: 'notification_icon',
                                ),
                              );
                            }

                            // Ensure both durationController and doseController are numbers
                            var duration =
                                int.parse(durationController.text.trim());
                            var dose = int.parse(doseController.text.trim());

                            var remain = duration * dose;

                            // Call addMedicine to save data
                            controller.addMedicine(
                              medicineName: medicineController.text.trim(),
                              strength: strengthController.text.trim(),
                              note: noteController.text.trim(),
                              doctorName: doctorController.text.trim(),
                              duration: durationController.text.trim(),
                              intakePerDay: doseController.text.trim(),
                              reminderTime: selectedTime?.format(context) ?? '',
                              memberName: homeController.selectedMember.value,
                              remain: remain,
                            );

                            // Set the alarms
                            Alarm.set(alarmSettings: alarmSettings);
                            if (secondAlarmSettings != null) {
                              Alarm.set(alarmSettings: secondAlarmSettings);
                            }
                            if (thirdAlarmSettings != null) {
                              Alarm.set(alarmSettings: thirdAlarmSettings);
                            }

                            Get.snackbar('Success',
                                'All alarms have been set successfully!');
                          } else {
                            Get.snackbar('Error',
                                'Please select at least the first time for the alarm');
                          }
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build input fields
  Widget _buildInputField(
    String label,
    TextEditingController controller,
    String hint,
    IconData icon, {
    bool isNumber = false,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: kSmallTitle1.copyWith(color: Colors.black)),
        SizedBox(height: 8.h),
        CustomTextFeild(
          obscureText: false,
          keyBordType: isNumber ? TextInputType.number : TextInputType.text,
          hint: hint,
          icon: icon,
          // maxLines: maxLines,
          controller: controller,
        ),
        SizedBox(height: 16.h),
      ],
    );
  }

// add member Widget
  Widget memberWidget() {
    final HomeController controller = Get.put(HomeController());

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: controller.getUserDataStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Text(
            'No Members Available',
            style: kSmallTitle1,
          );
        }

        // Extract member names from the Firestore documents
        final members = snapshot.data!.docs
            .map((doc) => doc.data()['memberName']
                as String) // Replace 'name' with the field that contains the member name
            .toList();

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 15.h),
          decoration: BoxDecoration(
            color: kPriemryColor,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Select Member',
                style: kSmallTitle1.copyWith(color: Colors.black),
              ),
              Obx(() {
                return DropdownButton<String>(
                  value: controller.selectedMember.value.isEmpty
                      ? null
                      : controller.selectedMember.value,
                  // Default to null if no selection
                  hint: Text(
                    'Choose Member',
                    style: kSmallTitle1.copyWith(color: Colors.black),
                  ),
                  icon: const Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  elevation: 16,
                  style: kSmallTitle1.copyWith(color: Colors.black),
                  dropdownColor: kWhit,
                  underline: Container(height: 0),
                  items: members.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      controller.selectedMember.value = newValue;
                    }
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }
}

