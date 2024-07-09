import 'package:cloud_firestore/cloud_firestore.dart';
import '../Models/product.dart';
import '../Screens/cart.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Constants/colors.dart';
import 'package:share_plus/share_plus.dart';

import '../Models/cart_attr.dart';
import '../Provider/user_provider.dart';
import '../services/firebase_dynamic_link.dart';
import 'package:collection/collection.dart';
import 'package:uuid/uuid.dart';

import '../services/global_method.dart';
import 'package:badges/badges.dart' as badge;

class ProductDetails extends StatefulWidget {
  static const routeName = '/ProductDetails';

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  GlobalKey previewContainer = GlobalKey();

  String? productId;
  double quantity = 1;
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    //  productId = ModalRoute.of(context)!.settings.arguments as String;
    print('product details ddichangede printing');
    productId = ModalRoute.of(context)!.settings.arguments as String;
    print('product id $productId');
    // print('product id $productId');
  }

  Future<void> addProductToCart(
      {required String productId,
      required double price,
      required String title,
      required String imageUrl,
      required double cuttedPrice,
      required String percentOff,
      required double quantity,
      required String unitAmount}) async {
    try {
      setState(() {
        isLoading = true;
      });
      final _auth = FirebaseAuth.instance;
      var uuid = const Uuid();
      final cartId = uuid.v4();
      User? user = _auth.currentUser;
      final _uid = user!.uid;
      await FirebaseFirestore.instance.collection('cart').doc(cartId).set({
        'cartId': cartId,
        'userId': _uid,
        'productId': productId,
        'title': title,
        'price': price,
        'imageUrl': imageUrl,
        'quantity': quantity,
        'cuttedPrice': cuttedPrice,
        'percentOff': percentOff,
        'unitAmount': unitAmount,
        'cartDate': Timestamp.now(),
      }).then((value) {
        print('then block success');
        setState(() {
          isLoading = false;
        });
      }).catchError((error) {
        setState(() {
          isLoading = false;
        });
      });
    } catch (error) {
      print('error occured:${error.toString()}');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<List<Product>>(builder: (context, products, child) {
      print('products in product details ${products.length}');
      Product? product =
          products.firstWhereOrNull((element) => element.id == productId);
      print('product title in product details.dart ${product!.title}');

      bool? isInStock = product!.inStock;

      return Consumer<List<CartAttr>>(builder: (context, cartItems, child) {
        bool isAdded(String productId) {
          CartAttr? cartItem = cartItems
              .firstWhereOrNull((element) => element.productId == productId);
          if (cartItems.contains(cartItem)) {
            return true;
          } else {
            return false;
          }
        }

        return SafeArea(
          child: Scaffold(
            bottomSheet: Padding(
              padding: const EdgeInsets.only(left: 12, right: 12),
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  color: ColorsConsts.AppMainColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(children: [
                        const WidgetSpan(
                            child: SizedBox(
                          width: 10,
                        )),
                        const WidgetSpan(
                          child: Icon(
                            Icons.currency_rupee,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                        TextSpan(
                            text: '${product.price * quantity}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 35,
                                fontWeight: FontWeight.bold)),
                        // const TextSpan(
                        //   text: ' /kg',
                        //   style: TextStyle(
                        //       fontWeight: FontWeight.normal,
                        //       color: Colors.white,
                        //       fontSize: 16),
                        // )
                      ]),
                      textAlign: TextAlign.left,
                    ),
                    Container(
                      height: 70,
                      width: 180,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xFF90B886),
                      ),
                      child: isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.black,
                              ),
                            )
                          : InkWell(
                              onTap: () {
                                if (isInStock == false) {
                                  GlobalMethod.showSnackBar(
                                      title:
                                          '${product.title} is out of stock!',
                                      context: context,
                                      color: Colors.red,
                                      icon: Icons.shopping_bag,
                                      isIcon: false,
                                      iconBackgroundColor: Colors.green);
                                  return;
                                }
                                if (Provider.of<UserProvider>(context,
                                            listen: false)
                                        .userAttr
                                        ?.status ==
                                    'Blocked') {
                                  GlobalMethod.showSnackBar(
                                      title: 'You have been blocked !',
                                      context: context,
                                      color: Colors.red,
                                      icon: Icons.shopping_bag,
                                      isIcon: false,
                                      iconBackgroundColor: Colors.green);
                                  return;
                                }
                                if (isAdded(productId!)) {
                                  GlobalMethod.showSnackBar(
                                      title: 'Item already added to cart !',
                                      context: context,
                                      color: Colors.black,
                                      icon: Icons.shopping_bag,
                                      isIcon: true,
                                      iconBackgroundColor: Colors.green);
                                  return;
                                } else {
                                  addProductToCart(
                                          productId: productId!,
                                          price: product.price,
                                          title: product.title,
                                          imageUrl: product.imageUrl,
                                          cuttedPrice: product.cuttedPrice,
                                          percentOff: product.percentOff,
                                          quantity: quantity,
                                          unitAmount: product.unitAmount)
                                      .then((value) {
                                    GlobalMethod.showSnackBar(
                                      title:
                                          'Item added to cart successfully !',
                                      context: context,
                                      color: Colors.black,
                                      isIcon: true,
                                      icon: Icons.shopping_bag,
                                      function: () {
                                        Navigator.of(context)
                                            .pushNamed(Cart.routeName);
                                      },
                                      iconBackgroundColor: Colors.green,
                                    );
                                  }).catchError((onError) {
                                    GlobalMethod.showSnackBar(
                                      title: 'Error occurred adding to cart !',
                                      context: context,
                                      color: Colors.red,
                                      isIcon: true,
                                      icon: Icons.shopping_bag,
                                      iconBackgroundColor: Colors.green,
                                    );
                                  });
                                }
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 15, right: 15),
                                child: Row(
                                  children: [
                                    const CircleAvatar(
                                      backgroundColor: Color(0xFFA5C59E),
                                      child: Icon(
                                        Icons.shopping_bag,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    isInStock!
                                        ? Text(
                                            isAdded(productId!)
                                                ? 'In Cart'
                                                : 'Add to cart',
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w900),
                                          )
                                        : const Text(
                                            'Out of Stock',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 17,
                                                fontWeight: FontWeight.w900),
                                          )
                                    // Consumer<Cartprovider>(
                                    //     builder: (context, data, child) {
                                    //   return Text(
                                    //     data.isAdded(productId!)
                                    //         ? 'In Cart'
                                    //         : 'Add to cart',
                                    //     style: const TextStyle(
                                    //         color: Colors.white,
                                    //         fontSize: 20,
                                    //         fontWeight: FontWeight.w900),
                                    //   );
                                    // }),
                                  ],
                                ),
                              ),
                            ),
                    )
                  ],
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 350,
                        decoration: BoxDecoration(
                          color: Colors.green.shade300,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(180),
                            bottomRight: Radius.circular(180),
                          ),
                        ),
                      ),
                      Positioned(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
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
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context)
                                          .pushNamed(Cart.routeName);
                                    },
                                    child: badge.Badge(
                                      badgeContent: Consumer<List<CartAttr>>(
                                          builder: (context, cartItems, child) {
                                        return Text(
                                          cartItems.length.toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                          ),
                                        );
                                      }),
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        child: const Icon(
                                          Icons.shopping_bag,
                                          color: Colors.white,
                                        ),
                                        decoration: BoxDecoration(
                                            color: ColorsConsts.AppMainColor,
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                      ),
                                      padding: const EdgeInsets.all(7),
                                      badgeColor: Colors.red,
                                      animationType:
                                          badge.BadgeAnimationType.fade,
                                      animationDuration: const Duration(
                                        milliseconds: 300,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Container(
                                    width: 40,
                                    height: 40,
                                    child: const Icon(
                                      Icons.favorite,
                                      color: Colors.white,
                                    ),
                                    decoration: BoxDecoration(
                                        color: ColorsConsts.AppMainColor,
                                        borderRadius: BorderRadius.circular(8)),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      if (!kIsWeb) {
                                        String generatedLink =
                                            await FirebaseDynamicLinkService
                                                .createDynamicLink(product);
                                        print(generatedLink);
                                        await Share.share(
                                            'check out product ${product.title} on Sabjitaja app $generatedLink');
                                      } else {
                                        null;
                                      }
                                    },
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      child: const Icon(
                                        Icons.share,
                                        color: Colors.white,
                                      ),
                                      decoration: BoxDecoration(
                                          color: ColorsConsts.AppMainColor,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.center,
                          child: Image.network(
                            product.imageUrl,
                            height: 200,
                            width: 200,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.title,
                          style: const TextStyle(
                              overflow: TextOverflow.clip,
                              fontSize: 28,
                              fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                              text: TextSpan(children: [
                                WidgetSpan(
                                  child: Icon(
                                    Icons.star,
                                    color: ColorsConsts.AppMainColor,
                                    size: 16,
                                  ),
                                ),
                                const TextSpan(
                                  text: ' 4.6',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF7C7C7C),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const TextSpan(
                                  text: ' (126 reviews)',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF7C7C7C),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ]),
                            ),
                            RichText(
                              text: TextSpan(children: [
                                WidgetSpan(
                                  child: Icon(
                                    Icons.delivery_dining,
                                    color: ColorsConsts.AppMainColor,
                                    size: 16,
                                  ),
                                ),
                                const TextSpan(
                                  text: ' 40  min',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF7C7C7C),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ]),
                            ),
                            RichText(
                              text: TextSpan(children: [
                                WidgetSpan(
                                  child: Icon(
                                    Icons.local_fire_department_rounded,
                                    color: ColorsConsts.AppMainColor,
                                    size: 16,
                                  ),
                                ),
                                const TextSpan(
                                  text: ' 32 kCal',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF7C7C7C),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ]),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            height: 50,
                            width: 150,
                            decoration: BoxDecoration(
                              color: ColorsConsts.AppMainColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    if (quantity > 0.5) {
                                      setState(() {
                                        quantity = quantity - 0.5;
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
                                  '$quantity ${product.unitAmount}',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      quantity = quantity + 0.5;
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
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Product Description',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 17,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          product.description.isEmpty
                              ? 'हमलोग आपके घर तक ताजा सब्जी, फल, मीट देते हैं।'
                                  ' आपको अब दुकान जाने की जरूरत नही है। हमलोग दुकान से भी '
                                  'सस्ते दामों पर सब्जी ,फल, देते हैं।'
                                  'हमलोग अलग से कोई एक्स्ट्रा चार्ज नहीं लेते हैं। '
                                  'इस app के बारे में अपने दोस्त,  पड़ोसी और सबको बताएं। धन्यवाद'
                              : product.description,
                          textAlign: TextAlign.left,
                          style: const TextStyle(color: Color(0xFF989896)),
                        ),
                        const SizedBox(
                          height: 71,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      });
    });
  }
}
