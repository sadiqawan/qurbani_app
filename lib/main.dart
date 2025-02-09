
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:medally_pro/views/splash_view/splash_view.dart';


import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,

  );

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      splitScreenMode: true,
      minTextAdapt: true,
      builder: (BuildContext context, Widget? child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'MediTrack',
          theme: ThemeData(
            primarySwatch: Colors.cyan,
          ),
          home: const SplashScreen(),
        );
      },
    );
  }
}



//   ListView.builder(
//   itemCount: medications.length,
//   itemBuilder: (context, index) {
//     final medicationData = medications[index].data();
//     final medicineName = medicationData['medicineName'] ?? 'Unknown';
//     final doctorName = medicationData['doctorName'] ?? 'N/A';
//     final reminderTime = medicationData['reminderTime'] ?? 'N/A';
//     final durationTime = medicationData['duration'] ?? 'N/A';
//     final remainingDose = medicationData['strength'] ?? 'N/A';
//     final memberName = medicationData['memberName'] ?? 'N/A';
//     final medicineImage = medicationData['picture'];
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: MedicineCard(
//         onTap: () async {
//           final url = 'https://google.com/search?q=$medicineName';
//           final uri = Uri.parse(url);
//
//           if (await canLaunchUrl(uri)) {
//             await launchUrl(uri,
//                 mode: LaunchMode.externalApplication);
//           } else {
//             Get.snackbar(
//               "Error",
//               "Cannot launch $url",
//               snackPosition: SnackPosition.TOP,
//               backgroundColor: Colors.red,
//             );
//           }
//         },
//         medicineName: medicineName,
//         doctorName: doctorName,
//         durationTime: durationTime,
//         time: reminderTime,
//         remainingDose: remainingDose,
//         memberName: memberName,
//         image: medicineImage,
//         editOnTap: () {
//           Get.to(
//                 () => EditMedicineView(
//               documentId: medications[index].id,
//             ),
//           );
//         },
//         medTakenOnTap: () async {
//           try {
//             // Get the current document
//             final docSnapshot = await FirebaseFirestore.instance
//                 .collection('usersMemberList')
//                 .doc(FirebaseAuth.instance.currentUser!.uid)
//                 .collection('medication')
//                 .doc(medications[index].id)
//                 .get();
//
//             if (docSnapshot.exists) {
//               int currentIntake =
//               int.parse(docSnapshot['strength'].toString());
//               int updatedIntake = currentIntake - 1;
//               String updatedIntakeInString = updatedIntake.toString();
//
//               await FirebaseFirestore.instance
//                   .collection('usersMemberList')
//                   .doc(FirebaseAuth.instance.currentUser!.uid)
//                   .collection('medication')
//                   .doc(medications[index].id)
//                   .update({'strength': updatedIntakeInString});
//
//               Get.snackbar(
//                 "Success",
//                 "Medication successfully taken",
//                 snackPosition: SnackPosition.TOP,
//                 backgroundColor: Colors.green,
//               );
//             } else {
//               Get.snackbar(
//                 "Error",
//                 "Document does not exist",
//                 snackPosition: SnackPosition.TOP,
//                 backgroundColor: Colors.red,
//               );
//             }
//           } catch (e) {
//             Get.snackbar(
//               "Error",
//               "Failed, something went wrong: $e",
//               snackPosition: SnackPosition.TOP,
//               backgroundColor: Colors.red,
//             );
//           }
//         },
//         deleteOnTap: () async {
//           try {
//             await FirebaseFirestore.instance
//                 .collection('usersMemberList')
//                 .doc(FirebaseAuth.instance.currentUser!.uid)
//                 .collection('medication')
//                 .doc(medications[index].id)
//                 .delete();
//
//             Get.snackbar(
//               "Success",
//               "Medication deleted successfully",
//               snackPosition: SnackPosition.TOP,
//               backgroundColor: Colors.green,
//             );
//           } catch (e) {
//             Get.snackbar(
//               "Error",
//               "Failed to delete medication: $e",
//               snackPosition: SnackPosition.TOP,
//               backgroundColor: Colors.red,
//             );
//           }
//         },
//         stockReminderOnTap: () => Get.to(
//           AddStockView(
//             docId: medications[index].id,
//           ),
//         ),
//       ),
//     );
//   },
// );