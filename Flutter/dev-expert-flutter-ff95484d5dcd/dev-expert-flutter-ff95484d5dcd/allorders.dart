import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:planishor/screens/addproductpage.dart';
import 'package:planishor/services/addtoplacedorder.dart';
import 'package:planishor/widgets/spinner.dart';

// ignore: must_be_immutable
class AllOrders extends StatefulWidget {
  String email;

  AllOrders(this.email);
  @override
  _AllOrdersState createState() => _AllOrdersState();
}

class _AllOrdersState extends State<AllOrders> {
  bool flag = false;
  double finalAmount = 0;
  String name = '';
  String email = '';
  String phoneNumber = '';
  Map address = {
    'houseNumber': '',
    'city': '',
    'colony': '',
    'landmark': '',
    'state': '',
    'pin': '',
  };

  Future<void> onLoad() async {
    await FirebaseFirestore.instance
        .collection(widget.email + '_data')
        .doc('data')
        .get()
        .then(
          (value) => {
            setState(
              () {
                name = value['name'];
              },
            ),
          },
        );

    await FirebaseFirestore.instance
        .collection(widget.email + '_data')
        .doc('address')
        .get()
        .then(
          (value) => {
            setState(
              () {
                flag = true;
                email = widget.email;
                phoneNumber = value['address']['phoneNumber'];
                address['houseNumber'] = value['address']['houseNumber'];
                address['city'] = value['address']['city'];
                address['colony'] = value['address']['colony'];
                address['landmark'] = value['address']['landmark'];
                address['state'] = value['address']['state'];
                address['pin'] = value['address']['pin'];
              },
            ),
          },
        );
  }

  _itemsDelivered() async {
    var now = new DateTime.now();
    var order = [];
    await FirebaseFirestore.instance
        .collection(widget.email + '_placed')
        .get()
        .then(
          (data) => {
            data.docs.forEach(
              (doc) => {
                order.add(
                  doc.data(),
                ),
              },
            ),
            FirebaseFirestore.instance
                .collection('items_delivered')
                .doc(widget.email + ' Delivered at - ' + now.toString())
                .set({
              'name': name,
              'email': email,
              'phonenumber': phoneNumber,
              'address': address,
              'order': order,
            }).then(
              (value) => {
                FirebaseFirestore.instance
                    .collection(widget.email + '_placed')
                    .get()
                    .then(
                      (value) => {
                        for (DocumentSnapshot ds in value.docs)
                          {
                            ds.reference.delete(),
                          }
                      },
                    ),
                FirebaseFirestore.instance
                    .collection('placedOrders')
                    .get()
                    .then(
                      (value) => {
                        for (DocumentSnapshot ds in value.docs)
                          {
                            if (ds['email'] == widget.email)
                              {ds.reference.delete()}
                          }
                      },
                    ),
              },
            ),
          },
        );
  }

  @override
  void initState() {
    super.initState();
    onLoad();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text(widget.email),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddProductsPage(widget.email),
                    ),
                  );
                },
                child: Icon(Icons.add),
              ),
            )
          ],
        ),
        body: (flag == false)
            ? Center(
                child: CircularProgressIndicator(),
              )
            : FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection(widget.email + '_placed')
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final List<DocumentSnapshot> documents = snapshot.data.docs;
                    return Stack(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 1,
                                // height:
                                //     MediaQuery.of(context).size.height * 0.4,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                margin: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.black26,
                                  border: Border.all(),
                                ),
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.person,
                                            size: 30,
                                            color: Colors.green,
                                          ),
                                          SizedBox(width: 2),
                                          Text(
                                            name,
                                            style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.symmetric(vertical: 3),
                                      width:
                                          MediaQuery.of(context).size.width * 1,
                                      height: 1,
                                      color: Colors.black,
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.phone,
                                          size: 30,
                                          color: Colors.green,
                                        ),
                                        SizedBox(width: 2),
                                        Text(
                                          phoneNumber,
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin: EdgeInsets.symmetric(vertical: 3),
                                      width:
                                          MediaQuery.of(context).size.width * 1,
                                      height: 1,
                                      color: Colors.black,
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.email,
                                          size: 30,
                                          color: Colors.green,
                                        ),
                                        SizedBox(width: 2),
                                        Text(
                                          email,
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin: EdgeInsets.symmetric(vertical: 3),
                                      width:
                                          MediaQuery.of(context).size.width * 1,
                                      height: 1,
                                      color: Colors.black,
                                    ),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.house,
                                            size: 30,
                                            color: Colors.green,
                                          ),
                                          SizedBox(width: 2),
                                          Text(
                                            address['houseNumber'].toString() +
                                                ', ' +
                                                address['colony'].toString() +
                                                ' ,\n' +
                                                address['city'].toString() +
                                                ' ,' +
                                                address['state'].toString() +
                                                ' ,\n' +
                                                address['landmark'].toString() +
                                                ' ,\n' +
                                                address['pin'].toString(),
                                            style: TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.symmetric(vertical: 3),
                                      width:
                                          MediaQuery.of(context).size.width * 1,
                                      height: 1,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 5),
                                child: Text(
                                  'ORDERS',
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        ListView(
                          padding: EdgeInsets.symmetric(vertical: 300),
                          children: documents
                              .map(
                                (doc) => Column(
                                  children: [
                                    Card(
                                      child: Column(
                                        children: [
                                          ListTile(
                                            leading: Image.memory(
                                              base64Decode(
                                                  doc['cart']['image']),
                                              width: 50,
                                            ),
                                            title: Text(
                                              doc['cart']['title'],
                                              softWrap: true,
                                            ),
                                            subtitle:
                                                Text(doc['cart']['category']),
                                            trailing: Text(
                                              'Rs. ' +
                                                  doc['cart']['price']
                                                      .toString() +
                                                  ' ✖ ' +
                                                  doc['cart']['amount']
                                                      .toString() +
                                                  '\n\n ▶   Rs. ' +
                                                  (doc['cart']['price'] *
                                                          doc['cart']['amount'])
                                                      .toString(),
                                              softWrap: true,
                                            ),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 3),
                                          ),
                                          Align(
                                            alignment: Alignment.center,
                                            child: Container(
                                              height: 30,
                                              width: 130,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.black12,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Row(
                                                children: [
                                                  OutlinedButton(
                                                    onPressed: () {
                                                      setState(
                                                        () {
                                                          AddToPlacedOrder()
                                                              .subtracting(
                                                            doc['cart']
                                                                ['image'],
                                                            doc['cart']
                                                                ['title'],
                                                            doc['cart']
                                                                ['price'],
                                                            doc['cart']
                                                                ['category'],
                                                            widget.email,
                                                          );
                                                        },
                                                      );
                                                      Future.delayed(
                                                          const Duration(
                                                              milliseconds:
                                                                  1000), () {
                                                        Navigator.pop(context);
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                AllOrders(widget
                                                                    .email),
                                                          ),
                                                        );
                                                      });
                                                    },
                                                    child: Text(
                                                      '➖',
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                  OutlinedButton(
                                                    onPressed: () {
                                                      setState(
                                                        () {
                                                          AddToPlacedOrder()
                                                              .adding(
                                                            doc['cart']
                                                                ['image'],
                                                            doc['cart']
                                                                ['title'],
                                                            doc['cart']
                                                                ['price'],
                                                            doc['cart']
                                                                ['category'],
                                                            widget.email,
                                                          );
                                                        },
                                                      );
                                                      Future.delayed(
                                                          const Duration(
                                                              milliseconds:
                                                                  1000), () {
                                                        Navigator.pop(context);
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                AllOrders(widget
                                                                    .email),
                                                          ),
                                                        );
                                                      });
                                                    },
                                                    child: Text(
                                                      '➕',
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      child: sumAmount(
                                        doc['cart']['price'],
                                        doc['cart']['amount'],
                                      ),
                                    )
                                  ],
                                ),
                              )
                              .toList(),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // ignore: deprecated_member_use
                            FlatButton.icon(
                              color: Colors.green,
                              padding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 50),
                              textColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.white),
                              ),
                              onPressed: () {
                                // print('inside function');
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    content: Text('Is this order delivered ?'),
                                    actions: <Widget>[
                                      // ignore: deprecated_member_use
                                      FlatButton(
                                        child: Text('No'),
                                        onPressed: () {
                                          Navigator.of(ctx).pop();
                                        },
                                      ),
                                      // ignore: deprecated_member_use
                                      FlatButton(
                                        child: Text('Yes'),
                                        onPressed: () {
                                          _itemsDelivered();
                                          Navigator.pop(context);
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Spinner({
                                                Future.delayed(
                                                  const Duration(
                                                      milliseconds: 1000),
                                                  () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              }),
                                            ),
                                          );
                                        },
                                      )
                                    ],
                                  ),
                                );
                                // _itemsDelivered();
                              },
                              icon: Icon(Icons.thumb_up),
                              label: Text('Delivered'),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 20),
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.green,
                                    width: 2.0,
                                    style: BorderStyle.solid), //Border.all

                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10.0),
                                  topRight: Radius.circular(10.0),
                                  bottomLeft: Radius.circular(10.0),
                                  bottomRight: Radius.circular(10.0),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black,
                                    offset: const Offset(
                                      5.0,
                                      5.0,
                                    ),
                                    blurRadius: 10.0,
                                    spreadRadius: 2.0,
                                  ), //BoxShadow
                                  BoxShadow(
                                    color: Colors.white,
                                    offset: const Offset(0.0, 0.0),
                                    blurRadius: 0.0,
                                    spreadRadius: 0.0,
                                  ), //BoxShadow
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Total'),
                                  Text(finalAmount.toString()),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  } else {
                    return Text(" ");
                  }
                },
              ),
      ),
    );
  }

  sumAmount(price, amount) {
    finalAmount = finalAmount + (price * amount);
    // return finalAmount;
  }
}
