import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:planishor/screens/confirmation.dart';
import 'package:planishor/screens/mylocation.dart';
import 'package:planishor/library/globals.dart' as globals;
import 'package:planishor/widgets/spinner.dart';

class Address extends StatefulWidget {
  @override
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<Address> {
  String name = '';
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool flag = false;

  Map<String, String> _authData = {
    'phoneNumber': '',
    'pin': '',
    'state': '',
    'city': '',
    'houseNumber': '',
    'colony': '',
    'landmark': ''
  };

  getLocalLocation() async {
    if (FirebaseFirestore.instance
            .collection(globals.activeUserEmail + '_data')
            .doc('address') !=
        null) {
      await FirebaseFirestore.instance
          .collection(globals.activeUserEmail + '_data')
          .doc('address')
          .get()
          .then((value) {
        // print(value.data()['address']['pin']);
        setState(() {
          flag = true;
        });
        setState(() {
          _authData['pin'] = value.data()['address']['pin'];
          _authData['state'] = value.data()['address']['state'];
          _authData['city'] = value.data()['address']['city'];
          _authData['houseNumber'] = value.data()['address']['houseNumber'];
          _authData['colony'] = value.data()['address']['colony'];
          _authData['landmark'] = value.data()['address']['landmark'];
          _authData['phoneNumber'] = value.data()['address']['phoneNumber'];
        });
      });
    } else {}
    setState(() {
      flag = true;
    });
    flag = true;
    print(_authData);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();

    await FirebaseFirestore.instance
        .collection(globals.activeUserEmail + '_data')
        .doc('address')
        .set({
      'address': _authData,
    }).then(
      (value) => {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Spinner({
              Future.delayed(
                const Duration(milliseconds: 1000),
                () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Confirmation(),
                    ),
                  );
                },
              ),
            }),
          ),
        ),
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getLocalLocation();
  }

  @override
  Widget build(BuildContext context) {
    // getLocalLocation();
    return SafeArea(
      child: Scaffold(
        // resizeToAvoidBottomInset: false, // this avoids the overflow error
        /////////////////////////////////AppBar/////////////////////////////////////////////
        /////////////////////////////////AppBar/////////////////////////////////////////////
        appBar: AppBar(
          title: Text('Address'),
          backgroundColor: Colors.green,
          leading: Icon(Icons.pin_drop),
          actions: [
            IconButton(
              icon: Icon(Icons.my_location),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyLocation(_authData)),
                );
              },
            )
          ],
        ),

        body: (flag == false)
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      /////////////////////////////////Input Fields/////////////////////////////////////////////
                      /////////////////////////////////Input Fields/////////////////////////////////////////////
                      SizedBox(height: 20),

                      TextFormField(
                        //Phone
                        initialValue: _authData['phoneNumber'].toString(),
                        autofocus: true,
                        cursorColor: Colors.green,
                        cursorHeight: 30,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.call,
                            color: Colors.grey,
                          ),
                          labelText: 'Enter Phone Number',
                          labelStyle: TextStyle(color: Colors.green),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.green),
                          ),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value.isEmpty || value.length != 10) {
                            return 'invalid phone number';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _authData['phoneNumber'] = value;
                        },
                      ),

                      SizedBox(height: 10),

                      TextFormField(
                        //Pin code
                        initialValue: _authData['pin'].toString(),
                        autofocus: true,
                        cursorColor: Colors.green,
                        cursorHeight: 30,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.circle,
                            color: Colors.grey,
                          ),
                          labelText: 'Enter Pincode',
                          labelStyle: TextStyle(color: Colors.green),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.green),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value.isEmpty || value.length != 6) {
                            return 'invalid pincode';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _authData['pin'] = value;
                        },
                      ),

                      SizedBox(height: 10),

                      TextFormField(
                        //State
                        initialValue: _authData['state'],
                        autofocus: true,
                        cursorColor: Colors.green,
                        cursorHeight: 30,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.map,
                            color: Colors.grey,
                          ),
                          labelText: 'Enter State',
                          labelStyle: TextStyle(color: Colors.green),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.green),
                          ),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'invalid state';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          _authData['state'] = value;
                        },
                      ),

                      SizedBox(height: 10),

                      TextFormField(
                        //City
                        initialValue: _authData['city'],
                        autofocus: true,
                        cursorColor: Colors.green,
                        cursorHeight: 30,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.location_city,
                            color: Colors.grey,
                          ),
                          labelText: 'Enter City',
                          labelStyle: TextStyle(color: Colors.green),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.green),
                          ),
                        ),
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'invalid city';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _authData['city'] = value;
                        },
                      ),

                      SizedBox(height: 10),

                      TextFormField(
                        //House Number
                        initialValue: _authData['houseNumber'],
                        autofocus: true,
                        cursorColor: Colors.green,
                        cursorHeight: 30,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.house,
                            color: Colors.grey,
                          ),
                          labelText: 'Enter House no.,Building no.',
                          labelStyle: TextStyle(color: Colors.green),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.green),
                          ),
                        ),
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'invalid city';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _authData['houseNumber'] = value;
                        },
                      ),

                      SizedBox(height: 10),

                      TextFormField(
                        //Colony
                        initialValue: _authData['colony'],
                        autofocus: true,
                        cursorColor: Colors.green,
                        cursorHeight: 30,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.add_road,
                            color: Colors.grey,
                          ),
                          labelText: 'Enter Colony, Road, Area',
                          labelStyle: TextStyle(color: Colors.green),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.green),
                          ),
                        ),
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'invalid name';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _authData['colony'] = value;
                        },
                      ),

                      SizedBox(height: 10),

                      TextFormField(
                        //Landmark
                        initialValue: _authData['landmark'],
                        autofocus: true,
                        cursorColor: Colors.green,
                        cursorHeight: 30,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.pin_drop_sharp,
                            color: Colors.grey,
                          ),
                          labelText: 'Enter Landmark',
                          labelStyle: TextStyle(color: Colors.green),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.green),
                          ),
                        ),
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'invalid landmark';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _authData['landmark'] = value;
                        },
                      ),

                      SizedBox(height: 50),

                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 0),
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
                            _submit();
                          },
                          child: Text(
                            'Place order',
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
}
