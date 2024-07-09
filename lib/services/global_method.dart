
import 'package:flutter/material.dart';

import '../Constants/colors.dart';

class GlobalMethod {
  // Future<void> showDialogg(String title, String subtitle, Function function,
  //     BuildContext context) async {
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext ctx) {
  //         return AlertDialog(
  //           title: Row(
  //             children: [
  //               Padding(
  //                 padding: const EdgeInsets.only(right: 6.0),
  //                 child: Image.asset(
  //                   'images/error_img.webp',
  //                   height: 20,
  //                   width: 20,
  //                 ),
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: Text(title),
  //               ),
  //             ],
  //           ),
  //           content: Text(subtitle),
  //           actions: [
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.pop(context);
  //               },
  //               child: Text('Cancel'),
  //             ),
  //             TextButton(
  //               onPressed: () {
  //                 function();
  //                 Navigator.pop(context);
  //               },
  //               child: Text('Ok'),
  //             )
  //           ],
  //         );
  //       });
  // }

  Future<void> authErrorHandle(String subtitle, BuildContext context) async {
    await showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            backgroundColor: const Color(0xFFFDEDEF),
            title: Row(
              children: const [
                Padding(
                  padding: EdgeInsets.only(right: 6.0),
                  child: Icon(
                    Icons.error,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Error Occurred',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
            content: Text(
              subtitle,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Ok',
                  style: TextStyle(
                    color: ColorsConsts.AppMainColor,
                    fontSize: 16,
                  ),
                ),
              )
            ],
          );
        });
  }

  Future<void> authSuccessHandle(
      {required String title,
      required String subtitle,
      required BuildContext context}) async {
    await showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            backgroundColor: Colors.green.shade50,
            title: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 6.0),
                  child: CircleAvatar(
                    backgroundColor: ColorsConsts.AppMainColor,
                    child: const Icon(
                      Icons.done,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
            content: Text(
              subtitle,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Ok',
                  style: TextStyle(
                    color: ColorsConsts.AppMainColor,
                    fontSize: 16,
                  ),
                ),
              )
            ],
          );
        });
  }

  static void showSnackBar({
    required String title,
    required BuildContext context,
    required Color color,
    required IconData? icon,
    required Color iconBackgroundColor,
    required bool isIcon,
    VoidCallback? function,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(
          milliseconds: 500,
        ),
        backgroundColor: color,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            isIcon
                ? InkWell(
                    onTap: function,
                    child: CircleAvatar(
                      backgroundColor: iconBackgroundColor,
                      child: Icon(
                        icon,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  )
                : const SizedBox(
                    height: 0,
                    width: 0,
                  ),
          ],
        ),
      ),
    );
  }
}
