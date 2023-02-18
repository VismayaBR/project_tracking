import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';

class Review extends StatefulWidget {
  const Review({Key? key}) : super(key: key);

  @override
  State<Review> createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  Future<dynamic> getData() async {
    SharedPreferences spref = await SharedPreferences.getInstance();
    var sp = spref.getString('s_id');
    var data={
      "id":sp
    };
    print(data);
    var res = await post(Uri.parse('${Con.url}view-date.php'),body:data );
    print(res.body);
    return jsonDecode(res.body);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: getData(),
        builder: (context,snapshot) {
          if(!snapshot.hasData){
            return Center(child: const CircularProgressIndicator());
          }
          else if(snapshot .data[0]['message']=='failed') {
            return Center(child: Text('No Project added'));
          }
          else{
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset('assets/images/date.json',height: 150,width: 400),
                Card(elevation:3,
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Text(snapshot.data[0]['date'],style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.blueAccent),),
                    )),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Text('Note : ',style: TextStyle(fontWeight: FontWeight.bold),),
                      ),
                      Container(
                        child: Text(' *    ',style: TextStyle(color: Colors.red),),
                      ),
                      Container(
                        child: Text(snapshot.data[0]['note']),
                      )
                    ],
                  ),
                ),

              ],
            );
          }

        }
      ),
    );
  }
}
