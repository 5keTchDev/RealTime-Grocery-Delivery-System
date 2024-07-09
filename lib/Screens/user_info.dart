import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Constants/colors.dart';
import '../Models/cart_attr.dart';
import '../orders/order.dart';
import '../services/global_method.dart';
import 'AboutUs.dart';
import 'address.dart';
import '../Screens/privacy.dart';
import 'package:share_plus/share_plus.dart';

class UserInfoo extends StatefulWidget {
  static const routeName = '/userInfo';

  @override
  State<UserInfoo> createState() => _UserInfooState();
}

class _UserInfooState extends State<UserInfoo> {
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        // fit: StackFit.loose,

        children: [
          Positioned(
            top: 0,
            left: 0, // to shift little up
            // left: 0,
            // right: 0,
            child: Container(
              color: Colors.green.shade300,
              height: 200,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          color: ColorsConsts.AppMainColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white),
                        ),
                        child: const Icon(
                          Icons.manage_accounts_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      Positioned(
                        top: 50,
                        right: 0,
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                              color: ColorsConsts.AppMainColor,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white)),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    _auth.currentUser!.displayName ?? '',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    '${_auth.currentUser!.email}',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: 150,
            left: 0,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: Column(
                  children: [
                    Container(
                      height: 240,
                      width: MediaQuery.of(context).size.width - 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 12, right: 12, top: 12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Align(
                                              alignment: Alignment.center,
                                              child: SizedBox(
                                                height: 5,
                                                width: 100,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: Colors.blue.shade700,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            const Text(
                                              'Account Info',
                                              style: TextStyle(
                                                fontSize: 20,
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
                                              contentPadding:
                                                  const EdgeInsets.all(0),
                                              trailing: const Icon(
                                                Icons.arrow_forward_ios_sharp,
                                                size: 15,
                                              ),
                                              leading: Container(
                                                width: 50,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color:
                                                      const Color(0xFFE7FAF0),
                                                ),
                                                child: const Center(
                                                  child: Icon(
                                                    Icons
                                                        .manage_accounts_rounded,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                              title: Text(
                                                FirebaseAuth
                                                        .instance
                                                        .currentUser!
                                                        .displayName ??
                                                    '',
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                              subtitle: Text(
                                                FirebaseAuth.instance
                                                        .currentUser!.email ??
                                                    '',
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            const Text(
                                              'Payment Method',
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
                                              contentPadding:
                                                  const EdgeInsets.all(0),
                                              trailing: const Icon(
                                                Icons.arrow_forward_ios_sharp,
                                                size: 15,
                                              ),
                                              leading: Container(
                                                width: 50,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color:
                                                      const Color(0xFFE7FAF0),
                                                ),
                                                child: const Center(
                                                  child: Icon(
                                                    Icons.monetization_on,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                              title: const Text(
                                                'COD',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            const Text(
                                              'Cart Info',
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
                                              contentPadding:
                                                  const EdgeInsets.all(0),
                                              trailing: const Icon(
                                                Icons.arrow_forward_ios_sharp,
                                                size: 15,
                                              ),
                                              leading: Container(
                                                width: 50,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color:
                                                      const Color(0xFFE7FAF0),
                                                ),
                                                child: const Center(
                                                  child: Icon(
                                                    Icons.shopping_cart,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                              title: const Text(
                                                'Total Cart Items',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                              subtitle:
                                                  Consumer<List<CartAttr>>(
                                                      builder: (context,
                                                          cartItems, child) {
                                                return Text(
                                                  cartItems.length.toString(),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                );
                                              }),
                                            ),
                                          ],
                                        ),
                                      );
                                    });
                              },
                              child: AccountTile(
                                icon: Icons.manage_accounts,
                                title: 'Account Info',
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed(OrderScreen.routeName);
                              },
                              child: AccountTile(
                                icon: Icons.shopping_bag,
                                title: 'My Orders',
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                GlobalMethod.showSnackBar(
                                    title:
                                        'You have only one payment method COD',
                                    context: context,
                                    color: Colors.black,
                                    icon: null,
                                    iconBackgroundColor: Colors.black,
                                    isIcon: false);
                              },
                              child: AccountTile(
                                icon: Icons.payment,
                                title: 'Payment Method',
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed(Address.routeName);
                              },
                              child: AccountTile(
                                icon: Icons.location_on,
                                title: 'Delivery Address',
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      height: 290,
                      width: MediaQuery.of(context).size.width - 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 12, right: 12, top: 12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                GlobalMethod.showSnackBar(
                                    title: 'Settings is under progress !',
                                    context: context,
                                    color: Colors.black,
                                    icon: null,
                                    iconBackgroundColor: Colors.black,
                                    isIcon: false);
                              },
                              child: AccountTile(
                                icon: Icons.settings,
                                title: 'Settings',
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                String url =
                                    "https://wa.me/${918340328891}/?text=${Uri.parse('Hii Sabjitaja.in\n I need help.')}"; // new line

                                if (await canLaunchUrl(Uri.parse(url))) {
                                  await launchUrl(
                                    Uri.parse(url),
                                    mode: LaunchMode.externalApplication,
                                  ).then((value) {
                                    if (value == false) {}
                                  });
                                } else {
                                  GlobalMethod.showSnackBar(
                                    title: 'Unable to connect !',
                                    context: context,
                                    color: Colors.black,
                                    icon: null,
                                    iconBackgroundColor: Colors.black,
                                    isIcon: false,
                                  );
                                }
                              },
                              child: AccountTile(
                                icon: Icons.help_center,
                                title: 'Help Center',
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                String tel = 'tel:+918340328891';
                                if (await canLaunchUrl(Uri.parse(tel))) {
                                  await launchUrl(
                                    Uri.parse(tel),
                                    mode: LaunchMode.externalApplication,
                                  );
                                } else {
                                  GlobalMethod.showSnackBar(
                                      title: 'Unable to connect !',
                                      context: context,
                                      color: Colors.black,
                                      icon: null,
                                      iconBackgroundColor: Colors.black,
                                      isIcon: false);
                                }
                              },
                              child: AccountTile(
                                icon: Icons.quick_contacts_dialer,
                                title: 'Contact Us',
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                String url =
                                    'https://play.google.com/store/apps/details?id=com.sabjitaja.sabjitaja';
                                if (await canLaunchUrl(Uri.parse(url))) {
                                  await launchUrl(
                                    Uri.parse(url),
                                    mode: kIsWeb
                                        ? LaunchMode.platformDefault
                                        : LaunchMode.externalApplication,
                                  );
                                }
                              },
                              child: AccountTile(
                                icon: Icons.star_rate,
                                title: 'Rate Us',
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                String url =
                                    'https://play.google.com/store/apps/details?id=com.sabjitaja.sabjitaja';
                                Share.share(
                                    'Install our SabjiTaja App to buy vegetables, fruits, meats, and many more in your city Daudnagar $url');
                              },
                              child: AccountTile(
                                icon: Icons.share,
                                title: 'Share App',
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      height: 120,
                      width: MediaQuery.of(context).size.width - 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 12, right: 12, top: 12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed(PrivacyPage.routeName);
                              },
                              child: AccountTile(
                                icon: Icons.privacy_tip,
                                title: 'Privacy & Policy',
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed(AboutPage.routeName);
                              },
                              child: AccountTile(
                                icon: Icons.developer_board,
                                title: 'About Us',
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    InkWell(
                      onTap: () async {
                        await FirebaseAuth.instance.signOut();
                      },
                      child: Container(
                        height: 65,
                        width: MediaQuery.of(context).size.width - 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12, right: 12),
                          child: Center(
                            child: AccountTile(
                              icon: Icons.power_settings_new,
                              title: 'Logout',
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    )));
  }
}

class AccountTile extends StatelessWidget {
  final IconData icon;
  final title;

  AccountTile({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
              color: ColorsConsts.AppMainColor,
              borderRadius: BorderRadius.circular(10)),
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          '$title',
          style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
        ),
        const Spacer(),
        const Icon(
          Icons.arrow_forward_ios_sharp,
          color: Colors.grey,
          size: 18,
        )
      ],
    );
  }
}
