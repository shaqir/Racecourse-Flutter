import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:racecourse_tracks/ui/core/theme/appcolors.dart';
import 'package:racecourse_tracks/ui/core/theme/appfonts.dart';
import 'package:racecourse_tracks/ui/core/theme/appimages.dart';
import 'package:racecourse_tracks/config/appmenubuttontitles.dart';
import 'package:racecourse_tracks/ui/selection/view_model/selection_view_model.dart';
import 'package:racecourse_tracks/utils/apputils.dart';
import 'package:racecourse_tracks/ui/core/ui/clearallbutton.dart';
import 'package:racecourse_tracks/ui/core/ui/selectable_image_button.dart';
import 'package:racecourse_tracks/ui/subscription/widgets/user_subscription_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectionScreen extends StatefulWidget {
  final Function(Set<Map<String, dynamic>>) onNavigateToDashboard;

  const SelectionScreen({super.key, required this.onNavigateToDashboard, required this.viewModel});
  final SelectionViewModel viewModel;

  @override
  State<SelectionScreen> createState() => _SelectionPage();
}

class _SelectionPage extends State<SelectionScreen> {
  //List<Map<String, dynamic>> _racecourses = [];
  List<Map<String, dynamic>> _tempRacecources = [];
  String _selectedCountry = '';
  String _selectedState = '';
  bool isStateVisible = false;

  late String _selectedButton;
  int _selectedIndex = -1; // Track selected button index

  bool isDataLoaded = false;
  bool showTickbuttonOnlyOnce = false;
  bool showSearchBar = false;
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    widget.viewModel.init(); // Initialize the view model
    _selectedIndex = 0;
    _selectedCountry = "All";
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

  List<String> _getStatesForCountry(String country) {
    if (_selectedCountry.isNotEmpty && _selectedCountry != "All") {
      return widget.viewModel
          .allItems
          .where((user) => user['Country'] == country)
          .where((user) => user['Racecourse Type'] == _selectedButton)
          .map((user) => user['State'] as String)
          .toSet()
          .toList();
    } else {
      return widget.viewModel.allItems.map((user) => user['State'] as String).toSet().toList();
    }
  }

  void _filterByRacecourseType(String type) {
    setState(() {
      _selectedButton = type;
      if(!widget.viewModel.allItems.any((item) => item['Racecourse Type'] == _selectedButton && item['Country'] == _selectedCountry)) {
        _selectedCountry = "All"; // Reset country if no items match
      }
      if(!widget.viewModel.allItems.any((item) => item['Racecourse Type'] == _selectedButton && item['State'] == _selectedState)) {
        _selectedState = "All"; // Reset state if no items match
      }
    });
  }

  void _clearAll() {
    widget.viewModel.resetSelectedItems();
    widget.viewModel.resetAll();
    widget.viewModel
        .toggleClearSelection();
  }

  void _selectButton(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _navigateToDashboard() {
    // Hide the button after it's clicked and save the state
    _setActionButtonState(false);

    if (widget.viewModel
        .savedItems
        .isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select at least one item."),
        ),
      );
    } else {
      widget.onNavigateToDashboard(
          widget.viewModel
              .savedItems); // Use the callback to trigger navigation
    }
  }

  @override
  Widget build(BuildContext context) {
    var isClear = widget.viewModel
        .clearButtonEnabled;

    return Scaffold(
      appBar: AppBar(
        leading: UserSubscriptionWidget(),
        backgroundColor: AppColors.checkboxlist2Color,
        title: const Text(
          'Select Courses',
          style: AppFonts.title1,
        ),
        centerTitle: true,
        actions: [
          if (showTickbuttonOnlyOnce)
            IconButton(
              icon: const Icon(Icons.check, color: Colors.white),
              iconSize: 28,
              onPressed: () => _navigateToDashboard(),
            ),
          if(!showSearchBar)
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              iconSize: 28,
              onPressed: () {
                setState(() {
                  showSearchBar = true;
                });
              },
            ),
        ],
        bottom: showSearchBar ? PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              autofocus: true,
              decoration: InputDecoration(
                // suffix icon to close the search bar
                suffixIcon: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      showSearchBar = false;
                      _searchText = '';
                    });
                  },
                ),
                hintText: 'Search...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                // Implement search functionality here
                setState(() {
                  _searchText = value;
                });
              },
            ),
          ),
        ) : null,
      ),
      body: ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, _) {
          if(widget.viewModel.isLoading) {
            return Center(child: CircularProgressIndicator(color: ColorScheme.of(context).primary,));
          }
          return Container(
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
                        .withValues(alpha: 0.05), // Background color
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        width: 0.5, //
                        color: Apputils().getColor(_selectedButton)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SelectableImageButton(
                          imagePath: AppImages.gallopsIconImage,
                          title: AppMenuButtonTitles.gallops,
                          isSelected: _selectedIndex == 0,
                          //height: AppFonts.selectionMenuItemHeight,
                          onTap: () {
                            _selectButton(0);
                            _filterByRacecourseType(
                                AppMenuButtonTitles.gallopsField);
                          },
                          raceCourseType: _selectedButton,
                        ),
                        SelectableImageButton(
                          imagePath: AppImages.harnessIconImage,
                          title: AppMenuButtonTitles.harness,
                          isSelected: _selectedIndex == 1,
                          onTap: () {
                            _selectButton(1);
                            _filterByRacecourseType(
                                AppMenuButtonTitles.harnessField);
                          },
                          raceCourseType: _selectedButton,
                        ),
                        SelectableImageButton(
                          imagePath: AppImages.dogsIconImage,
                          title: AppMenuButtonTitles.dogs,
                          isSelected: _selectedIndex == 2,
                          onTap: () {
                            _selectButton(2);
                            _filterByRacecourseType(AppMenuButtonTitles.dogsField);
                          },
                          raceCourseType: _selectedButton,
                        ),
                        ClearAllButton(
                          imagePath: AppImages.clearAllIconImage,
                          title: AppMenuButtonTitles.clearAll,
                          isSelected: isClear,
                          onTap: () {
                            _clearAll();
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
                    color: AppColors.tablecontentBgColor.withValues(alpha: 0.05),
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
                                  color: AppColors.dropdownButtonColor,
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
                                  },
                                  items: [
                                    "All",
                                    ...widget.viewModel
                                        .allItems
                                        .where((item) =>
                                            item['Racecourse Type'] ==
                                            _selectedButton)
                                        .map((user) =>
                                            user['Country'] as String? ??
                                            "") // Provide a default value
                                            .sorted()
                                        .toSet() // Sort countries,
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
                                      .toList()
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
                                        color: AppColors.dropdownButtonColor,
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
                                        },
                                        items: [
                                          "All",
                                          ..._getStatesForCountry(
                                                  _selectedCountry).sorted()
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
                          : SizedBox(
                              width: 0,
                              height: 0,
                            )
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.tablecontentBgColor.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                          width: 0.5, color: Apputils().getColor(_selectedButton)),
                    ),
                    margin: const EdgeInsets.all(8),
                    child: ListenableBuilder(
                      listenable: widget.viewModel,
                      builder: (context, child) {
                        // Start with filtering by racecourse type
                        //All Countries
                        _tempRacecources = widget.viewModel.allItems
                            .where((user) =>
                                user['Racecourse Type'] == _selectedButton)
                            .toList();
          
                        // Country + All State
                        if (_selectedCountry.isNotEmpty &&
                            _selectedCountry != "All" &&
                            _selectedState.isNotEmpty &&
                            _selectedState == "All") {
                          _tempRacecources = _tempRacecources
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
                          _tempRacecources = _tempRacecources
                              .where((user) =>
                                  user['Racecourse Type'] == _selectedButton &&
                                  user['Country'] == _selectedCountry &&
                                  user['State'] == _selectedState)
                              .toList();
                        }
                        // Sort alphabetically by "Racecourse"
                        _tempRacecources.sort(
                            (a, b) => a["Racecourse"].compareTo(b["Racecourse"]));
          
                        // Separate favorites from other items
                        List<Map<String, dynamic>> favoriteItems = _tempRacecources
                            .where((item) => item['isFavorite'] == true)
                            .toList();
                        List<Map<String, dynamic>> otherItems = _tempRacecources
                            .where((item) => item['isFavorite'] == false)
                            .toList();
                        // Filter by search text
                        if (_searchText.isNotEmpty) {
                          favoriteItems = favoriteItems
                              .where((item) => item['Racecourse']
                                  .toString()
                                  .toLowerCase()
                                  .startsWith(_searchText.toLowerCase()))
                              .toList();
                          otherItems = otherItems
                              .where((item) => item['Racecourse']
                                  .toString()
                                  .toLowerCase()
                                  .startsWith(_searchText.toLowerCase()))
                              .toList();
                        }
          
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
                                    color: AppColors.checkboxlist2Color,
                                  ),
                                ),
                              ),
                              ...favoriteItems.asMap().entries.map(
                                    (entry) =>
                                        buildListItem(entry.key, entry.value),
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
                                    color: AppColors.checkboxlist2Color,
                                  ),
                                ),
                              ),
                              ...otherItems.asMap().entries.map(
                                    (entry) => buildListItem(
                                        favoriteItems.length +
                                            entry.key, // Ensure index continuity
                                        entry.value),
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
          );
        }
      ),
    );
  }

  Widget buildListItem(int index, Map<String, dynamic> item) {
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
                  widget.viewModel
                      .favoriteSelection(item, newFavoriteStatus);
                  widget.viewModel
                      .updateFavoriteList(item, newFavoriteStatus);
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
            int selectedCount =
                widget.viewModel
                    .savedItems
                    .where((item) => item['isSelected'])
                    .length;

            if (selectedCount > 49 && value == true) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("You reached the maximum racecourse limit."),
                  duration: Duration(milliseconds: 500),
                ),
              );
            } else {
              widget.viewModel
                  .toggleSelection(item, value ?? false);
              widget.viewModel
                  .updateSelectedList(item, value ?? false);
              widget.viewModel
                  .toggleClearSelection();
            }
          },
        ),
      ),
    );
  }
}
