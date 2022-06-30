import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:users_app/mainScreen/about_screen.dart';
import 'package:users_app/mainScreen/call_centerl_screen.dart';
import 'package:users_app/mainScreen/main_screen.dart';
import 'package:users_app/mainScreen/shop_screen.dart';
import 'package:users_app/mainScreen/trips_history_screen.dart';
import 'package:users_app/widgets/my_drawer.dart';
import '../assistants/assistant_method.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}
class _FirstPageState extends State<FirstPage> {

  Future<Object> getImage(BuildContext context, String imageName) async {
    Image? image;
      AssistantMethods.readTripsKeysForOnlineUser(context);
    await FireStorageServices.loadImage(context, imageName).then((value){
      image = Image.network(value.toString(),fit: BoxFit.scaleDown,
      );
    } );
    return image!;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.yellow.shade400,
     appBar: AppBar(
       iconTheme: IconThemeData(color: Colors.yellow),
       title: Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
         children: [
           Container(),
           const Text("Ride Kr",
             style: TextStyle(color: Colors.yellow),
           ),
           IconButton(onPressed: (){
             Navigator.push(context, MaterialPageRoute(builder: (c)=> CallCenterScreen()));
           },
               icon: const Icon(Icons.phone_forwarded,))
         ],
       ),
       backgroundColor: Colors.blueGrey,

     ),
      drawer: Container(
          width: 265,
          child: Theme(
              data: Theme.of(context).copyWith(
                canvasColor: Colors.black,
              ),
              child: const MyDrawer())),
      body: Column(
        children: [
          Container(
          color: Colors.grey.withOpacity(0.5),
            child:  ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FutureBuilder(
                    future: getImage(context, "advert.jpg"),
                    builder: (context, snapshot){
                      if(snapshot.connectionState == ConnectionState.done){
                        return SizedBox(
                          child: snapshot.data as Widget,
                        );
                      }
                      if(snapshot.connectionState == ConnectionState.waiting){
                        return const SizedBox(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return Container();
                    }),
            ),
            alignment: Alignment.center,
            height: 300,
          ),
       const SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (c)=> MainScreen()));
                },
                child: MyGridView(imagePath: 'images/map.jpg',text: "Get Ride"),
              ),
              Container(),
             GestureDetector(
                 onTap: (){
                   Navigator.push(context, MaterialPageRoute(builder: (c)=> ShopScreen()));
                 },
                 child: MyGridView(text: "Shops", imagePath: "images/shop.jpg"))
            ],
          ),
          const SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> AboutScreen()));
                  },
                  child: MyGridView(text: "About Us", imagePath: "images/about.jpg")),
             GestureDetector(
                 onTap: (){
                   Navigator.push(context, MaterialPageRoute(builder: (c)=> TripsHistoryScreen()));
                 },
                 child: MyGridView(text: "History", imagePath: "images/history.jpg")),
            ],
          )
        ],
      ),
    );

  }
}

class MyGridView extends StatelessWidget {
  String text;
  String imagePath;
  MyGridView({Key? key, required this.text, required this.imagePath}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(imagePath),
            ),
                height: 100,
          ),
        Text(text,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blueGrey,)),
      ],
    );
  }
}

class FireStorageServices extends ChangeNotifier{
  FireStorageServices();
  static Future<dynamic> loadImage(BuildContext context, String Image) async {
    return await FirebaseStorage.instance.ref("test/").child(Image).getDownloadURL();
  }
}
