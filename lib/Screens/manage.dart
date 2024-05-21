
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:eshop_seller/config/configuration.dart';
import 'package:eshop_seller/config/routes.dart';


class ManageProducts extends StatefulWidget {
  const ManageProducts({super.key});

  @override
  State<ManageProducts> createState() => _ManageProductsState();
}

class _ManageProductsState extends State<ManageProducts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text(
          "M A N A G E  P R O D U C T S",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
       body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection("products").where("userEmail", isEqualTo: FirebaseAuth.instance.currentUser!.email).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = snapshot.data;
          return Padding(
            padding: EdgeInsets.symmetric(
                vertical: MyConstants.screenHeight(context) * 0.01),
            child: ListView.builder(
              itemCount: data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                final productData = data.docs[index];
                Map<String, dynamic> productmap =
                    productData.data() as Map<String, dynamic>;
                return Padding(
                  padding:
                      EdgeInsets.all(MyConstants.screenHeight(context) * 0.01),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                     
                        title: Text("${productmap["productName"]}"),
                        subtitle: Text("₹ ${productmap["price"]}"),
                      leading: Image.network(productmap["imageUrls"][0]),
                      onTap: () {
                        Navigator.pushNamed(context, Routes.viewproduct,arguments:productmap["productid"] );
                        print(productmap["productid"]);
                      },
                      ),
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