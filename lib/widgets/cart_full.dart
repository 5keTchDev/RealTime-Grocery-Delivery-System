import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Constants/colors.dart';
import '../Models/product.dart';
import '../services/global_method.dart';

class CartFull extends StatefulWidget {
  final String productImage;
  final String productTitle;
  final String productPrice;
  final double productQuantity;
  final String cartId;
  final String productId;
  final void Function(List) function;
  CartFull({
    required this.productImage,
    required this.productTitle,
    required this.productPrice,
    required this.productQuantity,
    required this.cartId,
    required this.productId,
    required this.function,
  });

  @override
  _CartFullState createState() => _CartFullState();
}

class _CartFullState extends State<CartFull> {
  double quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Consumer<List<Product>>(builder: (context, products, child) {
      Product product =
          products.firstWhere((element) => element.id == widget.productId);

      List<Product> listProducts =
          products.where((element) => element.inStock == false).toList();
      List<String> listsOfProductIdsNotInStock = [];
      listProducts.forEach((element) {
        listsOfProductIdsNotInStock.add(element.id);
      });

      widget.function(listsOfProductIdsNotInStock);

      return Container(
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
                  Container(
                    // color: Colors.red,
                    width: 100,
                    height: 20,
                    child: Text(
                      '${widget.productTitle}',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
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
                          text: widget.productPrice,
                          style: TextStyle(
                              color: ColorsConsts.AppMainColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      // const TextSpan(
                      //   text: '/kg',
                      //   style: TextStyle(
                      //       fontWeight: FontWeight.normal,
                      //       color: Colors.black,
                      //       fontSize: 12),
                      // )
                    ]),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                                      'Delete item !',
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
                                  'Are you sure ? ${widget.productTitle} will be deleted from your cart.',
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () async {
                                    await FirebaseFirestore.instance
                                        .collection('cart')
                                        .doc(widget.cartId)
                                        .delete();
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    'Delete',
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
                                    'Cancel',
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
                    child: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
                  product.inStock!
                      ? Container(
                          height: 50,
                          width: 110,
                          decoration: BoxDecoration(
                            color: ColorsConsts.AppMainColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () async {
                                  if (widget.productQuantity > 0.5) {
                                    await FirebaseFirestore.instance
                                        .collection('cart')
                                        .doc(widget.cartId)
                                        .update({
                                      'quantity': widget.productQuantity - 0.5
                                    });
                                  } else {
                                    GlobalMethod.showSnackBar(
                                      title:
                                          'You cannot buy products below 0.5kg !',
                                      context: context,
                                      color: Colors.black,
                                      isIcon: false,
                                      icon: null,
                                      iconBackgroundColor: Colors.transparent,
                                    );
                                  }
                                },
                                child: const Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Text(
                                    '-',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 40),
                                  ),
                                ),
                              ),
                              Text(
                                widget.productQuantity.toString(),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              InkWell(
                                onTap: () async {
                                  await FirebaseFirestore.instance
                                      .collection('cart')
                                      .doc(widget.cartId)
                                      .update({
                                    'quantity': widget.productQuantity + 0.5
                                  });
                                },
                                child: const Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Text(
                                    '+',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 30),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      : const Text(
                          'Out of Stock',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
