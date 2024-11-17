import 'package:flutter/material.dart';
import 'package:racecourse_tracks/core/appcolors.dart';
import 'package:racecourse_tracks/core/firestoreservice.dart';

class SelectionPage extends StatefulWidget {
  const SelectionPage({super.key});

  @override
  _SelectionPage createState() => _SelectionPage();
}

class _SelectionPage extends State<SelectionPage> {
  final TextEditingController _searchController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();

  List<Map<String, dynamic>> _users = [];
  List<String> _filteredItems = [];
  final Set<String> _selectedItems = {};

  @override
  void initState() {
    super.initState();

    // Initialize search listener
    _searchController.addListener(_filterUsers);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterUsers);
    _searchController.dispose();
    super.dispose();
  }

  void _filterUsers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredItems = query.isEmpty
          ? _users.map((user) => user['Address'].toString()).toList()
          : _users
              .where((user) =>
                  user['Address'].toString().toLowerCase().contains(query))
              .map((user) => user['Address'].toString())
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryLightBgColor,
        title: const Text(
          'Selection Page',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: AppColors.primaryLightBgColor,
        margin: const EdgeInsets.only(bottom: 0),
        child: Column(
          children: [
            // Search field
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                
                decoration: InputDecoration(
                  hintText: 'Search Racecourse',
                  filled: true,
                  fillColor: Colors.black12,
                  enabledBorder: const OutlineInputBorder(
                    borderSide:
                         BorderSide(color: Colors.black, width: 1.0),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
            ),
            // Action buttons
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Handle Gallops button click
                    },
                    child: const Text('Gallops'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Handle Harness button click
                    },
                    child: const Text('Harness'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Handle Doges button click
                    },
                    child: const Text('Doges'),
                  ),
                ],
              ),
            ),
            // List of users
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream:
                    _firestoreService.getUsers(), // Replace with your stream
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No users found"));
                  }

                  // Update the users list only if necessary
                  if (_users.isEmpty) {
                    _users = snapshot.data!;
                    _filteredItems = _users
                        .map((user) => user['Address'].toString())
                        .toList();
                  }

                  return ListView.builder(
                    itemCount: _filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = _filteredItems[index];

                      return StatefulBuilder(
                        builder: (context, setStateForItem) {
                          final isSelected = _selectedItems.contains(item);

                          return ListTile(
                            title: Text(item,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                )),
                            trailing: Checkbox(
                              activeColor: Colors.black,
                              checkColor: Colors.white,
                              side: const BorderSide(
                                  color: Colors.black, width: 2),
                              value: isSelected,
                              onChanged: (bool? value) {
                                setStateForItem(() {
                                  if (value == true) {
                                    _selectedItems.add(item);
                                  } else {
                                    _selectedItems.remove(item);
                                  }
                                });
                              },
                            ),
                            onTap: () {
                              setStateForItem(() {
                                if (isSelected) {
                                  _selectedItems.remove(item);
                                } else {
                                  _selectedItems.add(item);
                                }
                              });
                            },
                          );
                        },
                      );
                    },
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
