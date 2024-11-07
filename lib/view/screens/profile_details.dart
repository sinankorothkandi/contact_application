import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contact_app/navbar.dart';
import 'package:contact_app/view/screens/contact_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ContactDetailsScreen extends StatelessWidget {
  final contact;

  ContactDetailsScreen({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ContactFormScreen(
                      contact: contact,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.edit_outlined)),
          IconButton(
              onPressed: () {
                showDeleteAlert(context, contact['id'].toString());
              },
              icon: const Icon(Icons.delete)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 30,
            ),
            Center(
              child: CircleAvatar(
                radius: 100,
                backgroundColor:
                    Colors.primaries[Random().nextInt(Colors.primaries.length)],
                child: Text(
                  contact['name'].isNotEmpty
                      ? contact['name'].substring(0, 1).toUpperCase()
                      : '',
                  style: const TextStyle(
                    color: Color.fromARGB(255, 26, 26, 26),
                    fontSize: 90,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              contact['name'],
              style: const TextStyle(fontSize: 28),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(90, 216, 188, 94),
                          borderRadius: BorderRadius.circular(90)),
                      child: IconButton(
                          icon: const Icon(
                            Icons.call_outlined,
                            color: Color.fromARGB(134, 253, 244, 227),
                          ),
                          onPressed: () {
                            _makePhoneCall(contact['phone'].toString());
                          }),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text('Call')
                  ],
                ),
                const SizedBox(
                  width: 40,
                ),
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(90, 216, 188, 94),
                          borderRadius: BorderRadius.circular(90)),
                      child: IconButton(
                          icon: Icon(
                            Icons.message_outlined,
                            color: Color.fromARGB(134, 253, 244, 227),
                          ),
                          onPressed: () {
                            // _openWhatsApp(contact['phone'].toString(), context);
                          }),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text('Text')
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Card(
              child: SizedBox(
                width: double.infinity,
                height: 190,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Contact Info',
                        style: TextStyle(fontSize: 17),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.call_outlined),
                          const SizedBox(
                            width: 15,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                contact['phone'],
                                style: const TextStyle(fontSize: 15),
                              ),
                              const Text(
                                'Phone: Default ',
                                style: TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                          const Spacer(),
                          const Icon(Icons.message_outlined),
                          const SizedBox(
                            width: 20,
                          )
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.mail_outline_outlined),
                          const SizedBox(
                            width: 15,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                contact['email'],
                                style: const TextStyle(fontSize: 15),
                              ),
                              const Text(
                                'Mail: Default ',
                                style: TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                          const Spacer(),
                          const Icon(Icons.message_outlined),
                          const SizedBox(
                            width: 20,
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _makePhoneCall(String number) async {
    bool? res = await FlutterPhoneDirectCaller.callNumber(number);
    if (res == null || !res) {}
  }
// void _openWhatsApp(String number, BuildContext context) async {
//   String url = "https://wa.me/91$number";
//   try {
//     if (await canLaunchUrlString(url)) {
//       await launchUrlString(url);
//     } else {
//       // Handle the case where WhatsApp is not installed or the URL cannot be launched
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("WhatsApp is not installed or the URL cannot be launched"),
//         ),
//       );
//     }
//   } catch (e) {
//     // Handle the PlatformException
//     print('Error opening WhatsApp: $e');
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text("Error opening WhatsApp"),
//       ),
//     );
//   }
// }
  void showDeleteAlert(BuildContext context, Id) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              "Delete Friend",
              style: TextStyle(),
            ),
            content: const Text(
              'Are You Sure You Want delete this friend?',
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'No',
                  )),
              TextButton(
                  onPressed: () {
                    deleteUser(Id);
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => NavBar()));
                  },
                  child: const Text('Yes'))
            ],
          );
        });
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> deleteUser(String docId) async {
    try {
      await _firestore.collection('contacts').doc(docId).delete();

      print(" deleted successfully.");
    } catch (e) {
      print("Error deleting doctor: $e");
    }
  }
}
