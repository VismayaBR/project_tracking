import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Downloading extends StatefulWidget {
  const Downloading({Key? key}) : super(key: key);

  @override
  State<Downloading> createState() => _DownloadingState();
}

class _DownloadingState extends State<Downloading> {
  Dio dio = Dio();
  double progress = 0.0;
  void startDownloading()async{
    const String url = 'https://file-examples.com/storage/fe7122043963cd639947840/2017/10/file-sample_150kB.pdf';
    const String filename = "abc.pdf";
    String path = await _getFilePath(filename);
    print(path);

    await dio.download(url, path,onReceiveProgress: (recivedBytes,totalBytes){
      setState(() {
        progress=recivedBytes/totalBytes;
      });
      print(progress);
    },
    deleteOnError: true,

    ).then((_) => {
      Navigator.pop(context)
    });

  }
  Future<String>_getFilePath(String filename)async{
    final dir=await getApplicationDocumentsDirectory();
    return "${dir.path}/$filename";
  }
  @override
  void initState(){
    super.initState();
    startDownloading();
  }
  @override
  Widget build(BuildContext context) {
    String downloadingProgress= (progress*100).toInt().toString();
    return AlertDialog(
      backgroundColor: Colors.black,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator.adaptive(),
          const SizedBox(height: 20,),
          Text('Downloading',style: TextStyle(color: Colors.white,fontSize: 17),)
        ],
      ),
    );
  }
}
