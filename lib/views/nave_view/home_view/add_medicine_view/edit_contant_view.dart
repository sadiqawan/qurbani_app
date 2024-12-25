import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:alarm/model/notification_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../componants/custom_button.dart';
import '../../../../componants/custom_text_feild.dart';
import '../../../../const/constant_colors.dart';
import '../../../../const/contant_style.dart';
import 'add_contant_view_controller.dart';

class EditMedicineView extends StatefulWidget {
  final String documentId; // Pass document ID for fetching and updating
  const EditMedicineView({Key? key, required this.documentId}) : super(key: key);

  @override
  _EditMedicineViewState createState() => _EditMedicineViewState();
}

class _EditMedicineViewState extends State<EditMedicineView> {
  final controller = Get.put(AddMedicineController());

  final TextEditingController medicineController = TextEditingController();
  final TextEditingController strengthController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController doctorController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController doseController = TextEditingController();
  final TextEditingController memController = TextEditingController();
  TimeOfDay? selectedTime;

  @override
  void initState() {
    super.initState();
    fetchMedicineDetails(); // Fetch initial data for the document
  }

  Future<void> fetchMedicineDetails() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User is not authenticated');
      }

      final medicationRef = FirebaseFirestore.instance
          .collection('usersMemberList')
          .doc(user.uid)
          .collection('medication')
          .doc(widget.documentId);

      final doc = await medicationRef.get();
      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          medicineController.text = data['medicineName'] ?? '';
          strengthController.text = data['strength'] ?? '';
          noteController.text = data['note'] ?? '';
          doctorController.text = data['doctorName'] ?? '';
          durationController.text = data['duration'] ?? '';
          doseController.text = data['intakePerDay'] ?? '';
          memController.text = data['memberName'] ?? '';
          // Convert reminder time if available
          if (data['reminderTime'] != null) {
            final timeParts = (data['reminderTime'] as String).split(':');
            selectedTime = TimeOfDay(
              hour: int.parse(timeParts[0]),
              minute: int.parse(timeParts[1]),
            );
          }
        });
      }
    } catch (error) {
      Get.snackbar('Error', 'Failed to fetch medicine details: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Medicine'),
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
              // Reuse existing _buildInputField method
              _buildInputField('Medicine Name:', medicineController, 'Medicine Name', Icons.medical_information_outlined),
              _buildInputField('Strength:', strengthController, 'Strength', Icons.format_list_numbered, isNumber: true),
              _buildInputField('Note (Optional):', noteController, 'Note', Icons.note_alt_outlined, maxLines: 3),
              _buildInputField('Doctor Name (Optional):', doctorController, 'Doctor Name', Icons.person),
              _buildInputField('Duration (days):', durationController, 'Duration', Icons.calendar_today, isNumber: true),
              _buildInputField('Dose per day:', doseController, 'Dose', Icons.format_list_numbered_rounded, isNumber: true),
              _buildInputField('Member Name:', memController, 'Member Name', Icons.person),

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
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 15.h),
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
              SizedBox(height: 20.h),

              // Update Button
              Center(
                child: Obx(() {
                  return CustomButton(
                    title: controller.isLoading.value ? 'Updating...' : 'Update',
                    onTap: () {
                      if (!controller.isLoading.value) {
                        controller.updateMedicine(
                          documentId: widget.documentId,
                          medicineName: medicineController.text.trim(),
                          strength: strengthController.text.trim(),
                          note: noteController.text.trim(),
                          doctorName: doctorController.text.trim(),
                          duration: durationController.text.trim(),
                          intakePerDay: doseController.text.trim(),
                          reminderTime: selectedTime?.format(context) ?? '',
                          memberName: memController.text.trim(),
                        );
                      }
                    },
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

