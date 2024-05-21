// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:eshop_seller/Screens/register.dart';
import 'package:eshop_seller/config/configuration.dart';
import 'package:eshop_seller/config/routes.dart';
import 'package:eshop_seller/config/styles.dart';
import 'package:eshop_seller/widgets/button.dart';
import 'package:eshop_seller/widgets/textbox.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  void login() async {
    String email = emailcontroller.text.trim();
    String password = passwordcontroller.text.trim();
    if (email == "" || password == "") {
      showDialog(context: context, builder: (BuildContext context) { 
        return const AlertDialog(
          content: Column(
           mainAxisSize:MainAxisSize.min,
           children: [
             Text("fill all fields")
           ],
          ),
        );
       }, );
    } else {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
                    bool isapproved= await getapproval(email);

        if (userCredential.user != null) {
          Navigator.popUntil(context, (route) => route.isFirst);
          Navigator.pushReplacementNamed(context,isapproved? Routes.home: Routes.pending);
        }
      } on FirebaseAuthException catch (exception) {
      showDialog(context: context, builder: (BuildContext context) { 
        return AlertDialog(
          content: Text(exception.code.toString()),
        );
       }, );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(MyConstants.screenHeight(context) * 0.01),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             SizedBox(height: MediaQuery.of(context).size.height * 0.15),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Eshop Seller",
                  style: Styles.title(context),
                ),
              ),
              Text(
                "Welcome back.Please sign in to",
                style: Styles.subtitlegrey(context),
              ),
              Text(
                "continue",
                style: Styles.subtitlegrey(context),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.15),
              Textbox(
                hideText: false,
                tcontroller: emailcontroller,
                type: TextInputType.emailAddress,
                hinttext: 'Email',
                icon: Icon(Icons.email,color:Theme.of(context). colorScheme.primary,),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.013),
              Textbox(
                hideText: true,
                tcontroller: passwordcontroller,
                type: TextInputType.visiblePassword,
                hinttext: 'Password',
                icon:Icon(Icons.lock,color:Theme.of(context). colorScheme.primary,),
              ),
             
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(onPressed: (){
                  Navigator.pushNamed(context, Routes.forgot);
                }, child: Text("forgot password", style: TextStyle(color: Theme.of(context).colorScheme.primary),)),
              ),
             
           
              CustomLoginButton(
                  text: "Sign in",
                  onPress: login),
              Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("don't have an account?"),
                      TextButton(onPressed: (){
                         Navigator.pushNamed(context, Routes.register);
                      }, child: Text("Sign up", style: TextStyle(color: Theme.of(context).colorScheme.primary),))
                    ],
                  )
            ],
          ),
        ),
      ),
    );
  }
}


dynamic getapproval(String email)async{
  print(email);
  bool isapproved;
 QuerySnapshot snapshot=await FirebaseFirestore.instance.collection("seller").where("email" , isEqualTo: email).get();
    var doc = snapshot.docs.first;
    Map<String, dynamic> userMap = doc.data() as Map<String, dynamic>;
    isapproved=userMap["isapproved"];
    print(isapproved);
 return isapproved;
}