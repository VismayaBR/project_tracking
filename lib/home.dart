import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:project_tracking/feedback.dart';
import 'package:project_tracking/login.dart';
import 'package:project_tracking/project_view.dart';

import 'constants.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<dynamic> getData() async {
    var res = await get(Uri.parse('${Con.url}project_list.php'));
    print(res.body);
    return jsonDecode(res.body);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Feedbacks();
                },));
              },
                child: Icon(Icons.feedback)),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: InkWell(
                onTap:() {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                   return Login();
                  },));
                },
                child: Icon(Icons.logout)),
          )
        ],
      ),
      body: FutureBuilder(
        future: getData(),
        builder: (context,snapshot) {
          if(!snapshot.hasData){
              return Center(child: const CircularProgressIndicator());
          }
          else if(snapshot.data[0]['message']=='failed') {
            return Center(child: Text('No Project added'));
          }
          else{

            return ListView.separated(
              separatorBuilder: (context, index) {
                return Divider();
              },

              itemCount: snapshot.data.length,

              itemBuilder: (context, index) {

                return  ListTile(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return Project(id: snapshot.data![index]['id']);
                    },));
                  },
                  title: Text(snapshot.data![index]['topic']),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(snapshot.data![index]['about']),
                  ),
                  trailing: Text(snapshot.data![index]['date']),
                );
              },

            );
          }

        }
      ),
    );
  }
}
