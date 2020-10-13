import 'package:flutter/material.dart';
import 'package:barcode_app2/scan.dart';
import 'file_utils.dart';



class MyTextInput extends StatefulWidget {
  @override
  MyTextInputState  createState() => MyTextInputState();
}

class MyTextInputState extends State<MyTextInput> {

  String fileContents="";
  final TextEditingController controller = new TextEditingController();
  String resultInput = "";

  void getting() {
    FileUtils.readFromFile().then((contents){

      setState(() {
        resultInput=contents;
        controller.text = contents;
      });

      ScanScreen(api:resultInput);

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getting();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: new AppBar(
        title: new Text("API Input"),
        backgroundColor: Colors.deepOrange,
      ),

      body: new Container(

        child: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              new Text(
                "Enter Your New API",
                style: TextStyle(fontSize: 40.0,decorationStyle: TextDecorationStyle.solid,fontWeight: FontWeight.bold,),
              ),



              new SizedBox(
                height: 100,
              ),

              new TextField(


                decoration: new InputDecoration(
                  hintText: "Enter An API  If You Don't Have An Existing One",

                ),
                onSubmitted: (str) {

                  setState(() {
                    resultInput=str;
                  });
                  controller.text = " ";
                },
                controller: controller,


              ),
              //new Text(resultInput),

              /*new RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                color: Colors.deepOrange,
                child: new Text("GO",style: TextStyle(fontSize: 20.0)),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ScanScreen(api:resultInput),
                    ),
                  );
                }
              ),*/

              new RaisedButton(

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  color: Colors.deepOrange,
                  child: new Text("Save",style: TextStyle(fontSize: 20.0)),
                  onPressed: () {
                    FileUtils.saveToFile(controller.text);
                  }
              ),

              new RaisedButton(

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                color: Colors.deepOrange,
                child: new Text("Get",style: TextStyle(fontSize: 20.0)),
                onPressed: getting,
              )
            ],
          ),
        ),
      ),
    );
  }
}