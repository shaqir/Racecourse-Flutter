import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:racecourse_tracks/core/common/appcolors.dart';
import 'package:racecourse_tracks/core/common/appfonts.dart';
import 'package:racecourse_tracks/core/common/appimages.dart';
import 'package:racecourse_tracks/core/common/appmenubuttontitles.dart';
import 'package:racecourse_tracks/core/utility/clearallbutton.dart';
import 'package:racecourse_tracks/core/utility/firestoreservice.dart';
import 'package:racecourse_tracks/core/utility/selectableImagebutton.dart';
import 'package:racecourse_tracks/screens/SelectionPage/itemlistprovider.dart';

class SelectionPage extends StatefulWidget {
  final Function(Set<Map<String, dynamic>>) onNavigateToDashboard;

  const SelectionPage({super.key, required this.onNavigateToDashboard});

  @override
  _SelectionPage createState() => _SelectionPage();
}

class _SelectionPage extends State<SelectionPage> {
  List<Map<String, dynamic>> _users = [];
  List<Map<String, dynamic>> _tempusers = [];
  String? _selectedCountry;
  String? _selectedState;

  late String _selectedButton;
  int _selectedIndex = -1; // Track selected button index

  bool filterOnlyOnce = false;
  @override
  void initState() {
    super.initState();
    _selectedCountry = _users.isNotEmpty ? _users.first['Country'] : "All";
    _selectedState = "All";
    _selectedIndex = 0;
    _selectedButton = AppMenuButtonTitles.gallops_field;
  }

  List<String> _getStatesForCountry(String country) {
    if (_selectedCountry != null && _selectedCountry != "All") {
      return _users
          .where((user) => user['Country'] == country)
          .map((user) => user['State'] as String)
          .toSet()
          .toList();
    } else {
      return _users.map((user) => user['State'] as String).toSet().toList();
    }
  }

  void _filterUsers(ItemListProvider provider) {
    setState(() {
      // Start with filtering by racecourse type
      _tempusers = _users
          .where((user) => user['Racecourse Type'] == _selectedButton)
          .toList();

      // Apply country filter if a specific country is selected
      if (_selectedCountry != null && _selectedCountry != "All") {
        _tempusers = _tempusers
            .where((user) =>
                user['Racecourse Type'] == _selectedButton &&
                user['Country'] == _selectedCountry)
            .toList();
      }

      // Apply state filter if a specific state is selected
      if (_selectedState != null && _selectedState != "All") {
        _tempusers = _tempusers
            .where((user) =>
                user['Racecourse Type'] == _selectedButton &&
                user['Country'] == _selectedCountry &&
                user['State'] == _selectedState)
            .toList();
      }

      // Sort alphabetically by "Racecourse"
      _tempusers.sort((a, b) => a["Racecourse"].compareTo(b["Racecourse"]));

      // Update provider
      provider.setAllItems(_tempusers.toSet());
      provider.resetAll();
      provider.setDefaultSelected();
    });
  }

  void _filterByRacecourseType(String type, ItemListProvider provider) {
    setState(() {
      _selectedButton = type;
      _filterUsers(
          provider); // Update the filtered list when the button changes
    });
  }

  void _clearAll(ItemListProvider provider) {
    setState(() {
      provider.resetSelectedItems();
      provider.resetAll();
      provider.toggleClearSelection(false);
    });
  }

  void _selectButton(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _navigateToDashboard(ItemListProvider provider) {
    if (provider.selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select at least one item."),
        ),
      );
    } else {
      widget.onNavigateToDashboard(
          provider.selectedItems); // Use the callback to trigger navigation
    }
  }

  @override
  Widget build(BuildContext context) {
    final _itemListProvider =
        Provider.of<ItemListProvider>(context, listen: false);
    var isClear = _itemListProvider.clearButtonEnabled;
    // Default listen: true
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
            onPressed: () => _navigateToDashboard(_itemListProvider),
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
                        _filterByRacecourseType(
                            AppMenuButtonTitles.gallops_field,
                            _itemListProvider);
                      },
                    ),
                    SelectableImageButton(
                      imagePath: AppImages.harnessIconImage,
                      title: AppMenuButtonTitles.harness,
                      isSelected: _selectedIndex == 1,
                      height: AppFonts.selectionMenuItemHeight,
                      onTap: () {
                        _selectButton(1);
                        _filterByRacecourseType(
                            AppMenuButtonTitles.harness_field,
                            _itemListProvider);
                      },
                    ),
                    SelectableImageButton(
                      imagePath: AppImages.dogsIconImage,
                      title: AppMenuButtonTitles.dogs,
                      isSelected: _selectedIndex == 2,
                      height: AppFonts.selectionMenuItemHeight,
                      onTap: () {
                        _selectButton(2);
                        _filterByRacecourseType(
                            AppMenuButtonTitles.dogs_field, _itemListProvider);
                      },
                    ),
                    ClearAllButton(
                      title: AppMenuButtonTitles.clear_all,
                      isSelected: isClear,
                      height: AppFonts.selectionMenuItemHeight,
                      onTap: () {
                        _clearAll(_itemListProvider);
                      },
                    )
                  ],
                ),
              ),
            ),
            Center(
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryDarkBlueColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Country Dropdown
                    Text(
                      'Select Country',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 50,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.rectangleBoxColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          width: 1,
                          color: AppColors.selectedDarkBrownColor,
                        ),
                      ),
                      child: Center(
                        child: DropdownButton<String>(
                          value: _selectedCountry,
                          dropdownColor: Colors.white,
                          elevation: 10,
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedCountry = newValue!;
                              _selectedState =
                                  "All"; // Reset state to "All" when country changes
                            });
                            _filterUsers(_itemListProvider); // Apply filters
                          },
                          items: [
                            "All",
                            ..._users
                                .map((user) => user['Country'] as String)
                                .toSet()
                          ]
                              .map(
                                (country) => DropdownMenuItem<String>(
                                  value: country,
                                  child: Text(
                                    country,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // State Dropdown
                    Text(
                      'Select State',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 50,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.rectangleBoxColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          width: 1,
                          color: AppColors.selectedDarkBrownColor,
                        ),
                      ),
                      child: Center(
                        child: DropdownButton<String>(
                          value: _selectedState,
                          dropdownColor: Colors.white,
                          elevation: 10,
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedState = newValue!;
                            });
                            _filterUsers(_itemListProvider); // Apply filters
                          },
                          items: [
                            "All",
                            ...(_selectedCountry != null
                                ? _getStatesForCountry(_selectedCountry!)
                                : [])
                          ]
                              .map(
                                (state) => DropdownMenuItem<String>(
                                  value: state,
                                  child: Text(
                                    state,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
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

                    if (_users.isEmpty) {
                      _users = FirestoreService.users;
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _itemListProvider.setAllItems(
                            _users.map((user) => user).toList().toSet());
                        _itemListProvider.resetAll();
                        _filterByRacecourseType(
                            AppMenuButtonTitles.gallops_field,
                            _itemListProvider);
                        _itemListProvider.setDefaultSelected();
                      });
                    }
                    return Consumer<ItemListProvider>(
                      builder: (context, itemListProvider, child) {
                        return ListView.builder(
                          itemCount: _itemListProvider.allItems.length,
                          itemBuilder: (context, index) {
                            final item =
                                _itemListProvider.allItems.toList()[index];
                            return ListTile(
                              title: Text(item['Racecourse'],
                                  style: AppFonts.body2),
                              minVerticalPadding: 0,
                              trailing: Checkbox(
                                tristate: true,
                                activeColor: AppColors.checkboxlist2Color,
                                checkColor: Colors.white,
                                side: const BorderSide(
                                    color: AppColors.checkboxlist2Color,
                                    width: 2),
                                value: item['isSelected'],
                                onChanged: (bool? value) {
                                  itemListProvider.toggleSelection(
                                      index, value ?? false);
                                  if (value == true) {
                                    itemListProvider.updateSelectedList(
                                        item, true);
                                  } else {
                                    itemListProvider.updateSelectedList(
                                        item, false);
                                  }

                                  itemListProvider.toggleClearSelection(
                                      _itemListProvider.selectedItems.isEmpty
                                          ? false
                                          : true);
                                },
                              ),
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
