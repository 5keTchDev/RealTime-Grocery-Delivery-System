import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  String? name;
  String? url;
  String? id;
  String? backgroundColor;
  Timestamp? createdAt;

  CategoryModel(
      {this.name, this.url, this.id, this.backgroundColor, this.createdAt});

  Stream<List<CategoryModel>> get category {
    return FirebaseFirestore.instance
        .collection('Category')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((QuerySnapshot querySnapshot) => querySnapshot.docs
            .map(
              (DocumentSnapshot documentSnapshot) => CategoryModel(
                name: documentSnapshot.get('name'),
                url: documentSnapshot.get('image'),
                id: documentSnapshot.get('id'),
                backgroundColor: documentSnapshot.get('backgroundColor'),
                createdAt: documentSnapshot.get('createdAt'),
              ),
            )
            .toList());
  }
}
