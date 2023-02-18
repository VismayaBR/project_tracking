import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:project_tracking/bottomnavigation.dart';
import 'package:project_tracking/home.dart';
import 'package:project_tracking/register.dart';
import 'package:lottie/lottie.dart';
import 'package:project_tracking/review.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';
import 'coo_home.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var username = TextEditingController();
  var password = TextEditingController();
  Future<void> getData() async {
    var data = {
      "username":username.text,

      "password":password.text,
    };

   var response = await post(Uri.parse('${Con.url}login.php'),body: data);
   var res = jsonDecode(response.body);
   print(res);

   if(response.statusCode==200){
     if(res['message']=='User Successfully LoggedIn'){
       var id = res["login_id"];

       final spref = await SharedPreferences.getInstance();
       spref.setString('s_id', id);
       spref.setString('type', 'student');

       if(res['type']=='student'){
         Fluttertoast.showToast(msg: 'Successfully Login...');
         Navigator.push(context, MaterialPageRoute(
           builder: (context) {
             return Home();
           },
         ));
       }
       if(res['type']=='group'){
         Fluttertoast.showToast(msg: 'Successfully Login...');
         Navigator.push(context, MaterialPageRoute(
           builder: (context) {
             return MyNavigationBar();
           },
         ));
       }

     }
     else{
       Fluttertoast.showToast(msg: 'Invalid username or password');

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
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset('assets/images/login.json'),
                TextFormField(
                  controller: username,
                  decoration: InputDecoration(border: OutlineInputBorder()),
                ),
                SizedBox(
                  height: 25,
                ),
                TextFormField(
                  controller: password,
                  decoration: InputDecoration(border: OutlineInputBorder()),
                ),
                SizedBox(
                  height: 25,
                ),
                InkWell(
                  onTap: () {
                    getData();
                  },
                  child: Container(
                    height: 50,
                    width: 150,
                    child: Center(
                        child: Text(
                      'LOGIN',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(50)),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return Register();
                        },
                      ));
                    },
                    child: Container(child: Text('create new account?'))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
