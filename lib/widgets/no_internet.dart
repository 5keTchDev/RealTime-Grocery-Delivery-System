import 'package:flutter/material.dart';

class NoInternet extends StatelessWidget {
  const NoInternet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'icons/no internet.png',
              width: 250,
              height: 250,
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              'Ooops!',
              style: TextStyle(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w900,
                fontSize: 40,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Text(
                'It seems there is '
                'something wrong with your internet'
                ' connection. Please connect to the internet '
                'and start using the app.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
