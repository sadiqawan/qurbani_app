import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:medally_pro/componants/custom_button.dart';
import '../../../../componants/custom_text_feild.dart';
import '../../../../const/constant_colors.dart';
import '../../../../const/contant_style.dart';

class AddStockView extends StatefulWidget {
  final String docId;

  const AddStockView({super.key, required this.docId});

  @override
  State<AddStockView> createState() => _AddStockViewState();
}

class _AddStockViewState extends State<AddStockView> {
  final TextEditingController currentPillController = TextEditingController();
  final TextEditingController notifyPillController = TextEditingController();


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
                  'Refill Reminder',
                  style: kHeading2B,
                ),
              ),
              SizedBox(height: 10.h),
              _buildInputField(
                'How many pills do you have currently?',
                currentPillController,
                'Current Pills',
                Icons.medication_outlined,
                isNumber: true,
              ),
              SizedBox(height: 10.h),
              _buildInputField(
                'Notify when how many pills are left?',
                notifyPillController,
                'Pills left',
                Icons.notification_important_outlined,
                isNumber: true,
              ),

              SizedBox(height: 100.h),
              CustomButton(
                title: 'Set Now',
                onTap: () async {
                  if (currentPillController.text.isEmpty ||
                      notifyPillController.text.isEmpty) {
                    // Show an error message if any field is empty
                    Get.snackbar(
                      'Error',
                      'Please fill in all required fields',
                      backgroundColor: Colors.red.withOpacity(0.3),
                    );
                    return;
                  }

                  try {


                    // Get the current document
                    final docSnapshot = await FirebaseFirestore.instance
                        .collection('usersMemberList')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .collection('medication')
                        .doc(widget.docId)
                        .get();

                    if (docSnapshot.exists) {
                      await FirebaseFirestore.instance
                          .collection('usersMemberList')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection('medication')
                          .doc(widget.docId)
                          .update(
                        {
                          'stockReminder': true,
                          'stockReminderPills': notifyPillController.text.trim()
                        },
                      );
                      Navigator.pop(context);

                    } else {
                      Get.snackbar(
                        "Error",
                        "Document does not exist",
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: Colors.red,
                      );
                    }

                    // Show success message
                    Get.snackbar(
                      'Success',
                      'Stock reminder has been set successfully!',
                      backgroundColor: Colors.green.withOpacity(0.3),

                    );
                  } catch (e) {
                    // Handle any parsing or saving errors
                    Get.snackbar(
                      'Error',
                      'Failed to set the stock reminder. Please try again.',
                      backgroundColor: Colors.red.withOpacity(0.3),

                    );
                  }
                },
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
          controller: controller,
        ),
        SizedBox(height: 16.h),
      ],
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:medally_pro/componants/custom_button.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../../../componants/custom_text_feild.dart';
// import '../../../../const/constant_colors.dart';
// import '../../../../const/contant_style.dart';
//
// class AddStockView extends StatefulWidget {
//   final String docId;
//
//   const AddStockView({super.key, required this.docId});
//
//   @override
//   State<AddStockView> createState() => _AddStockViewState();
// }
//
// class _AddStockViewState extends State<AddStockView> {
//   TextEditingController currentPillController = TextEditingController();
//   TextEditingController notifyPillController = TextEditingController();
//   TimeOfDay? selectedTime;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Stock Management'),
//         backgroundColor: kPriemryColor,
//         centerTitle: true,
//         titleTextStyle: kSubTitle2B.copyWith(color: kWhit),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(height: 5.h),
//               Center(
//                 child: Text(
//                   'Refill Remainder',
//                   style: kHeading2B,
//                 ),
//               ),
//               SizedBox(height: 10.h),
//               _buildInputField(
//                 'Hom Many pills do you have currently ?',
//                 currentPillController,
//                 'Current Pills',
//                 Icons.medication_outlined,
//                 isNumber: true,
//               ),
//               SizedBox(height: 10.h),
//               _buildInputField(
//                 'Notify when How many pill left ?',
//                 notifyPillController,
//                 'Pill left',
//                 Icons.notification_important_outlined,
//                 isNumber: true,
//               ),
//
//               SizedBox(height: 10.h),
//               // Time Pickerc
//
//               Padding(
//                 padding: EdgeInsets.only(top: 100.h),
//                 child: CustomButton(
//                   title: 'Set Now',
//                   onTap: () async {
//                     if (currentPillController.text.isEmpty ||
//                         notifyPillController.text.isEmpty ||
//                         selectedTime == null) {
//                       // Show an error message if any field is empty
//                       Get.snackbar('Field ', 'Enter The required Fields' ,backgroundColor: Colors.red.withOpacity(.3));
//                     }
//                     // Save user inputs to SharedPreferences
//                     final SharedPreferences prefs = await SharedPreferences.getInstance();
//                     int currentPill = int.parse(currentPillController.text);
//                     int pillLeft = int.parse(notifyPillController.text);
//                     await prefs.setInt('current_pill', currentPill);
//                     await prefs.setInt('pill_left', pillLeft);
//                     await prefs.setString('docId', widget.docId);
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Helper method to build input fields
//   Widget _buildInputField(
//     String label,
//     TextEditingController controller,
//     String hint,
//     IconData icon, {
//     bool isNumber = false,
//     int maxLines = 1,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: kSmallTitle1.copyWith(color: Colors.black)),
//         SizedBox(height: 8.h),
//         CustomTextFeild(
//           obscureText: false,
//           keyBordType: isNumber ? TextInputType.number : TextInputType.text,
//           hint: hint,
//           icon: icon,
//           // maxLines: maxLines,
//           controller: controller,
//         ),
//         SizedBox(height: 16.h),
//       ],
//     );
//   }
// }
