import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:planishor/widgets/fileuploadbutton.dart';

class ThirdPartyManufacturing extends StatefulWidget {
  @override
  _ThirdPartyManufacturingState createState() =>
      _ThirdPartyManufacturingState();
}

class _ThirdPartyManufacturingState extends State<ThirdPartyManufacturing> {
  bool flag = false;
  Map<String, bool> _uploadStatus = {
    'Tablets': false,
    'Syrups': false,
    'Capsules': false,
    'Injections': false
  };

  Future<void> fileUploadCheck(fileName) async {
    try {
      await FirebaseFirestore.instance
          .collection('thirdPartyPDF')
          .doc(fileName.toString())
          .get()
          .then((value) {
        setState(() {
          flag = true;
          _uploadStatus[fileName] = value.data()['added'];
        });
      });
    } catch (e) {
      setState(() {
        flag = true;
        return;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fileUploadCheck('Tablets');
    fileUploadCheck('Syrups');
    fileUploadCheck('Capsules');
    fileUploadCheck('Injections');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text('Third Party Manufacturing'),
        ),
        body: (flag == false)
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                    children: [
                      Table(
                        children: [
                          TableRow(
                            children: [
                              FileUploadButton(
                                  'Tablets', _uploadStatus['Tablets']),
                              FileUploadButton(
                                  'Syrups', _uploadStatus['Syrups']),
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 10),
                      Table(
                        children: [
                          TableRow(
                            children: [
                              FileUploadButton(
                                  'Capsules', _uploadStatus['Capsules']),
                              FileUploadButton(
                                  'Injections', _uploadStatus['Injections']),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
