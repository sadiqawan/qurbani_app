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
                isNumber: true,
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

              SizedBox(height: 20.h),
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
                          // Image.asset(
                          //   'assets/images/icon_profile.png', // Default image
                          //   fit: BoxFit.fill,
                          // )
                          : Image.file(
                              controller.image.value!,
                              fit: BoxFit.fill, // Adjust for better display
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
                                            controller.pickImageFrom(
                                                ImageSource.camera);
                                          })),
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
                    Text(
                      'Upload Pic',
                      style: kSubTitle2B,
                    ),
                    const Icon(Icons.edit_outlined),
                  ],
                ),
              ),

              // // Image Upload Section
              // Center(
              //   child: Obx(() {
              //     return controller.image.value == null
              //         ? Icon(
              //       Icons.medical_services_outlined,
              //       size: 100.h,
              //       color: kPriemryColor.withOpacity(0.5),
              //     )
              //         : Image.file(
              //       controller.image.value!,
              //       height: 100.h,
              //       width: 100.w,
              //     );
              //   }),
              // ),
              // SizedBox(height: 15.h),
              // SizedBox(
              //   height: 200,
              //   child: Center(
              //     child: CustomButton(
              //       title: 'Upload Image',
              //       onTap: () {
              //         Get.bottomSheet(
              //
              //           backgroundColor: kWhit,
              //           SizedBox(
              //             height: 180.h,
              //             child: Column(
              //               mainAxisAlignment: MainAxisAlignment.center,
              //               children: [
              //                 Text('Upload Pic', style: kHeading2B),
              //                 Row(
              //                   mainAxisAlignment: MainAxisAlignment.spaceAround,
              //                   children: [
              //                     CustomButton(
              //                       title: 'Camera',
              //                       onTap: () {
              //                         controller.pickImageFrom(ImageSource.camera);
              //                       },
              //                     ),
              //                     CustomButton(
              //                       title: 'Gallery',
              //                       onTap: () {
              //                         controller.pickImageFrom(ImageSource.gallery);
              //                       },
              //                     ),
              //                   ],
              //                 ),
              //               ],
              //             ),
              //           ),
              //         );
              //       },
              //     ),
              //   ),
              // ),

              SizedBox(height: 30.h),

              // Submit Button
              Center(
                child: Obx(() {
                  return CustomButton(
                    title:
                        controller.isLoading.value ? 'Submitting...' : 'Submit',
                    onTap: () {
                      if (!controller.isLoading.value) {
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

/*
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:medally_pro/componants/custom_button.dart';
import 'package:medally_pro/const/constant_colors.dart';
import 'package:medally_pro/const/contant_style.dart';
import 'package:medally_pro/views/nave_view/home_view/add_medicine_view/add_contant_view_controller.dart';
import '../../../../componants/custom_text_feild.dart';

class AddMedicineView extends StatefulWidget {
  const AddMedicineView({super.key});

  @override
  State<AddMedicineView> createState() => _AddMedicineViewState();
}

class _AddMedicineViewState extends State<AddMedicineView> {
  AddMedicineController controller = Get.put(AddMedicineController());

  // Controllers for input fields
  TextEditingController medicineController = TextEditingController();
  TextEditingController strengthController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController doctorController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController doseController = TextEditingController();

  // Time variables
  TimeOfDay? selectedTime;

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
              _buildInputField('Enter Medicine name:', medicineController,
                  'Medicine Name', Icons.medical_information_outlined),
              _buildInputField('Enter Strength:', strengthController,
                  'Strength', Icons.format_list_numbered,
                  isNumber: true),
              _buildInputField('Enter Note (Optional):', noteController,
                  'Medicine Note', Icons.note_alt_outlined,
                  maxLines: 3),
              _buildInputField('Suggested by (Optional):', doctorController,
                  'Doctor Name', Icons.person),
              _buildInputField('Duration (in days):', durationController,
                  'Duration', Icons.format_list_numbered_rounded,
                  isNumber: true),
              _buildInputField('Dose/Intake per day:', doseController, 'Dose',
                  Icons.format_list_numbered_rounded,
                  isNumber: true),

              Text(
                'Set Time Range:',
                style: kSmallTitle1.copyWith(color: Colors.black),
              ),
              SizedBox(height: 8.h),

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
                    border: Border.all(color: kPriemryColor),
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
                          // Image.asset(
                          //   'assets/images/icon_profile.png', // Default image
                          //   fit: BoxFit.fill,
                          // )
                          : Image.file(
                              controller.image.value!,
                              fit: BoxFit.fill, // Adjust for better display
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
                                            controller.pickImageFrom(
                                                ImageSource.camera);
                                          })),
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
                    Text(
                      'Upload Pic',
                      style: kSubTitle2B,
                    ),
                    const Icon(Icons.edit_outlined),
                  ],
                ),
              ),

              SizedBox(height: 30.h),
              // Submit Button
              Center(
                child: CustomButton(
                  title: 'Submit',
                  onTap: () {


                   */
/* debugPrint('Medicine details submitted!');
                    debugPrint(
                        'Selected Time: ${selectedTime?.format(context) ?? 'No Time Selected'}');*/ /*

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
  Widget _buildInputField(String label, TextEditingController controller,
      String hint, IconData icon,
      {bool isNumber = false, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: kSmallTitle1.copyWith(color: Colors.black),
        ),
        SizedBox(height: 8.h),
        CustomTextFeild(
          obscureText: false,
          keyBordType: isNumber ? TextInputType.number : TextInputType.text,
          hint: hint,
          icon: icon,
          maxLine: maxLines,
          controller: controller,
        ),
        SizedBox(height: 15.h),
      ],
    );
  }
}
*/
