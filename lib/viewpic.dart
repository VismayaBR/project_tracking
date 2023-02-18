import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'constants.dart';

class ViewPic extends StatefulWidget {
   ViewPic({Key? key, required this.id}) : super(key: key);
String id;
  @override
  State<ViewPic> createState() => _ViewPicState();
}

class _ViewPicState extends State<ViewPic> {
  Future<dynamic> getData() async {
    print('object');
    var data={
      "id":widget.id,
    };
    var res = await post(Uri.parse('${Con.url}pic.php'),body: data);

    print(res.body);
    var r = jsonDecode(res.body);
    return r;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
body: FutureBuilder(
  future: getData(),
  builder: (context,snap) {
    if(snap.hasData){

      return     Container(

        height: double.infinity,

        width: double.infinity,

        color: Colors.black,

        child: Image.asset('assets/images/${snap.data![0]['file']}'),



      );
    }
    else{
      return Text('no data');
    }
  }
),
    );
  }
}
