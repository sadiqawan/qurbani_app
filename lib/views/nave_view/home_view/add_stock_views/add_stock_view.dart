import 'package:alarm/model/alarm_settings.dart';
import 'package:alarm/model/notification_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medally_pro/componants/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../componants/custom_text_feild.dart';
import '../../../../const/constant_colors.dart';
import '../../../../const/contant_style.dart';

class AddStockView extends StatefulWidget {
  const AddStockView({super.key});

  @override
  State<AddStockView> createState() => _AddStockViewState();
}

class _AddStockViewState extends State<AddStockView> {
  TextEditingController currentPillController = TextEditingController();
  TextEditingController notifyPillController = TextEditingController();
  TimeOfDay? selectedTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Management'),
        backgroundColor: kPriemryColor,
        centerTitle: true,
        titleTextStyle: kSubTitle2B.copyWith(color: kWhit),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 5.h),
              Center(
                child: Text(
                  'Refill Remainder',
                  style: kHeading2B,
                ),
              ),
              SizedBox(height: 10.h),
              _buildInputField(
                'Hom Many pills do you have currently ?',
                currentPillController,
                'Current Pills',
                Icons.medication_outlined,
                isNumber: true,
              ),
              SizedBox(height: 10.h),
              _buildInputField(
                'Notify when How many pill left ?',
                notifyPillController,
                'Pill left',
                Icons.notification_important_outlined,
                isNumber: true,
              ),
              SizedBox(height: 10.h),
              Text(
                'Select Remainder',
                style: kSmallTitle1,
              ),
              SizedBox(height: 10.h),
              // Time Picker
              InkWell(
                onTap: () async {
                  if (currentPillController.text.isEmpty ||
                      notifyPillController.text.isEmpty ||
                      selectedTime == null) {
                    // Show an error message if any field is empty
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                              Text("Please fill all fields and select a time")),
                    );
                    return;
                  }

                  // Save user inputs to SharedPreferences
                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  int currentPill = int.parse(currentPillController.text);
                  int pillLeft = int.parse(notifyPillController.text);

                  await prefs.setInt('current_pill', currentPill);
                  await prefs.setInt('pill_left', pillLeft);

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
                      title: 'Medicine Refill Reminder',
                      body: 'It’s time to refill your medicine.',
                      stopButton: 'STOP',
                      icon: 'notification_icon',
                    ),
                  );

                  // Logic to simulate pill count check
                  // This would ideally be implemented as a background task or service
                  if (currentPill <= pillLeft) {
                    // Trigger alarm or notification
                    // Your logic for triggering alarm goes here
                    print("Triggering reminder alarm!");
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Reminder set successfully!")),
                  );
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

              Padding(
                padding: EdgeInsets.only(top: 100.h),
                child: CustomButton(
                    title: 'Set Now',
                    onTap: () async {
                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.setInt('current_pill', 10);
                      await prefs.setInt('pill_left', 10);
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
                          title: 'Medicine Refill Reminder Reminder',
                          body: 'It’s time to refill your medicine.',
                          stopButton: 'STOP',
                          icon: 'notification_icon',
                        ),
                      );
                    }),
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
}
