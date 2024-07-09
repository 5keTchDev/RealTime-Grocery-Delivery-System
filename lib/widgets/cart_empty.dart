import 'package:flutter/material.dart';

import '../services/global_method.dart';

class CartEmpty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.contain,
                    image: AssetImage('images/cart_empty.png')),
              ),
            ),
            const Text(
              'Your Cart is Empty!',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              'Add items to it now.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 13,
            ),
            // Container(
            //   color: Colors.green,
            //   child: const Padding(
            //     padding:
            //         EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 8),
            //     child: Text(
            //       'Shop Now',
            //       textAlign: TextAlign.center,
            //       style: TextStyle(
            //         color: Colors.white,
            //         fontSize: 13,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
