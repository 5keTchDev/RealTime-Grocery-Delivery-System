import 'dart:async';
import 'package:SabjiTaja/widgets/address_empty.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'Models/address_attr.dart';
import 'Models/cart_attr.dart';
import 'Models/product.dart';
import 'Provider/user_provider.dart';
import 'Screens/address.dart';
import 'Screens/bottom_bar.dart';
import 'Screens/cart.dart';
import 'Screens/feeds.dart';
import 'Screens/home.dart';
import 'Screens/login.dart';
import 'Screens/order_success.dart';
import 'Screens/order_summary.dart';
import 'Screens/search.dart';
import 'Screens/sign_up.dart';
import 'Screens/upload_product_form.dart';
import 'Screens/user_info.dart';
import 'Screens/user_state.dart';
import 'firebase_options.dart';
import 'Screens/AboutUs.dart';
import 'Screens/feeds_category.dart';

import 'Screens/forget_password.dart';
import 'Screens/help.dart';
import 'Screens/payments.dart';
import 'Screens/privacy.dart';
import 'Constants/colors.dart';
import 'package:url_strategy/url_strategy.dart';
import './Models/category_model.dart';
import 'inner_screen/product_details.dart';
import 'orders/order.dart';
import 'widgets/no_internet.dart';
import 'services/firebase_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  // await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.green.shade300, // navigation bar color
    statusBarColor: Colors.green.shade300, // status bar color
  ));

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ConnectivityResult _connectionStatus = ConnectivityResult.mobile;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    print('init state in main.dart');

    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e);
      return;
    }
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_connectionStatus == ConnectivityResult.none) {
      print('connection state in main.dart $_connectionStatus');
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: NoInternet(),
        ),
      );
    }
    // return StreamBuilder<QuerySnapshot>(
    //     stream: FirebaseFirestore.instance.collection('Appservice').snapshots(),
    //     builder: (context, snapshot) {
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         return const MaterialApp(
    //           debugShowCheckedModeBanner: false,
    //           home: Scaffold(
    //             body: Center(
    //               child: CircularProgressIndicator(),
    //             ),
    //           ),
    //         );
    //       }
    //       if (snapshot.hasError) {
    //         return const MaterialApp(
    //           debugShowCheckedModeBanner: false,
    //           home: Scaffold(
    //             body: Center(
    //               child: Text(
    //                 'Error Occurred...',
    //               ),
    //             ),
    //           ),
    //         );
    //       }
    //       if (snapshot.hasData) {
    //         final data = snapshot.data!.docs;
    //         if (data[0].get('canOrder') == false) {
    //           return MaterialApp(
    //             debugShowCheckedModeBanner: false,
    //             home: Scaffold(
    //               body: Padding(
    //                 padding: const EdgeInsets.all(10.0),
    //                 child: Column(
    //                   mainAxisAlignment: MainAxisAlignment.center,
    //                   crossAxisAlignment: CrossAxisAlignment.center,
    //                   children: [
    //                     Text(
    //                       '${data[0].get('title')}',
    //                       style: const TextStyle(
    //                         color: Colors.black,
    //                         fontSize: 20,
    //                         fontWeight: FontWeight.bold,
    //                       ),
    //                     ),
    //                     const SizedBox(
    //                       height: 10,
    //                     ),
    //                     Text(
    //                       '${data[0].get('description')}',
    //                       textAlign: TextAlign.center,
    //                       style: const TextStyle(
    //                         color: Colors.grey,
    //                         fontSize: 14,
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ),
    //           );
    //         }
    //       }

    // return
    //
    //   StreamBuilder(
    //     stream: FirebaseAuth.instance.authStateChanges(),
    //     builder: (context, userSnapshot) {
    //       if (userSnapshot.connectionState == ConnectionState.waiting) {
    //         return MaterialApp(
    //           debugShowCheckedModeBanner: false,
    //           home: Scaffold(
    //             body: Center(
    //               child: CircularProgressIndicator(
    //                 color: ColorsConsts.AppMainColor,
    //               ),
    //             ),
    //           ),
    //         );
    //       }
    //       if (userSnapshot.hasError) {
    //         return const MaterialApp(
    //           debugShowCheckedModeBanner: false,
    //           home: Scaffold(
    //             body: Center(
    //               child: Text(
    //                 'Error Occurred...',
    //                 style: TextStyle(color: Colors.black),
    //               ),
    //             ),
    //           ),
    //         );
    //       }
    //       if (userSnapshot.connectionState == ConnectionState.active) {
    //         if (!userSnapshot.hasData) {
    //           return MaterialApp(
    //             debugShowCheckedModeBanner: false,
    //             home: LoginScreen(),
    //             routes: {
    //               ForgetPassword.routeName: (contex) => ForgetPassword(),
    //               SignUpScreen.routeName: (contex) => SignUpScreen(),
    //               LoginScreen.routeName: (contex) => LoginScreen(),
    //               ProductDetails.routeName: (context) => ProductDetails(),
    //             },
    //           );
    //         }
    //
    //       }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(create: (_) {
          return UserProvider();
        }),
        ChangeNotifierProvider<FirebaseServices>(create: (_) {
          return FirebaseServices();
        }),
        StreamProvider<List<CategoryModel>>(
          create: (context) => CategoryModel().category,
          initialData: [],
          catchError: (context, error) {
            return [];
          },
        ),
        StreamProvider<List<CartAttr>>(
          create: (context) => CartAttr(
                  id: 'id',
                  productId: 'productId',
                  userId: 'userId',
                  title: 'title',
                  quantity: 1,
                  price: 10,
                  imageUrl: 'imageUrl',
                  cuttedPrice: 12,
                  unitAmount: 'unitAmount',
                  percentOff: 'percentOff')
              .cartItems,
          initialData: [],
          catchError: (context, error) {
            return [];
          },
        ),
        StreamProvider<List<AddressAttr>>(
          create: (context) => AddressAttr(
                  addressId: 'addressId',
                  userId: 'userId',
                  name: 'name',
                  phoneNumber: 'phoneNumber',
                  pincode: 'pincode',
                  state: 'state',
                  city: 'city',
                  houseNo: 'houseNo',
                  roadName: 'roadName',
                  selected: true)
              .addresses,
          initialData: [],
          catchError: (context, error) {
            return [];
          },
        ),
        StreamProvider<List<Product>>(
          create: (context) => Product(
                  id: 'id',
                  title: 'title',
                  description: 'description',
                  price: 0,
                  cuttedPrice: 0,
                  imageUrl: 'imageUrl',
                  productCategoryName: 'productCategoryName',
                  unitAmount: 'unitAmount',
                  isPopular: true,
                  percentOff: 'percentOff')
              .products,
          initialData: [],
          catchError: (context, error) {
            return [];
          },
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SabjiTaja',
        theme: ThemeData(
            progressIndicatorTheme: ProgressIndicatorThemeData(
              color: ColorsConsts.AppMainColor,
            ),
            inputDecorationTheme: const InputDecorationTheme(
              fillColor: Colors.white,
            ),
            buttonTheme: ButtonThemeData(
              buttonColor: ColorsConsts.AppMainColor,
            ),
            bottomSheetTheme:
                const BottomSheetThemeData(backgroundColor: Colors.transparent),
            appBarTheme: AppBarTheme(
                systemOverlayStyle: SystemUiOverlayStyle(
                    statusBarColor: Colors.green.shade300)),
            primaryColor: ColorsConsts.AppMainColor,
            scaffoldBackgroundColor: Colors.green.shade50),
        home: UserState(),
        routes: {
          Feeds.routeName: (contex) => Feeds(),
          FeedsCategory.routeName: (context) => FeedsCategory(),
          ProductDetails.routeName: (context) => ProductDetails(),
          Cart.routeName: (contex) => Cart(),
          LoginScreen.routeName: (contex) => LoginScreen(),
          SignUpScreen.routeName: (contex) => SignUpScreen(),
          BottomBarScreen.routeName: (contex) => BottomBarScreen(),
          UploadProductForm.routeName: (contex) => UploadProductForm(),
          ForgetPassword.routeName: (contex) => ForgetPassword(),
          OrderScreen.routeName: (contex) => OrderScreen(),
          AboutPage.routeName: (contex) => AboutPage(),
          Home.routeName: (contex) => Home(),
          Address.routeName: (context) => Address(),
          AddressEmpty.routeName: (context) => AddressEmpty(),
          OrderSummary.routeName: (context) => OrderSummary(),
          Payments.routeName: (context) => Payments(),
          OrderSuccess.routeName: (context) => OrderSuccess(),
          UserInfoo.routeName: (context) => UserInfoo(),
          HelpPage.routeName: (context) => HelpPage(),
          PrivacyPage.routeName: (context) => PrivacyPage(),
          Search.routeName: (context) => Search(),
        },
      ),
    );
    //  });
    // });
  }
}
