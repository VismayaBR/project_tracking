import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'constants.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  Future<dynamic> getData() async {
    var response = await get(Uri.parse('${Con.url}view_notification.php'));
    var res = jsonDecode(response.body);
    print(res);
    return res;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(

        future: getData(),
        builder: (context,snapshot) {
          if(snapshot.hasData){
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data![index]['title']),
                  subtitle: Text(snapshot.data![index]['content']),
                  // trailing: Text('date'),
                );
              },

            );
          }
          else if(snapshot.connectionState==ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          }
          else{
            return Center(child: Text('No Notifications'));
          }

        }
      ),
    );
  }
}
