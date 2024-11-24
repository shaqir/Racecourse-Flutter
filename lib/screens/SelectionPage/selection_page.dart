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
import 'dart:async';

class SelectionPage extends StatefulWidget {
  final Function(Set<Map<String, dynamic>>) onNavigateToDashboard;

  const SelectionPage({super.key, required this.onNavigateToDashboard});

  @override
  _SelectionPage createState() => _SelectionPage();
}

class _SelectionPage extends State<SelectionPage> {
  List<Map<String, dynamic>> _users = [];
  List<Map<String, dynamic>> _tempusers = [];
  late String _selectedButton;
  int _selectedIndex = -1; // Track selected button index

  bool filterOnlyOnce = false;
  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;
    _selectedButton = AppMenuButtonTitles.gallops_field;
  }

  void _filterUsers(ItemListProvider provider) {
    setState(() {
      _tempusers = _users
          .where((user) => user['Racecourse Type'] == _selectedButton)
          .map((user) => user)
          .toList();
      // Sort alphabetically by the "Racecourse" key
      _tempusers.sort((a, b) => a["Racecourse"].compareTo(b["Racecourse"]));
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
