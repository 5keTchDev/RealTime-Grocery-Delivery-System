import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../Constants/colors.dart';
import '../Models/address_attr.dart';
import '../Models/cart_attr.dart';
import '../services/global_method.dart';
import '../widgets/appbarCustom.dart';
import 'order_success.dart';

class Payments extends StatefulWidget {
  static const routeName = '/payments';

  @override
  State<Payments> createState() => _PaymentsState();
}

class _PaymentsState extends State<Payments> {
  bool isLoading = false;
  GlobalMethod globalMethod = GlobalMethod();
  void submitOrder() async {
    setState(() {
      isLoading = true;
    });
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? _user = _auth.currentUser;
    var _uid = _user?.uid;
    var uuid = Uuid();

    final cartListProvider =
        Provider.of<List<CartAttr>>(context, listen: false);
    final addressProvider =
        Provider.of<List<AddressAttr>>(context, listen: false);
    AddressAttr selectedAddress;
    selectedAddress =
        addressProvider.firstWhere((element) => element.selected == true);
    cartListProvider.forEach((cartItem) async {
      final orderId = uuid.v4();

      try {
        await FirebaseFirestore.instance.collection('order').doc(orderId).set({
          'orderId': orderId,
          'userId': _uid,
          'productId': cartItem.productId,
          'productTitle': cartItem.title,
          'address': '${selectedAddress.name} '
              '${selectedAddress.houseNo}  '
              '${selectedAddress.roadName} '
              '${selectedAddress.city} '
              '${selectedAddress.state} '
              '${selectedAddress.pincode} '
              '${selectedAddress.phoneNumber}',
          'price': cartItem.price * cartItem.quantity,
          'imageUrl': cartItem.imageUrl,
          'quantity': cartItem.quantity,
          'status': 'Ordered',
          'orderDate': Timestamp.now(),
          'Phone': selectedAddress.phoneNumber.toString(),
          'deliveryBoy': '',
        }).then((value) async {
          var snapshot = await FirebaseFirestore.instance
              .collection('cart')
              .where('userId', isEqualTo: _uid)
              .get();
          for (var doc in snapshot.docs) {
            await doc.reference.delete().then((value) {
              setState(() {
                isLoading = false;
              });
            });
          }
          Navigator.of(context).pushNamedAndRemoveUntil(
            OrderSuccess.routeName,
            (Route<dynamic> route) => false,
            arguments: 'please check in orders',
          );
        }).catchError((error) {
          setState(() {
            isLoading = false;
          });
          globalMethod.authErrorHandle(error.toString(), context);
        });
      } catch (error) {
        print('error occured:${error.toString()}');
        //  globalMethod.authErrorHandle(error.toString(), context);
        // setState(() {
        //   isLoading = false;
        // });
      } finally {
        // setState(() {
        //   isLoading = false;
        // });

      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<List<CartAttr>>(builder: (context, cartList, child) {
      double totalAmount = 0;
      cartList.forEach((element) {
        totalAmount = totalAmount + element.price * element.quantity;
      });
      return SafeArea(
        child: Scaffold(
          // backgroundColor: Colors.white,
          appBar: const PreferredSize(
            preferredSize: Size.fromHeight(100),
            child: AppBarCustom(
              title: 'Payments',
            ),
          ),
          bottomSheet: Container(
            height: 60,
            decoration: BoxDecoration(
              color: ColorsConsts.AppMainColor,
              border:
                  const Border(top: BorderSide(color: Colors.grey, width: 0.5)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Expanded(
                    child: isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                            color: Colors.white,
                          ))
                        : Material(
                            color: Colors.deepOrange,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(30),
                              onTap: () {
                                submitOrder();
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Continue',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(
                        FontAwesomeIcons.rupeeSign,
                        color: Colors.white,
                        size: 20,
                      ),
                      Text(
                        totalAmount.toStringAsFixed(2),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 15, left: 8, bottom: 15),
                    child: Text(
                      'Cash on Delivery',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                  SizedBox(
                    height: 2,
                    child: Container(
                      color: Colors.grey.shade300,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Price Details',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // productId != null
                            //     ? Text(
                            //         'Price (1 item)',
                            //         style: TextStyle(
                            //             color: Colors.black, fontSize: 13),
                            //       )
                            //     :
                            Text(
                              'Price (${cartList.length} items)',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 13),
                            ),
                            // productId != null
                            //     ? Text(
                            //         '${Provider.of<Products>(context).getById(productId.toString()).price}',
                            //         style: TextStyle(
                            //             color: Colors.black, fontSize: 13),
                            //       )
                            //     :
                            Text(
                              '$totalAmount',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 13),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              'Delivery Charges',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 13),
                            ),
                            Text(
                              'Free',
                              style:
                                  TextStyle(color: Colors.green, fontSize: 13),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 2,
                          child: Container(
                            color: Colors.grey.shade300,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total Amount',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold),
                            ),
                            // productId != null
                            //     ? Text(
                            //         '${Provider.of<Products>(context).getById(productId.toString()).price}',
                            //         style: TextStyle(
                            //             color: Colors.black, fontSize: 13),
                            //       )
                            //     :
                            Text(
                              '$totalAmount',
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
