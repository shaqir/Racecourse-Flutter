import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:racecourse_tracks/core/common/appcolors.dart';
import 'package:racecourse_tracks/core/common/appfonts.dart';
import 'package:racecourse_tracks/core/common/appimages.dart';
import 'package:racecourse_tracks/core/common/appmenubuttontitles.dart';
import 'package:racecourse_tracks/core/utility/apputils.dart';
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
  bool isStateVisible = false;

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
      //All Countries
      _tempusers = _users
          .where((user) => user['Racecourse Type'] == _selectedButton)
          .toList();

      // Country + All State
      if (_selectedCountry != null &&
          _selectedCountry != "All" &&
          _selectedState != null &&
          _selectedState == "All") {
        _tempusers = _tempusers
            .where((user) =>
                user['Racecourse Type'] == _selectedButton &&
                user['Country'] == _selectedCountry)
            .toList();
      }

      // Country + Selected State
      if (_selectedCountry != null &&
          _selectedCountry != "All" &&
          _selectedState != null &&
          _selectedState != "All") {
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
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(
              height: 4,
            ),
            // Action buttons
            Container(
              margin: EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: AppColors.tablecontentBgColor, // Background color
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    width: 1, //
                    color: Apputils().getColor(_selectedButton)),
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
                      raceCourseType: _selectedButton,
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
                      raceCourseType: _selectedButton,
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
                      raceCourseType: _selectedButton,
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
            SizedBox(
              height: 8,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: AppColors.tablecontentBgColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    width: 1, //
                    color: Apputils().getColor(_selectedButton)),
              ),
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Country Dropdown
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width *
                              0.2, // 80% of screen width
                          child: Text(
                            'Country'.toUpperCase(),
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Flexible(
                          child: Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width *
                                0.7, // 80% of screen width
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: AppColors.rectangleBoxColor,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                width: 0.5,
                                color: Colors.black,
                              ),
                            ),
                            child: DropdownButton<String>(
                              menuWidth:
                                  MediaQuery.of(context).size.width * 0.5,
                              isExpanded: true,
                              value: _selectedCountry,
                              alignment: Alignment.topLeft,
                              dropdownColor: Colors.white,
                              icon: Icon(
                                Icons.arrow_drop_down, // Change to any icon
                                size: 35.0, // Adjust icon size
                                color: Colors.black,
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedCountry = newValue!;
                                  if (_selectedCountry == 'All') {
                                    isStateVisible = false;
                                  } else {
                                    isStateVisible = true;
                                  }
                                  _selectedState =
                                      "All"; // Reset state to "All" when country changes
                                });
                                _filterUsers(
                                    _itemListProvider); // Apply filters
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
                                        country.toUpperCase(),
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
                  SizedBox(
                    height: isStateVisible ? 16 : 0,
                  ),
                  isStateVisible
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // State Dropdown
                              const SizedBox(height: 8),
                              SizedBox(
                                width: MediaQuery.of(context).size.width *
                                    0.2, // 80% of screen width
                                child: Text(
                                  'State'.toUpperCase(),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Flexible(
                                child: Container(
                                  height: 50,
                                  width: MediaQuery.of(context).size.width *
                                      0.7, // 80% of screen width
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: AppColors.rectangleBoxColor,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      width: 0.5,
                                      color: Colors.black,
                                    ),
                                  ),
                                  child: DropdownButton<String>(
                                    menuWidth:
                                        MediaQuery.of(context).size.width * 0.5,
                                    isExpanded: true,
                                    value: _selectedState,
                                    alignment: Alignment.topLeft,
                                    dropdownColor: Colors.white,
                                    icon: Icon(
                                      Icons
                                          .arrow_drop_down, // Change to any icon
                                      size: 35.0, // Adjust icon size
                                      color: Colors.black,
                                    ),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _selectedState = newValue!;
                                      });
                                      _filterUsers(
                                          _itemListProvider); // Apply filters
                                    },
                                    items: [
                                      "All",
                                      ...(_selectedCountry != null
                                          ? _getStatesForCountry(
                                              _selectedCountry!)
                                          : [])
                                    ]
                                        .map(
                                          (state) => DropdownMenuItem<String>(
                                            value: state,
                                            child: Text(
                                              state.toUpperCase(),
                                              textAlign: TextAlign.right,
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
                        )
                      : Container(
                          width: 0,
                          height: 0,
                        )
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
                      width: 1, //
                      color: Apputils().getColor(_selectedButton)),
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
                                  style: AppFonts.body5),
                              minVerticalPadding: 0,
                              trailing: Checkbox(
                                tristate: true,
                                activeColor: Apputils().getColor(_selectedButton),
                                checkColor: Colors.white,
                                side:  BorderSide(
                                    color: Apputils().getColor(_selectedButton),
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
