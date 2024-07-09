import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/appbarCustom.dart';
import 'order_empty.dart';
import 'order_full.dart';

class OrderScreen extends StatefulWidget {
  //To be known 1) the amount must be an integer 2) the amount must not be double 3) the minimum amount should be less than 0.5 $
  static const routeName = '/OrderScreen';

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: AppBarCustom(
            title: 'Your Orders',
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('order')
                // .orderBy('orderDate', descending: false)
                .where('userId',
                    isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .orderBy('orderDate', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return const Center(
                  child: Text('error occurred'),
                );
              }
              final order = snapshot.data!.docs;
              if (order.isEmpty) {
                return OrderEmpty();
              }

              return Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: order.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: OrderFull(
                              productImage: order[index].get('imageUrl'),
                              productTitle: order[index].get('productTitle'),
                              productPrice: order[index].get('price'),
                              productQuantity: order[index].get('quantity'),
                              productId: order[index].get('productId'),
                              orderId: order[index].get('orderId'),
                              status: order[index].get('status'),
                              address: order[index].get('address'),
                              orderDate: order[index].get('orderDate'),
                            ),
                          );
                        }),
                  )
                ],
              );
            }),
      ),
    );
  }
}
