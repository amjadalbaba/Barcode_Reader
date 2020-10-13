import 'dart:async';
import 'file_utils.dart';
import 'dart:convert';
import 'package:barcode_app2/Input.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class Product {
  final String barcode;
  final String name;
  final String price;

  Product({this.barcode, this.name,this.price});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      barcode: json["Barcode"],
      name: json["Name"],
      price: json['Price'],
    );
  }
}

class ScanScreen extends StatefulWidget {

  String api;
  ScanScreen({Key key,@required this.api}) : super(key:key);
  @override
  _ScanState createState() => new _ScanState(api);
}

class _ScanState extends State<ScanScreen> {
  String barcode = "";
  //String api="http://opentech.me/stock/pos/api_product.php?Barcode=";
  Future<Product> fProduct;
  String apiVal="";
  String apiVal1="";
  String resultInput="";
  _ScanState(this.apiVal);

  void getting() {
    FileUtils.readFromFile().then((contents){

      setState(() {
        resultInput=contents;
      });



    });
  }

  @override
  void initState() {
    super.initState();
    getting();
    //MyTextInput();
    //MyTextInputState t = new MyTextInputState();
    //t.getting();
  }

  @override

  @override
  void dispose() {
    super.dispose();
  }

  Future<Product> getData() async {

    final response = await http.get(
        Uri.encodeFull(
            resultInput + barcode),
        headers: {"Accept": "application/json"});

    print('getData() reponse:  ' + response.body);

    return Product.fromJson(json.decode(response.body));


  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      //print('Rabih Scan:' + barcode);
      print(apiVal);
      setState(() {
        this.barcode = barcode;
        //this.apiVal=apiVal;

        fProduct = getData();
      });

    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'Camera permission not granted';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {



    return Scaffold(
      appBar: AppBar(
        title: new Text('Code Scanner'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(

                  builder: (context) => MyTextInput(),
                ),
                );


              },
          )
        ],
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  color: Colors.pink,
                  textColor: Colors.white,
                  splashColor: Colors.grey,
                  onPressed: scan,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.settings_overscan,
                        size: 60,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        children: <Widget>[
                          Text(
                            "Camera Scan",
                            style: TextStyle(fontSize: 20.0),
                          ),
                          /* SizedBox(height: 2,),
            Text("Click here for camera Scan"),*/
                        ],
                      )
                    ],
                  )),
            ),
           /* Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.delete,
                      size: 60,
                    ),
                  ],
                ),
              ),
            ),*/
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: FutureBuilder<Product>(
                future: fProduct,
                builder: (context, snapshot) {
                          if (snapshot.hasData) {
                         if (snapshot.data != null) {
                            return Container(

                                height: 320,
                                padding:  const EdgeInsets.all(10.0),

                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(20),

                                ),

                              child:Center(
                                child:Text('Barcode: ' +
                                    snapshot.data.barcode +
                                    '\n\nName: ' +
                                    snapshot.data.name + '\n\n Price: ' + snapshot.data.price,
                                    textScaleFactor: 2.0,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                              ),
                            );
            } } else if (snapshot.hasError) {
                            //return Text("${snapshot.error}");
                            return Container(

                              height: 120,
                              padding:  const EdgeInsets.all(10.0),

                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(20),

                              ),
                              child: Center(

                                 child:Text("Not Valid!",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),textScaleFactor: 2.0,),

                              ),);
                          }

                  return Container(height: 0,width: 0,);


                },
              ),

            )
          ],
        ),
      ),
    );
  }
}
