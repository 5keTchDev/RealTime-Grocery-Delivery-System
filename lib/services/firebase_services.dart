import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FirebaseServices extends ChangeNotifier {
  String? description;
  bool? canOrder;
  int value = 0;
  Future<void> getAppService() async {
    final doc = FirebaseFirestore.instance
        .collection('Appservice')
        .doc('PfYO4WQFXzmhbt0wLGMJ')
        .get();
    doc.then((value) {
      description = value.get('description');
      canOrder = value.get('canOrder');

      print('des $description');
    });
    print('descr $description');
    notifyListeners();
  }

  void increaseValue() {
    value = value + 1;
    print(value);
    notifyListeners();
  }
}
