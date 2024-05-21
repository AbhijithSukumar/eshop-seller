import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({super.key});

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _categoryNameController = TextEditingController();
  bool isEditClicked=false;
  final TextEditingController newCategoryNameController =
      TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  

  // Stream to get categories from Firebase
  Stream<QuerySnapshot<Map<String, dynamic>>> get _categoriesStream =>
      _firestore.collection('categories').snapshots();

  @override
  void dispose() {
    _categoryNameController.dispose();
    super.dispose();
  }

  Future<void> _addNewCategory(String categoryName) async {
    try {
      await _firestore.collection('categories').add({
        'name': categoryName,
      });
      _categoryNameController.clear();
    } catch (error) {
      print(error);
      // Handle errors appropriately (e.g., show a snackbar)
    }
  }

  Future<String?> showTextInputDialog(BuildContext context,String id) async {
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
            controller: controller,
            autofocus: true,  // Focus the input field automatically
            decoration: InputDecoration(
              labelText: 'type new category name',
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
            final text = controller.text.trim();
            if (text.isEmpty) {
              // Handle empty input case (optional)
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Please enter some data'),
                ),
              );
              return;
            }
            _editCategory(id,text);
            Navigator.pop(context, text);
          },
          child: Text('OK'),
        ),
      ],
    ),
  );
}
  // Function to edit an existing category
  Future<void> _editCategory(String categoryId, String newCategoryName) async {
    try {
      await _firestore.collection('categories').doc(categoryId).update({
        'name': newCategoryName,
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

// Function to delete a category
  Future<void> _deleteCategory(String categoryId) async {
    try {
      await _firestore.collection('categories').doc(categoryId).delete();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Category'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Form to add a new category
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _categoryNameController,
                decoration: const InputDecoration(
                  labelText: 'Category Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a category name';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _addNewCategory(_categoryNameController.text);
                }
              },
              child: const Text('Add Category'),
            ),

            const SizedBox(height: 20.0),
            const Text("Your custom categories"),
            const Divider(
              thickness: 1,
              color: Colors.grey,
            ),
            const SizedBox(height: 20.0),
            // StreamBuilder to display existing categories
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _categoriesStream,
              builder: (context, snapshot) {
                // ... existing code for handling errors and loading ...

                final data = snapshot.data!.docs;
                if (data.isEmpty) {
                  return const Text('No categories yet');
                }

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final category = data[index].data();
                    final categoryId = data[index].id; // Get the category ID

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                           Text(category['name']),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  showTextInputDialog(context,data[index].id);                      
                                  // Clear the text field after edit attempt
                                  newCategoryNameController.clear();
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  _deleteCategory(categoryId);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

