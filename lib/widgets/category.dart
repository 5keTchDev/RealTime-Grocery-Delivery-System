
import 'package:flutter/material.dart';
import '../Screens/feeds_category.dart';

class CategoryWidget extends StatefulWidget {
  final String name;
  final String image;
  final String color;

  CategoryWidget({
    required this.name,
    required this.image,
    required this.color,
  });

  @override
  _CategoryWidgetState createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  // final List<Map<String, dynamic>> _categories = [
  //   {
  //     'categoryName': 'Fruits',
  //     'categoryImagesPath': 'icons/fruits.png',
  //     'backgroundColor': ColorsConsts.AppMainColor,
  //     'categoryNameColor': Colors.white
  //   },
  //   {
  //     'categoryName': 'Dairy',
  //     'categoryImagesPath': 'icons/dairy.png',
  //     'backgroundColor': const Color(0xFFF7EDE4),
  //     'categoryNameColor': Colors.black
  //   },
  //   {
  //     'categoryName': 'Vegeta',
  //     'categoryImagesPath': 'icons/vegetable.png',
  //     'backgroundColor': const Color(0xFFFAF4E6),
  //     'categoryNameColor': Colors.black
  //   },
  //   {
  //     'categoryName': 'Meat',
  //     'categoryImagesPath': 'icons/meat.png',
  //     'backgroundColor': const Color(0xFFEBF2F8),
  //     'categoryNameColor': Colors.black
  //   }
  // ];

  @override
  Widget build(BuildContext context) {
    String valueString =
        widget.color.split('(0x')[1].split(')')[0]; // kind of hacky..
    int value = int.parse(valueString, radix: 16);
    return InkWell(
      onTap: () async {
        await Navigator.pushNamed(context, FeedsCategory.routeName,
            arguments: widget.name);
      },
      child: Container(
        width: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color(value),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
              widget.image,
              height: 32,
              width: 32,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              widget.name,
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.w400),
            )
          ],
        ),
      ),
    );
  }
}
