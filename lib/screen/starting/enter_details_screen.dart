import 'package:astrogram/helper/color.dart';
import 'package:astrogram/helper/custom_text.style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
//import 'package:flutter/cupertino.dart';

import '../../widgets/my_text_button.dart';

import '../dashboard/dashboard_screen.dart';

class EnterDetailsScreen extends StatefulWidget {
  const EnterDetailsScreen({super.key});

  @override
  State<EnterDetailsScreen> createState() => _EnterDetailsScreenState();
}

class _EnterDetailsScreenState extends State<EnterDetailsScreen> {
  /// editing text controller
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _locationController = TextEditingController();

  late Size mqData = MediaQuery.of(context).size;

  /// controller
  final PageController _pageController = PageController();
  //current index

  int _currentPage = 0;

  //date of birthday
  //DateTime? _selectedDateOfBirth;

  /// birth time
  String? _bornTime;

  /// gender
  String? _selectGender;

  ///birth location
  //String? _birthPlace;

  ///selected language
  final List<String> _selectedLanguage = [];

  ///language
  final List<String> language = [
    "English",
    "Hindi",
    "Bengali",
    "Gujarati",
    "kannada",
    "Marathi",
    "Punjabi",
    "Tamil",
    "Telugu",
    "Urdu",
  ];

  /// List of indicator icon

  List<dynamic> indicatorIcon = [
    Icons.person,
    Icons.female_rounded,
    Icons.calendar_month_rounded,
    Icons.access_time_rounded,
    Icons.location_on_outlined,
    Icons.language,
  ];

  ///date picker

  ///months
  final List<String> months = [
    "Jan",
    "Feb",
    "Mar",
    "April",
    "May",
    "June",
    "July",
    "Aug",
    "Sept",
    "Oct",
    "Nov",
    "Dec",
  ];

  /// date 1 - 31
  final List<int> days = List.generate(31, (index) => index + 1);

  /// year
  final List<int> years = List.generate(100, (index) => 2026 - index);

  int selectedMonthIndex = 6;
  int selectedDayIndex = 6;
  int selectedYearIndex = 24;

  /// next page function
  void _nextPage() {
    if (_currentPage < 6) {
      setState(() {
        _currentPage++;
      });
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  //back page function
  void _backPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
      });
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  bool _isNameValid() {
    return _nameController.text.trim().isNotEmpty;
  }

  final bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() {
      setState(() {});
    });

    // Check if profile already exists in global session to pre-fill
    if (AuthService.currentUserProfile != null &&
        AuthService.currentUserProfile!['notFound'] != true) {
      _applyProfileData(AuthService.currentUserProfile!);
    }
  }

  void _applyProfileData(Map<String, dynamic> profile) {
    setState(() {
      _nameController.text = profile['fullName']?.toString() ?? "";
      _locationController.text = profile['placeOfBirth']?.toString() ?? "";

      final genderStr = profile['gender']?.toString().toUpperCase();
      if (genderStr == "MALE") _selectGender = "Male";
      if (genderStr == "FEMALE") _selectGender = "Female";

      // Parse Date (Expects YYYY-MM-DD)
      if (profile['dateOfBirth'] != null) {
        try {
          final dob = DateTime.parse(profile['dateOfBirth'].toString());
          int yearIdx = years.indexOf(dob.year);
          if (yearIdx != -1) selectedYearIndex = yearIdx;
          selectedMonthIndex = dob.month - 1;
          selectedDayIndex = dob.day - 1;
        } catch (e) {
          debugPrint("Error parsing DOB in EnterDetails: $e");
        }
      }

      if (profile['timeOfBirth'] != null) {
        _bornTime = "Yes";
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _locationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.darkBackground,
        appBar: AppBar(
          title: Text(
            "Enter Your Details",
            style: myTextStyle21(textColor: Colors.white),
          ),
          leading: IconButton(
            onPressed: () => _backPage(),
            icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [_buildPageIndicator()],
                    ),
                    Expanded(
                      child: PageView(
                        controller: _pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          _buildNamePage(),
                          _buildGenderPage(),
                          _buildDateOfBirth(),
                          _buildBirthTime(),
                          _buildLocationPage(),
                          _buildLanguagePage(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (_isLoading)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// page indicator
  Widget _buildPageIndicator() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(indicatorIcon.length, (index) {
          final isActive = _currentPage == index;
          final isCompleted = index < _currentPage;
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 3),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 32,
                  width: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive || isCompleted
                        ? AppColors.primary
                        : Colors.white12,
                  ),
                ),
                if (isActive)
                  Icon(indicatorIcon[index], size: 21, color: Colors.black),
              ],
            ),
          );
        }),
      ),
    );
  }

  ///name page
  Widget _buildNamePage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 32),
        Text(
          "Hey there!",
          style: myTextStyle24(
            fontweight: FontWeight.bold,
            textColor: Colors.white70,
          ),
        ),
        SizedBox(height: 4),
        Text(
          "What is your name",
          style: myTextStyle24(
            fontweight: FontWeight.bold,
            textColor: Colors.white70,
          ),
        ),
        SizedBox(height: 32),

        ///name text field
        TextField(
          autofocus: false,
          style: myTextStyle18(textColor: Colors.white),
          controller: _nameController,
          decoration: InputDecoration(
            hintText: "Enter name",
            hintStyle: myTextStyle18(textColor: Colors.white54),
            filled: true,
            fillColor: const Color(0xFF1E1E1E),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(width: 1, color: Colors.white38),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(width: 0.5, color: Colors.white38),
            ),
          ),
        ),
        SizedBox(height: 32),

        SizedBox(
          width: double.infinity,
          child: MyTextButton(
            btnText: 'Next',
            onPress: () {
              if (_nameController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Please enter your name",
                      style: myTextStyle18(textColor: Colors.white),
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              } else {
                _nextPage();
              }
            },
            btnBackgroundColor: _isNameValid()
                ? AppColors.primary
                : Colors.grey.withAlpha(140),
            borderRadius: 16,
          ),
        ),
      ],
    );
  }

  /// gender
  Widget _buildGenderPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 32),
        Text(
          "What is your gender?",
          style: myTextStyle21(
            fontweight: FontWeight.bold,
            textColor: Colors.white70,
          ),
        ),

        SizedBox(height: 32),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            /// Male
            Column(
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      _selectGender = "Male";
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: _selectGender == "Male"
                          ? AppColors.primary
                          : const Color(0xFF1E1E1E),
                      shape: BoxShape.circle,
                      border: Border.all(width: 1, color: AppColors.primary),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Image.asset(
                        "lib/assets/icons/man.png",
                        fit: BoxFit.cover,
                        height: mqData.height * 0.1,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    "Male",
                    style: myTextStyle21(
                      fontweight: FontWeight.bold,
                      textColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),

            /// female
            Column(
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      _selectGender = "Female";
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: _selectGender == "Female"
                          ? AppColors.primary
                          : const Color(0xFF1E1E1E),
                      shape: BoxShape.circle,
                      border: Border.all(width: 1, color: AppColors.primary),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Image.asset(
                        "lib/assets/icons/woman.png",
                        fit: BoxFit.cover,
                        height: mqData.height * 0.1,
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    "Female",
                    style: myTextStyle21(
                      fontweight: FontWeight.bold,
                      textColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),

        SizedBox(height: mqData.height * 0.05),

        if (_selectGender != null)
          SizedBox(
            width: double.infinity,
            child: MyTextButton(
              btnText: "Next",
              onPress: () {
                _nextPage();
              },
              btnBackgroundColor: _isNameValid()
                  ? AppColors.primary
                  : Colors.grey.withAlpha(140),
              borderRadius: 16,
            ),
          ),
      ],
    );
  }

  Widget _buildDateOfBirth() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 32),
        Text(
          "Enter your birth date ",
          style: myTextStyle21(
            fontweight: FontWeight.bold,
            textColor: Colors.white70,
          ),
        ),
        SizedBox(height: mqData.height * 0.02),

        SizedBox(
          height: mqData.height * 0.14,
          child: Row(
            children: [
              /// months
              _buildPicker(
                items: months,
                selectedIndex: selectedMonthIndex,
                onSelectedItemChanged: (index) {
                  setState(() {
                    selectedMonthIndex = index;
                  });
                },
              ),

              /// days
              _buildPicker(
                items: days,
                selectedIndex: selectedDayIndex,
                onSelectedItemChanged: (index) {
                  setState(() {
                    selectedDayIndex = index;
                  });
                },
              ),

              /// year
              _buildPicker(
                items: years,
                selectedIndex: selectedYearIndex,
                onSelectedItemChanged: (index) {
                  setState(() {
                    selectedYearIndex = index;
                  });
                },
              ),
            ],
          ),
        ),
        SizedBox(height: mqData.height * 0.05),

        SizedBox(
          width: double.infinity,
          child: MyTextButton(
            btnText: 'Next',
            borderRadius: 16,
            onPress: () => _nextPage(),
          ),
        ),
      ],
    );
  }

  Widget _buildPicker<T>({
    required List<T> items,
    required int selectedIndex,
    required ValueChanged<int> onSelectedItemChanged,
  }) {
    return Expanded(
      child: CupertinoPicker(
        itemExtent: 60,
        looping: true,

        scrollController: FixedExtentScrollController(
          initialItem: selectedIndex,
        ),
        onSelectedItemChanged: onSelectedItemChanged,
        children: items.map((item) {
          return Center(
            child: Text(
              item.toString(),
              style: myTextStyle21(textColor: Colors.white),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBirthTime() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 32),
        Text(
          "Do you know your time of birth?",
          style: myTextStyle21(
            fontweight: FontWeight.bold,
            textColor: Colors.white70,
          ),
        ),
        SizedBox(height: mqData.height * 0.02),

        GestureDetector(
          onTap: () {
            setState(() {
              _bornTime = "Yes";
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            height: mqData.height * 0.06,
            decoration: BoxDecoration(
              color: _bornTime == "Yes"
                  ? AppColors.primary
                  : const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(width: 1, color: Colors.white38),
            ),
            child: Row(
              children: [
                Icon(Icons.verified_user_outlined, color: Colors.green),
                SizedBox(width: 16),
                Text(
                  "Yes",
                  style: myTextStyle21(
                    fontweight: FontWeight.bold,
                    textColor: _bornTime == "Yes" ? Colors.black : Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 21),

        GestureDetector(
          onTap: () {
            setState(() {
              _bornTime = "No";
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            height: mqData.height * 0.06,
            decoration: BoxDecoration(
              color: _bornTime == "No"
                  ? AppColors.primary
                  : const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(width: 1, color: Colors.white38),
            ),
            child: Row(
              children: [
                Icon(Icons.close_rounded, color: Colors.red),
                SizedBox(width: 16),
                Text(
                  "No",
                  style: myTextStyle21(
                    fontweight: FontWeight.bold,
                    textColor: _bornTime == "No" ? Colors.black : Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: mqData.height * 0.05),

        if (_bornTime != null)
          SizedBox(
            width: double.infinity,
            child: MyTextButton(
              btnText: 'Next',
              borderRadius: 16,
              onPress: () => _nextPage(),
            ),
          ),
      ],
    );
  }

  Widget _buildLocationPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 32),
        Text(
          "Where were you born?",
          style: myTextStyle21(
            fontweight: FontWeight.bold,
            textColor: Colors.white70,
          ),
        ),

        SizedBox(height: mqData.height * 0.05),

        /// name text field
        TextField(
          autofocus: false,
          style: myTextStyle18(textColor: Colors.white),
          controller: _locationController,
          decoration: InputDecoration(
            hintText: "Enter your birth location",
            hintStyle: myTextStyle18(textColor: Colors.white54),
            filled: true,
            fillColor: const Color(0xFF1E1E1E),
            suffixIcon: Icon(Icons.search, color: Colors.white54),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(width: 1, color: Colors.white38),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(width: 1, color: Colors.white38),
            ),
          ),
        ),

        SizedBox(height: 32),

        SizedBox(
          width: double.infinity,
          child: MyTextButton(
            btnText: "Next",
            onPress: () {
              _nextPage();
            },

            btnBackgroundColor: AppColors.primary,
            borderRadius: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildLanguagePage() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 32),
          Text(
            "Select Language",
            style: myTextStyle21(
              fontweight: FontWeight.bold,
              textColor: Colors.white70,
            ),
          ),
          SizedBox(height: mqData.height * 0.02),

          /// language chip
          Wrap(
            spacing: 10,
            runSpacing: 8,
            children: language.map((lang) {
              final isSelected = _selectedLanguage.contains(lang);
              return FilterChip(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(21),
                  side: BorderSide(width: 2, color: AppColors.primary),
                ),
                selectedColor: AppColors.primary,
                elevation: 1,
                showCheckmark: false,
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      lang,
                      style: myTextStyle15(
                        textColor: isSelected ? Colors.black : Colors.white,
                      ),
                    ),
                    Icon(isSelected ? Icons.check : Icons.add),
                  ],
                ),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      setState(() {
                        _selectedLanguage.add(lang);
                      });
                    } else {
                      _selectedLanguage.remove(lang);
                    }
                  });
                },
              );
            }).toList(),
          ),

          SizedBox(height: mqData.height * 0.05),

          if (_selectedLanguage.isNotEmpty)
            SizedBox(
              width: double.infinity,
              child: MyTextButton(
                btnText: 'Start chat with Astrologer',
                borderRadius: 16,
                onPress: () {
                  // Save name to profile session
                  if (_nameController.text.isNotEmpty) {
                    if (AuthService.currentUserProfile != null) {
                      AuthService.currentUserProfile!['fullName'] =
                          _nameController.text;
                    } else {
                      AuthService.currentUserProfile = {
                        'fullName': _nameController.text,
                      };
                    }
                  }

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => DashboardScreen()),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
