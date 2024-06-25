import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:planishor/widgets/spinner.dart';

class AddProducts extends StatefulWidget {
  @override
  _AddProductsState createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts> {
  bool _disabledbutton = false;
  String dropdownValue;
  File imageFile;
  Map<String, dynamic> _productData = {
    'title': '',
    'price': '',
    'price_per_strip': '',
    'description': '',
    'category': '',
    'image': ''
  };

  void _showErrorDialog(String msg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occured'),
        content: Text(msg),
        actions: <Widget>[
          // ignore: deprecated_member_use
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    if (imageFile == null) {
      return _showErrorDialog('Image missing');
    }

    if (dropdownValue == null) {
      return _showErrorDialog('Category Missing');
    }

    _formKey.currentState.save();

    try {
      FirebaseFirestore.instance.collection('products').add({
        'title': _productData['title'] as String,
        'price': _productData['price'] as double,
        'price_per_strip': _productData['price_per_strip'] as double,
        'description': _productData['description'] as String,
        'category': _productData['category'] as String,
        'image': _productData['image'] as String
      }).then((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Spinner({
              Future.delayed(
                const Duration(milliseconds: 1000),
                () {
                  Navigator.pop(context);
                  //   Navigator.pushReplacement(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => BottomNavigation(),
                  //     ),
                  //   );
                  // },
                },
              ),
            }),
          ),
        );
      });
    } catch (error) {
      var errorMessage = 'Authentication Failed. Please try again later.';
      _showErrorDialog(errorMessage);
    }
  }

  ///////////////////////////Image Upload////////////////////////

  Future _showChoiceDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Choose option",
            style: TextStyle(color: Colors.blue),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Divider(
                  height: 1,
                  color: Colors.blue,
                ),
                ListTile(
                  onTap: () {
                    _openGallery(context);
                  },
                  title: Text("Gallery"),
                  leading: Icon(
                    Icons.account_box,
                    color: Colors.blue,
                  ),
                ),
                Divider(
                  height: 1,
                  color: Colors.blue,
                ),
                ListTile(
                  onTap: () {
                    _openCamera(context);
                  },
                  title: Text("Camera"),
                  leading: Icon(
                    Icons.camera,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey();
  double finalAmount = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text('Add Item'),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  width: MediaQuery.of(context).size.width * 1,
                  height: 50,
                  child: Text(
                    'Add Item',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                ////////////////////////////////////////Form///////////////////////////////////////////
                ////////////////////////////////////////Form///////////////////////////////////////////
                SizedBox(height: 20),

                /////////////////////////////////////Upload Image//////////////////////////////////////////////
                /////////////////////////////////////Upload Image//////////////////////////////////////////////
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: (imageFile == null)
                      ? SizedBox()
                      : Image.file(File(imageFile.path)),
                ),
                GestureDetector(
                  onTap: () {
                    _showChoiceDialog(context);
                  },
                  child: imageFile == null
                      ? Text(
                          "    🖼 Select Image",
                          style: TextStyle(color: Colors.green, fontSize: 16),
                        )
                      : Text(
                          "    🔄 Retake Image",
                          style: TextStyle(color: Colors.green, fontSize: 16),
                        ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  height: 1,
                  color: Colors.grey,
                ),

                SizedBox(height: 20),

                TextFormField(
                  //Name of Product
                  autofocus: true,
                  cursorColor: Colors.green,
                  cursorHeight: 30,
                  decoration: InputDecoration(
                    labelText: '    ✔ Name of Product',
                    labelStyle: TextStyle(color: Colors.green),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'invalid name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _productData['title'] = value;
                  },
                ),

                SizedBox(height: 10),

                TextFormField(
                  //price
                  autofocus: true,
                  cursorColor: Colors.green,
                  cursorHeight: 30,
                  decoration: InputDecoration(
                    labelText: '    📦 Price per box',
                    labelStyle: TextStyle(color: Colors.green),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'invalid price';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _productData['price'] = double.parse(value);
                  },
                ),

                SizedBox(height: 10),

                TextFormField(
                  //price
                  autofocus: true,
                  cursorColor: Colors.green,
                  cursorHeight: 30,
                  decoration: InputDecoration(
                    labelText: '    💲 Price per strip',
                    labelStyle: TextStyle(color: Colors.green),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'invalid price';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _productData['price_per_strip'] = double.parse(value);
                  },
                ),

                SizedBox(height: 10),

                TextFormField(
                  //Description
                  autofocus: true,
                  cursorColor: Colors.green,
                  cursorHeight: 30,
                  decoration: InputDecoration(
                    labelText: '    ✍🏿 Enter Description',
                    labelStyle: TextStyle(color: Colors.green),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'invalid description';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.multiline,
                  onSaved: (value) {
                    _productData['description'] = value;
                  },
                ),

                SizedBox(height: 10),

                DropdownButton<String>(
                  focusColor: Colors.white,
                  style: TextStyle(color: Colors.white),
                  iconEnabledColor: Colors.black,
                  value: dropdownValue,
                  items: <String>[
                    'Tablet',
                    'Syrup',
                    'Capsule',
                    'Injections',
                    'others',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(color: Colors.green),
                      ),
                    );
                  }).toList(),
                  underline: Container(
                    height: 1,
                    color: Colors.grey,
                  ),
                  hint: Text(
                    "    📝 Select category",
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 16,
                      // fontWeight: FontWeight.w500,
                    ),
                  ),
                  onChanged: (String value) {
                    setState(
                      () {
                        _productData['category'] = value;
                        dropdownValue = value;
                      },
                    );
                  },
                ),

                SizedBox(height: 10),
                ////////////////////////////////////////Submit///////////////////////////////////////////
                ////////////////////////////////////////Submit///////////////////////////////////////////
                SizedBox(height: 30),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 0),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    border: Border.all(
                      color: Colors.green,
                      width: 0.8,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextButton(
                    onPressed: () {
                      // ignore: unnecessary_statements
                      (_disabledbutton == false) ? _submit() : null;
                      setState(() {
                        _disabledbutton = true;
                      });
                    },
                    child: Text(
                      'Add Product',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openGallery(BuildContext context) async {
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      imageQuality: 40,
    );

    File croppedFile = await ImageCropper.cropImage(
      sourcePath: pickedFile.path,
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: 'Edit image',
        toolbarColor: Colors.green,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: false,
      ),
      iosUiSettings: IOSUiSettings(
        title: 'Edit Image',
      ),
    );

    setState(() {
      imageFile = croppedFile;
    });
    final bytes = File(imageFile.path).readAsBytesSync();

    _productData['image'] = base64Encode(bytes);

    Navigator.pop(context);
  }

  void _openCamera(BuildContext context) async {
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      imageQuality: 40,
    );

    File croppedFile = await ImageCropper.cropImage(
      sourcePath: pickedFile.path,
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: 'Edit image',
        toolbarColor: Colors.green,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: false,
      ),
      iosUiSettings: IOSUiSettings(
        title: 'Edit Image',
      ),
    );

    setState(() {
      imageFile = croppedFile;
    });
    final bytes2 = File(imageFile.path).readAsBytesSync();

    _productData['image'] = base64Encode(bytes2);

    Navigator.pop(context);
  }
}
