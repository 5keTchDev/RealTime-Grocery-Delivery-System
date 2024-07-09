import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Models/product.dart';
import '../inner_screen/product_details.dart';

class FirebaseDynamicLinkService {
  static Future<String> createDynamicLink(Product product) async {
    final dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse("https://sabjitaja.in/product?id=${product.id}"),
      uriPrefix: "https://sabjitaja.in/link/",
      androidParameters: AndroidParameters(
        fallbackUrl: Uri.parse(
            "https://play.google.com/store/apps/details?id=com.sabjitaja.sabjitaja"),
        packageName: "com.sabjitaja.sabjitaja",
        minimumVersion: 1,
      ),
      // iosParameters: const IOSParameters(
      //   bundleId: "com.example.app.ios",
      //   appStoreId: "123456789",
      //   minimumVersion: "1.0.1",
      // ),
      // googleAnalyticsParameters: const GoogleAnalyticsParameters(
      //   source: "whatsapp",
      //   medium: "social",
      //   campaign: "promo",
      // ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: product.title,
        description: 'Fresh and Healthy',
        imageUrl: Uri.parse(product.imageUrl),
      ),
    );
    final dynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(
      dynamicLinkParams,
      shortLinkType: ShortDynamicLinkType.unguessable,
    );

    return dynamicLink.shortUrl.toString();
  }

  static Future<void> initDynamicLink(BuildContext context) async {
    ///for background/foreground state
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
      //Navigator.pushNamed(context, dynamicLinkData.link.path);

      final Uri deepLink = dynamicLinkData.link;
      print('deeplink uri in firebase dynamic service.dart $deepLink');
      var isProduct = deepLink.pathSegments.contains('product');

      if (isProduct) {
        String? id = deepLink.queryParameters['id'];
        print('product id in firebasedynamiclink.dart $id');
        if (deepLink != null) {
          Product? product = Provider.of<List<Product>>(context)
              .firstWhere((element) => element.id == id);
          print('product title in firebase dynamic  link.dart$product.title');
          if (product != null) {
            Navigator.pushNamed(context, ProductDetails.routeName,
                arguments: id);
          }
        } else {}
      }
    }).onError((error) {
      // Handle errors
      print('error in firebase dynamic link.dart $error');
    });

    ///for terminated state
    final PendingDynamicLinkData? initialLink =
        await FirebaseDynamicLinks.instance.getInitialLink();
    if (initialLink != null) {
      final Uri deepLink = initialLink.link;

      // Example of using the dynamic link to push the user to a different screen
      Navigator.pushNamed(context, ProductDetails.routeName,
          arguments: deepLink.queryParameters['id']);
    } else {}
  }
}
