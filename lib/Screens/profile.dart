import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:eshop_seller/config/configuration.dart';
import 'package:eshop_seller/config/routes.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text(
          "P R O F I L E",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: Padding(
          padding: EdgeInsets.all(MyConstants.screenHeight(context) * 0.02),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("seller")
                .where("email",
                    isEqualTo: FirebaseAuth.instance.currentUser!.email)
                .snapshots(),
            builder: (BuildContext context, snapshot) {
              final userData = snapshot.data!.docs;
              final userDoc = userData.first;
              final documentId = userDoc.id;

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (userData.isEmpty) {
                return const Center(child: Text('No user data found.'));
              }

              final userMap = userData.first.data() as Map<String, dynamic>;

              final email = userMap['email'] ?? '';
              final phone = userMap['phone'] ?? '';
              final address = userMap['adress'] ?? '';
              final companyName = userMap['companyname'] ?? '';
              final description = userMap['description'] ?? '';
              final url = userMap['url'] ?? '';

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Seller Information',
                    style: TextStyle(
                      fontSize: MyConstants.screenHeight(context) * 0.033,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Information(title: 'Email', value: email),
                  Information(title: 'Phone', value: phone),
                  Information(title: 'Address', value: address),
                  Information(title: 'Company', value: companyName),
                  Information(
                      title: 'Business Description', value: description),
                  Information(title: 'Business URL', value: url),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.all(
                          MyConstants.screenHeight(context) * 0.01),
                      child: MaterialButton(
                        onPressed: () {
                          Navigator.pushNamed(context, Routes.editprofile,
                              arguments: {
                                "documentID": documentId,
                                "userMap": userMap
                              });
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              MyConstants.screenHeight(context) * 0.01),
                        ),
                        color: Theme.of(context).colorScheme.primary,
                        elevation: 10,
                        child: Text(
                          "Edit",
                          style: TextStyle(
                              fontSize:
                                  MyConstants.screenHeight(context) * 0.025),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          )),
    );
  }
}

class Information extends StatelessWidget {
  final String title;
  final String value;
  const Information({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: MyConstants.screenHeight(context) * 0.02,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: MyConstants.screenHeight(context) * 0.0057),
        Text(
          value,
          style: TextStyle(
            fontSize: MyConstants.screenHeight(context) * 0.018,
          ),
        ),
        SizedBox(height: MyConstants.screenHeight(context) * 0.02),
      ],
    );
  }
}
