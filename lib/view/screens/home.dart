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

  void _handleSearchQueryChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 40),
          SearchBarWidget(
            onSearchQueryChanged: _handleSearchQueryChanged,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.78,
            width: double.infinity,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('contacts')
                  .where('name', isGreaterThanOrEqualTo: _searchQuery)
                  .where('name', isLessThanOrEqualTo: '$_searchQuery\uf8ff')
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
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: ListView.builder(
                    itemCount: contactDocs.length,
                    itemBuilder: (context, index) {
                      final doc = contactDocs[index];
                      final contactData = doc.data() as Map<String, dynamic>;
                      return ContactListTile(contactData: contactData);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ContactFormScreen()),
          );
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
      ),
    );
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
        leading: const CircleAvatar(
          radius: 20,
        ),
        title: Container(
          width: 100,
          height: 25,
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 46, 46, 46),
              borderRadius: BorderRadius.circular(30)),
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
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
      ),
      title: Text(
        contactData['name'],
        style: GoogleFonts.poppins(),
      ),
      trailing: const Icon(Icons.navigate_next),
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
