import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:users_app/SplashScreen/splash_screen.dart';
import 'package:users_app/global/global.dart';
import 'package:users_app/widgets/progress_dialog.dart';

import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  validateForm(){
    if(nameTextEditingController.text.length<3){
      Fluttertoast.showToast(msg: "Name must be atleast 3 character");
    }
    else if(!emailTextEditingController.text.contains("@")){
      Fluttertoast.showToast(msg: "Email Address is not correct");
    }
    else if(phoneTextEditingController.text.length != 11){
      Fluttertoast.showToast(msg: "Please enter valid phone number");
    }
    else if (passwordTextEditingController.text.length<6){
      Fluttertoast.showToast(msg: "Password must be atleast 6 character long");
    }
    else{
      saveUserInfo();
    }
  }

  saveUserInfo() async {
    showDialog(context: context,
        barrierDismissible: false,
        builder: (BuildContext c){
          return ProgressDialog(message: "Processing, Please wait....",);
        });

    final User? firebaseUser = (
    await firebaseAuth.createUserWithEmailAndPassword(
        email: emailTextEditingController.text.trim(),
        password: passwordTextEditingController.text.trim(),
    ).catchError((msg){
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error: " + msg.toString());
    })
    ).user;

    if(firebaseUser!= null){
      Map userMap = {
        "id": firebaseUser.uid,
        "name": nameTextEditingController.text.trim(),
        "email": emailTextEditingController.text.trim(),
        "phone": phoneTextEditingController.text.trim(),
      };

      DatabaseReference driversRef = FirebaseDatabase.instance.ref().child("users");
      driversRef.child(firebaseUser.uid).set(userMap);

      currentFirebaseUser = firebaseUser;
      Navigator.push(context, MaterialPageRoute(builder: (e)=> MySplashScreen()));

    }else{
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Account has not been created");
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10,),

              Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Image.asset("images/logo1.jpg"),
              ),

              SizedBox(height: 10,),

              const Text("Register as a User",
              style: TextStyle(
                fontSize: 24,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
              ),

              SignUpTextField(nameTextEditingController: nameTextEditingController, labelText: 'Name', hintText: 'Name',inputType: TextInputType.text,),
              SignUpTextField(nameTextEditingController: emailTextEditingController, labelText: 'E-Mail', hintText: 'E-Mail',inputType: TextInputType.emailAddress),
              SignUpTextField(nameTextEditingController: phoneTextEditingController, labelText: 'Phone', hintText: 'Phone',inputType: TextInputType.phone),
              SignUpTextField(nameTextEditingController: passwordTextEditingController, labelText: 'Password', hintText: 'Password',inputType: TextInputType.text,),

              SizedBox(height: 10,),

              ElevatedButton(onPressed: (){
               validateForm();
              },
                  child: const Text("Create Account",
                  style: TextStyle(color: Colors.black,fontSize: 18),
                  ),
              ),

              TextButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (c)=> LoginScreen() ));
              },
                child: const Text("Already have an account? Click Here",
                  style: TextStyle(color: Colors.grey),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SignUpTextField extends StatelessWidget {
  const SignUpTextField({
    Key? key,
    required this.nameTextEditingController, required this.labelText, required this.hintText, required this.inputType, this.obscure=false,
  }) : super(key: key);

  final TextEditingController nameTextEditingController;
  final String labelText;
  final String hintText;
  final TextInputType inputType;
  final bool? obscure;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscure!,
      controller: nameTextEditingController,
      keyboardType: inputType,
      style: const TextStyle(
        color: Colors.grey,
      ),
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 14,
        ),
        labelStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 14,
        ),
      ),
    );
  }
}
