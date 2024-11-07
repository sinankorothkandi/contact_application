import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contact_app/view/screens/contact_form.dart';
import 'package:contact_app/view/screens/profile_details.dart';
import 'package:contact_app/view/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class FavoritesView extends StatefulWidget {
  const FavoritesView({super.key});

  @override
  State<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
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
            const SizedBox(
              height: 20,
            ),
            search_fuction(handleSearchQueryChanged, searchController),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('contacts')
                    .where('name', isGreaterThanOrEqualTo: _searchQuery)
                    .where('name', isLessThanOrEqualTo: '$_searchQuery\uf8ff')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ListView.builder(
                      itemCount: 15,
                      itemBuilder: (context, index) {
                        return const ShimmerListTile();
                      },
                    );
                  }

                  if (snapshot.hasError) {
                    String errorMessage = 'Error: ${snapshot.error}';
                    if (snapshot.error
                        .toString()
                        .contains('FAILED_PRECONDITION')) {
                      errorMessage =
                          'The query requires an index. You can create it here: https://console.firebase.google.com/v1/r/project/contact--application/firestore/indexes?create_composite=ClVwcm9qZWN0cy9jb250YWN0LS1hcHBsaWNhdGlvbi9kYXRhYmFzZXMvKGRlZmF1bHQpL2NvbGxlY3Rpb25Hcm91cHMvY29udGFjdHMvaW5kZXhlcy9fEAEaDgoKaXNGYXZvcml0ZRABGggKBG5hbWUQARoMCghfX25hbWVfXxAB';
                    }
                    return Center(child: Text(errorMessage));
                  }

                  final contactDocs = snapshot.data?.docs ?? [];
                  final favoriteContacts = contactDocs.where((doc) {
                    final contactData = doc.data() as Map<String, dynamic>;
                    return contactData['isFavorite'] == true;
                  }).toList();

                  if (favoriteContacts.isEmpty) {
                    // Display message if no favorite contacts
                    return const Center(
                      child: Text(
                        'There No Favorite Contacts',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                    child: ListView.builder(
                      itemCount: favoriteContacts.length,
                      itemBuilder: (context, index) {
                        final doc = favoriteContacts[index];
                        final contactData = doc.data() as Map<String, dynamic>;
                        return ContactListTile(
                          contactData: contactData,
                          heroTag: 'contact_$index',
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
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
    required this.heroTag,
  });

  final Map<String, dynamic> contactData;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Hero(
        tag: heroTag,
        child: CircleAvatar(
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
