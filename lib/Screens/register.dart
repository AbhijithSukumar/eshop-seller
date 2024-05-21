
// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:eshop_seller/config/routes.dart';
import 'package:eshop_seller/config/styles.dart';
import 'package:eshop_seller/widgets/button.dart';
import 'package:eshop_seller/widgets/textbox.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Future <void> requestAdmin( )async {
    Map<String,dynamic> sellermap={
      "email":emailcontroller.text.trim(),
       "password":passwordcontroller.text.trim(),
       "companyname":companynamecontroller.text.trim(),
       "phone":phonecontroller.text.trim(),
       "adress":adresscontroller.text.trim(),
       "description":businesssescriptioncontroller.text.trim(),
       "url":urlcontroller.text.trim(),
       "isapproved":false
    };
  if(
    sellermap["email"]==""||
     sellermap["password"]==""||
      sellermap["companyname"]==""||
       sellermap["phone"]==""||
        sellermap["adress"]==""||
         sellermap["description"]==""||
          sellermap["url"]==""||
          cpasswordcontroller.text.trim() ==""
  ){
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
  }
  else
    {
    await FirebaseFirestore.instance.collection("adminrequests").add(sellermap);
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: emailcontroller.text.trim(), password: passwordcontroller.text.trim());
    await FirebaseFirestore.instance.collection("seller").add(sellermap);
  emailcontroller.clear();
  passwordcontroller.clear();
  cpasswordcontroller.clear();
  companynamecontroller.clear();
  phonecontroller.clear();
  adresscontroller.clear();
  businesssescriptioncontroller.clear();
  urlcontroller.clear();
  Navigator.pushNamed(context, Routes.login);
  }
  
  }
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController cpasswordcontroller = TextEditingController();
  TextEditingController companynamecontroller = TextEditingController();
  TextEditingController phonecontroller = TextEditingController();
  TextEditingController adresscontroller = TextEditingController();
  TextEditingController businesssescriptioncontroller = TextEditingController();
  TextEditingController urlcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                  "Welcome , Please sign up using",
                  style: Styles.subtitlegrey(context),
                ),
                Text(
                  "your social account to continue",
                  style: Styles.subtitlegrey(context),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                Textbox(
                  func: (value) {
                      if (value!.isEmpty) {
                        return "Please enter your email address";
                      } else if (!RegExp(
                              r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?)*$")
                          .hasMatch(value)) {
                        return "Invalid email format";
                      }
                      return null;
                    },
                  hideText: false,
                  tcontroller: emailcontroller,
                  type: TextInputType.emailAddress,
                  hinttext: 'Email',
                  icon: Icon(
                    Icons.email,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.013),
                Textbox(
                  func: (value) {
                      if (value!.isEmpty) {
                        return "Please enter your mobile number";
                      } else if (!RegExp(
                              r'^[0-9]{10}$').hasMatch(value)) {
                        return "Invalid phone number";
                      }
                      return null;
                    },
                  hideText: false,
                  tcontroller: phonecontroller,
                  type: TextInputType.number,
                  hinttext: 'Phone',
                  icon: Icon(
                    Icons.phone,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.013),
                Textbox(
                  func: (value) {
                      if (value!.isEmpty) {
                        return "Please enter your company name";
                      }
                      return null;
                    },
                  hideText: false,
                  tcontroller: companynamecontroller,
                  type: TextInputType.text,
                  hinttext: 'companyname',
                  icon: Icon(
                    Icons.app_registration,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.013),
                Textbox(
                  func: (value) {
                      if (value!.isEmpty) {
                        return "Please enter some description";
                      }
                      return null;
                    },
                  hideText: false,
                  tcontroller: businesssescriptioncontroller,
                  type: TextInputType.text,
                  hinttext: 'bussiness description',
                  icon: Icon(
                    Icons.app_registration,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.013),
                Textbox(
                  func: (value) {
                      if (value!.isEmpty) {
                        return "Please enter your buisness url";
                      }
                      return null;
                    },
                  hideText: false,
                  tcontroller: urlcontroller,
                  type: TextInputType.text,
                  hinttext: 'Business url',
                  icon: Icon(
                    Icons.app_registration,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.013),
                
                Textbox(
                  func: (value) {
                      if (value!.isEmpty) {
                        return "Please enter company address";
                      }
                      return null;
                    },
                  hideText: false,
                  tcontroller: adresscontroller,
                  type: TextInputType.text,
                  hinttext: 'adress',
                  icon: Icon(
                    Icons.app_registration,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.013),
                Textbox(
                  func: (value) {
                      if (value!.isEmpty) {
                        return "Please enter your password";
                      } else if (!RegExp(
                              r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                          .hasMatch(value)) {
                        return "Invalid password format";
                      }
                      return null;
                    },
                  hideText: true,
                  tcontroller: passwordcontroller,
                  type: TextInputType.visiblePassword,
                  hinttext: 'Password',
                  icon: Icon(
                    Icons.app_registration,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.013),
                Textbox(
                  hideText: true,
                  tcontroller: cpasswordcontroller,
                  type: TextInputType.visiblePassword,
                  hinttext: 'Confrm password',
                  icon: Icon(
                    Icons.app_registration,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                CustomLoginButton(
                  text: "Sign up",
                  onPress: () async {
                    if(_formKey.currentState!.validate())
                    {
                      await requestAdmin();
                    }
                  },
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, Routes.login);
                      },
                      child: Text(
                        "Sign in",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}