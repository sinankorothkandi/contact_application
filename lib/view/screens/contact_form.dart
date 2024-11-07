import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contact_app/model/contact_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ContactFormScreen extends StatefulWidget {
  final Map<String, dynamic>? contact;

  const ContactFormScreen({super.key, this.contact});

  @override
  _ContactFormScreenState createState() => _ContactFormScreenState();
}

class _ContactFormScreenState extends State<ContactFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.contact?['name'] ?? '');
    _phoneController =
        TextEditingController(text: widget.contact?['phone'] ?? '');
    _emailController =
        TextEditingController(text: widget.contact?['email'] ?? '');
    isFavorite = widget.contact?['isFavorite'] ?? false;
  }

  void _saveContact() async {
    if (_formKey.currentState!.validate()) {
      final contact = Contact(
        id: widget.contact?['id'], // Access the id from the Map
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        isFavorite: isFavorite,
        image: '', // No image, but keeping for model consistency
      );

      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Check if it's a new contact or an existing one
      if (widget.contact == null || widget.contact!['id'] == null) {
        // Add new contact to Firestore
        var idd = DateTime.now().microsecondsSinceEpoch.toInt();
        await firestore.collection('contacts').doc(idd.toString()).set({
          'id': idd,
          'name': contact.name,
          'phone': contact.phone,
          'email': contact.email,
          'isFavorite': contact.isFavorite,
        });
      } else {
        // Update existing contact in Firestore
        await firestore
            .collection('contacts')
            .doc(widget.contact!['id'].toString())
            .update({
          'id': contact.id,
          'name': contact.name,
          'phone': contact.phone,
          'email': contact.email,
          'isFavorite': contact.isFavorite,
        });
      }

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close)),
        title: Text(
          widget.contact == null ? 'Add Contact' : 'Edit Contact',
          style: const TextStyle(fontWeight: FontWeight.w300),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.star : Icons.star_border,
              color: isFavorite ? Colors.yellow : Colors.white,
            ),
            onPressed: () {
              setState(() {
                isFavorite = !isFavorite;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 70),
                GestureDetector(
                  onTap: () {
                    // ctrl.pickImage();
                  },
                  child: const CircleAvatar(
                      backgroundColor: Color.fromARGB(90, 216, 188, 94),
                      radius: 70,
                      // backgroundImage: ctrl.imageFile.value != null
                      //     ? FileImage(ctrl.imageFile.value!)
                      //     : null,
                      child: Icon(
                        Icons.add_photo_alternate_rounded,
                        size: 50,
                        color: Color.fromARGB(134, 253, 244, 227),
                      )),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Add Image',
                  style: TextStyle(color: Color.fromARGB(255, 197, 161, 2)),
                ),
                const SizedBox(height: 50),
                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ]')),
                  ],
                  decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle: const TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[600]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 2, color: Color.fromARGB(255, 197, 161, 2)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  validator: (value) => value!.isEmpty ? 'Enter name' : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Phone',
                    labelStyle: const TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[600]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 2, color: Color.fromARGB(255, 197, 161, 2)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter phone number';
                    }
                    if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                      return 'Enter a valid 10-digit phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: const TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[600]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 2, color: Color.fromARGB(255, 197, 161, 2)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter email';
                    }
                    if (!RegExp(r'^[\w\.-]+@[a-zA-Z\d\.-]+\.[a-zA-Z]{2,4}$')
                        .hasMatch(value)) {
                      return 'Enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveContact,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 197, 161, 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(27),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    child: Text(
                      widget.contact == null ? 'Save' : 'Update Contact',
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
