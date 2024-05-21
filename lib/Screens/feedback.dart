
import 'package:flutter/material.dart';
import 'package:eshop_seller/config/configuration.dart';


class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text(
          "F E E D B A C K S",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
    body: Center(
      child: Text("comming soon",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: MyConstants.screenHeight(context)*0.02
      ),),
    ),
      );
  }
}