import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Models/product.dart';
import '../widgets/appbarCustom.dart';
import '../widgets/popular_card_widget.dart';

class FeedsCategory extends StatefulWidget {
  static const routeName = '/feedsCategory';

  @override
  State<FeedsCategory> createState() => _FeedsCategoryState();
}

class _FeedsCategoryState extends State<FeedsCategory> {
  String categoryName = '';

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    categoryName = ModalRoute.of(context)?.settings.arguments as String;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<List<Product>>(builder: (context, products, child) {
      List<Product> categoryProducts = products
          .where((element) => element.productCategoryName
              .toLowerCase()
              .contains(categoryName.toLowerCase()))
          .toList();

      if (categoryProducts.isEmpty) {
        return SafeArea(
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(100),
              child: AppBarCustom(
                title: categoryName,
              ),
            ),
            body: const Center(
              child: Text(
                'No Products Found !',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      }

      return SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(100),
            child: AppBarCustom(
              title: categoryName,
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
                      itemCount: categoryProducts.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        childAspectRatio: 0.88,
                      ),
                      itemBuilder: (context, index) {
                        return ProductCardWidget(
                          productPrice:
                              categoryProducts[index].price.toString(),
                          productId: categoryProducts[index].id,
                          productTitle: categoryProducts[index].title,
                          productImage: categoryProducts[index].imageUrl,
                          cuttedPrice:
                              categoryProducts[index].cuttedPrice.toString(),
                          unitAmount: categoryProducts[index].unitAmount,
                        );
                        // return ChangeNotifierProvider.value(
                        //     // value: Provider.of<Products>(context).products[index],
                        //     value: Provider.of<Products>(context)
                        //         .getByCategory(categoryName)[index],
                        //     child: ProductCardWidget());
                      }),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
