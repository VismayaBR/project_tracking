import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'constants.dart';
import 'login.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  var name = TextEditingController();
  var email = TextEditingController();
  var mobile = TextEditingController();
  var place = TextEditingController();
  var username = TextEditingController();
  var password = TextEditingController();

  Future<void> getData() async {
    var data = {
      "name":name.text,
      "email":email.text,
      "mobile":mobile.text,
      "place":place.text,
      "username":username.text,
      "password":password.text,

    };
    var response = await post(Uri.parse('${Con.url}student.php'),body: data);
    print(response.body);
    if(response.statusCode==200){
       var res = jsonDecode(response.body)["message"];
       if(res=='Added'){
         Fluttertoast.showToast(msg: 'Successfully Registered...');
         Navigator.push(context, MaterialPageRoute(
           builder: (context) {
             return Login();
           },
         ));
       }

    }
    else {
      Fluttertoast.showToast(msg: 'Something went wrong!');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Center(
                  child: Text(
                'Register',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              )),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                controller: name,
                decoration: InputDecoration(border: OutlineInputBorder(),
                hintText: 'name',
                  labelText: 'Enter your name',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                controller: email,
                decoration: InputDecoration(border: OutlineInputBorder(),
                  hintText: 'email',
                  labelText: 'Enter your email',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                controller: mobile,
                decoration: InputDecoration(border: OutlineInputBorder(),
                  hintText: 'mobile',
                  labelText: 'Enter your mobile',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                controller: place,
                decoration: InputDecoration(border: OutlineInputBorder(),
                  hintText: 'place',
                  labelText: 'Enter your place',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                controller: username,
                decoration: InputDecoration(border: OutlineInputBorder(),
                  hintText: 'username',
                  labelText: 'Enter your username',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                controller: password,
                decoration: InputDecoration(border: OutlineInputBorder(),
                  hintText: 'Password',
                  labelText: 'Enter your password',
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                getData();
              },
              child: Container(
                width: 50,
                height: 40,
                child: Center(
                  child: Text(
                    'Register',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                decoration: BoxDecoration(
                    color: Colors.blue, borderRadius: BorderRadius.circular(50)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
