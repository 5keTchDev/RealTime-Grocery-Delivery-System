import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Models/product.dart';
import '../widgets/appbarCustom.dart';
import '../widgets/popular_card_widget.dart';

class Feeds extends StatefulWidget {
  static const routeName = '/feeds';

  @override
  State<Feeds> createState() => _FeedsState();
}

class _FeedsState extends State<Feeds> {
  List<Product>? productList;
  String? string;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    string = ModalRoute.of(context)!.settings.arguments as String?;
    if (string == 'Top Offers') {
      productList = productList = Provider.of<List<Product>>(context)
          .where((element) =>
              double.parse(element.percentOff) > 5 && element.inStock == true)
          .toList();
    }
    if (string == 'Popular Products') {
      productList = Provider.of<List<Product>>(context)
          .where((element) => element.isPopular && element.inStock == true)
          .toList();
    }
    if (string == 'Popular Fruits') {
      productList = Provider.of<List<Product>>(context)
          .where((element) =>
              element.productCategoryName.contains('Fruits') &&
              element.inStock == true)
          .toList();
    }
    if (string == 'Popular Vegetables') {
      productList = Provider.of<List<Product>>(context)
          .where((element) =>
              element.productCategoryName.contains('Vegeta') &&
              element.inStock == true)
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: AppBarCustom(
            title: string!,
          ),
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: GridView.builder(
                    itemCount: productList!.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 0.88,
                    ),
                    itemBuilder: (context, index) {
                      return ProductCardWidget(
                        productPrice: productList![index].price.toString(),
                        productId: productList![index].id,
                        productTitle: productList![index].title,
                        productImage: productList![index].imageUrl,
                        cuttedPrice: productList![index].cuttedPrice.toString(),
                        unitAmount: productList![index].unitAmount,
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
