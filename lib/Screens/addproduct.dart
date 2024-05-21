import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:eshop_seller/config/configuration.dart';
import 'package:eshop_seller/widgets/reuabletextfield.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
   final TextEditingController stockController = TextEditingController();

   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

   Future<void> getCategories() async {
    // Try fetching categories from Firebase
    try {
      final snapshot = await _firestore.collection('categories').get();
      final documents = snapshot.docs;

      for (var doc in documents) {
        final categoryName = doc.data()['name'];
        if (categoryName != null) {
          print("---------- $categoryName");
          dropdownlist.add(categoryName);
        }
      }
      setState(() {}); // Trigger rebuild to update UI (optional)
    } catch (error) {
      print(error);
      // Handle errors appropriately (e.g., show a snackbar)
    }
  }

  String? selectedCategory;

  List<String> dropdownlist = [
    'electronics and accessories',
    'laptops and computers',
    'mens clothing',
    'womens clothing',
    'kids clothing',
    'appliances',
    'footwear'
  ];
  List<XFile> imagesfiles = []; // List to store selected images

  // Function to pick image from gallery
  Future<void> _pickImage() async {
    List<XFile> images = await ImagePicker().pickMultiImage();

    setState(() {
      imagesfiles = images;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCategories();
  }

  void saveProduct() async {
    List<String> imageUrls = [];

    // Get current user
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      print("User not logged in.");
      return;
    }

    // Upload images to Firebase Stoarge
    for (XFile imageFile in imagesfiles) {
      // Generate a unique ID for mageFithe image
      String imageName = imageFile.name; 
      UploadTask task = FirebaseStorage.instance
          .ref()
          .child("product_images")
          .child(imageName)
          .putFile(File(imageFile.path));

      TaskSnapshot taskSnapshot = await task;

      String imageUrl = await taskSnapshot.ref.getDownloadURL();

      imageUrls.add(imageUrl);
    }

    // Add product data to Firestore
    await FirebaseFirestore.instance.collection("products").add({
      "productName": productNameController.text.trim(),
      "description": descriptionController.text.trim(),
      "price": double.parse(priceController.text.trim()),
      "category": selectedCategory,
      "imageUrls": imageUrls,
      "userEmail": currentUser.email,
      "stock":double.parse(stockController.text.trim()),
      "productid": const Uuid().v1(),
    });

    

    // Clear controllers and reset selected images
    productNameController.clear();
    descriptionController.clear();
    priceController.clear();
    setState(() {
      imagesfiles.clear();
    });

    print("Product added");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text(
          "A D D  P R O D U C T S",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ReusableTextfield(
                controller: productNameController,
                isobscure: false,
                inputtype: TextInputType.text,
                hint: 'Product Name',
              ),
              ReusableTextfield(
                controller: descriptionController,
                isobscure: false,
                inputtype: TextInputType.text,
                hint: 'Description',
              ),
              ReusableTextfield(
                controller: priceController,
                isobscure: false,
                inputtype: TextInputType.number,
                hint: 'Price',
              ),
               ReusableTextfield(
                controller: stockController,
                isobscure: false,
                inputtype: TextInputType.number,
                hint: 'stock',
              ),
              DropdownButton<String>(
                value: selectedCategory,
                underline: const SizedBox(),
                isExpanded: true,
                dropdownColor: Colors.white,
                borderRadius: BorderRadius.circular(15),
                hint: const Text(
                  "Select Category",
                  style: TextStyle(color: Colors.black),
                ),
                items: dropdownlist.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    selectedCategory = value;
                  });
                },
              ),
              Padding(
                padding:
                    EdgeInsets.all(MyConstants.screenHeight(context) * 0.01),
                child: ElevatedButton(
                  onPressed: _pickImage,
                  child: const Text('Select Image'),
                ),
              ),
              imagesfiles.isNotEmpty
                  ? CarouselSlider.builder(
                      itemCount: imagesfiles.length,
                      options: CarouselOptions(
                        enlargeCenterPage: true,
                        autoPlay: true,
                        viewportFraction: 1,
                      ),
                      itemBuilder: (BuildContext context, int index, _) {
                        return Image.file(
                          File(imagesfiles[index].path),
                          fit: BoxFit.contain,
                        );
                      },
                    )
                  : const SizedBox(),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding:
                      EdgeInsets.all(MyConstants.screenHeight(context) * 0.01),
                  child: MaterialButton(
                    onPressed: () {
                     saveProduct();
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          MyConstants.screenHeight(context) * 0.01),
                    ),
                    color: Theme.of(context).colorScheme.primary,
                    elevation: 10,
                    child: Text(
                      "add product",
                      style: TextStyle(
                          fontSize: MyConstants.screenHeight(context) * 0.025),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



