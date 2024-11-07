import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contact_app/model/contact_model.dart';
import 'package:flutter/material.dart';
class ContactFormProvider extends ChangeNotifier {
  Map<String, dynamic>? _contact;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  bool _isFavorite = false;

  Map<String, dynamic>? get contact => _contact;
  TextEditingController get nameController => _nameController;
  TextEditingController get phoneController => _phoneController;
  TextEditingController get emailController => _emailController;
  bool get isFavorite => _isFavorite;

  void initializeContact(Map<String, dynamic>? contact) {
    _contact = contact;
    _nameController.text = contact?['name'] ?? '';
    _phoneController.text = contact?['phone'] ?? '';
    _emailController.text = contact?['email'] ?? '';
    _isFavorite = contact?['isFavorite'] ?? false;
    notifyListeners();
  }

  void setIsFavorite(bool value) {
    _isFavorite = value;
    notifyListeners();
  }

  Future<void> saveContact() async {
    if (_nameController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty &&
        _emailController.text.isNotEmpty) {
      final contact = Contact(
        id: _contact?['id'],
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        isFavorite: _isFavorite,
        image: '',
      );

      FirebaseFirestore firestore = FirebaseFirestore.instance;

      if (_contact == null || _contact!['id'] == null) {
        var id = DateTime.now().microsecondsSinceEpoch.toInt();
        await firestore.collection('contacts').doc(id.toString()).set({
          'id': id,
          'name': contact.name,
          'phone': contact.phone,
          'email': contact.email,
          'isFavorite': contact.isFavorite,
        });
      } else {
        await firestore
            .collection('contacts')
            .doc(_contact!['id'].toString())
            .update({
          'id': contact.id,
          'name': contact.name,
          'phone': contact.phone,
          'email': contact.email,
          'isFavorite': contact.isFavorite,
        });
      }

      notifyListeners();
    }
  }
}