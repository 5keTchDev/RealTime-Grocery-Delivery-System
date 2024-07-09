import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class AddressFull extends StatefulWidget {
  bool isSelected;
  String userName;
  String houseNo;
  String roadName;
  String city;
  String phoneNo;
  String addressId;

  AddressFull({
    required this.isSelected,
    required this.userName,
    required this.houseNo,
    required this.roadName,
    required this.city,
    required this.phoneNo,
    required this.addressId,
  });

  @override
  State<AddressFull> createState() => _AddressFullState();
}

class _AddressFullState extends State<AddressFull> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    // final addressAttrProvider = Provider.of<AddressAttr>(context);
    // final addressProvider=Provider.of<AddressProvider>(context);

    return Container(
      color: Colors.white,
      height: 150,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            onChanged: (value) async {
              // FirebaseFirestore.instance
              //     .collection('address')
              //     .doc(widget.addressId)
              //     .update({'selected': true});
              // setState(() {
              //   widget.isSelected = value!;
              // });
              final FirebaseAuth _auth = FirebaseAuth.instance;
              final User? user = _auth.currentUser;
              final _uid = user!.uid;
              try {
                isLoading = true;

                var collection = FirebaseFirestore.instance
                    .collection('address')
                    .where('userId', isEqualTo: _uid);
                var querySnapshots = await collection.get();
                for (var doc in querySnapshots.docs
                    .where((element) => element.id == widget.addressId)) {
                  await doc.reference.update({
                    'selected': true,
                  });
                }
                for (var doc in querySnapshots.docs
                    .where((element) => element.id != widget.addressId)) {
                  await doc.reference.update({
                    'selected': false,
                  });
                }

                // addressProvider.fetchAddressItems();
                // addressProvider.notifyListeners();

              } catch (e) {
                Fluttertoast.showToast(msg: 'error occured $e');
              } finally {
                isLoading = false;
              }
            },
            value: widget.isSelected,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Text(
                    '${widget.userName}',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 50,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Container(
                      child: Text(
                        '${widget.houseNo}, ${widget.roadName}, ${widget.city}, ',
                        style: TextStyle(fontSize: 15, color: Colors.black),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Text(
                      '${widget.phoneNo}',
                      style: TextStyle(fontSize: 15, color: Colors.black),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
