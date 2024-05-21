
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:eshop_seller/config/configuration.dart';
import 'package:eshop_seller/config/routes.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) {
     final user = FirebaseAuth.instance.currentUser;
    final useremail = user?.email;

    return Scaffold(
       backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text(
          "O R D E R S",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
       body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection("orders").where("seller email" ,isEqualTo:useremail ).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final orders=snapshot.data!.docs;
          if(orders.isEmpty){
            return const Center(child: Text('No orders found.'));
          }
          final data = snapshot.data;
          return Padding(
            padding: EdgeInsets.symmetric(
                vertical: MyConstants.screenHeight(context) * 0.01),
            child: ListView.builder(
              itemCount: data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                final userData = data.docs[index];
                // final userId = userData.id;
                Map<String, dynamic> sellermap =
                    userData.data() as Map<String, dynamic>;
                return Card(
                  child: Padding(
                    padding:
                        EdgeInsets.all(MyConstants.screenHeight(context) * 0.01),
                    child: ListTile(
                      onTap: (){
                        Navigator.pushNamed(context, Routes.manageorder,arguments:sellermap["id"] );
                      },
                    
                      leading: Image.network(sellermap["image"]),
                      title: Text("${sellermap["product name"]}"),
                      subtitle: Text(sellermap["buyer email"]),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}