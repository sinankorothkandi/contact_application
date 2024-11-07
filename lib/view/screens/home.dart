import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contact_app/view/screens/contact_form.dart';
import 'package:contact_app/view/screens/profile_details.dart';
import 'package:contact_app/view/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = '';

  void handleSearchQueryChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            search_fuction(handleSearchQueryChanged, searchController),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('contacts')
                    .orderBy('name')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ListView.builder(
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return const ShimmerListTile();
                      },
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final contactDocs = snapshot.data?.docs ?? [];
                  final favoriteContacts = contactDocs
                      .where((doc) => (doc['isFavorite'] ?? false) == true)
                      .toList();
                  final groupedContacts = _groupContacts(contactDocs);

                  return ListView(
                    children: [
                      if (favoriteContacts.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    size: 17,
                                  ),
                                  SizedBox(
                                    width: 7,
                                  ),
                                  Text(
                                    'Favorites',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ...favoriteContacts.map((contactDoc) {
                              final contactData =
                                  contactDoc.data() as Map<String, dynamic>;
                              return ContactListTile(contactData: contactData);
                            }),
                          ],
                        ),
                      ...groupedContacts.keys.map((letter) {
                        final contacts = groupedContacts[letter]!;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Text(
                                letter,
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            ...contacts.map((contactDoc) {
                              final contactData =
                                  contactDoc.data() as Map<String, dynamic>;
                              return ContactListTile(contactData: contactData);
                            }),
                          ],
                        );
                      }),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ContactFormScreen()),
          );
        },
        backgroundColor: const Color.fromARGB(135, 160, 123, 0),
        child: const Icon(
          Icons.add,
          color: Color.fromARGB(255, 255, 196, 1),
        ),
      ),
    );
  }

  Map<String, List<QueryDocumentSnapshot>> _groupContacts(
      List<QueryDocumentSnapshot> contacts) {
    final Map<String, List<QueryDocumentSnapshot>> groupedContacts = {};

    for (var doc in contacts) {
      final contactData = doc.data() as Map<String, dynamic>;
      final name = contactData['name'] ?? '';
      if (name.isEmpty) continue;

      // Convert the first letter to uppercase for consistent grouping
      final firstLetter = name[0].toUpperCase();
      groupedContacts.putIfAbsent(firstLetter, () => []).add(doc);
    }

    return groupedContacts;
  }
}

class ShimmerListTile extends StatelessWidget {
  const ShimmerListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color.fromARGB(255, 37, 37, 37),
      highlightColor: const Color.fromARGB(255, 82, 81, 81),
      child: ListTile(
        leading: const CircleAvatar(radius: 20),
        title: Container(
          width: 100,
          height: 25,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 46, 46, 46),
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        trailing: const Icon(Icons.navigate_next),
      ),
    );
  }
}

class ContactListTile extends StatelessWidget {
  const ContactListTile({
    super.key,
    required this.contactData,
  });

  final Map<String, dynamic> contactData;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 20,
        backgroundColor:
            Colors.primaries[Random().nextInt(Colors.primaries.length)],
        child: Text(
          contactData['name'].isNotEmpty
              ? contactData['name'].substring(0, 1).toUpperCase()
              : '',
          style: const TextStyle(fontSize: 20),
        ),
      ),
      title: Text(
        contactData['name'],
        style: GoogleFonts.poppins(),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ContactDetailsScreen(
              contact: contactData,
            ),
          ),
        );
      },
    );
  }
}
