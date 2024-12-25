import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
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

  // Controllers for input fields
  final TextEditingController medicineController = TextEditingController();
  final TextEditingController strengthController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController doctorController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController doseController = TextEditingController();
  final TextEditingController memController = TextEditingController();
  TimeOfDay? selectedTime;

  // final alarmSettings = AlarmSettings(
  //   id: 42,
  //   dateTime: dateTime,
  //   assetAudioPath: 'assets/alarm.mp3',
  //   loopAudio: true,
  //   vibrate: true,
  //   volume: 0.8,
  //   fadeDuration: 3.0,
  //   warningNotificationOnKill: Platform.isIOS,
  //   androidFullScreenIntent: true,
  //   notificationSettings: const NotificationSettings(
  //     title: 'This is the title',
  //     body: 'This is the body',
  //     stopButton: 'Stop the alarm',
  //     icon: 'notification_icon',
  //   ),
  // );

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
              // Input Fields
              _buildInputField(
                'Enter Medicine name:',
                medicineController,
                'Medicine Name',
                Icons.medical_information_outlined,
              ),
              _buildInputField(
                'Enter Strength:',
                strengthController,
                'Strength',
                Icons.format_list_numbered,
                isNumber: true,
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
                isNumber: false,
              ),
              _buildInputField(
                'Enter member:',
                memController,
                'Member Name',
                Icons.person_outline,
                isNumber: false,
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
                    const Icon(Icons.upload,size: 30,),

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
                      title: controller.isLoading.value ? 'Submitting...' : 'Submit',
                      onTap: () {
                        if (!controller.isLoading.value) {
                          if (selectedTime != null) {
                            final now = DateTime.now();

                            // Convert selected TimeOfDay to DateTime
                            final alarmDateTime = DateTime(
                              now.year,
                              now.month,
                              now.day,
                              selectedTime!.hour,
                              selectedTime!.minute,
                            );

                            // Define AlarmSettings
                            final alarmSettings = AlarmSettings(
                              id: 42, // Unique ID for the alarm
                              dateTime: alarmDateTime,
                              assetAudioPath: 'assets/alarm.mp3',
                              loopAudio: true,
                              vibrate: true,
                              volume: 0.8,
                              fadeDuration: 3.0,
                              androidFullScreenIntent: true,
                              notificationSettings: const NotificationSettings(
                                title: 'Medicine Reminder',
                                body: 'It’s time to take your medicine.',
                                stopButton: 'Stop the alarm',
                                icon: 'notification_icon',
                              ),
                            );

                            // Call addMedicine to save data
                            controller.addMedicine(
                              medicineName: medicineController.text.trim(),
                              strength: strengthController.text.trim(),
                              note: noteController.text.trim(),
                              doctorName: doctorController.text.trim(),
                              duration: durationController.text.trim(),
                              intakePerDay: doseController.text.trim(),
                              reminderTime: selectedTime?.format(context) ?? '',
                              memberName: memController.text.trim(),
                            );

                            // Set the Alarm
                            Alarm.set(alarmSettings: alarmSettings);
                            Get.snackbar('Success', 'Alarm has been set successfully!');
                          } else {
                            Get.snackbar('Error', 'Please select a time for the alarm');
                          }
                        }
                      },
                    );
                  },
                ),
              ),


              // Submit Button
              // Center(
              //   child: Obx(
              //     () {
              //       return CustomButton(
              //         title: controller.isLoading.value
              //             ? 'Submitting...'
              //             : 'Submit',
              //         onTap: () {
              //           if (!controller.isLoading.value) {
              //             controller.addMedicine(
              //               medicineName: medicineController.text.trim(),
              //               strength: strengthController.text.trim(),
              //               note: noteController.text.trim(),
              //               doctorName: doctorController.text.trim(),
              //               duration: durationController.text.trim(),
              //               intakePerDay: doseController.text.trim(),
              //               reminderTime: selectedTime?.format(context) ?? '',
              //               memberName: memController.text.trim(),
              //             );
              //            // Alarm.set(alarmSettings: alarmSettings);
              //           }
              //         },
              //       );
              //     },
              //   ),
              // ),
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
}

