import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../const/constant_colors.dart';
import '../../../const/contant_style.dart';

class AllReviewView extends StatefulWidget {
  final String name;
  final String age;
  final String price;
  final String location;

  const AllReviewView({
    super.key,
    required this.name,
    required this.age,
    required this.price,
    required this.location,
  });

  @override
  State<AllReviewView> createState() => _AllReviewViewState();
}

class _AllReviewViewState extends State<AllReviewView> {
  final TextEditingController _reviewController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPriemryColor,
        onPressed: () {
          _showAddReviewDialog();
        },
        child: const Icon(Icons.reviews_outlined),
      ),
      appBar: AppBar(
        title: const Text('Reviews'),
        backgroundColor: kPriemryColor,
      ),
      body: getPostReview(),
    );
  }

  void _showAddReviewDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Review'),
          content: TextField(
            controller: _reviewController,
            decoration: const InputDecoration(hintText: 'Enter your review'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _addReview();
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addReview() async {
    String reviewText = _reviewController.text.trim();
    if (reviewText.isEmpty) return;

    var querySnapshot = await FirebaseFirestore.instance
        .collection('userPosts')
        .where('animalName', isEqualTo: widget.name)
        .where('animalLocation', isEqualTo: widget.location)
        .where('price', isEqualTo: widget.price)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      var doc = querySnapshot.docs.first;
      List<dynamic> existingReviews = doc.data()['review'] ?? [];

      existingReviews.add(reviewText);

      await FirebaseFirestore.instance
          .collection('userPosts')
          .doc(doc.id)
          .update({'review': existingReviews});

      _reviewController.clear();
      Navigator.pop(context); // Close the dialog
      setState(() {}); // Refresh UI
    } else {
      // You can show a snackbar if no matching document is found
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No matching post found to add review')),
      );
    }
  }

  Widget getPostReview() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('userPosts').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.orange),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              "No reviews yet",
              style: kSubTitle2B,
            ),
          );
        }

        var matchingPosts = snapshot.data!.docs.where((doc) {
          var data = doc.data();
          return data['animalName'] == widget.name &&
              data['animalLocation'] == widget.location &&
              data['price'] == widget.price;
        }).toList();

        if (matchingPosts.isEmpty) {
          return Center(
            child: Text(
              "No matching posts found",
              style: kSubTitle2B,
            ),
          );
        }

        var reviews = matchingPosts.first.data()['review'] as List<dynamic>?;

        if (reviews == null || reviews.isEmpty) {
          return Center(
            child: Text(
              "No reviews yet",
              style: kSubTitle2B,
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(top: 10),
          itemCount: reviews.length,
          itemBuilder: (context, index) {
            var review = reviews[index];
            return ListTile(
              title: Text(review.toString()),
              leading: const Icon(Icons.person),
            );
          },
        );
      },
    );
  }
}
