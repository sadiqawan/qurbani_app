import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class SearchViewController extends GetxController {

  Stream<QuerySnapshot<Map<String, dynamic>>> getPostDataStream() {
    return FirebaseFirestore.instance.collection('userPosts').snapshots();
  }
}