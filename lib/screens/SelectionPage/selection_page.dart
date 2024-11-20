import 'package:flutter/material.dart';
import 'package:racecourse_tracks/core/appcolors.dart';
import 'package:racecourse_tracks/core/appimages.dart';
import 'package:racecourse_tracks/core/firestoreservice.dart';
import 'package:racecourse_tracks/core/selectableImagebutton.dart';

class SelectionPage extends StatefulWidget {
  const SelectionPage({super.key});

  @override
  _SelectionPage createState() => _SelectionPage();
}

class _SelectionPage extends State<SelectionPage> {
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _users = [];
  List<String> _filteredItems = [];
  final Set<String> _selectedItems = {};
  String _selectedButton = 'Gallops';
  int _selectedIndex = -1; // Track selected button index

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
      _filteredItems = _users
          .where((user) =>
              user['Racecourse Type'] ==
                  _selectedButton && // Filter by selected button
              (query.isEmpty ||
                  user['Racecourse'].toString().toLowerCase().contains(query)))
          .map((user) => user['Racecourse'].toString())
          .toList();
    });
  }

  void _filterByRacecourseType(String type) {
    setState(() {
      _selectedButton = type;
      _filterUsers(); // Update the filtered list when the button changes
    });
  }
  void _selectButton(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryLightBgColor,
        title: const Text(
          'Select RaceCourse',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.0,
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
            /*
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Search Racecourse...',
                  hintStyle:
                      const TextStyle(color: AppColors.checkboxlist1Color),
                  prefixIcon: const Icon(Icons.search),
                  prefixIconColor: AppColors.checkboxlist1Color,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.green,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(
                      color: AppColors.primaryDarkBlueColor,
                      width: 2.0,
                    ),
                  ),
                  iconColor: AppColors.primaryDarkBlueColor,
                ),
              ),
            ),
            */
            // Action buttons
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SelectableImageButton(
                    imagePath: AppImages.gallopsIconImage,
                    title: 'Gallops',
                    isSelected: _selectedIndex == 0,
                    height: 75,
                    onTap: () {
                       _selectButton(0);
                      _filterByRacecourseType('Gallops');
                    },
                  ),
                  SelectableImageButton(
                    imagePath: AppImages.hornessIconImage,
                    title: 'Harness',
                    isSelected: _selectedIndex == 1,
                    height: 75,
                    onTap: () {
                       _selectButton(1);
                      _filterByRacecourseType('Harness');
                    },
                  ),
                  SelectableImageButton(
                    imagePath: AppImages.dogsIconImage,
                    title: 'Dogs',
                    isSelected: _selectedIndex == 2,
                    height: 75,
                    onTap: () {
                       _selectButton(2);
                      _filterByRacecourseType('Dogs');
                    },
                  ),
                ],
              ),
            ),
            
            // List of users
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.tablecontentBgColor,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                      width: 0.5, //
                      color: AppColors.primaryLightBgColor),
                ),
                margin: const EdgeInsets.all(8),
                child: StreamBuilder<List<Map<String, dynamic>>>(
                  stream: FirestoreService()
                      .getUsers1(), // Replace with your stream
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text("No users found"));
                    }

                    // Update the users list only if necessary
                    if (_users.isEmpty) {
                      _users = FirestoreService.users;
                      _filteredItems = _users
                          .map((user) => user['Racecourse'].toString())
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
                                activeColor: AppColors.checkboxlist2Color,
                                checkColor: Colors.white,
                                side: const BorderSide(
                                    color: AppColors.checkboxlist2Color,
                                    width: 2),
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
            ),
          ],
        ),
      ),
    );
  }
}
