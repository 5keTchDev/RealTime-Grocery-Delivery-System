import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:provider/provider.dart';
import '../Constants/colors.dart';
import '../Models/cart_attr.dart';
import '../Models/product.dart';
import '../Provider/user_provider.dart';
import '../services/global_method.dart';
import '../widgets/cart_empty.dart';
import '../widgets/cart_full.dart';
import 'order_summary.dart';
import '../services/firebase_services.dart';

class Cart extends StatefulWidget {
  static const routeName = '/cart';

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  final FirebaseServices _services = FirebaseServices();

  Future<void> getAppService() async {
    await Provider.of<FirebaseServices>(context, listen: false).getAppService();
  }

  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getAppService();
    });
  }

  @override
  Widget build(BuildContext context) {
    // print('appservice ${_services.description}');
    // print('value ${Provider.of<FirebaseServices>(context).value}');

    getValue(value) {
      print('value in cart.dart $value');
    }

    return Consumer<List<CartAttr>>(builder: (context, cartItems, child) {
      if (cartItems.isEmpty) {
        return CartEmpty();
      }

      double totalPrice = 0;

      List<Product> listOfProducts = Provider.of<List<Product>>(context);
      List<Product> listProductsNotInStock =
          listOfProducts.where((element) => element.inStock == false).toList();

      List<String> listsOfProductIdsNotInStock = [];

      listProductsNotInStock.forEach((element) {
        listsOfProductIdsNotInStock.add(element.id);
      });

      List<String> lists = [];
      cartItems.forEach((element) {
        lists.add(element.productId);
      });
      List listOfIdsInCartOutOfStock = [];

      List<String> output = listsOfProductIdsNotInStock
          .where((element) => lists.contains(element))
          .toList();

      List<CartAttr> listsOfCarts = cartItems
          .where((element) => output.contains(element.productId))
          .toList();
      print('listsOfCarts $listsOfCarts');
      listsOfCarts.forEach((element) {});

      Future<void> delete() async {
        listsOfCarts.forEach((element) async {
          print(element.id);
          await FirebaseFirestore.instance
              .collection('cart')
              .doc(element.id)
              .delete();
        });
      }

      cartItems.forEach((element) {
        totalPrice = totalPrice + element.price * element.quantity;
      });
      return SafeArea(
        child: Scaffold(
          // bottomSheet: Container(
          //   height: 220,
          //   decoration: BoxDecoration(
          //     color: ColorsConsts.AppMainColor,
          //     borderRadius: BorderRadius.circular(20),
          //   ),
          //   child: Padding(
          //     padding: const EdgeInsets.all(15.0),
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: [
          //             Text(
          //               'Subtotal',
          //               style: TextStyle(color: Colors.white),
          //             ),
          //             RichText(
          //               text: TextSpan(children: [
          //                 WidgetSpan(
          //                     child: Icon(
          //                   Icons.currency_rupee,
          //                   color: Colors.white,
          //                   size: 15,
          //                 )),
          //                 TextSpan(
          //                   text: '10',
          //                   style: TextStyle(
          //                       color: Colors.white,
          //                       fontSize: 18,
          //                       fontWeight: FontWeight.bold),
          //                 )
          //               ]),
          //             ),
          //           ],
          //         ),
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: [
          //             Text(
          //               'Delivery Charge',
          //               style: TextStyle(color: Colors.white),
          //             ),
          //             RichText(
          //               text: TextSpan(children: [
          //                 WidgetSpan(
          //                     child: Icon(
          //                   Icons.currency_rupee,
          //                   color: Colors.white,
          //                   size: 15,
          //                 )),
          //                 TextSpan(
          //                   text: '0',
          //                   style: TextStyle(
          //                       color: Colors.white,
          //                       fontSize: 18,
          //                       fontWeight: FontWeight.bold),
          //                 )
          //               ]),
          //             ),
          //           ],
          //         ),
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: [
          //             Text(
          //               'Discount',
          //               style: TextStyle(color: Colors.white),
          //             ),
          //             RichText(
          //               text: TextSpan(children: [
          //                 WidgetSpan(
          //                     child: Icon(
          //                   Icons.currency_rupee,
          //                   color: Colors.white,
          //                   size: 15,
          //                 )),
          //                 TextSpan(
          //                   text: '0',
          //                   style: TextStyle(
          //                       color: Colors.white,
          //                       fontSize: 18,
          //                       fontWeight: FontWeight.bold),
          //                 )
          //               ]),
          //             ),
          //           ],
          //         ),
          //         Divider(
          //           color: Colors.white,
          //         ),
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: [
          //             Text(
          //               'Total',
          //               style: TextStyle(color: Colors.white),
          //             ),
          //             RichText(
          //               text: TextSpan(children: [
          //                 WidgetSpan(
          //                     child: Icon(
          //                   Icons.currency_rupee,
          //                   color: Colors.white,
          //                   size: 15,
          //                 )),
          //                 TextSpan(
          //                   text: '10',
          //                   style: TextStyle(
          //                       color: Colors.white,
          //                       fontSize: 18,
          //                       fontWeight: FontWeight.bold),
          //                 )
          //               ]),
          //             ),
          //           ],
          //         ),
          //         Row(
          //           children: [
          //             Expanded(
          //               child: OutlinedButton(
          //                 onPressed: null,
          //                 style: ButtonStyle(
          //                   backgroundColor:
          //                       MaterialStateProperty.all(Colors.white),
          //                   shape: MaterialStateProperty.all(
          //                       RoundedRectangleBorder(
          //                           borderRadius:
          //                               BorderRadius.circular(30.0))),
          //                 ),
          //                 child: Padding(
          //                   padding:
          //                       const EdgeInsets.only(top: 15, bottom: 15),
          //                   child: Text(
          //                     "Place my order",
          //                     style: TextStyle(
          //                         color: ColorsConsts.AppMainColor,
          //                         fontSize: 18),
          //                   ),
          //                 ),
          //               ),
          //             ),
          //           ],
          //         ),
          //       ],
          //     ),
          //   ),
          // ),

          bottomSheet: Container(
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
                    child: Material(
                      color: Colors.deepOrange,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(30),
                        onTap: () async {
                          if (listsOfCarts.isNotEmpty) {
                            await showDialog(
                                context: context,
                                builder: (BuildContext ctx) {
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
                                            'Error Occurred',
                                            style: TextStyle(
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    content: const Text(
                                      'आपके कार्ट में वैसे आइटम्स है जो अभी हमारे पास नहीं है, आप इस आइटम को delete कर दे।',
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () async {
                                          await delete();
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          'Delete',
                                          style: TextStyle(
                                            color: ColorsConsts.AppMainColor,
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
                                          style: TextStyle(
                                            color: ColorsConsts.AppMainColor,
                                            fontSize: 16,
                                          ),
                                        ),
                                      )
                                    ],
                                  );
                                });
                            return;
                          }
                          if (Provider.of<UserProvider>(context, listen: false)
                                  .userAttr
                                  ?.status ==
                              'Blocked') {
                            GlobalMethod.showSnackBar(
                                title: 'You have been blocked !',
                                context: context,
                                color: Colors.red,
                                icon: Icons.shopping_bag,
                                isIcon: false,
                                function: null,
                                iconBackgroundColor: Colors.green);
                            return;
                          }
                          if (totalPrice < 40) {
                            await showDialog(
                                context: context,
                                builder: (BuildContext ctx) {
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
                                            'Error Occurred',
                                            style: TextStyle(
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    content: const Text(
                                      'हमलोग 40 रुपए से कम का ऑर्डर नहीं लेते है। कृपया अपने cart में और item डाले।',
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          'Ok',
                                          style: TextStyle(
                                            color: ColorsConsts.AppMainColor,
                                            fontSize: 16,
                                          ),
                                        ),
                                      )
                                    ],
                                  );
                                });
                            return;
                          }
                          if (Provider.of<FirebaseServices>(context,
                                      listen: false)
                                  .canOrder !=
                              null) {
                            if (Provider.of<FirebaseServices>(context,
                                        listen: false)
                                    .canOrder ==
                                false) {
                              await showDialog(
                                  context: context,
                                  builder: (BuildContext ctx) {
                                    return AlertDialog(
                                      backgroundColor: const Color(0xFFFDEDEF),
                                      title: Row(
                                        children: const [
                                          Padding(
                                            padding:
                                                EdgeInsets.only(right: 6.0),
                                            child: Icon(
                                              Icons.error,
                                              color: Colors.red,
                                              size: 40,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              'Error Occurred',
                                              style: TextStyle(
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      content: Text(
                                        '${Provider.of<FirebaseServices>(context).description}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            'Ok',
                                            style: TextStyle(
                                              color: ColorsConsts.AppMainColor,
                                              fontSize: 16,
                                            ),
                                          ),
                                        )
                                      ],
                                    );
                                  });
                              return;
                            }
                          }
                          // if (!canOrder!) {
                          //   await showDialog(
                          //       context: context,
                          //       builder: (BuildContext ctx) {
                          //         return AlertDialog(
                          //           backgroundColor: const Color(0xFFFDEDEF),
                          //           title: Row(
                          //             children: const [
                          //               Padding(
                          //                 padding: EdgeInsets.only(right: 6.0),
                          //                 child: Icon(
                          //                   Icons.error,
                          //                   color: Colors.red,
                          //                   size: 40,
                          //                 ),
                          //               ),
                          //               Padding(
                          //                 padding: EdgeInsets.all(8.0),
                          //                 child: Text(
                          //                   'Error Occurred',
                          //                   style: TextStyle(
                          //                     fontSize: 20,
                          //                   ),
                          //                 ),
                          //               ),
                          //             ],
                          //           ),
                          //           content: Text(
                          //             '$description',
                          //             style: const TextStyle(
                          //               fontSize: 14,
                          //             ),
                          //           ),
                          //           actions: [
                          //             TextButton(
                          //               onPressed: () {
                          //                 Navigator.pop(context);
                          //               },
                          //               child: Text(
                          //                 'Ok',
                          //                 style: TextStyle(
                          //                   color: ColorsConsts.AppMainColor,
                          //                   fontSize: 16,
                          //                 ),
                          //               ),
                          //             )
                          //           ],
                          //         );
                          //       });
                          //   return;
                          // }

                          Navigator.of(context)
                              .pushNamed(OrderSummary.routeName);
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Place Order',
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
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        '${totalPrice}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.only(left: 12, right: 12),
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: ColorsConsts.AppMainColor,
                        ),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    const Text(
                      'Cart Details',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    InkWell(
                      onTap: () {
                        GlobalMethod.showSnackBar(
                          title: 'आप एक एक प्रोडक्ट delete कर दे!',
                          context: context,
                          color: ColorsConsts.AppMainColor,
                          icon: null,
                          iconBackgroundColor: Colors.white,
                          isIcon: false,
                        );
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        decoration: BoxDecoration(
                            color: ColorsConsts.AppMainColor,
                            borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height - 220,
                  child: ListView.builder(
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: CartFull(
                            productImage: cartItems[index].imageUrl,
                            productTitle: cartItems[index].title,
                            productPrice: cartItems[index].price.toString(),
                            productQuantity: cartItems[index].quantity,
                            cartId: cartItems[index].id,
                            productId: cartItems[index].productId,
                            function: getValue,
                          ),
                        );
                      }),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
