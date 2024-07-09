import 'dart:io';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../Constants/colors.dart';
import '../services/global_method.dart';

class UploadProductForm extends StatefulWidget {
  static const routeName = '/UploadProductForm';

  @override
  _UploadProductFormState createState() => _UploadProductFormState();
}

class _UploadProductFormState extends State<UploadProductForm> {
  final _formKey = GlobalKey<FormState>();

  var _productTitle = '';
  var _productPrice = '';
  var _cuttedPrice = '';
  var _productCategory = '';
  var _productUnit = '';
  // var _productBrand = '';
  var _productDescription = '';
   var _isPopular='';
  // var _productQuantity = '';
  bool _popular=false;
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _unitController = TextEditingController();
  final TextEditingController _popularController = TextEditingController();
  String? _categoryValue;
  String? _popularValue;
  String? _unitValue;
  String? _brandValue;
  GlobalMethod _globalMethods = GlobalMethod();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  File? _pickedImage;
  bool _isLoading = false;
  String? url;
  var uuid = Uuid();
  showAlertDialog(BuildContext context, String title, String body) {
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(body),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _trySubmit() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      print(_productTitle);
      print(_productPrice);
      print(_productCategory);
      // print(_productBrand);
      print(_productDescription);
      // print(_productQuantity);
      // Use those values to send our request ...
    }
    if (isValid) {
      _formKey.currentState!.save();
      try {
        if (_pickedImage == null) {
          _globalMethods.authErrorHandle('Please pick an image', context);
        } else {
          setState(() {
            _isLoading = true;
          });

          if(_isPopular=='Yes'){
            _popular=true;
          }else{
            _popular=false;
          }

          if(double.parse(_cuttedPrice)>=double.parse(_productPrice)){
            final ref = FirebaseStorage.instance
                .ref()
                .child('productsImages')
                .child(_productTitle + '.jpg');
            await ref.putFile(_pickedImage!);
            url = await ref.getDownloadURL();

            final User? user = _auth.currentUser;
            final _uid = user!.uid;
            final productId = uuid.v4();
            await FirebaseFirestore.instance
                .collection('products')
                .doc(productId)
                .set({
              'productId': productId,
              'productTitle': _productTitle,
              'price': _productPrice,
              'productImage': url,
              'productCategory': _productCategory,
              'unitAmount':_productUnit,
              'productDescription': _productDescription,
              'userId': _uid,
              'cuttedPrice':_cuttedPrice,
              'percentOff':((double.parse(_cuttedPrice)-double.parse(_productPrice))/double.parse(_cuttedPrice)*100).toStringAsFixed(2),
              'isPopular':_popular,
              'createdAt': Timestamp.now(),
            });
            Navigator.canPop(context) ? Navigator.pop(context) : null;

          }else{
            showAlertDialog(context, 'Error Occured !', 'Cutted Price should be Greater than Product Price');
          }

        }
      } catch (error) {
        _globalMethods.authErrorHandle(error.toString(), context);
        print('error occured ${error.toString()}');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _pickImageCamera() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(
      source: ImageSource.camera,
      imageQuality: 40,
    );
    final pickedImageFile = File(pickedImage!.path);
    setState(() {
      _pickedImage = pickedImageFile;
    });
    // widget.imagePickFn(pickedImageFile);
  }

  void _pickImageGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    final pickedImageFile = pickedImage == null ? null : File(pickedImage.path);

    setState(() {
      if(kIsWeb){
        // _pickedImage=pickedImageFile.path;
        print(pickedImageFile!.path);
      }
      _pickedImage = pickedImageFile;
    });
    // widget.imagePickFn(pickedImageFile);
  }

  void _removeImage() {
    setState(() {
      _pickedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Container(
        height: kBottomNavigationBarHeight * 0.8,
        width: double.infinity,
        decoration: BoxDecoration(
          color: ColorsConsts.white,
          border:const Border(
            top: BorderSide(
              color: Colors.grey,
              width: 0.5,
            ),
          ),
        ),
        child: Material(
          color: Theme.of(context).backgroundColor,
          child: InkWell(
            onTap: _trySubmit,
            splashColor: Colors.grey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 2),
                  child: _isLoading
                      ? Center(
                          child: Container(
                              height: 40,
                              width: 40,
                              child: CircularProgressIndicator()))
                      : Text('Upload',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center),
                ),
                GradientIcon(
                  FontAwesomeIcons.upload,
                  20,
                  LinearGradient(
                    colors: <Color>[
                      Colors.green,
                      Colors.yellow,
                      Colors.deepOrange,
                      Colors.orange,
                      Colors.yellow[800]!
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Card(
                margin: EdgeInsets.all(15),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Flexible(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 9),
                            child: TextFormField(
                              key: ValueKey('Title'),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a Title';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: 'Product Title',
                              ),
                              onSaved: (value) {
                                _productTitle = value!;
                              },
                            ),
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            Flexible(
                              flex: 1,
                              child: TextFormField(
                                key: ValueKey('Price'),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Price is missed';
                                  }
                                  return null;
                                },
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]')),
                                ],
                                decoration: InputDecoration(
                                  labelText: 'Price',
                                  //  prefixIcon: Icon(Icons.mail),
                                  // suffixIcon: Text(
                                  //   '\n \n \$',
                                  //   textAlign: TextAlign.start,
                                  // ),
                                ),
                                //obscureText: true,
                                onSaved: (value) {
                                  _productPrice = value!;
                                },
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: TextFormField(
                                key: ValueKey('Cutted Price'),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Cutted Price is missed';
                                  }
                                  return null;
                                },
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]')),
                                ],
                                decoration: InputDecoration(
                                  labelText: 'Cutted Price ',
                                  //  prefixIcon: Icon(Icons.mail),
                                  // suffixIcon: Text(
                                  //   '\n \n \$',
                                  //   textAlign: TextAlign.start,
                                  // ),
                                ),
                                //obscureText: true,
                                onSaved: (value) {
                                  _cuttedPrice = value!;
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        /* Image picker here ***********************************/
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              //  flex: 2,
                              child: this._pickedImage == null
                                  ? Container(
                                      margin: EdgeInsets.all(10),
                                      height: 200,
                                      width: 200,
                                      decoration: BoxDecoration(
                                        border: Border.all(width: 1),
                                        borderRadius: BorderRadius.circular(4),
                                        color:
                                            Theme.of(context).backgroundColor,
                                      ),
                                    )
                                  : Container(
                                      margin: EdgeInsets.all(10),
                                      height: 200,
                                      width: 200,
                                      child: Container(
                                        height: 200,
                                        // width: 200,
                                        decoration: BoxDecoration(
                                          // borderRadius: BorderRadius.only(
                                          //   topLeft: const Radius.circular(40.0),
                                          // ),
                                          color:
                                              Theme.of(context).backgroundColor,
                                        ),
                                        child: Image.file(
                                          this._pickedImage!,
                                          fit: BoxFit.contain,
                                          alignment: Alignment.center,
                                        ),
                                      ),
                                    ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FittedBox(
                                  child: TextButton.icon(
                                    // textColor: Colors.white,
                                    onPressed: _pickImageCamera,
                                    icon: Icon(Icons.camera,
                                        color: Colors.purpleAccent),
                                    label: Text(
                                      'Camera',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        // color: Theme.of(context)
                                        //     .textSelectionColor,
                                      ),
                                    ),
                                  ),
                                ),
                                FittedBox(
                                  child: TextButton.icon(
                                    // textColor: Colors.white,
                                    onPressed: _pickImageGallery,
                                    icon: Icon(Icons.image,
                                        color: Colors.purpleAccent),
                                    label: Text(
                                      'Gallery',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        // color: Theme.of(context)
                                        //     .textSelectionColor,
                                      ),
                                    ),
                                  ),
                                ),
                                FittedBox(
                                  child: TextButton.icon(
                                    // textColor: Colors.white,
                                    onPressed: _removeImage,
                                    icon: Icon(
                                      Icons.remove_circle_rounded,
                                      color: Colors.red,
                                    ),
                                    label: Text(
                                      'Remove',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        //    SizedBox(height: 5),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              // flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 9),
                                child: Container(
                                  child: TextFormField(
                                    controller: _categoryController,

                                    key: ValueKey('Category'),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter a Category';
                                      }
                                      return null;
                                    },
                                    //keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      labelText: 'Add a new Category',
                                    ),
                                    onSaved: (value) {
                                      _productCategory = value!;
                                    },
                                  ),
                                ),
                              ),
                            ),
                            DropdownButton<String>(
                              items: [
                                DropdownMenuItem<String>(
                                  child: Text('Cooking Essential'),
                                  value: 'Cooking Essential',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('Snacks'),
                                  value: 'Snacks',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('Packaged Food'),
                                  value: 'Packaged Food',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('Personal Care'),
                                  value: 'Personal Care',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('Household & Cleaning'),
                                  value: 'Household & Cleaning',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('Home & Kitchen'),
                                  value: 'Home & Kitchen',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('Fresh Dairy'),
                                  value: 'Fresh Dairy',
                                ),
                              ],
                              onChanged: (String? value) {
                                setState(() {
                                  _categoryValue = value;
                                  _categoryController.text = value!;
                                  //_controller.text= _productCategory;
                                  print(_productCategory);
                                });
                              },
                              hint: Text('Select a Category'),
                              value: _categoryValue,
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 9),
                                child: Container(
                                  child: TextFormField(
                                    controller: _unitController,

                                    key: ValueKey('Unit'),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Unit is missed';
                                      }
                                      return null;
                                    },
                                    //keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      labelText: 'Unit',
                                    ),
                                    onSaved: (value) {
                                      _productUnit = value!;
                                    },
                                  ),
                                ),
                              ),
                            ),
                            DropdownButton<String>(
                              items: [
                                DropdownMenuItem<String>(
                                  child: Text('Unitless'),
                                  value: 'Unitless',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('50 g'),
                                  value: '50 g',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('100 g'),
                                  value: '100 g',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('150 g'),
                                  value: '150 g',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('200 g'),
                                  value: '200 g',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('250 g'),
                                  value: '250 g',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('300 g'),
                                  value: '300 g',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('500 g'),
                                  value: '500 g',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('750 g'),
                                  value: '750 g',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('1 kg'),
                                  value: '1 kg',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('1.25 kg'),
                                  value: '1.25 kg',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('1.5 kg'),
                                  value: '1.5 kg',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('2 kg'),
                                  value: '2 kg',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('2.5 kg'),
                                  value: '2.5 kg',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('3 kg'),
                                  value: '3 kg',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('4 kg'),
                                  value: '4 kg',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('5 kg'),
                                  value: '5 kg',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('10 kg'),
                                  value: '10 kg',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('15 kg'),
                                  value: '15 kg',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('50 ml'),
                                  value: '50 ml',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('100 ml'),
                                  value: '100 ml',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('150 ml'),
                                  value: '150 ml',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('200 ml'),
                                  value: '200 ml',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('250 ml'),
                                  value: '250 ml',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('500 ml'),
                                  value: '500 ml',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('750 ml'),
                                  value: '750 ml',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('1 L'),
                                  value: '1 L',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('2 L'),
                                  value: '2 L',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('2.5 L'),
                                  value: '2.5 L',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('5 L'),
                                  value: '5 L',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('10 L'),
                                  value: '10 L',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('1 Packet'),
                                  value: '1 Packet',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('2 Packet'),
                                  value: '2 Packet',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('3 Packet'),
                                  value: '3 Packet',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('4 Packet'),
                                  value: '4 Packet',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('5 Packet'),
                                  value: '5 Packet',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('10 Packet'),
                                  value: '10 Packet',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('15 Packet'),
                                  value: '15 Packet',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('1 Piece'),
                                  value: '1 Piece',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('2 Piece'),
                                  value: '2 Piece',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('3 Piece'),
                                  value: '3 Piece',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('4 Piece'),
                                  value: '4 Piece',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('5 Piece'),
                                  value: '5 Piece',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('1 Dozen'),
                                  value: '1 Dozen',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('2 Dozen'),
                                  value: '2 Dozen',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('3 Dozen'),
                                  value: '3 Dozen',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('4 Dozen'),
                                  value: '4 Dozen',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('5 Dozen'),
                                  value: '5 Dozen',
                                ),
                              ],
                              onChanged: (String? value) {
                                setState(() {
                                  _brandValue = value;
                                  _unitController.text = value!;
                                  print(_productUnit);
                                });
                              },
                              hint: Text('Select a Unit'),
                              value: _unitValue,
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        TextFormField(
                            key: ValueKey('Description'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'product description is required';
                              }
                              return null;
                            },
                            //controller: this._controller,
                            maxLines: 10,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(
                              //  counterText: charLength.toString(),
                              labelText: 'Description',
                              hintText: 'Product description',
                              border: OutlineInputBorder(),
                            ),
                            onSaved: (value) {
                              _productDescription = value!;
                            },
                            onChanged: (text) {
                              // setState(() => charLength -= text.length);
                            }),
                        //    SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              // flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 9),
                                child: Container(
                                  child: TextFormField(
                                    controller: _popularController,

                                    key: ValueKey('Popular'),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please Select Popularity';
                                      }
                                      return null;
                                    },
                                    //keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      labelText: 'Select Popularity',
                                    ),
                                    onSaved: (value) {
                                      // _productCategory = value!;
                                      _isPopular = value!;
                                    },
                                  ),
                                ),
                              ),
                            ),
                            DropdownButton<String>(
                              items: [
                                DropdownMenuItem<String>(
                                  child: Text('Yes'),
                                  value: 'Yes',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('No'),
                                  value: 'No',
                                ),

                              ],
                              onChanged: (String? value) {
                                setState(() {
                                  _popularValue = value;
                                  _popularController.text = value!;
                                  //_controller.text= _productCategory;
                                  print(_popularValue);
                                });
                              },
                              hint: Text('Select Popularity'),
                              value: _popularValue,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }
}

class GradientIcon extends StatelessWidget {
  GradientIcon(
    this.icon,
    this.size,
    this.gradient,
  );

  final IconData icon;
  final double size;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      child: SizedBox(
        width: size * 1.2,
        height: size * 1.2,
        child: Icon(
          icon,
          size: size,
          color: Colors.white,
        ),
      ),
      shaderCallback: (Rect bounds) {
        final Rect rect = Rect.fromLTRB(0, 0, size, size);
        return gradient.createShader(rect);
      },
    );
  }
}
