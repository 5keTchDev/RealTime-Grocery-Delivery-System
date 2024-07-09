import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../Constants/colors.dart';
import '../Models/address_attr.dart';
import '../Models/cart_attr.dart';
import '../widgets/appbarCustom.dart';
import 'address.dart';
import '../Screens/payments.dart';

class OrderSummary extends StatefulWidget {
  static const routeName = '/OrderSummary';

  @override
  State<OrderSummary> createState() => _OrderSummaryState();
}

class _OrderSummaryState extends State<OrderSummary> {
  @override
  Widget build(BuildContext context) {
    if (Provider.of<List<AddressAttr>>(context).isEmpty) {
      return Address();
    }
    return Consumer<List<AddressAttr>>(builder: (context, addressList, child) {
      AddressAttr selectedAddress;
      selectedAddress =
          addressList.firstWhere((element) => element.selected == true);
      return Consumer<List<CartAttr>>(builder: (context, cartList, child) {
        double totalAmount = 0;
        cartList.forEach((element) {
          totalAmount = totalAmount + element.price * element.quantity;
        });

        return SafeArea(
          child: Scaffold(
            // backgroundColor: Colors.white,
            appBar: const PreferredSize(
              preferredSize: const Size.fromHeight(100),
              child: AppBarCustom(
                title: 'Order Summary',
              ),
            ),
            bottomSheet: Container(
              decoration: BoxDecoration(
                color: ColorsConsts.AppMainColor,
                border: const Border(
                    top: BorderSide(color: Colors.grey, width: 0.5)),
              ),
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Material(
                        color: Colors.deepOrange,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(30),
                          onTap: () {
                            Navigator.of(context).pushNamed(Payments.routeName);
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Continue',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(
                          FontAwesomeIcons.rupeeSign,
                          color: Colors.white,
                          size: 20,
                        ),
                        Text(
                          totalAmount.toStringAsFixed(2),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.only(
                left: 12,
                right: 12,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      // color: Colors.white,
                      height: 230,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: Text(
                                    selectedAddress.name,
                                    style: const TextStyle(
                                        fontSize: 18, color: Colors.black),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width - 50,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: Text(
                                      '${selectedAddress.houseNo}, ${selectedAddress.roadName}, ${selectedAddress.city}, ',
                                      style: const TextStyle(
                                          fontSize: 15, color: Colors.black),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: Text(
                                      selectedAddress.phoneNumber,
                                      style: const TextStyle(
                                          fontSize: 15, color: Colors.black),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 40,
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context)
                                        .pushNamed(Address.routeName);
                                  },
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width - 24,
                                    height: 40,
                                    color: Colors.blue,
                                    child: const Center(
                                      child: Text(
                                        'Change or Add Address',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 2,
                      child: Container(
                        color: Colors.grey.shade300,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Price Details',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // productId != null
                              //     ? Text(
                              //         'Price (1 item)',
                              //         style: TextStyle(
                              //             color: Colors.black, fontSize: 13),
                              //       )
                              // :
                              Text(
                                'Price (${cartList.length} items)',
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 13),
                              ),
                              // productId != null
                              //     ? Text(
                              //         '${Provider.of<Products>(context).getById(productId.toString()).price}',
                              //         style: TextStyle(
                              //             color: Colors.black, fontSize: 13),
                              //       )
                              //     :
                              Text(
                                '$totalAmount',
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 13),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'Delivery Charges',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 13),
                              ),
                              Text(
                                'Free',
                                style: TextStyle(
                                    color: Colors.green, fontSize: 13),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 2,
                            child: Container(
                              color: Colors.grey.shade300,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total Amount',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold),
                              ),
                              // productId != null
                              //     ? Text(
                              //         '${Provider.of<Products>(context).getById(productId.toString()).price}',
                              //         style: TextStyle(
                              //             color: Colors.black,
                              //             fontSize: 13,
                              //             fontWeight: FontWeight.bold),
                              //       )
                              //     :
                              Text(
                                '$totalAmount',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      });
    });
  }
}
