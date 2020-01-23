import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:kt_dart/kt.dart';

void main() {
  runApp (new MaterialApp(
    home: new Example(),
  ));
}

class Example extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ExampleState();
}


class _ExampleState extends State<Example> {


  String _mySelection1;
  String _mySelection2;
  String _mySelection3;
  List data1 = List();
  List data2 = List();
  List data3 = List();
  int test;
  String description;
  String tele;
  String loc;
  String mieter;
  var now;

  Future<String> getData() async {




    var response1 = await http.get(
        Uri.encodeFull(
            "http://dev.inform-objektservice.de/hmdinterface/rest/employee/"),
        headers: {

          "Accept": "application/json"
        }
    );

    var response2 = await http.get(
        Uri.encodeFull(
            "http://dev.inform-objektservice.de/hmdinterface/rest/object/"),
        headers: {

          "Accept": "application/json"
        }
    );

    var response3 = await http.get(
        Uri.encodeFull(
            "http://dev.inform-objektservice.de/hmdinterface/rest/object/"),
        headers: {

          "Accept": "application/json"
        }
    );




    this.setState(() {
      data1 = json.decode(response1.body);
      data2 = json.decode(response2.body);
      data3 = json.decode(response3.body);
    });
    print(data1[1][test] + "data1");
    print(data2[1][test] + "data2");
    print(data3[1][test] + "data3");

    print(data3.toSet().toList());

    return "Success!";
  }

  @override
  void initState() {
    super.initState();
    this.getData();
  }


  final TextEditingController myController = TextEditingController();
  final TextEditingController myController1 = TextEditingController();
  final TextEditingController myController2 = TextEditingController();
  final TextEditingController myController3 = TextEditingController();

  @override
  void dispose() {
    myController.dispose();
    myController1.dispose();
    myController2.dispose();
    myController3.dispose();
    super.dispose();
  }

  Future<http.Response> callWeb() async{
    print(description = myController.text);
    now = new DateTime.now().toUtc().millisecondsSinceEpoch / 1000;
    print(now);

    final paramDic = {
      "uid": "",
      "pid": "",
      "crdate": "",
      "tstamp": "",
      "hidden": "",
      "archived": "",
      "sent_on": "",
      "cruser_id": "",
      "description": description = myController.text,
      "deleted": "",
      "object_uid": _mySelection2,
      "employee_uid": _mySelection1,
      "phone": tele = myController1.text,
      "tenant": mieter = myController3.text,
      "location": loc = myController2.text,
      "date": "",
      "images": "",
      "seen": "",
      "update": "",

    };

    final data= await http.post(
      "http://dev.inform-objektservice.de/hmdinterface/rest/damage/",
      body: paramDic,
    );

    print(data.body);

    return data;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Hausmeister App"),
        backgroundColor: const Color(0xFF0099a9),
      ),
      body: Row(children: <Widget>[
        Column(
          children: [
            Container(
              width: 300.0,
              child: DropdownButtonHideUnderline(
                child: ButtonTheme(
                  alignedDropdown: true,
                    child: DropdownButton(
                      value: _mySelection1,
                      hint: Text("Mitarbeiter"),
                      items: data1.map((item) {
                        return new DropdownMenuItem(
                          child: new Text(item['name']),
                          value: item['uid'].toString(),
                        );
                      }).toList(),
                      onChanged: (newVal1) {
                        setState(() {
                          _mySelection1 = newVal1;
                        });
                        print(newVal1);
                      },
                    ),
                ),
              ),
            ),
            Container(
              width: 300.0,
              child: DropdownButtonHideUnderline(
                child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButton(
                    value: _mySelection2,
                    hint: Text("Besitzer"),
                    items: data2.map((item) {
                      return new DropdownMenuItem(
                        child: new Text(item['street']),
                        value: item['uid'].toString(),
                      );
                    }).toList(),
                    onChanged: (newVal2) {
                      setState(() {
                        _mySelection2 = newVal2;
                      });
                      print(newVal2);
                    },
                  ),
                ),
              ),
            ),
            Container(
              width: 300.0,
              child: TextFormField(
                controller: myController1,
                validator: (value) {
                  if (value.isEmpty){
                    return "Please enter some text";
                  }
                  return null;
                },
                decoration: InputDecoration(
                    labelText: "Telefonnummer"
                ),
              ),
            ),
            Container(
              width: 300.0,
              child: TextFormField(
                controller: myController2,
                validator: (value) {
                  if (value.isEmpty){
                    return "Please enter some text";
                  }
                  return null;
                },
                decoration: InputDecoration(
                    labelText: "Ort"
                ),
              ),
            ),
            Container(
              width: 300.0,
              child: TextFormField(
                controller: myController3,
                validator: (value) {
                  if (value.isEmpty){
                    return "Please enter some text";
                  }
                  return null;
                },
                decoration: InputDecoration(
                    labelText: "Mieter"
                ),
              ),
            ),
            Container(
              width: 300.0,
              child: TextFormField(
                controller: myController,
                validator: (value) {
                  if (value.isEmpty){
                    return "Please enter some text";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: "Schadensbericht"
                ),
              ),
            ),
            Container(
              width: 300.0,
              child: RaisedButton(
                onPressed:
                  callWeb,

                child: Text("Abschicken"),

              ),
            ),
          ],
        ),
      ],
      ),
    );



  }


}
