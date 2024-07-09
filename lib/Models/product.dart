import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class Product extends ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final double cuttedPrice;
  final String imageUrl;
  final String productCategoryName;
  final String unitAmount;
  final bool isPopular;
  final String percentOff;
  final bool? inStock;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.cuttedPrice,
    required this.imageUrl,
    required this.productCategoryName,
    required this.unitAmount,
    required this.isPopular,
    required this.percentOff,
    this.inStock,
  });

  Stream<List<Product>> get products {
    return FirebaseFirestore.instance
        .collection('products')
        .snapshots()
        .map((QuerySnapshot querySnapshot) => querySnapshot.docs
            .map((DocumentSnapshot documentSnapshot) => Product(
                  id: documentSnapshot.get('productId'),
                  title: documentSnapshot.get('productTitle'),
                  description: documentSnapshot.get('productDescription'),
                  price: double.parse(documentSnapshot.get('price')),
                  cuttedPrice:
                      double.parse(documentSnapshot.get('cuttedPrice')),
                  imageUrl: documentSnapshot.get('productImage'),
                  productCategoryName: documentSnapshot.get('productCategory'),
                  unitAmount: documentSnapshot.get('unitAmount'),
                  isPopular: documentSnapshot.get('isPopular'),
                  percentOff: documentSnapshot.get('percentOff'),
                  inStock: documentSnapshot.get('inStock'),
                ))
            .toList());
  }
}
