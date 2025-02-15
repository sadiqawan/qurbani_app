import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:medally_pro/componants/custom_button.dart';
import 'package:medally_pro/const/constant_colors.dart';
import 'package:medally_pro/const/contant_style.dart';
import 'package:url_launcher/url_launcher.dart';

import '../chat/user_chatting_screen.dart';

class AnimalDetailsView extends StatelessWidget {
  final String animalName;
  final String animalAge;
  final String animalBreed;
  final String animalDescription;
  final String animalImageUrl;
  final String animalPrice;
  final String animalLocation;
  final String contactNo;
  final String receiverId;

  const AnimalDetailsView({
    super.key,
    required this.animalName,
    required this.animalAge,
    required this.animalBreed,
    required this.animalDescription,
    required this.animalImageUrl,
    required this.animalPrice,
    required this.animalLocation,
    required this.contactNo,
    required this.receiverId,
  });

  @override
  Widget build(BuildContext context) {
    void _launchCaller(String contactNo) async {
      final Uri url = Uri.parse("tel:$contactNo");
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Animal Details'),
        backgroundColor: kPriemryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Animal Image
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  animalImageUrl,
                  width: double.infinity,
                  height: 350.h,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Text(
                      "Image not available",
                      style: TextStyle(color: Colors.red),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),

              // Animal Name
              Text('Animal', style: kSubTitle2B),
              Text(animalName, style: kHeading2B),
              SizedBox(height: 10),

              // Price
              Text(
                "Price: $animalPrice",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.green,
                ),
              ),
              SizedBox(height: 10),

              // Age, Breed, and Location
              Text(
                "Age: $animalAge | Breed: $animalBreed",
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              SizedBox(height: 5),
              Text(
                "Location: $animalLocation",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              SizedBox(height: 15),

              // Description
              Text(
                "Description",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                animalDescription,
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              SizedBox(height: 15),

              // Contact
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _launchCaller(contactNo),
                    icon: Icon(Icons.call, size: 20, color: Colors.white),
                    label: Text("Contact"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPriemryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Handle call action
                    },
                    icon: Icon(Icons.check_box, size: 20, color: Colors.white),
                    label: Text("Buy Now"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPriemryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.sp),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.h,
              ),

              CustomButton(
                  title: 'Chat Now',
                  onTap: () {
                    Get.to(UserChattingScreen(
                      receiverId: receiverId, userName: contactNo,

                    ));
                  }),
              SizedBox(
                height: 20.h,
              )
            ],
          ),
        ),
      ),
    );
  }
}
