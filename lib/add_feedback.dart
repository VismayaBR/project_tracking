import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:project_tracking/feedback.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';

class Addfeed extends StatefulWidget {
  const Addfeed({Key? key}) : super(key: key);

  @override
  State<Addfeed> createState() => _AddfeedState();
}

class _AddfeedState extends State<Addfeed> {
  var feed = TextEditingController();
  Future<dynamic> getData() async {
    SharedPreferences spref = await SharedPreferences.getInstance();
    var sp = spref.getString('s_id');
   var data = {
     "student_id":sp,
      "feedback": feed.text,
    };
   print(data);
    var res = await post(Uri.parse('${Con.url}add_feedback.php'),body:data );
    print(res.body);
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Feedbacks();
    },));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('add your feedback'),),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextFormField(
              controller: feed,
              decoration: InputDecoration(
                  border: OutlineInputBorder()
              ),
            ),
          ),
         ElevatedButton(onPressed: (){
            getData();
         }, child: Text('Add'))
        ],
      ),
    );
  }
}
