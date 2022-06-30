import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:percent_indicator/percent_indicator.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({Key? key}) : super(key: key);

  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  double percent = 0.0;
  Timer? timer;

  double? _height;
  double? _width;

  FirebaseStorage storage = FirebaseStorage.instance;
  // Retriew the uploaded images
  // This function is called when the app launches for the first time or when an image is uploaded or deleted
  Future<List<Map<String, dynamic>>> _loadImages() async {
    List<Map<String, dynamic>> files = [];

    final ListResult result = await storage.ref().list();
    final List<Reference> allFiles = result.items;

    await Future.forEach<Reference>(allFiles, (file) async {
      final String fileUrl = await file.getDownloadURL();
      final FullMetadata fileMeta = await file.getMetadata();
      files.add({
        "url": fileUrl,
        "path": file.fullPath,
        "uploaded_by": fileMeta.customMetadata?['uploaded_by'] ?? 'Nobody',
        "description":
        fileMeta.customMetadata?['description'] ?? 'No description'
      });
    });

    return files;
  }

  @override
  void initState() {
    timer = Timer.periodic(Duration(milliseconds:3000),(_){
      setState(() {
        percent+=10;
        if(percent >= 100){
          timer!.cancel();
          // percent=0;
        }
      });
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow.shade400,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.yellow),
        title: const Center(
          child: Text("Shops",
           style: TextStyle(color: Colors.yellow),
            ),
        ),
        backgroundColor: Colors.blueGrey,

      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: _loadImages(),
                builder: (context,
                    AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return ListView.builder(
                      itemCount: snapshot.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        final Map<String, dynamic> image =
                        snapshot.data![index];

                        return Container(
                          height: 300,
                          child: Card(
                            semanticContainer: true,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            color: Colors.grey.withOpacity(0.5),
                            child: Builder(
                              builder: (context) {
                                return Image.network(image['url'],height: 100,width: 100,fit: BoxFit.fill,);
                              }
                            ),
                          ),
                        );
                      },
                    );
                  }

                  return buildCenterPercentageCircularBar();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildCenterPercentageCircularBar() {
    return Center(
      // child: CircularProgressIndicator(color: Colors.black,),
      child: CircularPercentIndicator(
        radius: 60.0,
        lineWidth: 10.0,
        animation: true,
        percent: percent/100,
        center: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              percent.toString() + "%",
              style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
            const Text("Please wait....")
          ],
        ),
        backgroundColor: Colors.grey,
        circularStrokeCap: CircularStrokeCap.round,
        progressColor: Colors.redAccent,
      ),
    );
  }
}
