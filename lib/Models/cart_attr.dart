import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CartAttr extends ChangeNotifier {
  String id;
  String productId;
  String userId;
  String title;
  double quantity;
  double price;
  String imageUrl;
  double cuttedPrice;
  String unitAmount;
  String percentOff;

  CartAttr(
      {required this.id,
      required this.productId,
      required this.userId,
      required this.title,
      required this.quantity,
      required this.price,
      required this.imageUrl,
      required this.cuttedPrice,
      required this.unitAmount,
      required this.percentOff});

  Stream<List<CartAttr>> get cartItems {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? _user = _auth.currentUser;
    var _uid = _user?.uid;
    return FirebaseFirestore.instance
        .collection('cart')
        .where('userId', isEqualTo: _uid)
        .snapshots()
        .map((QuerySnapshot querySnapshot) => querySnapshot.docs
            .map((DocumentSnapshot documentSnapshot) => CartAttr(
                  id: documentSnapshot.get('cartId'),
                  productId: documentSnapshot.get('productId'),
                  userId: documentSnapshot.get('userId'),
                  title: documentSnapshot.get('title'),
                  quantity: documentSnapshot.get('quantity'),
                  price: documentSnapshot.get('price'),
                  imageUrl: documentSnapshot.get('imageUrl'),
                  cuttedPrice: documentSnapshot.get('cuttedPrice'),
                  unitAmount: documentSnapshot.get('unitAmount'),
                  percentOff: documentSnapshot.get('percentOff'),
                ))
            .toList());
  }
}
