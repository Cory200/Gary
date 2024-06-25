import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:planishor/library/globals.dart' as globals;

class OrderPlaced extends StatefulWidget {
  @override
  _OrderPlacedState createState() => _OrderPlacedState();
}

class _OrderPlacedState extends State<OrderPlaced> {
  double finalAmount = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text('Placed Order'),
        ),
        body: FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance
              .collection(globals.activeUserEmail + '_placed')
              .get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final List<DocumentSnapshot> documents = snapshot.data.docs;
              return Stack(
                children: [
                  ListView(
                    padding: EdgeInsets.only(bottom: 120),
                    children: documents
                        .map(
                          (doc) => Column(
                            children: [
                              Card(
                                child: ListTile(
                                  leading: Image.memory(
                                    base64Decode(doc['cart']['image']),
                                    width: 50,
                                  ),
                                  title: Text(
                                    doc['cart']['title'],
                                    softWrap: true,
                                  ),
                                  subtitle: Text(doc['cart']['category']),
                                  trailing: Text(
                                    'Rs. ' +
                                        doc['cart']['price'].toString() +
                                        ' ✖ ' +
                                        doc['cart']['amount'].toString() +
                                        '\n\n ▶   Rs. ' +
                                        (doc['cart']['price'] *
                                                doc['cart']['amount'])
                                            .toString(),
                                    softWrap: true,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 3),
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
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.green,
                            width: 5.0,
                            style: BorderStyle.solid), //Border.all

                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
                          bottomLeft: Radius.circular(30.0),
                          bottomRight: Radius.circular(30.0),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total'),
                          Text('Rs. ' + finalAmount.toString()),
                        ],
                      ),
                    ),
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
