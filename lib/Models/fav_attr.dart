import 'package:flutter/material.dart';

class FavsAttr extends ChangeNotifier{
  String id;
  String title;
  double price;
  String imageUrl;

  FavsAttr({required this.id,required this.title,required this.price,required this.imageUrl});
}