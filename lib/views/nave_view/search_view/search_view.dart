import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medally_pro/views/nave_view/home_view/aminal_details_view.dart';
import 'package:medally_pro/views/nave_view/search_view/search_controller.dart';
import '../../../const/constant_colors.dart';
import '../../../const/contant_style.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _searchController = TextEditingController();
  final RxString searchQuery = ''.obs;
  final SearchController searchController = Get.put(SearchController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Search', style: kSubTitle2B),
        backgroundColor: kPriemryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              onChanged: (value) {
                searchQuery.value = value;
              },
              decoration: InputDecoration(
                hintText: 'Search Medicine...',
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: kPriemryColor,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 20),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Obx(() => getSearchElement(context, searchQuery.value)),
            ),
          ],
        ),
      ),
    );
  }
}

Widget getSearchElement(BuildContext context, String searchQuery) {
  // final searchController = Get.find<SearchViewController>();
  SearchViewController searchViewController = Get.put(SearchViewController());

  return StreamBuilder<QuerySnapshot>(
    stream: searchViewController.getPostDataStream(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(color: Colors.orange),
        );
      }

      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return Center(
          child: Text(
            "No data available.",
            style: kSubTitle2B,
          ),
        );
      }

      var filteredData = snapshot.data!.docs.where((doc) {
        final animalName = (doc['animalName'] ?? '').toString().toLowerCase();
        return animalName.contains(searchQuery.toLowerCase());
      }).toList();

      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.8,
        ),
        itemCount: filteredData.length,
        itemBuilder: (context, index) {
          final item = filteredData[index];

          return InkWell(
            onTap: (){
              Get.to(
                AnimalDetailsView(
                  animalName: item['animalName'] ?? 'Unknown',
                  animalAge: item['age'] ?? 'Unknown',
                  animalBreed: item['breed'] ?? 'Unknown',
                  animalDescription: item['description'] ?? 'No description',
                  animalImageUrl: item["imageUrl"]??'',
                  animalPrice: item['price'] ?? 'Not available',
                  animalLocation: item['animalLocation'] ?? 'Unknown',
                  contactNo: item['animalContact'] ?? 'Not available',
                  receiverId: item['userId'] ?? 'No userId'
              ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: kWhit,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child:
                        Image.network(
                          item["imageUrl"]  ,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 120,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.image_not_supported),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      item["animalName"] ?? "Unknown",
                      style: kSubTitle2B,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}