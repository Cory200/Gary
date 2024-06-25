import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:planishor/library/globals.dart' as globals;

class AddToCart {
  int amount;

  adding(image, title, price, category, email, type) async {
    var tempobject = new HashMap();
    tempobject['title'] = title;
    tempobject['price'] = price;
    tempobject['category'] = category;
    tempobject['image'] = image;
    tempobject['amount'] = 1;
    tempobject['type'] = type;

    FirebaseFirestore.instance.collection(globals.activeUserEmail).get().then(
      (QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach(
          (doc) {
            if (doc['cart']['title'].toString() == title.toString() &&
                doc['cart']['price'].toString() == price.toString() &&
                doc['cart']['category'].toString() == category.toString() &&
                doc['cart']['type'].toString() == type.toString()) {
              amount = doc['cart']['amount'];
            } else {}
          },
        );
      },
    );

    bool updated = false;

    FirebaseFirestore.instance.collection(email).get().then(
      (querySnapshot) {
        querySnapshot.docs.forEach(
          (doc) {
            if (doc.data()['cart'] != null) {
              if (doc.data()['cart']['title'] == tempobject['title'] &&
                  doc.data()['cart']['price'] == tempobject['price'] &&
                  doc.data()['cart']['category'] == tempobject['category'] &&
                  doc.data()['cart']['type'] == tempobject['type']) {
                amount = doc['cart']['amount'];
                amount++;
                tempobject['amount'] = amount;
                doc.reference.update({"cart": tempobject});
                updated = true;
              } else {}
            } else {}
          },
        );
        if (updated == false) {
          FirebaseFirestore.instance
              .collection(email)
              .add({"cart": tempobject}).then((_) {
            print("cart added");
          }).catchError((_) {
            print("an error occured");
          });
        } else {}
      },
    );
  }

  //Delete from cart

  subtracting(image, title, price, category, email, type) {
    var tempobject = new HashMap();
    tempobject['title'] = title;
    tempobject['price'] = price;
    tempobject['category'] = category;
    tempobject['image'] = image;
    tempobject['type'] = type;

    FirebaseFirestore.instance.collection(email).get().then(
      (QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach(
          (doc) {
            if (doc['cart']['title'].toString() == title.toString() &&
                doc['cart']['price'].toString() == price.toString() &&
                doc['cart']['category'].toString() == category.toString() &&
                doc['cart']['image'].toString() == image.toString() &&
                doc['cart']['type'].toString() == type.toString()) {
              amount = doc['cart']['amount'];
            } else {}
          },
        );
      },
    );

    FirebaseFirestore.instance.collection(email).get().then(
      (querySnapshot) {
        querySnapshot.docs.forEach(
          (doc) {
            if (doc.data()['cart'] != null) {
              if (doc.data()['cart']['title'] == tempobject['title'] &&
                  doc.data()['cart']['price'] == tempobject['price'] &&
                  doc.data()['cart']['category'] == tempobject['category'] &&
                  doc.data()['cart']['image'] == tempobject['image'] &&
                  doc.data()['cart']['type'] == tempobject['type']) {
                amount = doc['cart']['amount'];
                if (amount == 1) {
                  doc.reference.delete();
                } else {
                  amount--;
                  tempobject['amount'] = amount;
                }
                doc.reference.update({"cart": tempobject});
              } else {}
            } else {}
          },
        );
      },
    );
  }

  counting(title) {
    int count = 0;
    String collectionName = globals.activeUserEmail;

    FirebaseFirestore.instance
        .collection(collectionName)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (doc.data()['cart'] != null) {
          if (doc.data()['cart']['title'] == title) {
            count++;
          } else {}
        } else {}
      });
      return count;
    });
  }
}
