import 'dart:ui';


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Models/address_attr.dart';
import '../widgets/address_empty.dart';
import '../widgets/address_full.dart';
import '../widgets/appbarCustom.dart';

class Address extends StatefulWidget {
  static const routeName = '/address';

  @override
  State<Address> createState() => _AddressState();
}

class _AddressState extends State<Address> {
  @override
  Widget build(BuildContext context) {
    if (Provider.of<List<AddressAttr>>(context).isEmpty) {
      return AddressEmpty();
    }
    return Consumer<List<AddressAttr>>(builder: (context, addressList, child) {
      return SafeArea(
        child: Scaffold(
          // backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(100),
            child: AppBarCustom(
              title: 'Select Address (${addressList.length})',
            ),
          ),
          bottomSheet: InkWell(
            onTap: () {
              Navigator.canPop(context) ? Navigator.pop(context) : null;
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              color: Colors.deepOrange,
              child: const Center(
                  child: Text(
                'DELIVER HERE',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500),
              )),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    color: Colors.white,
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, AddressEmpty.routeName);
                      },
                      child: Row(
                        children: const [
                          Padding(
                            padding:
                                EdgeInsets.only(left: 15, top: 15, bottom: 15),
                            child: Icon(
                              Icons.add,
                              color: Colors.blue,
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(left: 15, top: 15, bottom: 15),
                            child: Text(
                              'Add a new address',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 2,
                    child: Container(
                      color: Colors.grey.shade300,
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height,
                    margin: const EdgeInsets.only(top: 10, bottom: 50),
                    child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: addressList.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              AddressFull(
                                addressId: addressList[index].addressId,
                                isSelected: addressList[index].selected,
                                userName: addressList[index].name,
                                houseNo: addressList[index].houseNo,
                                roadName: addressList[index].roadName,
                                city: addressList[index].city,
                                phoneNo: addressList[index].phoneNumber,
                              ),
                              // AddressFull(
                              //   isSelected: addressList[index].selected,
                              // ),
                              Container(
                                height: 1,
                                width: MediaQuery.of(context).size.width,
                                color: Colors.grey.shade300,
                              ),
                            ],
                          );
                        }),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
