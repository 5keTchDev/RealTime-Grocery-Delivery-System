import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../Constants/colors.dart';
import '../Constants/my_icons.dart';
import '../Models/cart_attr.dart';
import 'cart.dart';
import 'home.dart';
import '../Screens/user_info.dart';

class BottomBarScreen extends StatefulWidget {
  static const routeName = '/BottomBarScreen';

  @override
  _BottomBarScreenState createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  var _pages;

  int _selectedIndex = 0;
  bool selected = false;

  @override
  void initState() {
    // TODO: implement initState
    print('init state in bottombar.dart ');

    _pages = [
      {
        'page': Home(),
        'title': 'Home',
      },
      {
        'page': const Scaffold(
          body: Center(
            child: Text(
              'No Favorite Items !',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
        'title': 'Feeds',
      },
      {
        'page': Cart(),
        'title': 'Cart',
      },
      {
        'page': UserInfoo(),
        'title': 'User Info',
      },
    ];

    super.initState();
  }

  void _selectedPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Do you want to exit the app?'),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text('Yes'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text('No'),
                ),
              ],
            );
          },
        );
        return shouldPop!;
      },
      child: Scaffold(
        body: _pages[_selectedIndex]['page'],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(30), topLeft: Radius.circular(30)),
            boxShadow: [
              BoxShadow(
                  color: ColorsConsts.AppMainColor.withOpacity(0.2),
                  spreadRadius: 0,
                  blurRadius: 20),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              onTap: _selectedPage,
              backgroundColor: Colors.white,
              showSelectedLabels: true,
              selectedItemColor: ColorsConsts.AppMainColor,
              currentIndex: _selectedIndex,
              items: [
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Icon(MyAppIcon.home),
                  ),
                  tooltip: 'HOME',
                  label: 'Home',
                ),
                const BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Icon(Icons.favorite),
                  ),
                  tooltip: 'Favorite',
                  label: 'Favorite',
                ),
                // BottomNavigationBarItem(
                //   icon: Padding(
                //     padding: const EdgeInsets.only(top: 8),
                //     child: Icon(MyAppIcon.search),
                //   ),
                //   tooltip: 'Search',
                //   label: '',
                // ),
                // BottomNavigationBarItem(
                //   icon: Icon(MyAppIcon.cart),
                //   tooltip: 'Cart',
                //   label: '',
                // ),
                BottomNavigationBarItem(
                  icon: Stack(
                    // alignment: AlignmentDirectional.topEnd,
                    clipBehavior: Clip.none,
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Icon(Icons.shopping_bag),
                      ),
                      Positioned(
                        // draw a red marble
                        top: 0,
                        right: -10,

                        child: Container(
                            height: 20,
                            width: 20,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Center(child: Consumer<List<CartAttr>>(
                                builder: (context, cartList, child) {
                              return Text(
                                cartList.length.toString(),
                                // '${Provider.of<Cartprovider>(context).getCartItems.length.toString()}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 10),
                              );
                            }))),
                      )
                    ],
                  ),
                  tooltip: 'Cart',
                  label: 'Cart',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Icon(MyAppIcon.user),
                  ),
                  tooltip: 'Account',
                  label: 'Account',
                ),
              ],
            ),
          ),
        ),
        // floatingActionButtonLocation:
        //     FloatingActionButtonLocation.miniCenterDocked,
        // floatingActionButton: FloatingActionButton(
        //   backgroundColor: ColorsConsts.green,
        //   tooltip: 'Search',
        //   elevation: 5,
        //   child: (Icon(MyAppIcon.search)),
        //   onPressed: () {
        //     setState(() {
        //       _selectedIndex = 2;
        //     });
        //   },
        // ),
      ),
    );
  }
}
