import 'package:flutter/material.dart';

import '../Constants/colors.dart';
import '../inner_screen/product_details.dart';

class ProductCardWidget extends StatefulWidget {
  final String productId;
  final String productImage;
  final String productPrice;
  final String productTitle;
  final String cuttedPrice;
  final String unitAmount;

  const ProductCardWidget({
    required this.productPrice,
    required this.productId,
    required this.productTitle,
    required this.productImage,
    required this.cuttedPrice,
    required this.unitAmount,
  });

  @override
  State<ProductCardWidget> createState() => _ProductCardWidgetState();
}

class _ProductCardWidgetState extends State<ProductCardWidget> {
  // final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 158,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, ProductDetails.routeName,
              arguments: widget.productId);
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  height: 25,
                  width: 40,
                  decoration: BoxDecoration(
                    color: ColorsConsts.AppMainColor,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.star,
                        color: Colors.white,
                        size: 12,
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Text(
                        '4.6',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      )
                    ],
                  ),
                ),
              ),
              Image.network(
                widget.productImage,
                height: 60,
                fit: BoxFit.contain,
              ),
              const SizedBox(
                height: 10,
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          width: 100,
                          height: 20,
                          child: Text(
                            widget.productTitle,
                            overflow: TextOverflow.clip,
                            style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                                color: Colors.black),
                          )),
                      RichText(
                        text: TextSpan(children: [
                          const WidgetSpan(
                            child: Icon(
                              Icons.currency_rupee,
                              size: 16,
                            ),
                          ),
                          TextSpan(
                              text: '${widget.productPrice}',
                              style: TextStyle(
                                  color: ColorsConsts.AppMainColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                          TextSpan(
                            text: '/${widget.unitAmount}',
                            style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                                fontSize: 12),
                          ),
                        ]),
                        textAlign: TextAlign.left,
                      ),
                      RichText(
                        text: TextSpan(children: [
                          const WidgetSpan(
                            child: Icon(
                              Icons.currency_rupee,
                              size: 16,
                            ),
                          ),
                          TextSpan(
                            text: '${widget.cuttedPrice}',
                            style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: ColorsConsts.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: '/${widget.unitAmount}',
                            style: const TextStyle(
                                decoration: TextDecoration.lineThrough,
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                                fontSize: 12),
                          ),
                        ]),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  // Container(
                  //   height: 25,
                  //   width: 25,
                  //   decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(7),
                  //       color: ColorsConsts.AppMainColor),
                  //   child: const Icon(
                  //     Icons.favorite,
                  //     color: Colors.white,
                  //     size: 15,
                  //   ),
                  // ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
