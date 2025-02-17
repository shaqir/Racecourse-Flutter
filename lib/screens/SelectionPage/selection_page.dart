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
import 'package:racecourse_tracks/core/utility/sharedpreferenceshelper.dart';
import 'package:racecourse_tracks/screens/SelectionPage/itemlistprovider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectionPage extends StatefulWidget {
  final Function(Set<Map<String, dynamic>>) onNavigateToDashboard;
  ItemListProvider provider;

  SelectionPage(
      {super.key, required this.provider, required this.onNavigateToDashboard});

  @override
  _SelectionPage createState() => _SelectionPage();
}

class _SelectionPage extends State<SelectionPage> {
  List<Map<String, dynamic>> _users = [];
  List<Map<String, dynamic>> _tempusers = [];
  String _selectedCountry = '';
  String _selectedState = '';
  bool isStateVisible = false;

  late String _selectedButton;
  int _selectedIndex = -1; // Track selected button index

  bool isDataLoaded = false;
  bool showTickbuttonOnlyOnce = false;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
    _selectedIndex = 0;
    _selectedCountry = _users.isNotEmpty ? _users.first!['Country'] : "All";
    _selectedState = "All";
    _selectedButton = "Gallops";

    _loadActionButtonState(); // Load the button state when the page is initialized
  }

  // Load the action button state from SharedPreferences
  _loadActionButtonState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      showTickbuttonOnlyOnce = prefs.getBool('showActionButton') ?? true;
      showTickbuttonOnlyOnce = false;
    });
  }

  // Save the action button state to SharedPreferences
  _setActionButtonState(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('showActionButton', value);
  }

  void fetchUserDataOnlyOnce(ItemListProvider provider) async {
    Set<Map<String, dynamic>> _loadselectedItems = {};
    _loadselectedItems = await SharedPreferencesHelper.getSetFromPreferences();
    isDataLoaded = true;
    if (_loadselectedItems.isEmpty) {
      return;
    }
    // provider.loadSelectedItems();
    provider.loadSelectedItems(_loadselectedItems);
  }

  Future<void> _fetchUsers() async {
    final tmpUsers =
        await FirestoreService.users; // Fetch users from FirestoreService

    tmpUsers.removeWhere((element) => element == Null || element.isEmpty);

    setState(() {
      _users = tmpUsers;
      _filterUsers(Provider.of<ItemListProvider>(context, listen: false));
    });
  }

  List<String> _getStatesForCountry(String country) {
    if (_selectedCountry.isNotEmpty && _selectedCountry != "All") {
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
      if (_selectedCountry.isNotEmpty &&
          _selectedCountry != "All" &&
          _selectedState.isNotEmpty &&
          _selectedState == "All") {
        _tempusers = _tempusers
            .where((user) =>
                user['Racecourse Type'] == _selectedButton &&
                user['Country'] == _selectedCountry)
            .toList();
      }

      // Country + Selected State
      if (_selectedCountry.isNotEmpty &&
          _selectedCountry != "All" &&
          _selectedState.isNotEmpty &&
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
      // provider.setDefaultSelected();
      // if (!isDataLoaded) {
      fetchUserDataOnlyOnce(provider);
      // }
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
    // Hide the button after it's clicked and save the state
    _setActionButtonState(false);

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
    var isClear = widget.provider.clearButtonEnabled;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.checkboxlist2Color,
        title: const Text(
          AppMenuButtonTitles.selectionScreen,
          style: AppFonts.title1,
        ),
        centerTitle: true,
        actions: [
          if (showTickbuttonOnlyOnce)
            IconButton(
              icon: const Icon(Icons.check, color: Colors.white),
              iconSize: 28,
              onPressed: () => _navigateToDashboard(widget.provider),
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
                color: AppColors.tablecontentBgColor
                    .withOpacity(0.05), // Background color
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    width: 0.5, //
                    color: Apputils().getColor(_selectedButton)),
              ),
              height: 88,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
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
                            AppMenuButtonTitles.gallops_field, widget.provider);
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
                            AppMenuButtonTitles.harness_field, widget.provider);
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
                            AppMenuButtonTitles.dogs_field, widget.provider);
                      },
                      raceCourseType: _selectedButton,
                    ),
                    ClearAllButton(
                      imagePath: AppImages.clearAllIconImage,
                      title: AppMenuButtonTitles.clear_all,
                      isSelected: isClear,
                      height: AppFonts.selectionMenuItemHeight,
                      onTap: () {
                        _clearAll(widget.provider);
                      },
                    ),
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
                color: AppColors.tablecontentBgColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    width: 0.5, //
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
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Flexible(
                          child: Container(
                            height: 40,
                            width: MediaQuery.of(context).size.width *
                                0.7, // 80% of screen width
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: AppColors.tablecontentBgColor
                                  .withOpacity(0.5),
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
                              underline: SizedBox(), //Disable underline
                              value: _selectedCountry,
                              alignment: Alignment.topLeft,
                              dropdownColor: Colors.white,
                              icon: Icon(
                                Icons.arrow_drop_down, // Change to any icon
                                size: 30.0, // Adjust icon size
                                color: Colors.black87,
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
                                _filterUsers(widget.provider); // Apply filters
                              },
                              items: [
                                "All",
                                ..._users
                                    .map((user) =>
                                        user['Country'] as String? ??
                                        "") // Provide a default value
                                    .toSet(),
                              ]
                                  .map(
                                    (country) => DropdownMenuItem<String>(
                                      value: country,
                                      child: Text(
                                        country.toUpperCase(),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.w500,
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
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Flexible(
                                child: Container(
                                  height: 40,
                                  width: MediaQuery.of(context).size.width *
                                      0.7, // 80% of screen width
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: AppColors.tablecontentBgColor
                                        .withOpacity(0.5),
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
                                    underline: SizedBox(), //Disable underline
                                    value: _selectedState,
                                    alignment: Alignment.topLeft,
                                    dropdownColor: Colors.white,
                                    icon: Icon(
                                      Icons
                                          .arrow_drop_down, // Change to any icon
                                      size: 30.0, // Adjust icon size
                                      color: Colors.black87,
                                    ),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _selectedState = newValue!;
                                      });
                                      _filterUsers(
                                          widget.provider); // Apply filters
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
                                                fontSize: 13.0,
                                                fontWeight: FontWeight.w500,
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
            // Expanded(
            //   child: Container(
            //     decoration: BoxDecoration(
            //       color: AppColors.tablecontentBgColor.withOpacity(0.05),
            //       borderRadius: BorderRadius.circular(5),
            //       border: Border.all(
            //           width: 0.5, //
            //           color: Apputils().getColor(_selectedButton)),
            //     ),
            //     margin: const EdgeInsets.all(8),
            //     child: Consumer<ItemListProvider>(
            //       builder: (context, itemListProvider, child) {
            //         return ListView.builder(
            //           itemCount: widget.provider.allItems.length,
            //           itemBuilder: (context, index) {
            //             final item = widget.provider.allItems.toList()[index];
            //             return ListTile(
            //               title: Row(
            //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                 children: [
            //                   Row(
            //                     mainAxisAlignment: MainAxisAlignment.start,
            //                     children: [
            //                       ElevatedButton(
            //                         style: ElevatedButton.styleFrom(
            //                           backgroundColor: Colors
            //                               .transparent, // Transparent background
            //                           shadowColor: Colors.transparent,
            //                           fixedSize: Size(25, 25),
            //                           minimumSize: Size(25, 25),
            //                           padding: EdgeInsets.all(2),
            //                         ),
            //                         onPressed: () {
            //                           itemListProvider.favoriteSelection(index,
            //                               item['isFavorite'] ? false : true);
            //                           if (item['isFavorite'] == true) {
            //                             itemListProvider.updateFavoriteList(
            //                                 item, true);
            //                           } else {
            //                             itemListProvider.updateFavoriteList(
            //                                 item, false);
            //                           }
            //                         },
            //                         child: Image.asset(
            //                           item['isFavorite']
            //                               ? AppImages.starIconSelectedImage
            //                               : AppImages.starIconImage,
            //                           width: 25,
            //                           height: 25,
            //                         ),
            //                       ),
            //                       SizedBox(
            //                         width: 8,
            //                       ),
            //                       Text(item['Racecourse'],
            //                           style: AppFonts.body5),
            //                     ],
            //                   ),
            //                   Spacer(),
            //                   Text(
            //                     item['Country'],
            //                     textAlign: TextAlign.right,
            //                     style: const TextStyle(
            //                       color: Colors.grey,
            //                       fontSize: 13.0,
            //                       fontWeight: FontWeight.w600,
            //                     ),
            //                   )
            //                 ],
            //               ),
            //               minVerticalPadding: 0,
            //               trailing: SizedBox(
            //                 width: 30,
            //                 height: 30,
            //                 child: Checkbox(
            //                   tristate: true,
            //                   activeColor: Apputils().getColor(_selectedButton),
            //                   checkColor: Colors.white,
            //                   side: BorderSide(
            //                       color: Apputils().getColor(_selectedButton),
            //                       width: 2),
            //                   value: item['isSelected'],
            //                   onChanged: (bool? value) {
            //                     if (widget.provider.selectedItems.length > 24 &&
            //                         value == true) {
            //                       ScaffoldMessenger.of(context).showSnackBar(
            //                         const SnackBar(
            //                           content: Text(
            //                               "You reached maximum racecourse limit."),
            //                           duration: Duration(milliseconds: 500),
            //                         ),
            //                       );
            //                     } else {
            //                       itemListProvider.toggleSelection(
            //                           index, value ?? false);
            //                       if (value == true) {
            //                         itemListProvider.updateSelectedList(
            //                             item, true);
            //                       } else {
            //                         itemListProvider.updateSelectedList(
            //                             item, false);
            //                       }

            //                       itemListProvider.toggleClearSelection(
            //                           widget.provider.selectedItems.isEmpty
            //                               ? false
            //                               : true);
            //                     }
            //                   },
            //                 ),
            //               ),
            //             );
            //           },
            //         );
            //       },
            //     ),
            //   ),
            // ),

            // Expanded(
            //   child: Container(
            //     decoration: BoxDecoration(
            //       color: AppColors.tablecontentBgColor.withOpacity(0.05),
            //       borderRadius: BorderRadius.circular(5),
            //       border: Border.all(
            //           width: 0.5, color: Apputils().getColor(_selectedButton)),
            //     ),
            //     margin: const EdgeInsets.all(8),
            //     child: Consumer<ItemListProvider>(
            //       builder: (context, itemListProvider, child) {
            //         // Separate favorites from other items
            //         List<Map<String, dynamic>> favoriteItems = widget
            //             .provider.allItems
            //             .where((item) => item['isFavorite'] == true)
            //             .toList();
            //         List<Map<String, dynamic>> otherItems = widget
            //             .provider.allItems
            //             .where((item) => item['isFavorite'] == false)
            //             .toList();

            //         // Sort favorites alphabetically by "Racecourse"
            //         favoriteItems.sort(
            //             (a, b) => a['Racecourse'].compareTo(b['Racecourse']));

            //         // Combine both lists, favorites first
            //         List<Map<String, dynamic>> sortedItems = [
            //           ...favoriteItems,
            //           ...otherItems
            //         ];

            //         return ListView.builder(
            //           itemCount: sortedItems.length +
            //               (favoriteItems.isNotEmpty
            //                   ? 1
            //                   : 0), // Extra item for "Favorite" section
            //           itemBuilder: (context, index) {
            //             if (favoriteItems.isNotEmpty && index == 0) {
            //               return Padding(
            //                 padding: const EdgeInsets.all(8.0),
            //                 child: Text(
            //                   "Favorites",
            //                   style: TextStyle(
            //                     fontSize: 16,
            //                     fontWeight: FontWeight.bold,
            //                     color: Colors.blueAccent,
            //                   ),
            //                 ),
            //               );
            //             }

            //             final item = sortedItems[
            //                 index - (favoriteItems.isNotEmpty ? 1 : 0)];

            //             return ListTile(
            //               title: Row(
            //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                 children: [
            //                   Row(
            //                     mainAxisAlignment: MainAxisAlignment.start,
            //                     children: [
            //                       ElevatedButton(
            //                         style: ElevatedButton.styleFrom(
            //                           backgroundColor: Colors.transparent,
            //                           shadowColor: Colors.transparent,
            //                           fixedSize: const Size(25, 25),
            //                           minimumSize: const Size(25, 25),
            //                           padding: const EdgeInsets.all(2),
            //                         ),
            //                         onPressed: () {
            //                           bool newFavoriteStatus =
            //                               !(item['isFavorite'] ?? false);
            //                           itemListProvider.favoriteSelection(
            //                               index, newFavoriteStatus);
            //                           itemListProvider.updateFavoriteList(
            //                               item, newFavoriteStatus);
            //                         },
            //                         child: Image.asset(
            //                           item['isFavorite']
            //                               ? AppImages.starIconSelectedImage
            //                               : AppImages.starIconImage,
            //                           width: 25,
            //                           height: 25,
            //                         ),
            //                       ),
            //                       const SizedBox(width: 8),
            //                       Text(item['Racecourse'],
            //                           style: AppFonts.body5),
            //                     ],
            //                   ),
            //                   const Spacer(),
            //                   Text(
            //                     item['Country'],
            //                     textAlign: TextAlign.right,
            //                     style: const TextStyle(
            //                       color: Colors.grey,
            //                       fontSize: 13.0,
            //                       fontWeight: FontWeight.w600,
            //                     ),
            //                   )
            //                 ],
            //               ),
            //               minVerticalPadding: 0,
            //               trailing: SizedBox(
            //                 width: 30,
            //                 height: 30,
            //                 child: Checkbox(
            //                   tristate: true,
            //                   activeColor: Apputils().getColor(_selectedButton),
            //                   checkColor: Colors.white,
            //                   side: BorderSide(
            //                       color: Apputils().getColor(_selectedButton),
            //                       width: 2),
            //                   value: item['isSelected'],
            //                   onChanged: (bool? value) {
            //                     if (widget.provider.selectedItems.length > 24 &&
            //                         value == true) {
            //                       ScaffoldMessenger.of(context).showSnackBar(
            //                         const SnackBar(
            //                           content: Text(
            //                               "You reached the maximum racecourse limit."),
            //                           duration: Duration(milliseconds: 500),
            //                         ),
            //                       );
            //                     } else {
            //                       itemListProvider.toggleSelection(
            //                           index, value ?? false);
            //                       itemListProvider.updateSelectedList(
            //                           item, value ?? false);
            //                       itemListProvider.toggleClearSelection(
            //                           widget.provider.selectedItems.isNotEmpty);
            //                     }
            //                   },
            //                 ),
            //               ),
            //             );
            //           },
            //         );
            //       },
            //     ),
            //   ),
            // ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.tablecontentBgColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                      width: 0.5, color: Apputils().getColor(_selectedButton)),
                ),
                margin: const EdgeInsets.all(8),
                child: Consumer<ItemListProvider>(
                  builder: (context, itemListProvider, child) {
                    // Separate favorites from other items
                    List<Map<String, dynamic>> favoriteItems = widget
                        .provider.allItems
                        .where((item) => item['isFavorite'] == true)
                        .toList();
                    List<Map<String, dynamic>> otherItems = widget
                        .provider.allItems
                        .where((item) => item['isFavorite'] == false)
                        .toList();

                    // Sort lists alphabetically by "Racecourse"
                    favoriteItems.sort(
                        (a, b) => a['Racecourse'].compareTo(b['Racecourse']));
                    otherItems.sort(
                        (a, b) => a['Racecourse'].compareTo(b['Racecourse']));

                    return ListView(
                      children: [
                        // Favorites Section
                        if (favoriteItems.isNotEmpty) ...[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Favorites",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                            ),
                          ),
                          ...favoriteItems.asMap().entries.map(
                                (entry) => buildListItem(
                                    entry.key, entry.value, itemListProvider),
                              ),
                        ],

                        // Other Section
                        if (otherItems.isNotEmpty) ...[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Other",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                            ),
                          ),
                          ...otherItems.asMap().entries.map(
                                (entry) => buildListItem(
                                  favoriteItems.length +
                                      entry.key, // Ensure index continuity
                                  entry.value,
                                  itemListProvider,
                                ),
                              ),
                        ],
                      ],
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

  Widget buildListItem(
      int index, Map<String, dynamic> item, ItemListProvider itemListProvider) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  fixedSize: const Size(25, 25),
                  minimumSize: const Size(25, 25),
                  padding: const EdgeInsets.all(2),
                ),
                onPressed: () {
                  bool newFavoriteStatus = !(item['isFavorite'] ?? false);
                  itemListProvider.favoriteSelection(item, newFavoriteStatus);
                  itemListProvider.updateFavoriteList(item, newFavoriteStatus);
                },
                child: Image.asset(
                  item['isFavorite']
                      ? AppImages.starIconSelectedImage
                      : AppImages.starIconImage,
                  width: 25,
                  height: 25,
                ),
              ),
              const SizedBox(width: 8),
              Text(item['Racecourse'], style: AppFonts.body5),
            ],
          ),
          const Spacer(),
          Text(
            item['Country'],
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 13.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      minVerticalPadding: 0,
      trailing: SizedBox(
        width: 30,
        height: 30,
        child: Checkbox(
          tristate: true,
          activeColor: Apputils().getColor(_selectedButton),
          checkColor: Colors.white,
          side: BorderSide(
            color: Apputils().getColor(_selectedButton),
            width: 2,
          ),
          value: item['isSelected'],
          onChanged: (bool? value) {
            if (itemListProvider.selectedItems.length > 24 && value == true) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("You reached the maximum racecourse limit."),
                  duration: Duration(milliseconds: 500),
                ),
              );
            } else {
              itemListProvider.toggleSelection(item, value ?? false);
              itemListProvider.updateSelectedList(item, value ?? false);
              itemListProvider.toggleClearSelection(
                  itemListProvider.selectedItems.isNotEmpty);
            }
          },
        ),
      ),
    );
  }
}
