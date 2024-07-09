import 'dart:ui';

import 'package:flutter/material.dart';

import '../widgets/appbarCustom.dart';

class AboutPage extends StatelessWidget {
  static const routeName = '/AboutUs';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: AppBarCustom(
            title: 'About Us',
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: RichText(
                text: const TextSpan(
                    text: 'About Us',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text:
                            '\n\nFirst of all very very thanks for installing  our app. '
                            'We are young graduates from Daudnagar, Bihar. We want to serve Daudnagar people by '
                            'providing vegetables and meats online on market price. Actually, we saw problems among '
                            'parents who are living here, far from their native place for their children.'
                            'These parents struggle a lot so that their children can study well.'
                            'We SabjiTaja team will help these parents through this app. We will serve you on time'
                            '. You will like our service. If you find any issue you can contact us directly.'
                            'Finally, thanks for installing our app.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ]),
              )),
        ),
      ),
    );
  }
}
