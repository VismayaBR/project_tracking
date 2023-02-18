import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'add_feedback.dart';
import 'constants.dart';

class Feedbacks extends StatefulWidget {
  const Feedbacks({Key? key}) : super(key: key);

  @override
  State<Feedbacks> createState() => _FeedbacksState();
}

class _FeedbacksState extends State<Feedbacks> {
  Future<dynamic> getData() async {
    var response = await get(Uri.parse('${Con.url}view_feedback.php'));
    print(response.body);
   var res = jsonDecode(response.body);
   return res;

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Feedbacks'),),
      body: FutureBuilder(
        future: getData(),
        builder: (context,snapshot) {
          if(snapshot.hasData){

            return Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(snapshot.data[index]['student']),
                        subtitle: Text(snapshot.data[index]['feedback']),
                      );
                    },

                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: FloatingActionButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return Addfeed();
                        },));
                      },child: Icon(Icons.add),),
                    ),
                  ],
                )
              ],
            );
          }
          else if(snapshot.connectionState==ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(),
            );

          }
          else{
            return Text('No feedbacks');
          }

        }
      ),
    );
  }
}
