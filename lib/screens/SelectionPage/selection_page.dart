import 'package:flutter/material.dart';
import 'package:racecourse_tracks/core/common/appcolors.dart';
import 'package:racecourse_tracks/core/common/appfonts.dart';
import 'package:racecourse_tracks/core/common/appimages.dart';
import 'package:racecourse_tracks/core/common/appmenubuttontitles.dart';
import 'package:racecourse_tracks/core/utility/firestoreservice.dart';
import 'package:racecourse_tracks/core/utility/selectableImagebutton.dart';

class SelectionPage extends StatefulWidget {
  final Function(Set<Map<String, dynamic>>) onNavigateToDashboard;

  const SelectionPage({super.key, required this.onNavigateToDashboard});

  @override
  _SelectionPage createState() => _SelectionPage();
}

class _SelectionPage extends State<SelectionPage> {
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _users = [];
  List<Map<String, dynamic>> _filteredItems = [];
  final Set<Map<String, dynamic>> _selectedItems = {};
  String _selectedButton = 'Gallops';
  int _selectedIndex = -1; // Track selected button index

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterUsers);
    _selectedIndex = 0;
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
          .map((user) => user)
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

  void _navigateToDashboard() {
    if (_selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select at least one item."),
        ),
      );
    } else {
      widget.onNavigateToDashboard(
          _selectedItems); // Use the callback to trigger navigation
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          AppMenuButtonTitles.selectionScreen,
          style: AppFonts.title1,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.white),
            iconSize: 28,
            onPressed: () => _navigateToDashboard(),
          ),
        ],
      ),
      body: Container(
        color: AppColors.primaryLightBgColor,
        child: Column(
          children: [
            // Action buttons
            Container(
              margin: EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: AppColors.tablecontentBgColor, // Background color
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                      width: 1, //
                      color: AppColors.rectangleBoxColor),
                
              ),
              height: 100,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SelectableImageButton(
                      imagePath: AppImages.gallopsIconImage,
                      title: AppMenuButtonTitles.gallops,
                      isSelected: _selectedIndex == 0,
                      height: AppFonts.selectionMenuItemHeight,
                      onTap: () {
                        _selectButton(0);
                        _filterByRacecourseType(AppMenuButtonTitles.gallops_field);
                      },
                    ),
                    SelectableImageButton(
                      imagePath: AppImages.harnessIconImage,
                      title: AppMenuButtonTitles.harness,
                      isSelected: _selectedIndex == 1,
                      height: AppFonts.selectionMenuItemHeight,
                      onTap: () {
                        _selectButton(1);
                        _filterByRacecourseType(AppMenuButtonTitles.harness_field);
                      },
                    ),
                    SelectableImageButton(
                      imagePath: AppImages.dogsIconImage,
                      title: AppMenuButtonTitles.dogs,
                      isSelected: _selectedIndex == 2,
                      height: AppFonts.selectionMenuItemHeight,
                      onTap: () {
                        _selectButton(2);
                        _filterByRacecourseType(AppMenuButtonTitles.dogs_field);
                      },
                    ),
                  ],
                ),
              ),
            ),
            // List of users
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.tablecontentBgColor,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                      width: 1, //
                      color: AppColors.rectangleBoxColor),
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
                      _filteredItems = _users.map((user) => user).toList();
                    }

                    return ListView.builder(
                      itemCount: _filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = _filteredItems[index];

                        return StatefulBuilder(
                          builder: (context, setStateForItem) {
                            final isSelected = _selectedItems.contains(item);
                            return ListTile(
                              title: Text(item['Racecourse'],
                                  style: AppFonts.body2),
                              minVerticalPadding: 0,    
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

// class DashboardScreen extends StatelessWidget {
//   final Set<Map<String, dynamic>> selectedItems;

//   const DashboardScreen({super.key, required this.selectedItems});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Dashboard")),
//       body: ListView(
//         children: selectedItems
//             .map((item) => ListTile(title: Text(item['Racecourse'])))
//             .toList(),
//       ),
//     );
//   }
// }
