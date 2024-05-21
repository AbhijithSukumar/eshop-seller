import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:eshop_seller/config/configuration.dart';

class ManageOrers extends StatefulWidget {
  const ManageOrers({super.key});

  @override
  State<ManageOrers> createState() => _ManageOrersState();
}

class _ManageOrersState extends State<ManageOrers> {
  dynamic check(String id,String field) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("orders")
        .where("id", isEqualTo: id)
        .get();
         var doc = snapshot.docs.first;
    Map<String, dynamic> productData = doc.data() as Map<String, dynamic>;
    if(
      productData[field]==true
    ){
      await doc.reference.update({field:false});
    }
    else{
        await doc.reference.update({field:true});
    }
  }

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)?.settings.arguments as String;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text(
          "M A N A G E O R D E R S",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: Padding(
        padding: EdgeInsets.all(MyConstants.screenHeight(context) * 0.01),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("orders")
              .where("id", isEqualTo: id)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final userData = snapshot.data!.docs;
            final productMap = userData.first.data() as Map<String, dynamic>;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(
                      productMap["product name"],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "₹ ${productMap["price"]} ",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: Image.network(productMap["image"]),
                  ),
                ),
                const Divider(),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Shipping Address",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: FutureBuilder(
                    future: getBuyerAddress(productMap["buyer email"]),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> addressSnapshot) {
                      if (addressSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (addressSnapshot.hasError) {
                        return Center(
                            child: Text('Error: ${addressSnapshot.error}'));
                      }
                      final buyerAddress =
                          addressSnapshot.data as Map<String, dynamic>;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Name: ${buyerAddress["username"]}"),
                          Text("Phone: ${buyerAddress["phone"]}"),
                          Text("House Name: ${buyerAddress["housename"]}"),
                          Text(
                              "Street Address: ${buyerAddress["Steetadress"]}"),
                          Text("District: ${buyerAddress["district"]}"),
                          Text("State: ${buyerAddress["state"]}"),
                          Text("Pincode: ${buyerAddress["pincode"]}"),
                        ],
                      );
                    },
                  ),
                ),
                const Divider(),
                CheckboxListTile(
                  value: productMap["order shipped"],
                  onChanged: (value) {
                    check(id, "order shipped");
                  },
                  title: const Text(
                    "order shipped",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                CheckboxListTile(
                  value: productMap["out for delivery"],
                  onChanged: (value) {
                     check(id, "out for delivery");
                  },
                  title: const Text(
                    "out for delivery",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                CheckboxListTile(
                  value: productMap["order delivered"],
                  onChanged: (value) {
                        check(id, "order delivered");
                  },
                  title: const Text(
                    "order delivered",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<dynamic> getBuyerAddress(buyerEmail) async {
    final snapshot = await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: buyerEmail)
        .get();
    final doc = snapshot.docs.first;
    return doc.data();
  }
}
