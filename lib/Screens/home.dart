import 'dart:ui';
import '../Screens/search.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro_nullsafety/carousel_pro_nullsafety.dart';
import 'package:provider/provider.dart';

import '../Constants/colors.dart';
import '../Models/category_model.dart';
import '../Models/product.dart';
import '../Provider/user_provider.dart';
import '../services/firebase_dynamic_link.dart';
import '../services/firebase_services.dart';
import '../widgets/category.dart';
import 'package:shimmer/shimmer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../widgets/popular_card_widget.dart';
import 'feeds.dart';

class Home extends StatefulWidget {
  static const routeName = '/HomeScreen';
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _auth = FirebaseAuth.instance;
  String? _uid;
  String? name;
  String? email;
  int? phoneNumber;
  bool isLoading = false;

  bool isInit = true;

  //fetching user for user blocked status

  Future<void> fetchUser() async {
    await Provider.of<UserProvider>(context, listen: false).fetchUsers();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getToken();
    print('initState in home.dart');
    //get device token;
    if (!kIsWeb) {
      FirebaseMessaging.instance.subscribeToTopic('sabjitaja');
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    // fetch();

    if (Provider.of<UserProvider>(context, listen: false).userAttr == null) {
      fetchUser();
    } else {
      if (kDebugMode) {
        print('user not fetching in dependency');
      }
    }
  }

  Future<String?> getToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken(
        vapidKey:
            "BGplB3TIm1kE1-qczahHlEa4Cn0Qa4iIjuZw1693FbHtGiy1xlsTZQKC2L5lg6UD8w3fRtNwW68UWCV3_igagKc");
    print(fcmToken);
    return fcmToken;
  }

  @override
  Widget build(BuildContext context) {
    print('build method in home.dart');
    if (kDebugMode) {
      print('build method always running in home.dart');
    }

    return Consumer<List<Product>>(builder: (context, products, child) {
      List<Product> topOffersProductList = products
          .where((element) =>
              double.parse(element.percentOff) > 5 && element.inStock == true)
          .toList();
      List<Product> popularList = products
          .where((element) => element.isPopular && element.inStock == true)
          .toList();
      List<Product> popularFruits = products
          .where((element) =>
              element.productCategoryName.contains('Fruits') &&
              element.inStock == true)
          .toList();
      print('length of popular fruits ${popularFruits.length}');

      List<Product> popularVegetables = products
          .where((element) =>
              element.productCategoryName.contains('Vegeta') &&
              element.inStock == true)
          .toList();

      print('products length ${products.length}');
      if (!kIsWeb) {
        if (products.isNotEmpty) {
          FirebaseDynamicLinkService.initDynamicLink(context);
        }
      }

      return products.isEmpty
          ? const Scaffold(
              body: Center(
                  child: CircularProgressIndicator(
              color: Colors.green,
            )))
          : Scaffold(
              body: Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: SafeArea(
                  child: SingleChildScrollView(
                    primary: false,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Welcome!',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width - 70,
                                  child: Text(
                                    '${_auth.currentUser!.displayName ?? _auth.currentUser!.email}',
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: ColorsConsts.AppMainColor,
                                    content: const Text(
                                      'No new notifications yet !',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                child: const Icon(
                                  Icons.notifications,
                                  color: Colors.white,
                                ),
                                decoration: BoxDecoration(
                                    color: ColorsConsts.AppMainColor,
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, Search.routeName);
                          },
                          child: Container(
                            height: 50,
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 10,
                                ),
                                Image.asset(
                                  'images/search_icon.png',
                                  height: 20,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Text('Search what do you want?',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w300))
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),

                        StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection("Banners")
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const ShimmerEffect();
                              }
                              if (snapshot.hasError) {
                                return const Center(
                                  child: Text(''),
                                );
                              }

                              final images = snapshot.data!.docs;

                              return Container(
                                clipBehavior: Clip.hardEdge,
                                height: 150.0,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Carousel(
                                    boxFit: BoxFit.cover,
                                    autoplay: true,
                                    animationCurve: Curves.fastOutSlowIn,
                                    animationDuration:
                                        const Duration(milliseconds: 1000),
                                    showIndicator: false,
                                    images: images
                                        .map((e) => CachedNetworkImage(
                                              imageUrl: e.get('image'),
                                              fit: BoxFit.fill,
                                            ))
                                        .toList()),
                              );
                            }),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
                          'Categories',
                          style: TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 17),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          height: 70,
                          child: Consumer<List<CategoryModel>>(
                              builder: (context, categoryList, child) {
                            if (categoryList.isEmpty) {
                              return Container();
                            }
                            return ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext ctx, int index) =>
                                  CategoryWidget(
                                      name: categoryList[index].name!,
                                      image: categoryList[index].url!,
                                      color:
                                          categoryList[index].backgroundColor!),
                              separatorBuilder: (BuildContext ctx, int index) =>
                                  SizedBox(
                                width:
                                    (MediaQuery.of(context).size.width - 304) /
                                        3,
                              ),
                              itemCount: categoryList.length,
                            );
                          }),
                        ),
                        const SizedBox(
                          height: 5,
                        ),

                        ///// Top Offers
                        topOffersProductList.isEmpty
                            ? Container()
                            : View_All(
                                text: 'Top Offers',
                                color: Colors.lightBlueAccent.withOpacity(0.2),
                                function: () {
                                  Navigator.of(context).pushNamed(
                                      Feeds.routeName,
                                      arguments: 'Top Offers');
                                },
                              ),

                        topOffersProductList.isEmpty
                            ? Container()
                            : Container(
                                width: double.infinity,
                                height: 173,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: topOffersProductList.length > 7
                                      ? 7
                                      : topOffersProductList.length,
                                  itemBuilder: (BuildContext ctx, int index) {
                                    return ProductCardWidget(
                                      productPrice: topOffersProductList[index]
                                          .price
                                          .toString(),
                                      productId: topOffersProductList[index].id,
                                      productTitle:
                                          topOffersProductList[index].title,
                                      productImage:
                                          topOffersProductList[index].imageUrl,
                                      unitAmount: topOffersProductList[index]
                                          .unitAmount,
                                      cuttedPrice: topOffersProductList[index]
                                          .cuttedPrice
                                          .toString(),
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return SizedBox(
                                      width:
                                          (MediaQuery.of(context).size.width -
                                                  304) /
                                              3,
                                    );
                                  },
                                ),
                              ),

                        /// Top offers
                        const SizedBox(
                          height: 5,
                        ),

                        ///popular products
                        popularList.isEmpty
                            ? Container()
                            : View_All(
                                text: 'Popular Products',
                                color: Colors.lightBlueAccent.withOpacity(0.2),
                                function: () {
                                  Navigator.of(context).pushNamed(
                                      Feeds.routeName,
                                      arguments: 'Popular Products');
                                },
                              ),

                        popularList.isEmpty
                            ? Container()
                            : SizedBox(
                                width: double.infinity,
                                height: 173,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: popularList.length > 7
                                      ? 7
                                      : popularList.length,
                                  itemBuilder: (BuildContext ctx, int index) {
                                    return ProductCardWidget(
                                      productPrice:
                                          popularList[index].price.toString(),
                                      productId: popularList[index].id,
                                      productTitle: popularList[index].title,
                                      productImage: popularList[index].imageUrl,
                                      cuttedPrice: popularList[index]
                                          .cuttedPrice
                                          .toString(),
                                      unitAmount: popularList[index].unitAmount,
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return SizedBox(
                                      width:
                                          (MediaQuery.of(context).size.width -
                                                  304) /
                                              3,
                                    );
                                  },
                                ),
                              ),

                        ///popular fruits
                        popularFruits.isEmpty
                            ? Container()
                            : View_All(
                                text: 'Popular Fruits',
                                color: Colors.lightBlueAccent.withOpacity(0.2),
                                function: () {
                                  Navigator.of(context).pushNamed(
                                      Feeds.routeName,
                                      arguments: 'Popular Fruits');
                                },
                              ),

                        popularFruits.isEmpty
                            ? Container()
                            : SizedBox(
                                width: double.infinity,
                                height: 173,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: popularFruits.length > 7
                                      ? 7
                                      : popularFruits.length,
                                  itemBuilder: (BuildContext ctx, int index) {
                                    return ProductCardWidget(
                                      productPrice:
                                          popularFruits[index].price.toString(),
                                      productId: popularFruits[index].id,
                                      productTitle: popularFruits[index].title,
                                      productImage:
                                          popularFruits[index].imageUrl,
                                      cuttedPrice: popularFruits[index]
                                          .cuttedPrice
                                          .toString(),
                                      unitAmount:
                                          popularFruits[index].unitAmount,
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return SizedBox(
                                      width:
                                          (MediaQuery.of(context).size.width -
                                                  304) /
                                              3,
                                    );
                                  },
                                ),
                              ),

                        ///popular Vegetables
                        popularVegetables.isEmpty
                            ? Container()
                            : View_All(
                                text: 'Popular Vegetables',
                                color: Colors.lightBlueAccent.withOpacity(0.2),
                                function: () {
                                  Navigator.of(context).pushNamed(
                                      Feeds.routeName,
                                      arguments: 'Popular Vegetables');
                                },
                              ),

                        popularVegetables.isEmpty
                            ? Container()
                            : SizedBox(
                                width: double.infinity,
                                height: 173,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: popularVegetables.length > 7
                                      ? 7
                                      : popularVegetables.length,
                                  itemBuilder: (BuildContext ctx, int index) {
                                    return ProductCardWidget(
                                      productPrice: popularVegetables[index]
                                          .price
                                          .toString(),
                                      productId: popularVegetables[index].id,
                                      productTitle:
                                          popularVegetables[index].title,
                                      productImage:
                                          popularVegetables[index].imageUrl,
                                      cuttedPrice: popularVegetables[index]
                                          .cuttedPrice
                                          .toString(),
                                      unitAmount:
                                          popularVegetables[index].unitAmount,
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return SizedBox(
                                      width:
                                          (MediaQuery.of(context).size.width -
                                                  304) /
                                              3,
                                    );
                                  },
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            );
    });
  }
}

class View_All extends StatelessWidget {
  String text;
  Color color;
  VoidCallback function;

  View_All({required this.text, required this.color, required this.function});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 17,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        TextButton(
          // color: Colors.red,
          onPressed: function,
          // Navigator.of(context).pushNamed(Feeds.routeName,arguments: 'popular');

          child: Text(
            'See All',
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: ColorsConsts.AppSecColor),
          ),
        ),
      ],
    );
  }
}

class ShimmerEffect extends StatefulWidget {
  const ShimmerEffect({Key? key}) : super(key: key);

  @override
  State<ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<ShimmerEffect> {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: (Colors.grey[400])!,
      highlightColor: (Colors.grey[300])!,
      child: Container(
        height: 150.0,
        width: double.infinity,
        color: Colors.grey,
      ),
    );
  }
}
