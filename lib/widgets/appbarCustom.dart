import 'package:flutter/material.dart';

import '../Constants/colors.dart';

class AppBarCustom extends StatelessWidget {
  final String title;
  const AppBarCustom({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              width: 40,
              height: 40,
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
              ),
              decoration: BoxDecoration(
                color: ColorsConsts.AppMainColor,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
