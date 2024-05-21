// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:eshop_seller/config/configuration.dart';
import 'package:eshop_seller/config/routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  List dashboard=[
    ["profile","assets/user.png",Routes.profile],
    ["orders","assets/shopping-bag.png",Routes.order],
    ["add products","assets/add-product.png",Routes.add],
    ["feedbacks","assets/customer-service.png",Routes.feedback],
    ["manage product","assets/supply-chain.png",Routes.manage],
    ["add categories","assets/add_category.png",Routes.addCategory],
    ];
  void logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushReplacementNamed(context, Routes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
          title: const Text(
            "H O M E",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Theme.of(context).colorScheme.background,
          actions: [
            IconButton(onPressed: logout, icon: const Icon(Icons.logout))
          ]),
      body: Padding(
        padding:  EdgeInsets.all(MyConstants.screenHeight(context)*0.01),
        child: GridView.builder(
          itemCount: dashboard.length,
          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: (){
                Navigator.pushNamed(context,dashboard[index][2] );
              },
              child: Padding(

                padding:  EdgeInsets.all(MyConstants.screenHeight(context)*0.01),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                            width: MyConstants.screenHeight(context)*0.13, 
                            height: MyConstants.screenHeight(context)*0.13, 
                            child: Image.asset(
                              dashboard[index][1],
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                    Text(dashboard[index][0],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: MyConstants.screenHeight(context)*0.017,
                    ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
