import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../services/global_method.dart';
import 'appbarCustom.dart';

class AddressEmpty extends StatefulWidget {
  static const routeName = '/AddressEmpty';

  @override
  State<AddressEmpty> createState() => _AddressEmptyState();
}

class _AddressEmptyState extends State<AddressEmpty> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController stateController = TextEditingController();

  var name = '';
  var phoneNumber = '';
  var pincode = '';
  var state = '';
  var city = '';
  var houseNo = '';
  var roadNo = '';
  GlobalMethod _globalMethods = GlobalMethod();

  String? stateValue;
  bool _isLoading = false;
  var uuid = Uuid();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _trySubmit() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState!.save();

      if (phoneNumber.length != 10) {
        GlobalMethod method = GlobalMethod();
        method.authErrorHandle('Please Enter Valid Mobile Number!', context);
      } else {
        try {
          setState(() {
            _isLoading = true;
          });

          final User? user = _auth.currentUser;
          final _uid = user!.uid;
          final addressId = uuid.v4();
          await FirebaseFirestore.instance
              .collection('address')
              .doc(addressId)
              .set({
            'addressId': addressId,
            'userId': _uid,
            'name': name,
            'phoneNumber': phoneNumber,
            'pincode': pincode,
            'state': state,
            'city': stateValue,
            'houseNo': houseNo,
            'roadName': roadNo,
            'selected': true,
          });

          var collection = FirebaseFirestore.instance
              .collection('address')
              .where('userId', isEqualTo: _uid);
          var querySnapshots = await collection.get();
          for (var doc in querySnapshots.docs
              .where((element) => element.id != addressId)) {
            await doc.reference.update({
              'selected': false,
            });
          }

          // Navigator.removeRoute(context, MaterialPageRoute(builder: (context) => ThePage()));
          // Navigator.of(context)
          //     .pushNamedAndRemoveUntil(OrderSuccess.routeName, (Route<dynamic> route) => false);

          Navigator.canPop(context) ? Navigator.pop(context) : null;
        } catch (error) {
          _globalMethods.authErrorHandle(error.toString(), context);
          print('error occured ${error.toString()}');
        } finally {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: AppBarCustom(
            title: 'Add Delivery Address',
          ),
        ),
        bottomSheet: InkWell(
          onTap: _trySubmit,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            color: Colors.deepOrange,
            child: Center(
                child: _isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text(
                        'Save Address',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      )),
          ),
        ),
        body: Padding(
          padding:
              const EdgeInsets.only(top: 30, bottom: 60, right: 8, left: 8),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          key: const ValueKey('name'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your Name';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Name (Required)*',
                            labelStyle: TextStyle(color: Colors.grey),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.red, width: 1.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.red, width: 1.0),
                            ),
                          ),
                          onSaved: (value) {
                            name = value!;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          key: ValueKey('phoneNumber'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your Mobile Number';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelStyle: TextStyle(color: Colors.grey),
                            labelText: 'Mobile (Required)*',
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.red, width: 1.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.red, width: 1.0),
                            ),
                          ),
                          onSaved: (value) {
                            phoneNumber = value!;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          key: const ValueKey('pincode'),
                          validator: (value) {
                            if (value!.isEmpty && value.length == 6) {
                              return 'Please enter your Pincode';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Pincode (Required)*',
                            labelStyle: TextStyle(color: Colors.grey),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.red, width: 1.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.red, width: 1.0),
                            ),
                          ),
                          onSaved: (value) {
                            pincode = value!;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonFormField(
                          hint: const Text('Select State'),
                          decoration: const InputDecoration(
                            labelText: 'State (Required)*',
                            labelStyle: TextStyle(color: Colors.grey),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.red, width: 1.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.red, width: 1.0),
                            ),
                          ),
                          value: stateValue,
                          validator: (value) {
                            if (value == null) {
                              return 'Please Select State';
                            }
                          },
                          items: [
                            // 'Andhra Pradesh',
                            // 'Arunachal Pradesh',
                            // 'Assam',
                            'Bihar',
                            'Uttar Pradesh',
                            // 'Chhattisgarh',
                            // 'Delhi',
                            // 'Goa',
                            // 'Gujarat',
                            // 'Haryana',
                            // 'Himachal Pradesh',
                            // 'Jammu Kashmir',
                            // 'Jharkhand',
                            // 'Karnataka',
                            // 'Kerala',
                            // 'Madhya Pradesh',
                            // 'Maharashtra',
                            // 'Manipur',
                            // 'Meghalaya',
                            // 'Mizoram',
                            // 'Nagaland',
                            // 'Odisha',
                            // 'Punjab',
                            // 'Rajasthan',
                            // 'Sikkim',
                            // 'Tamil Nadu',
                            // 'Telangana',
                            // 'Tripura',
                            // 'Uttar Pradesh',
                            // 'Uttarakhand',
                            // 'West Bengal'
                          ].map((value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              stateValue = value as String?;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          key: ValueKey('city'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your city';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'City (Required)*',
                            labelStyle: TextStyle(color: Colors.grey),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.red, width: 1.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.red, width: 1.0),
                            ),
                          ),
                          onSaved: (value) {
                            city = value!;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          key: const ValueKey('houseNo'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your House No.,Building name';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'House No,Building Name (Required)*',
                            labelStyle: TextStyle(color: Colors.grey),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.red, width: 1.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.red, width: 1.0),
                            ),
                          ),
                          onSaved: (value) {
                            houseNo = value!;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          key: const ValueKey('roadNo'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your Road Name,Area,Colony';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Road Name, Area, Colony (Required)*',
                            labelStyle: TextStyle(color: Colors.grey),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.red, width: 1.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.red, width: 1.0),
                            ),
                          ),
                          onSaved: (value) {
                            roadNo = value!;
                          },
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
