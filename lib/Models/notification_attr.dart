import 'package:flutter/material.dart';

class NotificationAttr extends ChangeNotifier{
  String userId;
  String title;
  String subTitle;
  String timestamp;
  bool isSeen;

  NotificationAttr({
     required this.userId,required this.title,required this.subTitle,required this.timestamp,required this.isSeen});
}