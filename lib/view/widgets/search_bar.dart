 import 'package:flutter/material.dart';
Padding search_fuction(handleSearchQueryChanged,searchController) {
    return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: TextField(
              controller: searchController,
              onChanged: handleSearchQueryChanged,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search,
                    color: Color.fromARGB(255, 143, 143, 143)),
                hintText: 'Search Contacts',
                hintStyle: const TextStyle(
                    color: Color.fromARGB(255, 143, 143, 143)),
                filled: true,
                fillColor: const Color.fromARGB(59, 122, 94, 0),
                contentPadding: const EdgeInsets.symmetric(vertical: 15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: const Padding(
                  padding: EdgeInsets.all(5.0),
                  child: CircleAvatar(
                    radius: 11,
                    backgroundColor: Color.fromARGB(225, 197, 151, 0),
                    child: Text(
                      'F',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ),
              ),
              textAlignVertical: TextAlignVertical.center,
            ),
          );
  }