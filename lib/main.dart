// ignore_for_file: avoid_print

import 'package:eshop_seller/Screens/addCategory.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:eshop_seller/Screens/addproduct.dart';
import 'package:eshop_seller/Screens/editprofile.dart';
import 'package:eshop_seller/Screens/feedback.dart';

import 'package:eshop_seller/Screens/forgotpassword.dart';
import 'package:eshop_seller/Screens/home.dart';
import 'package:eshop_seller/Screens/login.dart';
import 'package:eshop_seller/Screens/manage.dart';
import 'package:eshop_seller/Screens/manageorder.dart';
import 'package:eshop_seller/Screens/order.dart';
import 'package:eshop_seller/Screens/pendingScreen.dart';
import 'package:eshop_seller/Screens/profile.dart';
import 'package:eshop_seller/Screens/register.dart';
import 'package:eshop_seller/Screens/splash.dart';
import 'package:eshop_seller/Screens/viewproduct.dart';
import 'package:eshop_seller/config/configuration.dart';
import 'package:eshop_seller/config/routes.dart';
import 'package:eshop_seller/firebase_options.dart';

void main() async{
   WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("Firebase initialized successfully");
  } catch (e) {
    print("Error initializing Firebase: $e");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightmode,
      initialRoute: Routes.splash,
      routes: {
        Routes.home:(context) =>const HomeScreen(),
        Routes.login:(context)=>const LoginScreen(),
        Routes.splash:(context) =>const SplashScreen(), 
         Routes.add:(context) =>const AddProduct(), 
        Routes.feedback:(context)=>const FeedbackScreen(),
        Routes.manage:(context) =>const ManageProducts(), 
         Routes.forgot:(context) =>const ForgotPassword(), 
        Routes.profile:(context)=>const ProfileScreen(),
        Routes.order:(context) =>const OrderScreen(), 
        Routes.register:(context) => const RegisterScreen(),
        Routes.editprofile:(context) => const EditProfileScreen(),
        Routes.viewproduct:(context) => const ViewProduct(),
        Routes.manageorder:(context) => const ManageOrers(),
        Routes.pending:(context) => const PendingScreen(),
        Routes.addCategory:(context) => const AddCategoryScreen()
      },
      
    );
  }
}
