import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project_tracking/dialogue.dart';
import 'package:project_tracking/review.dart';
import 'package:project_tracking/view.dart';

import 'constants.dart';

class Project extends StatefulWidget {
   Project({Key? key,required this.id}) : super(key: key);
   String id;
  @override
  State<Project> createState() => _ProjectState();
}

class _ProjectState extends State<Project> {
  Future<dynamic> getData() async {
    var data={
      "id":widget.id,
    };
    var response =await post(Uri.parse('${Con.url}view_project.php'),body: data);
    // print(response.body);
    var res = jsonDecode(response.body) ;
    print(res);
    return res;

  }




bool downloading = false;
String progressString = '';
Future<bool>getStoragePermission()async{
  return await Permission.storage.request().isGranted;
}

Future<String>getDownloadFolderPath()async{
  return await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
}

Future downloadFile(String downloadDirectory)async{
  Dio dio = Dio();
  var downloadedImagePath = '$downloadDirectory/abc.jpg';
  try{
    await dio.download(pdf, downloadedImagePath,onReceiveProgress: (rec,total){
      print("REC : $rec , TOTAL : $total");
      setState(() {
        downloading = true;
        progressString = ((rec/total)*100).toStringAsFixed(0)+"%";
      });
    });
  }
  catch(e){
    print(e);
  }
  await Future.delayed(const Duration(seconds: 2));
  return downloadedImagePath;
}
Future<void>doDownloadFile()async{
  if(await getStoragePermission()){
    String downloadDirectory = await getDownloadFolderPath();
    await downloadFile(downloadDirectory).then((imagePath) {
      displayImage(imagePath);
    });
  }
}
void displayImage(String downloadDirectory){
  setState(() {
    downloading = false;
    progressString = 'COMPLETED';
    // downloadedImagePath = downloadDirectory;

  });
}




  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(),
      body:
      // downloading?
      //     Center(
      //       child: SizedBox(
      //         height: 120,
      //         width: 200,
      //         child: Card(
      //           color: Colors.black,
      //           child: Column(
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             children: [
      //               const CircularProgressIndicator(),
      //               const SizedBox(
      //                 height: 20,
      //
      //               ),
      //               Text('downloading $progressString',style:TextStyle(
      //                 color:Colors.white,
      //               )
      //               ),
      //
      //             ],
      //           ),
      //         ),
      //       ),
      //     ):

              FutureBuilder(
                future: getData(),
                builder: (context,snap) {
                  if(!snap.hasData){
                    return Center(child: const CircularProgressIndicator());
                  }
                  else if(snap .data[0]['message']=='failed') {
                    return Center(child: Text('No Project added'));
                  }
                  else{


                    return Column(

                      children: [
                        SizedBox(height: 20,),
                        ElevatedButton(onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return Review();
                          },));
                        }, child: Text('Coming Review date')),

                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Container(width: double.infinity,color: Colors.lightBlue,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text(snap.data![0]['topic'],style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: SingleChildScrollView(
                              child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: Text(snap.data[0]['about']),
                                ),
                                height: 500,
                                width: double.infinity,
                                color: Colors.white,

                              ),
                            ),
                          ),
                        ),
                        // const Text('Align Button to the Bottom in Flutter'),
                        Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: FloatingActionButton(
                                // onPressed: ()=>doDownloadFile(), child: const Icon(Icons.file_copy),
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                    return View();
                                  },));
                                }, child: const Icon(Icons.file_copy),
                              ),
                            )),

                      ],
                    );
                  }

                }
              ),
      // Column(
      //   children: [
      //     Padding(
      //       padding: const EdgeInsets.all(18.0),
      //       child: Container(width: double.infinity,color: Colors.lightBlue,
      //       child: Padding(
      //         padding: const EdgeInsets.all(20.0),
      //         child: Text('topic',style: TextStyle(
      //           fontWeight: FontWeight.bold,
      //           fontSize: 18,
      //         ),),
      //       ),
      //       ),
      //     ),
      //     Expanded(
      //       child: Padding(
      //         padding: const EdgeInsets.all(18.0),
      //         child: SingleChildScrollView(
      //           child: Container(
      //             child: Padding(
      //               padding: const EdgeInsets.all(18.0),
      //               child: Text(' Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leapLorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambledLorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled  into Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum'),
      //             ),
      //             height: 500,
      //             width: double.infinity,
      //             color: Colors.white,
      //
      //           ),
      //         ),
      //       ),
      //     ),
      //     // const Text('Align Button to the Bottom in Flutter'),
      //     Align(
      //         alignment: Alignment.bottomRight,
      //         child: Padding(
      //           padding: const EdgeInsets.all(20.0),
      //           child: FloatingActionButton(
      //               onPressed: (){
      //                 showDialog(context: context, builder: (context)=>const Downloading());
      //               }, child: const Icon(Icons.download),
      //           ),
      //         )),
      //
      //   ],
      // ),
    );

  }
}
