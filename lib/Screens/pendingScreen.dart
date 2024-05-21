
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:eshop_seller/config/routes.dart';

class PendingScreen extends StatelessWidget {
  const PendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
      child: StreamBuilder(stream: FirebaseFirestore.instance
    .collection("seller")
    .where("email", isEqualTo: FirebaseAuth.instance.currentUser!.email)
    .snapshots(), builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) { 
       final userData = snapshot.data!.docs;
       
  
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }
    if (snapshot.hasError) {
      return Center(child: Text('Error: ${snapshot.error}'));
    }
    if (userData.isEmpty) {
      
    
      return const Center(child: Text('No user data found.'));
     
    }

    final userMap = userData.first.data();

    if(userMap["isapproved"]){
      Navigator.pushNamed(context, Routes.home);
    }

      return  Center(child: LottieBuilder.asset("assets/Animation - 1711951385422.json"));
     },)
      ),
    );
  }
}