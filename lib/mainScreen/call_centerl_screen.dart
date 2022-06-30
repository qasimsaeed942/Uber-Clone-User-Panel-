import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';


class CallCenterScreen extends StatefulWidget
{
  @override
  State<CallCenterScreen> createState() => _CallCenterScreenState();
}

class _CallCenterScreenState extends State<CallCenterScreen>
{
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(

        children: [

          //image
           Container(
            height: 230,
            child: Center(
              child: Image.asset(
                "images/logo1.jpg",
                width: 260,
              ),
            ),
          ),

          Column(
            children: [

              //company name
              const Text(
                "Ride Kr Call Center",
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.white54,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              //about you & your company - write some info
              const Text(
                "0326-8780001",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.yellow,
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              const Text(
                "We Provide Services, We are more than team, "
                    "Our Services help move people's parcels and "
                    "payments efficiently in a safe reliable"
                    "and in a inexpensive way.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white54,
                ),
              ),

              const SizedBox(
                height: 40,
              ),

              //close
               ElevatedButton.icon(
                onPressed: ()
                {
                  launch(('tel://03268780001'));
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.yellow,
                ),
                icon: const Icon(
                  Icons.phone_android,
                  color: Colors.black54,
                  size: 33,
                ),
                label: const Text(
                  "Call Now",
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                  ),
                ),
              ),

            ],
          ),

        ],

      ),
    );
  }
}
