import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../Models/product.dart';
import '../widgets/popular_card_widget.dart';

class Search extends StatefulWidget {
  static const routeName = '/search';

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  late TextEditingController _searchTextController;
  final FocusNode _node = FocusNode();
  late List<Product> productsList = [];

  void initState() {
    super.initState();
    _searchTextController = TextEditingController();
    _searchTextController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _node.dispose();
    _searchTextController.dispose();
  }

  List<Product> _searchList = [];
  @override
  Widget build(BuildContext context) {
    return Consumer<List<Product>>(builder: (context, products, child) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            children: [
              TextField(
                controller: _searchTextController,
                minLines: 1,
                focusNode: _node,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  prefixIcon: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                  ),
                  hintText: 'Search',
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  suffixIcon: IconButton(
                    onPressed: _searchTextController.text.isEmpty
                        ? null
                        : () {
                            _searchTextController.clear();
                            _node.unfocus();
                          },
                    icon: Icon(
                      Icons.close,
                      color: _searchTextController.text.isNotEmpty
                          ? Colors.black
                          : Colors.grey,
                    ),
                  ),
                ),
                onChanged: (value) {
                  _searchTextController.text.trim().toLowerCase();
                  setState(() {
                    _searchList = products
                        .where((element) => element.title
                            .toLowerCase()
                            .contains(value.trim().toLowerCase()))
                        .toList();
                  });
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: Container(
                    child: _searchTextController.text.trim().isNotEmpty &&
                            _searchList.isEmpty
                        ? Column(
                            children: const [
                              SizedBox(
                                height: 50,
                              ),
                              Icon(
                                FontAwesomeIcons.search,
                                size: 60,
                              ),
                              SizedBox(
                                height: 50,
                              ),
                              Text(
                                'No products found !',
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.w700),
                              ),
                            ],
                          )
                        : SizedBox(
                            height: MediaQuery.of(context).size.height - 100,
                            child: GridView.builder(
                                itemCount:
                                    _searchTextController.text.trim().isEmpty
                                        ? products.length
                                        : _searchList.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 8,
                                        crossAxisSpacing: 8,
                                        childAspectRatio: 0.88),
                                itemBuilder: (context, index) {
                                  if (_searchTextController.text
                                      .trim()
                                      .isEmpty) {
                                    return ProductCardWidget(
                                      productPrice:
                                          products[index].price.toString(),
                                      productId: products[index].id,
                                      productTitle: products[index].title,
                                      productImage: products[index].imageUrl,
                                      cuttedPrice: products[index]
                                          .cuttedPrice
                                          .toString(),
                                      unitAmount: products[index].unitAmount,
                                    );
                                  }
                                  return ProductCardWidget(
                                    productPrice:
                                        _searchList[index].price.toString(),
                                    productId: _searchList[index].id,
                                    productTitle: _searchList[index].title,
                                    productImage: _searchList[index].imageUrl,
                                    cuttedPrice: _searchList[index]
                                        .cuttedPrice
                                        .toString(),
                                    unitAmount: _searchList[index].unitAmount,
                                  );
                                }),
                          )),
              ),
            ],
          ),
        ),
      );
    });
  }
}
