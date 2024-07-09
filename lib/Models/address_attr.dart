import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddressAttr extends ChangeNotifier {
  String addressId;
  String userId;
  String name;
  String phoneNumber;
  String pincode;
  String state;
  String city;
  String houseNo;
  String roadName;
  bool selected;

  AddressAttr(
      {required this.addressId,
      required this.userId,
      required this.name,
      required this.phoneNumber,
      required this.pincode,
      required this.state,
      required this.city,
      required this.houseNo,
      required this.roadName,
      required this.selected});

  Stream<List<AddressAttr>> get addresses {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? _user = _auth.currentUser;
    var _uid = _user?.uid;
    return FirebaseFirestore.instance
        .collection('address')
        .where('userId', isEqualTo: _uid)
        .snapshots()
        .map((QuerySnapshot querySnapshot) => querySnapshot.docs
            .map(
              (DocumentSnapshot documentSnapshot) => AddressAttr(
                addressId: documentSnapshot.get('addressId'),
                userId: documentSnapshot.get('userId'),
                name: documentSnapshot.get('name'),
                phoneNumber: documentSnapshot.get('phoneNumber'),
                pincode: documentSnapshot.get('pincode'),
                state: documentSnapshot.get('state'),
                city: documentSnapshot.get('city'),
                houseNo: documentSnapshot.get('houseNo'),
                roadName: documentSnapshot.get('roadName'),
                selected: documentSnapshot.get('selected'),
              ),
            )
            .toList());
  }
}
