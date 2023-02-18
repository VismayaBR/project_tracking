import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:project_tracking/down.dart';
import 'package:project_tracking/viewpic.dart';
import 'package:url_launcher/url_launcher.dart';

import 'constants.dart';


class View extends StatefulWidget {
  const View({Key? key}) : super(key: key);

  @override
  State<View> createState() => _ViewState();
}

class _ViewState extends State<View> {
  var pic='';
  Future<dynamic> getData() async {
    var res = await get(Uri.parse('${Con.url}view_images.php'));

    print(res.body);
    var r = jsonDecode(res.body);
    // var pic = r['file'];
    // print('                            $pic');
    return r;
  }


   Uri _url = Uri.parse('http://192.168.1.131/Project_tracking/images/');
  
  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: FutureBuilder(
          future: getData(),
          builder: (context,snap) {

            if(snap.hasData){

             return ListView.builder(
                itemCount: snap.data.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Container(
                      height: 100,
                      width: 100,
                      color: Colors.white,
                      child: Image.asset('assets/images/${snap.data![index]['file']}'),
                    ),
                    trailing: InkWell(
                      onTap: (){
                       Navigator.push(context, MaterialPageRoute(builder: (context) {
                         return ViewPic(id: snap.data![index]['u_id']);
                       },));
                      },
                        child: Icon(Icons.remove_red_eye)),
                  );
                },

              );
            }
            else if(snap.connectionState==ConnectionState.waiting){
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
