import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:eshop_seller/config/configuration.dart';

class ViewProduct extends StatefulWidget {
  const ViewProduct({super.key});

  @override
  State<ViewProduct> createState() => _ViewProductState();
}

class _ViewProductState extends State<ViewProduct> {
  @override
  Widget build(BuildContext context) {
    final productID = ModalRoute.of(context)?.settings.arguments as String;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text(
          "M A N A G E",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("products")
            .where("productid", isEqualTo: productID)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final productData = snapshot.data?.docs;
          if (productData == null || productData.isEmpty) {
            return const Center(child: Text('No product found.'));
          }
          final productDoc = productData.first;
          final documentId = productDoc.id;
          final productMap = productDoc.data() as Map<String, dynamic>;
          return ListView(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: MyConstants.screenHeight(context) * 0.05),
                child: CarouselSlider.builder(
                  itemCount: productMap["imageUrls"].length,
                  options: CarouselOptions(
                    enlargeCenterPage: true,
                    autoPlay: true,
                    viewportFraction: 0.8,
                    height: MyConstants.screenHeight(context) * 0.2,
                  ),
                  itemBuilder: (BuildContext context, int index, _) {
                    return Image.network(
                      productMap["imageUrls"][index],
                      fit: BoxFit.fill,
                    );
                  },
                ),
              ),
              ProductAndDescription(
                productName: productMap["productName"] ?? '',
                description: productMap["description"] ?? '',
                price: productMap["price"] ?? '',
                stock: productMap["stock"] ?? '',
                productID: documentId,
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection("products")
                      .doc(documentId)
                      .update({"stock": (productMap["stock"] ?? 0) + 1});
                },
                onPressed2: () async {
                  await FirebaseFirestore.instance
                      .collection("products")
                      .doc(documentId)
                      .update({"stock": (productMap["stock"] ?? 0) - 1});
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class ProductAndDescription extends StatefulWidget {
  final String productName;
  final String description;
  final dynamic price;
  final dynamic stock;
  final String productID;
  final Function onPressed;
  final Function onPressed2;
  const ProductAndDescription(
      {super.key,
      required this.productName,
      required this.description,
      required this.price,
      required this.stock,
      required this.onPressed,
      required this.productID,
      required this.onPressed2
      });

  @override
  State<ProductAndDescription> createState() => _ProductAndDescriptionState();
}

class _ProductAndDescriptionState extends State<ProductAndDescription> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var priceController = TextEditingController();
  var productNameController = TextEditingController();
  var descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Future<void> _deleteCategory(String categoryId) async {
      try {
        await _firestore.collection('products').doc(categoryId).delete();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Category deleted successfully!'),
          ),
        );
      } catch (error) {
        print(error);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting category: $error'),
          ),
        );
      }
    }

    Future<void> _editProductPrice(String productId, Map productMap) async {
      try {
        await _firestore.collection('products').doc(productId).update({
          'price': productMap["price"],
          'productName': productMap["productName"],
          'description': productMap["description"]
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Category edited successfully!'),
          ),
        );
      } catch (error) {
        print(error);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error editing category: $error'),
          ),
        );
      }
    }

    Future<String?> showTextInputDialog(BuildContext context, String id) async {
      final TextEditingController controller = TextEditingController();

      return await showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Change category"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //if (content.isNotEmpty) Text(content),
              TextField(
                controller: productNameController,
                autofocus: true, // Focus the input field automatically
                decoration: InputDecoration(
                  labelText: 'type new name',
                ),
              ),
              TextField(
                controller: descriptionController,
                autofocus: true, // Focus the input field automatically
                decoration: InputDecoration(
                  labelText: 'type new description',
                ),
              ),
              TextField(
                controller: priceController,
                autofocus: true, // Focus the input field automatically
                decoration: InputDecoration(
                  labelText: 'type new price',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                //final text = controller.text.trim();
                if (priceController.text.isEmpty ||
                    productNameController.text.isEmpty ||
                    descriptionController.text.isEmpty) {
                  // Handle empty input case (optional)
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter some data'),
                    ),
                  );
                  return;
                }
                Map<String, dynamic> productMap = {
                  "productName": productNameController.text,
                  "description": descriptionController.text,
                  "price": priceController.text
                };
                _editProductPrice(id, productMap);

                Navigator.pop(context);

                priceController.clear();
                productNameController.clear();
                descriptionController.clear();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.productName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "₹ ${widget.price}",
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.description,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
           Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  showTextInputDialog(context, widget.productID);
                  // Clear the text field after edit attempt
                  //newCategoryNameController.clear();
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  _deleteCategory(widget.productID);
                },
              ),
            ],
          ),
          const Divider(
            thickness: 1,
            color: Colors.grey,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "current stock: ${widget.stock}",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                  onPressed: widget.onPressed as void Function()?,
                  icon: const Icon(Icons.add)),
                   IconButton(
                  onPressed: widget.onPressed2 as void Function()?,
                  icon: const Icon(Icons.remove))
            ],
          ),
        ],
      ),
    );
  }
}
