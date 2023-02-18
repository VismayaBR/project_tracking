import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:project_tracking/project_view.dart';

import 'constants.dart';

class Coo extends StatefulWidget {
  const Coo({Key? key}) : super(key: key);

  @override
  State<Coo> createState() => _CooState();
}

class _CooState extends State<Coo> {
  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = ElevatedButton(
      child: Text("Cancel"),
      onPressed:  () {},
    );
    Widget continueButton = ElevatedButton(
      child: Text("Continue"),
      onPressed:  () {},
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("AlertDialog"),
      content: Text("Would you like to continue learning how to use Flutter alerts?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  Future<dynamic> getData() async {
    var res = await get(Uri.parse('${Con.url}project_list.php'));
    print(res.body);
    return jsonDecode(res.body);
  }
  Future<void> deleteData(id) async {
   var data = {
      "id":id,
    };
    var result = await post(Uri.parse('${Con.url}delete_project.php'),body: data);
    print(result.body);
    setState(() {

    });
  }
  XFile? pickedFile ;
  File? image;
  String? fileName;
  Future<void> Picture() async {

    getFilePath();
  }
  Future<String> getFilePath() async {
    var data ={
      "g_id":'1',
      "image":fileName
    };
    var r = await post(Uri.parse('${Con.url}upload.php'),body: data);
    print(fileName);
    print(r.body);
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory(); // 1
    String appDocumentsPath = appDocumentsDirectory.path; // 2
    String filePath = '$appDocumentsPath/$fileName'; // 3
    print(filePath);

    return filePath;

  }
  void saveFile() async {
    File file = File(await getFilePath()); // 1
    file.writeAsString("This is my demo text that will be saved to : demoTextFile.txt"); // 2
  }
  void readFile() async {
    File file = File(await getFilePath()); // 1
    String fileContent = await file.readAsString(); // 2

    print('File Content: $fileContent');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Icon(Icons.logout),
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

              return Column(
                children: [
                  Expanded(
                    child: ListView.separated(
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
                          trailing: InkWell(
                            onTap: () {
                              var id = snapshot.data![index]['id'];
                              deleteData(id);
                            },
                              child: Icon(Icons.delete,color: Colors.black,))
                        );

                      },

                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: FloatingActionButton(onPressed: ()  async {
                          ImagePicker picker = ImagePicker();
                          pickedFile = await picker.pickImage(source: ImageSource.gallery);

                          setState(() {


                            image = File(pickedFile!.path);
                            print('...................$image');
                             fileName = pickedFile!.path.split('/').last;

                            print('>>>>>>>>>>>>>>>>>>>>>>$fileName');

                            getFilePath();
                          });


                        },child: Icon(Icons.upload),),
                      ),

                      // image==null?Text('no image'): Image.file(image!),
                      // image==null?Text('no image'): Text('image'),
                      // Text(image==null?'':pickedFile!.name),
                      image==null?Text('no image'): Text('image')
                    ],
                  )
                ],
              );
            }

          }
      ),

    );
  }
}
