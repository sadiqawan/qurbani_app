import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medally_pro/const/constant_colors.dart';
import 'package:radial_button/widget/circle_floating_button.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../const/contant_style.dart';
import 'aminal_details_view.dart';
import 'home_controller.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPriemryColor,
        title: Row(
          children: [
            userImage(),
            SizedBox(width: 5.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Welcome To 👋",
                    style: kSubTitle2B.copyWith(fontSize: 16.sp)),
                Text(
                  "OnlineQurbaniShop",
                  style: kSubTitle2B.copyWith(fontSize: 12.sp),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: CircleFloatingButton.floatingActionButton(
        items: homeController.itemsActionBar,
        color: kPriemryColor,
        icon: Icons.add,
        duration: const Duration(milliseconds: 200),
        curveAnim: Curves.ease,
        useOpacity: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [getAllPost()],
        ),
      ),
    );
  }
}

Widget userImage() {
  HomeController controller = Get.put(HomeController());
  return StreamBuilder(
      stream: controller.getCurrentUserDataStream(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircleAvatar(
            maxRadius: 25.sp,
            backgroundColor: Colors.transparent,
            backgroundImage: const AssetImage("assets/images/icon_person.png"),
          );
        }
        var userData = snapshot.data?.data();
        if (userData == null || userData['picture'] == null) {
          return CircleAvatar(
            maxRadius: 25.sp,
            backgroundColor: Colors.transparent,
            backgroundImage: const AssetImage("assets/images/icon_person.png"),
          );
        } else {
          return CircleAvatar(
            maxRadius: 25.sp,
            backgroundImage: NetworkImage(userData!['picture']),
          );
        }
      });
}

// getting all posts

Widget getAllPost() {
  HomeController controller = Get.put(HomeController());


  return StreamBuilder(
    stream: controller.getAllPost(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(color: Colors.orange),
        );
      }

      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return Center(
          child: Text(
            "No Post Added",
            style: kSubTitle2B,
          ),
        );
      } else {
        var postData = snapshot.data!.docs;
        void launchCaller(String contactNo) async {
          final Uri url = Uri.parse("tel:$contactNo");
          if (await canLaunchUrl(url)) {
            await launchUrl(url);
          } else {
            throw 'Could not launch $url';
          }
        }

        return Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: postData.length,
            padding: EdgeInsets.only(top: 10),
            itemBuilder: (BuildContext context, int index) {
              var post = postData[index].data();
              var animalName = post['animalName'] ?? 'Unknown';
              var animalAge = post['age'] ?? 'N/A';
              var animalBreedingType = post['breed'] ?? 'Unknown';
              var animalDescription =
                  post['description'] ?? 'No description available';
              var animalImageUrl = post['imageUrl'] ?? '';
              // var postTime = post['timestamp'] ?? 'Just now';
              var animalPrice = post['price'] ?? 'N/A';
              var animalLocation = post['animalLocation'] ?? 'Unknown';
              var contactNo = post['animalContact'] ?? 'No Contact';
              var receiverId = post['userId'] ?? 'No userId';

              var timestamp = post['timestamp'] as Timestamp?;
              var postTime = timestamp != null
                  ? DateFormat('dd MMM yyyy, hh:mm a')
                      .format(timestamp.toDate())
                  : 'Unknown';

              return InkWell(
                onTap: () => Get.to(
                  AnimalDetailsView(
                    animalName: post['animalName'] ?? 'Unknown',
                    animalAge: post['age'] ?? 'Unknown',
                    animalBreed: post['breed'] ?? 'Unknown',
                    animalDescription: post['description'] ?? 'No description',
                    animalImageUrl: post['imageUrl'] ?? '',
                    animalPrice: post['price'] ?? 'Not available',
                    animalLocation: post['animalLocation'] ?? 'Unknown',
                    contactNo: post['animalContact'] ?? 'Not available',
                    receiverId: receiverId,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 8.0),
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Animal Image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: animalImageUrl.isNotEmpty
                                ? Image.network(
                                    animalImageUrl,
                                    width: double.infinity,
                                    height: 300,
                                    fit: BoxFit.fill,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                          child: CircularProgressIndicator());
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        "assets/images/placeholder.png",
                                        width: double.infinity,
                                        height: 200,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  )
                                : Image.asset(
                                    "assets/images/placeholder.png",
                                    width: double.infinity,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          SizedBox(height: 10),

                          // Animal Details
                          Text(
                            animalName,
                            style: kSubTitle2B.copyWith(
                                fontSize: 18.sp, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Text(
                            animalDescription,
                            style: kSubTitle2B.copyWith(
                                fontSize: 14.sp, color: Colors.grey[700]),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 10),

                          // Row with Animal Details
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _infoBox(
                                  Icons.calendar_today, "$animalAge years"),
                              _infoBox(Icons.pets, animalBreedingType),
                              _infoBox(Icons.location_on, animalLocation),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            "PKR:$animalPrice",
                            style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                          ),

                          // Price & Contact
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [

                              Flexible(
                                child: ElevatedButton.icon(
                                  onPressed: () => launchCaller(contactNo),
                                  icon: Icon(Icons.call,
                                      size: 15, color: Colors.white),
                                  label: Text("Contact"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: kPriemryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    controller.startPayment(animalName, animalPrice);
                                  },
                                  icon: Icon(Icons.check_box, size: 15, color: Colors.white),
                                  label: Text("Buy Now"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: kPriemryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),

                            ],
                          ),
                          SizedBox(height: 5),

                          // Timestamp
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              postTime,
                              style: TextStyle(
                                  fontSize: 12.sp, color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }
    },
  );
}

// Helper Widget for Small Info Boxes
Widget _infoBox(IconData icon, String text) {
  return Row(
    children: [
      Icon(icon, size: 16, color: Colors.grey[700]),
      SizedBox(width: 5),
      Text(
        text,
        style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
      ),
    ],
  );
}

/*Widget getAllPost() {
  HomeController controller = Get.put(HomeController());

  return StreamBuilder(
    stream: controller.getAllPost(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(color: Colors.orange),
        );
      }

      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return Center(
          child: Text(
            "No Post Added",
            style: kSubTitle2B,
          ),
        );
      } else {
        var postData = snapshot.data!.docs;

        return Expanded(  // Ensure ListView gets proper space
          child: ListView.builder(
            itemCount: postData.length,
            padding: EdgeInsets.only(top: 10),
            itemBuilder: (BuildContext context, int index) {
              var post = postData[index].data();
              var animalName = post['animalName'] ?? 'Loading';
              var animalAge = post['age'] ?? 'Loading';
              var animalBreedingType = post['breed'] ?? 'Loading';
              var animalDescription = post['description'] ?? 'Loading';
              var animalImageUrl = post['imageUrl'] ?? 'Loading';
              var postTime = post['timestamp'] ?? 'Loading';
              var animalPrice = post['price'] ?? 'Loading';
              var animalLocation = post['animalLocation'] ?? 'Loading';
              var contactNo = post['animalContact'] ?? 'Loading';

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: kPriemryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post["title"] ?? "No Title",
                        style: kSubTitle2B.copyWith(color: Colors.white),
                      ),
                      SizedBox(height: 5),
                      Text(
                        post["description"] ?? "No Description",
                        style: kSubTitle2B.copyWith(color: Colors.white70),
                      ),
                      if (post["image"] != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              post["image"],
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Text(
                                  "Image not available",
                                  style: kSubTitle2B.copyWith(color: Colors.white),
                                );
                              },
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }
    },
  );
}*/
