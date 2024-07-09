import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../Constants/colors.dart';
import '../Screens/address.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderFull extends StatefulWidget {
  final productImage;
  final productTitle;
  final productPrice;
  final productQuantity;
  final productId;
  final orderId;
  final status;
  final address;
  final orderDate;
  OrderFull({
    required this.productImage,
    required this.productTitle,
    required this.productPrice,
    required this.productQuantity,
    required this.productId,
    required this.orderId,
    required this.status,
    required this.address,
    required this.orderDate,
  });
  @override
  _OrderFullState createState() => _OrderFullState();
}

class _OrderFullState extends State<OrderFull> {
  String status(String status) {
    if (status == 'Ordered') {
      return 'Ordered';
    } else if (status == 'Cancelled') {
      return 'Cancelled';
    }
    return 'Delivered';
  }

  Color getMyColor(String value) {
    if (value == 'Delivered') {
      return Colors.green;
    } else if (value == 'Cancelled') {
      return const Color(0xFFDA1414);
    } else if (value == 'Ordered') {
      return const Color(0xFF2E5AAC);
    } else if (value == 'Out For Delivery') {
      return Colors.deepPurpleAccent;
    }
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    String formatTimestamp(Timestamp timestamp) {
      final timestampDate = widget.orderDate.toDate();
      final now = DateTime.now();
      final today =
          DateTime(timestampDate.year, timestampDate.month, timestampDate.day);
      final todayTime = DateTime(now.year, now.month, now.day);
      final yesterdayTime = DateTime(now.year, now.month, now.day - 1);

      String formattedTime = DateFormat.jm().format(widget.orderDate.toDate());

      if (today == todayTime) {
        return 'today at ${formattedTime}';
      } else if (today == yesterdayTime) {
        return 'yesterday at ${formattedTime}';
      }

      var format = DateFormat('d-MMMM-y'); // <- use skeleton here
      return format.format(timestamp.toDate());
    }

    return InkWell(
      onTap: () {
        showModalBottomSheet(
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
              ),
            ),
            backgroundColor: Colors.white,
            context: context,
            builder: (BuildContext context) {
              return Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        height: 5,
                        width: 100,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    RichText(
                      text: TextSpan(
                          text: 'Order Details',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                                text: ' (${widget.orderId})',
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 12)),
                          ]),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Container(
                          height: 85,
                          width: 85,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xFFE7FAF0),
                          ),
                          child: Center(
                            child: Image.network(
                              widget.productImage,
                              height: 70,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          height: 70,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.productTitle,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                'Pure Organic',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                              RichText(
                                text: TextSpan(children: [
                                  const WidgetSpan(
                                    child: Icon(
                                      Icons.currency_rupee,
                                      size: 16,
                                    ),
                                  ),
                                  TextSpan(
                                      text: widget.productPrice.toString(),
                                      style: TextStyle(
                                          color: ColorsConsts.AppMainColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  const TextSpan(
                                    text: '/kg',
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black,
                                        fontSize: 12),
                                  )
                                ]),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Delivery Address',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.of(context).pushNamed(Address.routeName);
                      },
                      contentPadding: const EdgeInsets.all(0),
                      trailing: const Icon(
                        Icons.arrow_forward_ios_sharp,
                        size: 15,
                      ),
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xFFE7FAF0),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.location_on,
                            color: Colors.red,
                          ),
                        ),
                      ),
                      title: Text(
                        widget.address,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Ordered Date',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ListTile(
                      onTap: () {
                        // Navigator.of(context).pushNamed(Address.routeName);
                      },
                      contentPadding: const EdgeInsets.all(0),
                      trailing: const Icon(
                        Icons.arrow_forward_ios_sharp,
                        size: 15,
                      ),
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xFFE7FAF0),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.shopping_bag,
                            color: Colors.green,
                          ),
                        ),
                      ),
                      title: Text(
                        '${formatTimestamp(widget.orderDate)}',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Order Info',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Price'),
                        RichText(
                          text: TextSpan(children: [
                            const WidgetSpan(
                              child: Icon(
                                Icons.currency_rupee,
                                size: 15,
                              ),
                            ),
                            TextSpan(
                                text: (widget.productPrice /
                                        widget.productQuantity)
                                    .toString(),
                                style: const TextStyle(
                                  color: Colors.black,
                                ))
                          ]),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Quantity'),
                        RichText(
                          text: TextSpan(children: [
                            // WidgetSpan(
                            //   child: Icon(
                            //     Icons.currency_rupee,
                            //     size: 15,
                            //   ),
                            // ),
                            TextSpan(
                                text: widget.productQuantity.toString(),
                                style: const TextStyle(
                                  color: Colors.black,
                                ))
                          ]),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Delivery Charge'),
                        RichText(
                          text: const TextSpan(children: [
                            WidgetSpan(
                              child: Icon(
                                Icons.currency_rupee,
                                size: 15,
                              ),
                            ),
                            TextSpan(
                                text: '0',
                                style: TextStyle(
                                  color: Colors.black,
                                ))
                          ]),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Amount'),
                        RichText(
                          text: TextSpan(children: [
                            const WidgetSpan(
                              child: Icon(
                                Icons.currency_rupee,
                                size: 25,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                                text: widget.productPrice.toString(),
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold))
                          ]),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              );
            });
      },
      child: Container(
        height: 100,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7), color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 85,
                width: 85,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xFFE7FAF0),
                ),
                child: Center(
                  child: Image.network(
                    widget.productImage,
                    height: 70,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.productTitle,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Pure Organic',
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                  RichText(
                    text: TextSpan(children: [
                      const WidgetSpan(
                        child: Icon(
                          Icons.currency_rupee,
                          size: 16,
                        ),
                      ),
                      TextSpan(
                          text: widget.productPrice.toString(),
                          style: TextStyle(
                              color: ColorsConsts.AppMainColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      const TextSpan(
                        text: '/kg',
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                            fontSize: 12),
                      )
                    ]),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.status == 'Ordered')
                    InkWell(
                      onTap: () async {
                        await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: const Color(0xFFFDEDEF),
                                title: Row(
                                  children: const [
                                    Padding(
                                      padding: EdgeInsets.only(right: 6.0),
                                      child: Icon(
                                        Icons.error,
                                        color: Colors.red,
                                        size: 40,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'Cancel order !',
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                content: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Are you sure ? ${widget.productTitle} will be cancelled from your orders.',
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () async {
                                      await FirebaseFirestore.instance
                                          .collection('order')
                                          .doc(widget.orderId)
                                          .update({
                                        'status': 'Cancelled',
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      'Yes',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'No',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        color: ColorsConsts.AppMainColor,
                                        fontSize: 16,
                                      ),
                                    ),
                                  )
                                ],
                              );
                            });
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(
                          right: 10,
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  if (widget.status == 'Ordered')
                    const SizedBox(
                      height: 20,
                    ),
                  // if (widget.status == 'Ordered')
                  Container(
                    // height: 30,
                    // width: 90,
                    decoration: BoxDecoration(
                      color: getMyColor(widget.status),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Text(
                          widget.status,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // if (widget.status == 'Cancelled')
                  //   Container(
                  //     height: 30,
                  //     width: 90,
                  //     decoration: BoxDecoration(
                  //       color: Colors.red,
                  //       borderRadius: BorderRadius.circular(20),
                  //     ),
                  //     child: const Center(
                  //       child: Text(
                  //         'Cancelled',
                  //         style: TextStyle(
                  //           color: Colors.white,
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // if (widget.status == 'Delivered')
                  //   Container(
                  //     height: 30,
                  //     width: 90,
                  //     decoration: BoxDecoration(
                  //       color: const Color(0xFF2E5AAC),
                  //       borderRadius: BorderRadius.circular(20),
                  //     ),
                  //     child: const Center(
                  //       child: Text(
                  //         'Delivered',
                  //         style: TextStyle(
                  //           color: Colors.white,
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // if (widget.status == 'Out For Delivery')
                  //   Container(
                  //     height: 30,
                  //     width: 90,
                  //     decoration: BoxDecoration(
                  //       color: const Color(0xFF2E5AAC),
                  //       borderRadius: BorderRadius.circular(20),
                  //     ),
                  //     child: const Center(
                  //       child: Text(
                  //         'Delivered',
                  //         style: TextStyle(
                  //           color: Colors.white,
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
