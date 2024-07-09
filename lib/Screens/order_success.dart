import '../Screens/user_state.dart';
import 'package:flutter/material.dart';

class OrderSuccess extends StatefulWidget {
  static const routeName = '/OrderSuccess';

  @override
  State<OrderSuccess> createState() => _OrderSuccessState();
}

class _OrderSuccessState extends State<OrderSuccess> {
  @override
  Widget build(BuildContext context) {
    // final orderId = ModalRoute.of(context)!.settings.arguments as String;

    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 100,
                ),
                Container(
                  height: 50,
                  width: 50,
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.green),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'ऑर्डर करने के लिए धन्यवाद !',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'आपका ऑर्डर हो चुका है। आपको आधा घंटे से 1 घंटे के अंदर में प्रोडक्ट मिल जायेगा।',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                    )),
                const SizedBox(
                  height: 100,
                ),
                Container(
                  color: Colors.green,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 8, left: 20, bottom: 8, right: 20),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => UserState()),
                        );
                      },
                      child: const Text(
                        'Continue Shopping',
                        style: TextStyle(fontSize: 13, color: Colors.white),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
