import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:collection/collection.dart';

import '../Models/user_attr.dart';

class UserProvider extends ChangeNotifier {
  // List<UserAttr> _userList = [];
  UserAttr? userAttr;
  int value = 0;

  // List<UserAttr> get getUsers {
  //   return _userList;
  // }

  Future<void> fetchUsers() async {
    // final FirebaseAuth _auth = FirebaseAuth.instance;
    // User? _user = _auth.currentUser;
    // var _uid = _user?.uid;
    var uid = FirebaseAuth.instance.currentUser?.uid;

    print('fetching users in user_provider.dart');

    try {
      var document =
          await FirebaseFirestore.instance.collection('users').doc(uid);
      document.get().then((value) {
        userAttr = UserAttr(
            id: value['id'],
            mobileNumber: '',
            name: value['name'],
            email: value['email'],
            joinedDate: value['joinedAt'],
            status: value['status']);
      });
      notifyListeners();
    } catch (error) {
      print('Printing error while fetching users in user_provider.dart $error');
    }
    notifyListeners();
  }

  void increaseValue() {
    value = value + 1;
    print(value);
    notifyListeners();
  }
}
