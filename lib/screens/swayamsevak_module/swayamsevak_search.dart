/*import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

import '../../dialogs/levelwise_dropdown.dart';
import '../../helpers/static_data.dart' as Statics;
import '../../providers/swayamsevak_provider.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/swayamsevak_card.dart';
import '../home_screen/home_screen.dart';
import 'edit_module/edit_swayamsevak_basic_info.dart';
import 'edit_module/edit_swayamsevak_screen.dart';
import 'edit_module/edit_swayamsevak_soochi.dart';

// ============================================================================
// SEARCH FILTERS MODEL - Organized state management
// ============================================================================

class SearchFilters {
  // Basic Info
  String searchText = '';
  String? bloodGroupID;
  String? motherTongueID;
  String? shaakhaSanchalanID;

  // Location
  String? geoUnitID;
  String? mandalID;
  String? graamID;
  String? vastiID;

  // Sangha Shikshan
  String? sanghaShikshanCode;
  String? shikshanFromYear;
  String? shikshanToYear;
  bool hasBeenShikshak = false;

  // Daayitva
  int? daayitvaForID;
  String? levelID;
  String? daayitvaID;
  String? daayitvaGeoUnitID;
  bool noDaayitva = false;
  bool pravaasi = false;
  bool wasVistaarak = false;
  bool wasPrachaarak = false;
  String? preritSansthaID;
  String? otherOrgName;

  // Pratidnya
  bool? isPratidnyit;
  String? pratidnyaYear;

  // Ganavesh
  bool isGanaveshComplete = false;
  bool noCap = false;
  bool noShirt = false;
  bool noPant = false;
  bool noBelt = false;
  bool noShoes = false;
  bool noSocks = false;
  bool noDanda = false;

  // Vehicle
  String? vehicleType;
  bool hasVehicleDriver = false;

  // Shaaririk Vishay (Physical subjects)
  Map<String, bool> mukhyaShaaririk = {
    'Danda': false,
    'Niyuddha': false,
    'Yogaasan': false,
    'Yogachaap': false,
    'Padavinyas': false,
    'DandaYuddha': false,
  };

  Map<String, bool> anyaShaaririk = {
    'Danda': false,
    'Niyuddha': false,
    'Yogaasan': false,
    'Yogachaap': false,
    'Padavinyas': false,
    'DandaYuddha': false,
  };

  // Ghosh Vishay (Musical instruments)
  Map<String, GhoshVishayFilter> ghoshVishay = {
    'Pratham': GhoshVishayFilter(),
    'Dwitiya': GhoshVishayFilter(),
    'Trutiya': GhoshVishayFilter(),
    'Anya': GhoshVishayFilter(),
  };

  // Occupation
  int? occupationCategoryID;
  EducationFilter education = EducationFilter();
  OccupationFilter occupation = OccupationFilter();

  // Shaakha Experience
  bool hasShaakhaaExperience = false;
  ShaakhaaExperienceFilter shaakhaaExp = ShaakhaaExperienceFilter();

  // Social Media
  SocialMediaFilter socialMedia = SocialMediaFilter();

  // Areas of Interest/Expertise
  List<int> areaOfInterestIDs = [];
  List<int> areaOfExpertiseIDs = [];

  // Sorting
  String sortOrder = 'Name';

  void reset() {
    searchText = '';
    bloodGroupID = null;
    motherTongueID = null;
    shaakhaSanchalanID = null;
    geoUnitID = null;
    sanghaShikshanCode = null;
    shikshanFromYear = null;
    shikshanToYear = null;
    hasBeenShikshak = false;
    daayitvaForID = null;
    levelID = null;
    daayitvaID = null;
    daayitvaGeoUnitID = null;
    noDaayitva = false;
    pravaasi = false;
    wasVistaarak = false;
    wasPrachaarak = false;
    isPratidnyit = null;
    pratidnyaYear = null;
    isGanaveshComplete = false;
    noCap = false;
    noShirt = false;
    noPant = false;
    noBelt = false;
    noShoes = false;
    noSocks = false;
    noDanda = false;
    vehicleType = null;
    hasVehicleDriver = false;
    mukhyaShaaririk.updateAll((key, value) => false);
    anyaShaaririk.updateAll((key, value) => false);
    ghoshVishay.forEach((key, value) => value.reset());
    occupationCategoryID = null;
    education.reset();
    occupation.reset();
    hasShaakhaaExperience = false;
    shaakhaaExp.reset();
    socialMedia.reset();
    areaOfInterestIDs.clear();
    areaOfExpertiseIDs.clear();
  }
}

class GhoshVishayFilter {
  String? rachanaaCount;
  bool understandsLipi = false;
  Map<String, bool> instruments = {
    'Vanshi': false,
    'Venu': false,
    'Aanak': false,
    'Shankha': false,
    'Naagaanga': false,
    'Turya': false,
    'Swarad': false,
    'Gomukha': false,
  };

  void reset() {
    rachanaaCount = null;
    understandsLipi = false;
    instruments.updateAll((key, value) => false);
  }
}

class EducationFilter {
  int? universityID;
  String universityName = '';
  String otherUniversityName = '';
  int? collegeID;
  String collegeName = '';
  String otherCollegeName = '';
  int? standardID;
  String standardName = '';
  String otherStandardName = '';
  int? programID;
  String programName = '';
  String otherProgramName = '';
  int? courseID;
  String courseName = '';
  String otherCourseName = '';
  String schoolName = '';
  String? program; // For Jr College

  void reset() {
    universityID = null;
    universityName = '';
    otherUniversityName = '';
    collegeID = null;
    collegeName = '';
    otherCollegeName = '';
    standardID = null;
    standardName = '';
    otherStandardName = '';
    programID = null;
    programName = '';
    otherProgramName = '';
    courseID = null;
    courseName = '';
    otherCourseName = '';
    schoolName = '';
    program = null;
  }
}

class OccupationFilter {
  String govtDept = '';
  String organizationName = '';
  String industrialVertical = '';
  String officeLocation = '';
  String orgAtRetirement = '';
  String desgAtRetirement = '';
  String deptAtRetirement = '';
  Set<int> weeklyOffDays = {};

  void reset() {
    govtDept = '';
    organizationName = '';
    industrialVertical = '';
    officeLocation = '';
    orgAtRetirement = '';
    desgAtRetirement = '';
    deptAtRetirement = '';
    weeklyOffDays.clear();
  }
}

class ShaakhaaExperienceFilter {
  bool baal = false;
  bool tarunVidyaarthi = false;
  bool tarunVyavasaayee = false;
  bool proudhaVyavasaayee = false;

  void reset() {
    baal = false;
    tarunVidyaarthi = false;
    tarunVyavasaayee = false;
    proudhaVyavasaayee = false;
  }
}

class SocialMediaFilter {
  bool hasFacebook = false;
  String? facebookUsage;
  bool hasInstagram = false;
  String? instagramUsage;
  bool hasTwitter = false;
  String? twitterUsage;

  void reset() {
    hasFacebook = false;
    facebookUsage = null;
    hasInstagram = false;
    instagramUsage = null;
    hasTwitter = false;
    twitterUsage = null;
  }
}

// ============================================================================
// MAIN SEARCH SCREEN
// ============================================================================

class SwayamSevakSearch extends StatefulWidget {
  static const routeName = '/swayamsevak-search-modern';

  @override
  State<SwayamSevakSearch> createState() => _SwayamSevakSearchState();
}

class _SwayamSevakSearchState extends State<SwayamSevakSearch> with SingleTickerProviderStateMixin {
  // Controllers
  final _searchController = TextEditingController();
  final _daayitvaController = TextEditingController();
  late TabController _tabController;

  // State
  final SearchFilters _filters = SearchFilters();
  bool _isSearching = false;
  bool _isSelectAll = false;
  Future<List<dynamic>>? _swList;

  // Selected items for bulk actions
  final Set<String> _selectedEmails = {};
  final Set<String> _selectedMobiles = {};
  final Set<String> _selectedSwIds = {};

  // Dropdown data
  List<dynamic>? _bloodGroups;
  List<dynamic>? _motherTongues;
  List<dynamic>? _shaakhaSanchalans;
  List<dynamic>? _categories;
  List<dynamic>? _daayitvaFor;
  List<dynamic>? _levels;
  List<dynamic>? _geoUnits;
  List<dynamic>? _sanghaPreritSanstha;
  List<dynamic>? _standards;
  List<dynamic>? _mandals;
  List<dynamic>? _graams;
  List<dynamic>? _vastis;

  // Area of Interest/Expertise
  final List<AreaItem> _areasOfInterest = [];
  final List<AreaItem> _areasOfExpertise = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadDropdownData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _daayitvaController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  // ============================================================================
  // DATA LOADING
  // ============================================================================

  Future<void> _loadDropdownData() async {
    final bloodGroups = await Statics.getStaticLDB('BloodGroup');
    final motherTongues = await Statics.getStaticLDB('MotherTongue');
    final shaakhaSanchalans = await Statics.getStaticLDB('ShaakhaaExperienceYear');
    final categories = await Statics.getStaticLDB('OccupationCategory');
    final daayitvaFor = await Statics.getStaticLDB('DaayitvaFor');
    final levels = await Statics.getLevelLDB();
    final sanghaPreritSanstha = await Statics.getSanghaPreritSanstha('1', null, null);
    final aoi = await Statics.getStaticLDB('AreaOfInterest');
    final aoe = await Statics.getStaticLDB('AreaOfExpertise');

    setState(() {
      _bloodGroups = bloodGroups;
      _motherTongues = motherTongues;
      _shaakhaSanchalans = shaakhaSanchalans;
      _categories = categories;
      _daayitvaFor = daayitvaFor;
      _levels = levels;
      _sanghaPreritSanstha = sanghaPreritSanstha;

      _areasOfInterest.clear();
      for (var item in aoi) {
        _areasOfInterest.add(AreaItem(
          id: item.staticID ?? 0,
          name: item.codeForDisplay ?? '',
          isSelected: false,
        ));
      }

      _areasOfExpertise.clear();
      for (var item in aoe) {
        _areasOfExpertise.add(AreaItem(
          id: item.staticID ?? 0,
          name: item.codeForDisplay ?? '',
          isSelected: false,
        ));
      }
    });
  }

  Future<void> _loadGeoUnitsForDaayitva(String levelID) async {
    final geoUnits = levelID.isEmpty ? await Statics.getGeoUnitsByLevel(Statics.levels['MahaanagarLevelID']) : await Statics.getGeoUnitsByLevel(levelID);

    setState(() {
      _geoUnits = geoUnits;
    });
  }

  Future<void> _loadMandals(String nagarID) async {
    final mandals = await Statics.getGeoUnitsByLevelAndParent(
      Statics.levels['MandalLevelID'].toString(),
      nagarID,
      'Nagar',
      '',
    );

    setState(() {
      _mandals = mandals.isNotEmpty ? mandals : null;
      _filters.graamID = null;
      _graams = null;
    });
  }

  Future<void> _loadGraams(String mandalID) async {
    final graams = await Statics.getGeoUnitsByLevelAndParent(
      Statics.levels['GraamLevelID'].toString(),
      mandalID,
      'Mandal',
      '',
    );

    setState(() {
      _graams = graams.isNotEmpty ? graams : null;
    });
  }

  Future<void> _loadVastis(String nagarID) async {
    final vastis = await Statics.getGeoUnitsByLevelAndParent(
      Statics.levels['VastiLevelID'].toString(),
      nagarID,
      'Nagar',
      '',
    );

    setState(() {
      _vastis = vastis.isNotEmpty ? vastis : null;
    });
  }

  Future<void> _loadStandards(String categoryCode) async {
    List<dynamic>? standards;

    if (categoryCode == 'School Student') {
      standards = await Statics.getStaticLDB('SchoolStandard');
    } else if (categoryCode == 'Jr College') {
      standards = await Statics.getStaticLDB('JrCollegeStandard');
    } else if (categoryCode == 'Senior College') {
      standards = await Statics.getStaticLDB('SrCollegeStandard');
    }

    setState(() {
      _standards = standards;
    });
  }

  // ============================================================================
  // SEARCH & EXPORT
  // ============================================================================

  Future<void> _performSearch() async {
    setState(() {
      _isSearching = true;
    });

    try {
      final results = await _executeSearch();
      setState(() {
        _swList = Future.value(results);
        _tabController.animateTo(1);
      });
    } finally {
      setState(() {
        _isSearching = false;
      });
    }
  }

  Future<List<dynamic>> _executeSearch() async {
    final isConnected = await Statics.isInternetConnected();
    if (!isConnected) {
      Statics.showMessageDialog(
        context,
        Statics.getLabel('internetNotConnected'),
      );
      return [];
    }

    final inputData = _buildSearchPayload();
    return await SwayamsevakProvider().getSwayamsevaks(inputData);
  }

  String _buildSearchPayload() {
    // Build Shaaririk Vishay codes
    final mukhyaCodes = _filters.mukhyaShaaririk.entries.where((e) => e.value).map((e) => e.key).join(',');

    final anyaCodes = _filters.anyaShaaririk.entries.where((e) => e.value).map((e) => e.key).join(',');

    // Build Ghosh Vishay codes for each level
    String buildGhoshCodes(String level) {
      final filter = _filters.ghoshVishay[level]!;
      return filter.instruments.entries.where((e) => e.value).map((e) => e.key).join(',');
    }

    // Build weekly off days
    final weeklyOffDays = _filters.occupation.weeklyOffDays.map((day) => day.toString()).join(',');

    // Build areas of interest/expertise
    final aoiIDs = _areasOfInterest.where((item) => item.isSelected).map((item) => item.id.toString()).join(',');

    final aoeIDs = _areasOfExpertise.where((item) => item.isSelected).map((item) => item.id.toString()).join(',');

    return json.encode({
      'AppUserID': Statics.userDetails['userID'],
      'SearchCriteria': _filters.searchText.isEmpty ? null : _filters.searchText,
      'BloodGroupID': _filters.bloodGroupID,
      'MotherTongueID': _filters.motherTongueID,
      'ShaakhaaExperienceYearID': _filters.shaakhaSanchalanID,
      'GeoUnitID': _filters.geoUnitID,
      'IsPratidnyit': _filters.isPratidnyit,
      'PratidnyaYear': _filters.pratidnyaYear,
      'IsGanaveshComplete': _filters.isGanaveshComplete,
      'NoCap': _filters.noCap,
      'NoShirt': _filters.noShirt,
      'NoPant': _filters.noPant,
      'NoBelt': _filters.noBelt,
      'NoShoes': _filters.noShoes,
      'NoSocks': _filters.noSocks,
      'NoDanda': _filters.noDanda,
      'VehicleType': _filters.vehicleType,
      'HasDriver': _filters.hasVehicleDriver,
      'SanghaShikshanCode': _filters.sanghaShikshanCode,
      'SanghaShikshanYearFrom': _filters.shikshanFromYear,
      'SanghaShikshanYearTo': _filters.shikshanToYear,
      'HasBeenOTCShikshak': _filters.hasBeenShikshak,
      'MukhyaShaaririkVishayCodes': mukhyaCodes.isEmpty ? null : mukhyaCodes,
      'AnyaShaaririkVishayCodes': anyaCodes.isEmpty ? null : anyaCodes,
      'PrathamVaadyaCodes': buildGhoshCodes('Pratham').isEmpty ? null : buildGhoshCodes('Pratham'),
      'DwitiyaVaadyaCodes': buildGhoshCodes('Dwitiya').isEmpty ? null : buildGhoshCodes('Dwitiya'),
      'TrutiyaVaadyaCodes': buildGhoshCodes('Trutiya').isEmpty ? null : buildGhoshCodes('Trutiya'),
      'AnyaVaadyaCodes': buildGhoshCodes('Anya').isEmpty ? null : buildGhoshCodes('Anya'),
      'IsUnderstandLipiPrathamVaadya': _filters.ghoshVishay['Pratham']!.understandsLipi,
      'IsUnderstandLipiDwitiyaVaadya': _filters.ghoshVishay['Dwitiya']!.understandsLipi,
      'IsUnderstandLipiTrutiyaVaadya': _filters.ghoshVishay['Trutiya']!.understandsLipi,
      'IsUnderstandLipiAnyaVaadya': _filters.ghoshVishay['Anya']!.understandsLipi,
      'RachanaaCountPrathamVaadya': _filters.ghoshVishay['Pratham']!.rachanaaCount,
      'RachanaaCountDwitiyaVaadya': _filters.ghoshVishay['Dwitiya']!.rachanaaCount,
      'RachanaaCountTrutiyaVaadya': _filters.ghoshVishay['Trutiya']!.rachanaaCount,
      'RachanaaCountAnyaVaadya': _filters.ghoshVishay['Anya']!.rachanaaCount,
      'OccupationCategoryID': _filters.occupationCategoryID,
      'DaayitvaForID': _filters.daayitvaForID,
      'DaayitvaID': _filters.daayitvaID,
      'DaayitvaLevelID': _filters.levelID,
      'DaayitvaGeoUnitID': _filters.daayitvaGeoUnitID,
      'IsNoDaayitva': _filters.noDaayitva,
      'IsPravaasi': _filters.pravaasi,
      'SanghaPreritSansthaaID': _filters.preritSansthaID,
      'SocialOrganizationName': _filters.otherOrgName,
      'SortOrder': _filters.sortOrder == 'Name' ? 'FullName' : 'SwayamsevakID',
      'HasBeenVistaarak': _filters.wasVistaarak,
      'HasBeenPrachaarak': _filters.wasPrachaarak,
      'HasShaakhaaSanchaalanExperience': _filters.hasShaakhaaExperience,
      'HasBaalShaakhaaExperience': _filters.shaakhaaExp.baal,
      'HasTarunVidyaarthiShaakhaaExperience': _filters.shaakhaaExp.tarunVidyaarthi,
      'HasTarunVyavasaayeeShaakhaaExperience': _filters.shaakhaaExp.tarunVyavasaayee,
      'HasProudhaVyavasaayeeShaakhaaExperience': _filters.shaakhaaExp.proudhaVyavasaayee,
      'HasFacebook': _filters.socialMedia.hasFacebook,
      'HasInstagram': _filters.socialMedia.hasInstagram,
      'HasTwitter': _filters.socialMedia.hasTwitter,
      'FacebookUsage': _filters.socialMedia.facebookUsage,
      'InstagramUsage': _filters.socialMedia.instagramUsage,
      'TwitterUsage': _filters.socialMedia.twitterUsage,
      'AreaOfInterestIDs': aoiIDs.isEmpty ? null : aoiIDs,
      'AreaOfExpertiseIDs': aoeIDs.isEmpty ? null : aoeIDs,
      'WeeklyOffDayIDs': weeklyOffDays.isEmpty ? null : weeklyOffDays,
      // Education fields would go here - simplified for length
      // Occupation fields would go here - simplified for length
    });
  }

  Future<void> _exportToCsv() async {
    setState(() {
      _isSearching = true;
    });

    try {
      // Implementation similar to original but cleaner
      // This would be the full export logic
      Statics.showToast('Export functionality - implementation needed');
    } finally {
      setState(() {
        _isSearching = false;
      });
    }
  }

  void _clearFilters() {
    setState(() {
      _filters.reset();
      _searchController.clear();
      _daayitvaController.clear();
      _swList = null;
      _geoUnits = null;
      _mandals = null;
      _graams = null;
      _vastis = null;
      _standards = null;
      _areasOfInterest.forEach((item) => item.isSelected = false);
      _areasOfExpertise.forEach((item) => item.isSelected = false);
    });
  }

  // ============================================================================
  // SELECTION HANDLERS
  // ============================================================================

  void _onCheckCard(String email, String mobile, String swId) {
    setState(() {
      _selectedEmails.add(email);
      _selectedMobiles.add(mobile);
      _selectedSwIds.add(swId);
    });
  }

  void _onUncheckCard(String email, String mobile, String swId) {
    setState(() {
      _selectedEmails.remove(email);
      _selectedMobiles.remove(mobile);
      _selectedSwIds.remove(swId);
    });
  }

  void _onSelectAll(bool value) {
    setState(() {
      _isSelectAll = value;

      if (value) {
        _swList?.then((dataList) {
          for (var data in dataList) {
            _onCheckCard(
              data['Email'],
              data['MobileNumber'],
              data['SwayamsevakID'].toString(),
            );
          }
        });
      } else {
        _selectedEmails.clear();
        _selectedMobiles.clear();
        _selectedSwIds.clear();
      }
    });
  }

  // ============================================================================
  // MENU ACTIONS
  // ============================================================================

  void _handleMenuAction(String action) {
    switch (action) {
      case 'SendMail':
        if (_selectedEmails.isEmpty) {
          Statics.showToast('Please select at least one member');
          return;
        }
        UrlLauncher.launch('mailto:${_selectedEmails.join(',')}');
        break;

      case 'SendSMS':
        if (_selectedMobiles.isEmpty) {
          Statics.showToast('Please select at least one member');
          return;
        }
        UrlLauncher.launch('sms:${_selectedMobiles.join(',')}');
        break;

      case 'EditMenu':
        Navigator.of(context).pushNamed(
          EditSwayamsevakScreen.routeName,
          arguments: Statics.ScreenArgumentsNew(0, 'EditMenu'),
        );
        break;

      case 'EditMenuNew':
        Navigator.of(context).pushNamed(
          EditSwayamsevakBasicInfo.routeName,
          arguments: Statics.ScreenArguments(0, 'EditMenu'),
        );
        break;

      case 'AddinSoochi':
        if (_selectedMobiles.isEmpty) {
          Statics.showToast('Please select at least one member');
          return;
        }
        Navigator.of(context).pushNamed(
          EditSwayamsevakSoochiInfo.routeName,
          arguments: Statics.ScreenArgumentsForSoochi(
            _selectedSwIds.join(','),
            'addinSoochi',
          ),
        );
        break;
    }
  }

  // ============================================================================
  // BUILD UI
  // ============================================================================

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_tabController.index == 1) {
          _tabController.animateTo(0);
          return false;
        }
        Navigator.popAndPushNamed(context, HomeScreen.routeName);
        return true;
      },
      child: Scaffold(
        appBar: _buildAppBar(),
        drawer: AppDrawer(),
        floatingActionButton: _buildFABs(),
        body: ModalProgressHUD(
          inAsyncCall: _isSearching,
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildFiltersTab(),
              _buildResultsTab(),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        Statics.getLabel('searchSwayamsevakScreenLabel'),
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
      ),
      actions: [
        PopupMenuButton<String>(
          icon: Icon(FontAwesomeIcons.ellipsisV),
          onSelected: _handleMenuAction,
          itemBuilder: (context) => [
            _buildMenuItem('AddinSoochi', Icons.list, 'addinSoochi'),
            _buildMenuItem('SendMail', Icons.mail, 'SendMail'),
            _buildMenuItem('SendSMS', Icons.sms, 'SendSMS'),
            _buildMenuItem('EditMenu', Icons.add, 'AddSwayamsevak'),
          ],
        ),
      ],
      bottom: TabBar(
        controller: _tabController,
        indicatorColor: Colors.white,
        physics: NeverScrollableScrollPhysics(),
        onTap: (index) {
          if (index == 1) {
            _performSearch();
          }
        },
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(FontAwesomeIcons.filter, size: 18),
                SizedBox(width: 12),
                Text(
                  Statics.getLabel('Filters'),
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people, size: 22),
                SizedBox(width: 12),
                Text(
                  Statics.getLabel('Results'),
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PopupMenuItem<String> _buildMenuItem(String key, IconData icon, String label) {
    return PopupMenuItem(
      value: key,
      child: Row(
        children: [
          Icon(icon, color: Colors.deepPurple, size: 20),
          SizedBox(width: 12),
          Text(Statics.getLabel(label)),
        ],
      ),
    );
  }

  Widget _buildFABs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          heroTag: 'search',
          tooltip: Statics.getLabel('Search'),
          backgroundColor: Colors.deepPurple,
          onPressed: _performSearch,
          child: Icon(Icons.search),
        ),
        SizedBox(width: 12),
        FloatingActionButton(
          heroTag: 'clear',
          tooltip: Statics.getLabel('Clear'),
          backgroundColor: Colors.orange,
          onPressed: _clearFilters,
          child: Icon(Icons.clear_all),
        ),
        SizedBox(width: 12),
        FloatingActionButton(
          heroTag: 'export',
          tooltip: Statics.getLabel('ExportToExcel'),
          backgroundColor: Colors.green,
          onPressed: _exportToCsv,
          child: Icon(Icons.download),
        ),
      ],
    );
  }

  Widget _buildFiltersTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildNotice(),
          SizedBox(height: 16),
          _buildSortingSection(),
          SizedBox(height: 24),
          _buildBasicInfoSection(),
          SizedBox(height: 24),
          _buildLocationSection(),
          SizedBox(height: 24),
          _buildGhoshVishaySection(),
          SizedBox(height: 24),
          _buildShaaririkVishaySection(),
          SizedBox(height: 24),
          _buildDaayitvaSection(),
          SizedBox(height: 24),
          _buildShaakhaaExperienceSection(),
          SizedBox(height: 24),
          _buildOccupationSection(),
          SizedBox(height: 24),
          _buildPratidnyaSection(),
          SizedBox(height: 24),
          _buildSanghaShikshanSection(),
          SizedBox(height: 24),
          _buildVehicleSection(),
          SizedBox(height: 24),
          _buildGanaveshSection(),
          SizedBox(height: 24),
          _buildSocialMediaSection(),
          SizedBox(height: 24),
          _buildAreasSection(),
          SizedBox(height: 80), // Space for FABs
        ],
      ),
    );
  }

  Widget _buildNotice() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.red, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              '${Statics.getLabel('Note')}: ${Statics.getLabel('searchSwayamsevakScreenTip')}',
              style: TextStyle(
                color: Colors.red[700],
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortingSection() {
    return ModernCard(
      title: 'Sorting',
      icon: Icons.sort,
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: Statics.getLabel('SortingOn'),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        value: _filters.sortOrder,
        items: [
          DropdownMenuItem(value: 'Name', child: Text(Statics.getLabel('Name'))),
          DropdownMenuItem(value: 'LinkedGeoUnit', child: Text(Statics.getLabel('LinkedGeoUnit'))),
          DropdownMenuItem(value: 'Daayitva', child: Text(Statics.getLabel('Daayitva'))),
          DropdownMenuItem(value: 'SanghaShikshan', child: Text(Statics.getLabel('SanghaShikshan'))),
        ],
        onChanged: (value) {
          setState(() {
            _filters.sortOrder = value!;
          });
        },
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return ModernCard(
      title: 'BasicInfo',
      icon: Icons.person,
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: Statics.getLabel('searchSwayamsevakLabel'),
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onChanged: (value) => _filters.searchText = value,
          ),
          SizedBox(height: 16),
          if (_bloodGroups != null)
            DropdownButtonFormField(
              decoration: InputDecoration(
                labelText: Statics.getLabel('SelectBloodGroup'),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              value: _filters.bloodGroupID,
              items: _bloodGroups!.map((bg) {
                return DropdownMenuItem(
                  value: bg.staticID.toString(),
                  child: Text(bg.codeForDisplay!),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _filters.bloodGroupID = value;
                });
              },
            ),
          SizedBox(height: 16),
          if (_motherTongues != null)
            DropdownButtonFormField(
              decoration: InputDecoration(
                labelText: Statics.getLabel('SelectMotherTongue'),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              value: _filters.motherTongueID,
              items: _motherTongues!.map((mt) {
                return DropdownMenuItem(
                  value: mt.staticID.toString(),
                  child: Text(mt.codeForDisplay!),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _filters.motherTongueID = value;
                });
              },
            ),
          SizedBox(height: 16),
          if (_shaakhaSanchalans != null)
            DropdownButtonFormField(
              decoration: InputDecoration(
                labelText: Statics.getLabel('ShaakhaaSanchaalan'),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              value: _filters.shaakhaSanchalanID,
              items: _shaakhaSanchalans!.map((ss) {
                return DropdownMenuItem(
                  value: ss.staticID.toString(),
                  child: Text(ss.codeForDisplay!),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _filters.shaakhaSanchalanID = value;
                });
              },
            ),
        ],
      ),
    );
  }

  Widget _buildLocationSection() {
    return ModernCard(
      title: 'LinkedGeoUnit',
      icon: Icons.location_on,
      child: LevelWiseDropdown(
        onFinalSelection: (level, geoUnitID) {
          setState(() {
            _filters.geoUnitID = geoUnitID;
            if (geoUnitID != null) {
              _loadMandals(geoUnitID);
              _loadVastis(geoUnitID);
            }
          });
        },
      ),
    );
  }

  // Implement remaining sections similarly...
  // Due to length constraints, showing pattern for other sections

  Widget _buildGhoshVishaySection() {
    return ModernCard(
      title: 'GhoshVishay',
      icon: Icons.music_note,
      child: Column(
        children: [
          _buildGhoshVishayLevel('Pratham'),
          SizedBox(height: 12),
          _buildGhoshVishayLevel('Dwitiya'),
          SizedBox(height: 12),
          _buildGhoshVishayLevel('Trutiya'),
          SizedBox(height: 12),
          _buildGhoshVishayLevel('Anya'),
        ],
      ),
    );
  }

  Widget _buildGhoshVishayLevel(String level) {
    final filter = _filters.ghoshVishay[level]!;

    return ExpansionTile(
      title: Text(
        Statics.getLabel('Ghosh${level}Vaadya'),
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      children: [
        Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: Statics.getLabel('RachanaaCount'),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) => filter.rachanaaCount = value,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: CheckboxListTile(
                      title: Text(Statics.getLabel('UnderstandLipi')),
                      value: filter.understandsLipi,
                      onChanged: (value) {
                        setState(() {
                          filter.understandsLipi = value ?? false;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: filter.instruments.keys.map((instrument) {
                  return SizedBox(
                    width: (MediaQuery.of(context).size.width - 64) / 3,
                    child: CheckboxListTile(
                      title: Text(Statics.getLabel(instrument)),
                      value: filter.instruments[instrument],
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (value) {
                        setState(() {
                          filter.instruments[instrument] = value ?? false;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildShaaririkVishaySection() {
    return ModernCard(
      title: 'ShaaririkVishay',
      icon: Icons.fitness_center,
      child: Column(
        children: [
          _buildShaaririkCategory('Mukhya', _filters.mukhyaShaaririk),
          SizedBox(height: 12),
          _buildShaaririkCategory('Anya', _filters.anyaShaaririk),
        ],
      ),
    );
  }

  Widget _buildShaaririkCategory(String type, Map<String, bool> items) {
    return ExpansionTile(
      title: Text(
        Statics.getLabel('${type}ShaaririkVishay'),
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      children: [
        Padding(
          padding: EdgeInsets.all(12),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: items.keys.map((item) {
              return SizedBox(
                width: (MediaQuery.of(context).size.width - 64) / 2,
                child: CheckboxListTile(
                  title: Text(Statics.getLabel(item)),
                  value: items[item],
                  dense: true,
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (value) {
                    setState(() {
                      items[item] = value ?? false;
                    });
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildDaayitvaSection() {
    return ModernCard(
      title: 'Daayitva',
      icon: Icons.work,
      child: Column(
        children: [
          CheckboxListTile(
            title: Text(Statics.getLabel('HasBeenVistaarak')),
            value: _filters.wasVistaarak,
            onChanged: (value) {
              setState(() {
                _filters.wasVistaarak = value ?? false;
              });
            },
          ),
          CheckboxListTile(
            title: Text(Statics.getLabel('HasBeenPrachaarak')),
            value: _filters.wasPrachaarak,
            onChanged: (value) {
              setState(() {
                _filters.wasPrachaarak = value ?? false;
              });
            },
          ),
          CheckboxListTile(
            title: Text(Statics.getLabel('NoDaayitva')),
            value: _filters.noDaayitva,
            onChanged: (value) {
              setState(() {
                _filters.noDaayitva = value ?? false;
              });
            },
          ),
          CheckboxListTile(
            title: Text(Statics.getLabel('Pravaasi')),
            value: _filters.pravaasi,
            onChanged: (value) {
              setState(() {
                _filters.pravaasi = value ?? false;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildShaakhaaExperienceSection() {
    return ModernCard(
      title: 'ShaakhaExp',
      icon: Icons.school,
      child: Column(
        children: [
          CheckboxListTile(
            title: Text(Statics.getLabel('HasShaakhaaSanchaalanExperience')),
            value: _filters.hasShaakhaaExperience,
            onChanged: (value) {
              setState(() {
                _filters.hasShaakhaaExperience = value ?? false;
              });
            },
          ),
          if (_filters.hasShaakhaaExperience) ...[
            SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildExpCheckbox('Baal', _filters.shaakhaaExp.baal, (v) {
                  setState(() => _filters.shaakhaaExp.baal = v ?? false);
                }),
                _buildExpCheckbox('TarunVidyaarthi', _filters.shaakhaaExp.tarunVidyaarthi, (v) {
                  setState(() => _filters.shaakhaaExp.tarunVidyaarthi = v ?? false);
                }),
                _buildExpCheckbox('TarunVyavasaayee', _filters.shaakhaaExp.tarunVyavasaayee, (v) {
                  setState(() => _filters.shaakhaaExp.tarunVyavasaayee = v ?? false);
                }),
                _buildExpCheckbox('ProudhVyavasaayee', _filters.shaakhaaExp.proudhaVyavasaayee, (v) {
                  setState(() => _filters.shaakhaaExp.proudhaVyavasaayee = v ?? false);
                }),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildExpCheckbox(String label, bool value, Function(bool?) onChanged) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width - 64) / 2,
      child: CheckboxListTile(
        title: Text(Statics.getLabel(label)),
        value: value,
        dense: true,
        controlAffinity: ListTileControlAffinity.leading,
        onChanged: onChanged,
      ),
    );
  }

  // Placeholder for other sections - implement similarly
  Widget _buildOccupationSection() => SizedBox();

  Widget _buildPratidnyaSection() => SizedBox();

  Widget _buildSanghaShikshanSection() => SizedBox();

  Widget _buildVehicleSection() => SizedBox();

  Widget _buildGanaveshSection() => SizedBox();

  Widget _buildSocialMediaSection() => SizedBox();

  Widget _buildAreasSection() => SizedBox();

  Widget _buildResultsTab() {
    return SwayamsevakListContainer(
      swList: _swList,
      isSelectAll: _isSelectAll,
      onSelectAll: _onSelectAll,
      onCheckCard: _onCheckCard,
      onUnCheckCard: _onUncheckCard,
      search: (type) => _performSearch(),
    );
  }
}

// ============================================================================
// MODERN CARD WRAPPER
// ============================================================================

class ModernCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const ModernCard({
    Key? key,
    required this.title,
    required this.icon,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.purple],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.white, size: 22),
                SizedBox(width: 12),
                Text(
                  Statics.getLabel(title),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: child,
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// HELPER CLASSES
// ============================================================================

class AreaItem {
  final int id;
  final String name;
  bool isSelected;

  AreaItem({
    required this.id,
    required this.name,
    this.isSelected = false,
  });
}*/

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

import '../../dialogs/levelwise_dropdown.dart';
import '../../helpers/static_data.dart' as Statics;
import '../../providers/bals.dart';
import '../../providers/swayamsevak_provider.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/legend.dart';
import '../../widgets/swayamsevak_card.dart';
import '../../widgets/titlebar.dart';
import '../home_screen/home_screen.dart';
import 'edit_module/edit_swayamsevak_basic_info.dart';
import 'edit_module/edit_swayamsevak_screen.dart';
import 'edit_module/edit_swayamsevak_soochi.dart';

class SwayamSevakSearch extends StatefulWidget {
  static const routeName = '/swayamsevak-search';

  @override
  _SwayamSevakSearchState createState() => _SwayamSevakSearchState();
}

class _SwayamSevakSearchState extends State<SwayamSevakSearch> with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();
  var _shikshaFromYearCntrl = TextEditingController();
  var _shikshaToYearCntrl = TextEditingController();

  bool? _isSearching = false;
  bool? _isExpanded = false;

  bool? _isMukhyaSharirikVishayExpanded = false;
  bool? _isAnyaSharirikVishayExpanded = false;
  bool? _isPratidnyit = null;
  List<String>? strEmail = [];
  List<String>? strMobile = [];
  List<String>? strSwId = [];
  bool _isSelectAll = false;

  List<GeoUnitMasterBAL>? _linkedbhaag;
  List<GeoUnitMasterBAL>? _linkedshahar;
  List<GeoUnitMasterBAL>? _linkednagar;
  List<GeoUnitMasterBAL>? _linkedmandal;
  List<GeoUnitMasterBAL>? _linkedgraam;
  List<GeoUnitMasterBAL>? _linkedvasti;

  String? _linkedbhaagValue = "";
  String? _linkedshaharValue = "";
  String? _linkednagarValue = "";
  String? _linkedmandalValue = "";
  String? _linkedgraamValue = "";
  String? _linkedvastiValue = "";

  String? _sanghaShikshaVarsha = "";
  String? _vehicleValue = "";
  String? geoUnitIDnew;

  bool? _isTrainedInMukhyaDanda = false;
  bool? _isTrainedInMukhyaNiyuddha = false;
  bool? _isTrainedInMukhyaPadavinyas = false;
  bool? _isTrainedInMukhyaYogaasan = false;
  bool? _isTrainedInMukhyaYogachaap = false;
  bool? _isTrainedInMukhyaDandaYuddha = false;
  bool? _isTrainedInAnyaDanda = false;
  bool? _isTrainedInAnyaNiyuddha = false;
  bool? _isTrainedInAnyaPadavinyas = false;
  bool? _isTrainedInAnyaYogaasan = false;
  bool? _isTrainedInAnyaYogachaap = false;
  bool? _isTrainedInAnyaDandaYuddha = false;

  bool? _isGanveshComplete = false;
  bool? _noCap = false;
  bool? _noShirt = false;
  bool? _noPant = false;
  bool? _noBelt = false;
  bool? _noShoes = false;
  bool? _noSocks = false;
  bool? _noDanda = false;

  bool? _shishu = false;
  bool? _baal = false;
  bool? _tarunVidyarthi = false;
  bool? _taarunVyavsai = false;
  bool? _prudhVyavsai = false;
  bool? _isDobAvail = false;

  var _pratidnyaYearCtrl = TextEditingController();

  List<StaticMasterBAL>? _program;

  StaticMasterBAL? _programValue;

  List<StaticMasterBAL>? _standard;

  StaticMasterBAL? _standardValue;

  bool? _isMon = null;
  bool? _isTue = null;
  bool? _isWed = null;
  bool? _isThu = null;
  bool? _isFri = null;
  bool? _isSat = null;
  bool? _isSun = null;

  //bool _isShaakhaaSanchalan = null;

  var _schoolNameCntrl = TextEditingController();

  int? _educationUniversityID = null;
  var _educationUniversityNameCntrl = TextEditingController();
  var _educationOthrUniversityNameCntrl = TextEditingController();
  int? _collegeID = null;
  var _collegeNameCntrl = TextEditingController();
  var _collegeOthrNameCntrl = TextEditingController();
  int? _educationStandardID = null;
  var _educationStandardNameCntrl = TextEditingController();
  var _educationOthrStandardNameCntrl = TextEditingController();
  int? _educationProgramID = null;
  var _educationProgramName = TextEditingController();
  var _educationOthrProgramName = TextEditingController();
  int? _educationCourseID = null;
  var _educationCourseName = TextEditingController();
  var _educationOthrCourseName = TextEditingController();

  var _govtDeptCtrl = TextEditingController();
  var _organizationNameCtrl = TextEditingController();
  var _industrialVerticalCtrl = TextEditingController();
  var _officeLocationCtrl = TextEditingController();
  var _organizationAtRetirementCtrl = TextEditingController();
  var _desgAtRetirementCtrl = TextEditingController();
  var _deptAtRetirementCtrl = TextEditingController();

  StaticMasterBAL? _daayitvaForValue;
  String? _levelValue = "";
  String? _daayitvaValue = "";
  String? _geoUnitsValue = "";
  TextEditingController _daayitvaController = TextEditingController();

  List<StaticMasterBAL>? _daayitvaFor;
  List<LevelMasterBAL>? _level;
  List<GeoUnitMasterBAL>? _geoUnits;
  List<dynamic>? _sanghaPreritSanstha;
  String? _preritSansthaValue = "";
  var _othOrgNameCtrl = TextEditingController();

  bool _hasShaakhaaExperience = false;
  bool _hasBaalShaakhaaExperience = false;
  bool _hasTarunVidShaakhaaExperience = false;
  bool _hasTarunVyavShaakhaaExperience = false;
  bool _hasProudhaVyavShaakhaaExperience = false;

  List<StaticMasterBAL>? _category;
  StaticMasterBAL? _categoryValue;
  String? _progValue;
  List<DropdownMenuItem> _prog = [
    new DropdownMenuItem(child: Text(Statics.getLabel('Science')), value: "Science"),
    new DropdownMenuItem(child: Text(Statics.getLabel('Commerce')), value: "Commerce"),
    new DropdownMenuItem(child: Text(Statics.getLabel('Arts')), value: "Arts"),
  ];
  bool? _hasVehicleDriver = false;

  Future<List<dynamic>>? _swList;

  TabController? _tabController;

  List<StaticMasterBAL>? _bloodGroup;
  List<StaticMasterBAL>? _motherTongue;
  List<StaticMasterBAL>? _shaakhaSanchalan;
  String? _bldGrpvalue = "";
  String? _mthrTngvalue = "";
  String? _shaakhaSanchalanvalue = "";

  bool? _isPrathamGhoshVishayExpanded = false;
  bool? _isDwitiyaGhoshVishayExpanded = false;
  bool? _isTrutiyaGhoshVishayExpanded = false;
  bool? _isAnyaGhoshVishayExpanded = false;

  bool? _isTrainedInPrathamVanshi = false;
  bool? _isTrainedInPrathamVenu = false;
  bool? _isTrainedInPrathamAanak = false;
  bool? _isTrainedInPrathamShankha = false;
  bool? _isTrainedInPrathamNaagaanga = false;
  bool? _isTrainedInPrathamTurya = false;
  bool? _isTrainedInPrathamSwarad = false;
  bool? _isTrainedInPrathamGomukha = false;

  bool? _isTrainedInDwitiyaVanshi = false;
  bool? _isTrainedInDwitiyaVenu = false;
  bool? _isTrainedInDwitiyaAanak = false;
  bool? _isTrainedInDwitiyaShankha = false;
  bool? _isTrainedInDwitiyaNaagaanga = false;
  bool? _isTrainedInDwitiyaTurya = false;
  bool? _isTrainedInDwitiyaSwarad = false;
  bool? _isTrainedInDwitiyaGomukha = false;

  bool? _isTrainedInTrutiyaVanshi = false;
  bool? _isTrainedInTrutiyaVenu = false;
  bool? _isTrainedInTrutiyaAanak = false;
  bool? _isTrainedInTrutiyaShankha = false;
  bool? _isTrainedInTrutiyaNaagaanga = false;
  bool? _isTrainedInTrutiyaTurya = false;
  bool? _isTrainedInTrutiyaSwarad = false;
  bool? _isTrainedInTrutiyaGomukha = false;

  bool? _isTrainedInAnyaVanshi = false;
  bool? _isTrainedInAnyaVenu = false;
  bool? _isTrainedInAnyaAanak = false;
  bool? _isTrainedInAnyaShankha = false;
  bool? _isTrainedInAnyaNaagaanga = false;
  bool? _isTrainedInAnyaTurya = false;
  bool? _isTrainedInAnyaSwarad = false;
  bool? _isTrainedInAnyaGomukha = false;

  var _rachanaaCountPrathamCntrl = TextEditingController();
  var _rachanaaCountDwitiyaCntrl = TextEditingController();
  var _rachanaaCountTrutiyaCntrl = TextEditingController();
  var _rachanaaCountAnyaCntrl = TextEditingController();

  bool? _isPrathamLipi = null;
  bool? _isDwitiyaLipi = null;
  bool? _isTrutiyaLipi = null;
  bool? _isAnyaLipi = null;
  List<MenuChoices>? choices = [];

  bool? _hasBeenShikshak = null;
  bool? _noDaayitva = null;
  bool? _wasVistaarak = null;
  bool? _wasPrachaarak = null;
  bool? _pravaasi = null;
  List<AreaOfInterestBAL> _areaOfInterestForSearch = [];
  List<AreaOfExpertiseBAL> _areaOfExpertiseForSearch = [];

  List<DropdownMenuItem<String>> _sortingOn = [
    new DropdownMenuItem(child: Text(Statics.getLabel("Name")), value: "Name"),
    new DropdownMenuItem(child: Text(Statics.getLabel("LinkedGeoUnit")), value: "Niwas Vasti/Graam"),
    new DropdownMenuItem(child: Text(Statics.getLabel("Daayitva")), value: "Daayitva"),
    new DropdownMenuItem(child: Text(Statics.getLabel("SanghaShikshan")), value: "Sangha Shikshan"),
  ];

  Map<String, String> _sanghashikshanItems = {
    'संघ शिक्षण न झालेले': 'None',
    'प्रारंभिक': 'prarambhik',
    'प्राथमिक': 'Praathamik',
    'प्रथम वर्ष / संघ शिक्षा वर्ग': 'Pratham',
    'द्वितीय वर्ष / कार्यकर्ता विकास वर्ग प्रथम': 'Dwitiya',
    'तृतीय वर्ष / कार्यकर्ता विकास वर्ग द्वितीय': 'Trutiya',
  };

  String _sortingOnValue = "Name";

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
    _daayitvaController.dispose();
    _shikshaFromYearCntrl.dispose();
    _shikshaToYearCntrl.dispose();
    _pratidnyaYearCtrl.dispose();
    _schoolNameCntrl.dispose();
    _educationUniversityNameCntrl.dispose();
    _educationOthrUniversityNameCntrl.dispose();
    _collegeNameCntrl.dispose();
    _collegeOthrNameCntrl.dispose();
    _educationStandardNameCntrl.dispose();
    _educationOthrStandardNameCntrl.dispose();
    _educationProgramName.dispose();
    _educationOthrProgramName.dispose();
    _educationCourseName.dispose();
    _educationOthrCourseName.dispose();
    _govtDeptCtrl.dispose();
    _organizationNameCtrl.dispose();
    _industrialVerticalCtrl.dispose();
    _officeLocationCtrl.dispose();
    _organizationAtRetirementCtrl.dispose();
    _desgAtRetirementCtrl.dispose();
    _deptAtRetirementCtrl.dispose();
    _rachanaaCountPrathamCntrl.dispose();
    _rachanaaCountDwitiyaCntrl.dispose();
    _rachanaaCountTrutiyaCntrl.dispose();
    _rachanaaCountAnyaCntrl.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 2, vsync: this);
    Future.delayed(Duration.zero, () {
      populateChoice();
      populateDropdown();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void populateChoice() {
    setState(() {
      choices = [
        new MenuChoices("AddinSoochi", Icons.list, Statics.getLabel('addinSoochi')),
        new MenuChoices("SendMail", Icons.mail, Statics.getLabel('SendMail')),
        new MenuChoices("SendSMS", Icons.sms, Statics.getLabel('SendSMS')),
        // if (Statics.userDetails['MobileNumber'] == '9322406725-1234') new MenuChoices("EditMenuNew", Icons.add, Statics.getLabel('AddSwayamsevak') + '-New'),

        /// CONFIRMATION FROM MAHESH JOSHI SIR TO MAKE IT OPEN TO ALL
        // if ((int.parse(Statics.userDetails['LevelID']) >= 4 &&
        //         (Statics.userDetails["DaayitvaName"] == "Join RSS Sanyojak" ||
        //             Statics.userDetails["DaayitvaName"] == "जॉयन आर.एस.एस. संयोजक" ||
        //             Statics.userDetails["DaayitvaName"] == "Join RSS Pramukh" ||
        //             Statics.userDetails["DaayitvaName"] == "जॉयन आर.एस.एस. प्रमुख" ||
        //             Statics.userDetails['DaayitvaName'] == 'Kaaryavaah' ||
        //             Statics.userDetails['DaayitvaName'] == 'कार्यवाह' ||
        //             Statics.userDetails["DaayitvaName"] == "karyalay sachiv" ||
        //             Statics.userDetails["DaayitvaName"] == "कार्यालय सचिव" ||
        //             Statics.userDetails['DaayitvaName'] == 'Saha-Kaaryavaah' ||
        //             Statics.userDetails['DaayitvaName'] == 'सह कार्यवाह' ||
        //             Statics.userDetails['DaayitvaName'] == 'Prachaarak' ||
        //             Statics.userDetails['DaayitvaName'] == 'प्रचारक' ||
        //             Statics.userDetails['DaayitvaName'] == 'Saha-Prachaarak' ||
        //             Statics.userDetails['DaayitvaName'] == 'सह प्रचारक' ||
        //             Statics.userDetails['DaayitvaName'] == 'बाल विद्यार्थी प्रमुख' ||
        //             Statics.userDetails['DaayitvaName'] == 'Baal Vidyaarthi Pramukh' ||
        //             Statics.userDetails['DaayitvaName'] == 'बाल विद्यार्थी प्रमुख' ||
        //             Statics.userDetails['DaayitvaName'] == 'Milan Pramukh' ||
        //             Statics.userDetails['DaayitvaName'] == 'Vyavasaayee Pramukh' ||
        //             Statics.userDetails['DaayitvaName'] == 'व्यवसायी प्रमुख' ||
        //             Statics.userDetails['DaayitvaName'] == 'व्यवसायी प्रमुख' ||
        //             Statics.userDetails['DaayitvaName'] == 'Vyavasaayee Saha-Pramukh' ||
        //             Statics.userDetails['DaayitvaName'] == 'व्यवसायी सह प्रमुख' ||
        //             Statics.userDetails['DaayitvaName'] == 'व्यवसायी सह प्रमुख' ||
        //             Statics.userDetails['DaayitvaName'] == 'Tarun Vyavsayee Pramukh' ||
        //             Statics.userDetails['DaayitvaName'] == 'तरुण व्यवसायी प्रमुख' ||
        //             Statics.userDetails['DaayitvaName'] == 'तरुण व्यवसायी प्रमुख' ||
        //             Statics.userDetails['DaayitvaName'] == 'Praudh Vyavsayee Pramukh' ||
        //             Statics.userDetails['DaayitvaName'] == 'प्रौढ व्यवसायी प्रमुख' ||
        //             Statics.userDetails['DaayitvaName'] == 'प्रौढ व्यवसायी प्रमुख' ||
        //             Statics.userDetails['DaayitvaName'] == 'Tarun Vyavsayee Sah Pramukh' ||
        //             Statics.userDetails['DaayitvaName'] == 'तरुण व्यवसायी सह प्रमुख' ||
        //             Statics.userDetails['DaayitvaName'] == 'तरुण व्यवसायी सह प्रमुख' ||
        //             Statics.userDetails['DaayitvaName'] == 'Praudh Vyavsayee Sah Pramukh' ||
        //             Statics.userDetails['DaayitvaName'] == 'प्रौढ व्यवसायी सह प्रमुख' ||
        //             Statics.userDetails['DaayitvaName'] == 'प्रौढ व्यवसायी सह प्रमुख' ||
        //             Statics.userDetails['DaayitvaName'] == 'Bal Vidyarthi Sah Pramukh' ||
        //             Statics.userDetails['DaayitvaName'] == 'बाल विद्यार्थी सह प्रमुख' ||
        //             Statics.userDetails['DaayitvaName'] == 'बाल विद्यार्थी सह प्रमुख' ||
        //             Statics.userDetails['DaayitvaName'] == 'Mahavidyaleen Vidyarthi Sah Pramukh' ||
        //             Statics.userDetails['DaayitvaName'] == 'महाविद्यालयीन विद्यार्थी सह प्रमुख' ||
        //             Statics.userDetails['DaayitvaName'] == 'महाविद्यालयीन विद्यार्थी सह प्रमुख' ||
        //             Statics.userDetails['DaayitvaName'] == 'App Sanyojak' ||
        //             Statics.userDetails['DaayitvaName'] == 'एप संयोजक' ||
        //             Statics.userDetails['DaayitvaName'] == 'Kaaryaalay Pramukh' ||
        //             Statics.userDetails['DaayitvaName'] == 'कार्यालय प्रमुख')) ||
        //     (Statics.userDetails['LevelName'] == 'Vasti' ||
        //         Statics.userDetails['LevelName'] == 'वस्ती' &&
        //             (Statics.userDetails['DaayitvaName'] == 'Vasti Pramukh' ||
        //                 Statics.userDetails['DaayitvaName'] == 'वस्ती प्रमुख' ||
        //                 Statics.userDetails['DaayitvaName'] == 'Vasti Saha-Pramukh' ||
        //                 Statics.userDetails['DaayitvaName'] == 'वस्ती सह प्रमुख')) ||
        //     (Statics.userDetails['LevelName'] == 'Shaakhaa' ||
        //         Statics.userDetails['LevelName'] == 'शाखा' &&
        //             (Statics.userDetails['DaayitvaName'] == 'Mukhya Shikshak' ||
        //                 Statics.userDetails['DaayitvaName'] == 'Kaaryavaah' ||
        //                 Statics.userDetails['DaayitvaName'] == 'Sangha Mandali Pramukh' ||
        //                 Statics.userDetails['DaayitvaName'] == 'Sangha Mandali Saha-Pramukh' ||
        //                 Statics.userDetails['DaayitvaName'] == 'Milan Pramukh' ||
        //                 Statics.userDetails['DaayitvaName'] == 'शाखा मिलन प्रमुख' ||
        //                 Statics.userDetails['DaayitvaName'] == 'Shaakhaa Milan Pramukh' ||
        //                 Statics.userDetails['DaayitvaName'] == 'शाखा मिलन प्रमुख' ||
        //                 Statics.userDetails['DaayitvaName'] == 'Milan Saha-Pramukh')))
        new MenuChoices("EditMenu", Icons.add, Statics.getLabel('AddSwayamsevak')),
      ];
    });
  }

  List<DropdownMenuItem<String>> _usage = [
    new DropdownMenuItem(child: Text(Statics.getLabel('SocialMediaUsageNone')), value: "None"),
    new DropdownMenuItem(child: Text(Statics.getLabel('SocialMediaUsageLow')), value: "Low"),
    new DropdownMenuItem(child: Text(Statics.getLabel('SocialMediaUsageMedium')), value: "Medium"),
    new DropdownMenuItem(child: Text(Statics.getLabel('SocialMediaUsageHigh')), value: "High"),
  ];
  bool? _isfb;
  bool? _isinsta;
  bool? _istwt;
  String? _fbUsage;
  String? _instaUsage;
  String? _twtUsage;

  Future<void> populateDropdown() async {
    var data = await Statics.getStaticLDB('OccupationCategory');
    var data4 = await Statics.getStaticLDB("DaayitvaFor");
    var data5 = await Statics.getLevelLDB();
    var data1 = await Statics.getStaticLDB("BloodGroup");
    var data2 = await Statics.getStaticLDB("MotherTongue");
    var data3 = await Statics.getStaticLDB("ShaakhaaExperienceYear");
    var data6 = await Statics.getSanghaPreritSanstha("1", null, null);
    var data7 = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['BhaagLevelID'].toString(), "", "", "");
    var aoi = await Statics.getStaticLDB("AreaOfInterest");
    var aoe = await Statics.getStaticLDB("AreaOfExpertise");
    setState(() {
      for (var data in aoi) {
        _areaOfInterestForSearch.add(new AreaOfInterestBAL(data.staticID, data.code, data.codeForDisplay, false));
      }

      for (var data in aoe) {
        _areaOfExpertiseForSearch.add(new AreaOfExpertiseBAL(data.staticID, data.code, data.codeForDisplay, false));
      }
      _category = data;
      _daayitvaFor = data4;
      _level = data5;
      _bloodGroup = data1;
      _motherTongue = data2;
      _shaakhaSanchalan = data3;
      _sanghaPreritSanstha = data6;
      _linkedbhaag = data7;
      _linkedshaharValue = null;
      _linkednagarValue = null;
      _linkedmandalValue = null;
      _linkedgraamValue = null;
      _linkedvastiValue = null;
    });
    //populatelinkedBhaagDropdown();
  }

  // void populateProgram(String strType) async {
  //   var data;
  //   if (strType == "Jr College")
  //     data = await Statics.getStaticLDB('JrCollegeProgram');
  //   else if (strType == "Senior College")
  //     data = await Statics.getStaticLDB('SrCollegeProgram');
  //   else if (strType == "Post Graduate")
  //     data = await Statics.getStaticLDB('PostGraduateProgram');
  //   else if (strType == "Correspondence Course")
  //     data = await Statics.getStaticLDB('CorrespndenceProgram');
  //   else if (strType == "Professional Studies")
  //     data = await Statics.getStaticLDB('ProfessionalProgram');
  //   setState(() {
  //     _program = data;
  //   });
  // }

  void populateStandard(String strType) async {
    var data;
    if (strType == "School Student")
      data = await Statics.getStaticLDB('SchoolStandard');
    else if (strType == "Jr College")
      data = await Statics.getStaticLDB('JrCollegeStandard');
    else if (strType == "Senior College") data = await Statics.getStaticLDB('SrCollegeStandard');

    setState(() {
      _standard = data;
    });
  }

  void populatelinkedBhaagDropdown() async {
    _linkedshaharValue = _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    var data = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['BhaagLevelID'].toString(), "", "", "");
    setState(() {
      _linkedbhaag = data;
    });
  }

  void populatelinkedShaharDropdown(String bhaagIDStr) async {
    _linkedshaharValue = _linkedvastiValue = _linkedshahar = _linkedvasti = null;
    var shDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['ShaharLevelID'].toString(), bhaagIDStr, 'Bhaag', '');
    setState(() {
      _linkedshahar = (shDD.length > 0 ? shDD : null);
    });
  }

  void populatelinkedNagarDropdown(String? bhaagIDStr, String? shaharIDStr) async {
    _linkednagarValue = _linkedmandalValue = _linkedgraamValue = _linkedvastiValue = null;
    _linkednagar = _linkedmandal = _linkedgraam = _linkedvasti = null;
    if (shaharIDStr != null) {
      var ngDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), shaharIDStr, 'Shahar', '');
      setState(() {
        _linkednagar = (ngDD.length > 0 ? ngDD : null);
      });
    } else {
      var ngDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['NagarLevelID'].toString(), bhaagIDStr!, 'Bhaag', '');
      setState(() {
        _linkednagar = (ngDD.length > 0 ? ngDD : null);
      });
    }
  }

  void populatelinkedMandalDropdown(String nagarIDStr) async {
    _linkedmandalValue = _linkedgraamValue = null;
    _linkedmandal = _linkedgraam = null;
    var mnDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['MandalLevelID'].toString(), nagarIDStr, 'Nagar', '');
    setState(() {
      _linkedmandal = (mnDD.length > 0 ? mnDD : null);
    });
  }

  void populatelinkedGraamDropdown(String mandalIDStr) async {
    _linkedgraamValue = null;
    var gmDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['GraamLevelID'].toString(), mandalIDStr, 'Mandal', '');
    setState(() {
      _linkedgraam = (gmDD.length > 0 ? gmDD : null);
    });
  }

  void populatelinkedVastiDropdown(String nagarIDStr) async {
    _linkedvastiValue = null;
    var vsDD = await Statics.getGeoUnitsByLevelAndParent(Statics.levels['VastiLevelID'].toString(), nagarIDStr, 'Nagar', '');
    setState(() {
      _linkedvasti = (vsDD.length > 0 ? vsDD : null);
    });
  }

  void populateGeoUnitforDaayitva(String levelID) async {
    var data4;
    if (levelID == "") {
      data4 = await Statics.getGeoUnitsByLevel(Statics.levels['MahaanagarLevelID']);
    } else
      data4 = await Statics.getGeoUnitsByLevel(levelID);
    setState(() {
      _geoUnits = data4;
    });
  }

  Future<List<DaayitvaMasterBAL>> populateDaayitva(String daayitvaId, String pattern) async {
    var data3 = await Statics.getDaayitvaLDB(daayitvaId, pattern, "");
    return data3;
  }

  Future<List<dynamic>> _getSwList(String strType) async {
    // print("strType :- $strType");
    bool isConnected = await Statics.isInternetConnected();
    if (isConnected) {
      int? bhaagVal = _linkedbhaagValue == null || _linkedbhaagValue == "" ? null : int.parse(_linkedbhaagValue!);
      int? shaharVal = _linkedshaharValue == null || _linkedshaharValue == "" ? null : int.parse(_linkedshaharValue!);
      int? nagarVal = _linkednagarValue == null || _linkednagarValue == "" ? null : int.parse(_linkednagarValue!);

      int? mandalVal = _linkedmandalValue == null || _linkedmandalValue == "" ? null : int.parse(_linkedmandalValue!);

      int? graamVal = _linkedgraamValue == null || _linkedgraamValue == "" ? null : int.parse(_linkedgraamValue!);

      int? vastiVal = _linkedvastiValue == null || _linkedvastiValue == "" ? null : int.parse(_linkedvastiValue!);

      int? geoUnitID;
      geoUnitID = vastiVal != null
          ? vastiVal
          : graamVal != null
              ? graamVal
              : mandalVal != null
                  ? mandalVal
                  : nagarVal != null
                      ? nagarVal
                      : shaharVal != null
                          ? shaharVal
                          : bhaagVal != null
                              ? bhaagVal
                              : null;

      String? mukhyaVishay = "";
      String? anyaVishay = "";

      if (_isTrainedInMukhyaDanda == true) mukhyaVishay += "Danda,";
      if (_isTrainedInMukhyaDandaYuddha == true) mukhyaVishay += "DandaYuddha,";
      if (_isTrainedInMukhyaNiyuddha == true) mukhyaVishay += "Niyuddha,";
      if (_isTrainedInMukhyaPadavinyas == true) mukhyaVishay += "PadaVinyaas,";
      if (_isTrainedInMukhyaYogaasan == true) mukhyaVishay += "Yogaasan,";
      if (_isTrainedInMukhyaYogachaap == true) mukhyaVishay += "YogaChaap,";

      mukhyaVishay = mukhyaVishay == "" ? null : mukhyaVishay.substring(0, mukhyaVishay.length - 1);

      if (_isTrainedInAnyaDanda == true) anyaVishay += "Danda,";
      if (_isTrainedInAnyaDandaYuddha == true) anyaVishay += "DandaYuddha,";
      if (_isTrainedInAnyaNiyuddha == true) anyaVishay += "Niyuddha,";
      if (_isTrainedInAnyaPadavinyas == true) anyaVishay += "PadaVinyaas,";
      if (_isTrainedInAnyaYogaasan == true) anyaVishay += "Yogaasan,";
      if (_isTrainedInAnyaYogachaap == true) anyaVishay += "YogaChaap,";

      anyaVishay = anyaVishay == "" ? null : anyaVishay.substring(0, anyaVishay.length - 1);

      String? prathamVaadya = "";
      if (_isTrainedInPrathamAanak == true) prathamVaadya += "Aanak,";
      if (_isTrainedInPrathamGomukha == true) prathamVaadya += "Gomukha,";
      if (_isTrainedInPrathamNaagaanga == true) prathamVaadya += "Naagaanga,";
      if (_isTrainedInPrathamShankha == true) prathamVaadya += "Shankha,";
      if (_isTrainedInPrathamSwarad == true) prathamVaadya += "Swarada,";
      if (_isTrainedInPrathamTurya == true) prathamVaadya += "Turya,";
      if (_isTrainedInPrathamVanshi == true) prathamVaadya += "Vanshi,";
      if (_isTrainedInPrathamVenu == true) prathamVaadya += "Venu,";

      prathamVaadya = prathamVaadya == "" ? null : prathamVaadya.substring(0, prathamVaadya.length - 1);

      String? dwitiyaVaadya = "";
      if (_isTrainedInDwitiyaAanak == true) dwitiyaVaadya += "Aanak,";
      if (_isTrainedInDwitiyaGomukha == true) dwitiyaVaadya += "Gomukha,";
      if (_isTrainedInDwitiyaNaagaanga == true) dwitiyaVaadya += "Naagaanga,";
      if (_isTrainedInDwitiyaShankha == true) dwitiyaVaadya += "Shankha,";
      if (_isTrainedInDwitiyaSwarad == true) dwitiyaVaadya += "Swarada,";
      if (_isTrainedInDwitiyaTurya == true) dwitiyaVaadya += "Turya,";
      if (_isTrainedInDwitiyaVanshi == true) dwitiyaVaadya += "Vanshi,";
      if (_isTrainedInDwitiyaVenu == true) dwitiyaVaadya += "Venu,";

      dwitiyaVaadya = dwitiyaVaadya == "" ? null : dwitiyaVaadya.substring(0, dwitiyaVaadya.length - 1);

      String? trutiyaVaadya = "";
      if (_isTrainedInTrutiyaAanak == true) trutiyaVaadya += "Aanak,";
      if (_isTrainedInTrutiyaGomukha == true) trutiyaVaadya += "Gomukha,";
      if (_isTrainedInTrutiyaNaagaanga == true) trutiyaVaadya += "Naagaanga,";
      if (_isTrainedInTrutiyaShankha == true) trutiyaVaadya += "Shankha,";
      if (_isTrainedInTrutiyaSwarad == true) trutiyaVaadya += "Swarada,";
      if (_isTrainedInTrutiyaTurya == true) trutiyaVaadya += "Turya,";
      if (_isTrainedInTrutiyaVanshi == true) trutiyaVaadya += "Vanshi,";
      if (_isTrainedInTrutiyaVenu == true) trutiyaVaadya += "Venu,";

      trutiyaVaadya = trutiyaVaadya == "" ? null : trutiyaVaadya.substring(0, trutiyaVaadya.length - 1);

      String? anyaVaadya = "";
      if (_isTrainedInAnyaAanak == true) anyaVaadya += "Aanak,";
      if (_isTrainedInAnyaGomukha == true) anyaVaadya += "Gomukha,";
      if (_isTrainedInAnyaNaagaanga == true) anyaVaadya += "Naagaanga,";
      if (_isTrainedInAnyaShankha == true) anyaVaadya += "Shankha,";
      if (_isTrainedInAnyaSwarad == true) anyaVaadya += "Swarada,";
      if (_isTrainedInAnyaTurya == true) anyaVaadya += "Turya,";
      if (_isTrainedInAnyaVanshi == true) anyaVaadya += "Vanshi,";
      if (_isTrainedInAnyaVenu == true) anyaVaadya += "Venu,";

      anyaVaadya = anyaVaadya == "" ? null : anyaVaadya.substring(0, anyaVaadya.length - 1);
      String? educationOrgName = "";

      if (_categoryValue != null) {
        if (_categoryValue!.code == "School Student") {
          educationOrgName = _schoolNameCntrl.text.isEmpty ? null : _schoolNameCntrl.text;
          _collegeID == null;
        } else if (_categoryValue!.code == 'Jr College') {
          _collegeID == null;
          educationOrgName = _collegeOthrNameCntrl.text.isEmpty ? null : _collegeOthrNameCntrl.text;
        } else if (_categoryValue!.code == 'Senior College' ||
            _categoryValue!.code == 'Post Graduate' ||
            _categoryValue!.code == 'Professional Studies' ||
            _categoryValue!.code == 'Correspondence Course') {
          educationOrgName = "";
        }
      }

      String? _weeklyOffDay = "";
      if (_isSun == true) _weeklyOffDay = _weeklyOffDay + "0,";
      if (_isMon == true) _weeklyOffDay = _weeklyOffDay + "1,";
      if (_isTue == true) _weeklyOffDay = _weeklyOffDay + "2,";
      if (_isWed == true) _weeklyOffDay = _weeklyOffDay + "3,";
      if (_isThu == true) _weeklyOffDay = _weeklyOffDay + "4,";
      if (_isFri == true) _weeklyOffDay = _weeklyOffDay + "5,";
      if (_isSat == true) _weeklyOffDay = _weeklyOffDay + "6,";
      //
      var areaOfInterestIDs = _areaOfInterestForSearch.where((data) => data.isSelected == true).map((data) => data.staticID.toString()).join(',');

      var areaOfExpertiseIDs = _areaOfExpertiseForSearch.where((data) => data.isSelected == true).map((data) => data.staticID.toString()).join(',');

      _weeklyOffDay = _weeklyOffDay == "" ? null : _weeklyOffDay.substring(0, _weeklyOffDay.length - 1);
      print("_geoUnitsValue  $_geoUnitsValue");
      print("geoUnitID  $geoUnitID");
      var inputData = json.encode({
        "AppUserID": Statics.userDetails["userID"],
        "SearchCriteria": _searchController.text.isEmpty ? null : _searchController.text,
        "BloodGroupID": _bldGrpvalue == "" ? null : _bldGrpvalue,
        "MotherTongueID": _mthrTngvalue == "" ? null : _mthrTngvalue,
        "ShaakhaaExperienceYearID": _shaakhaSanchalanvalue == "" ? null : _shaakhaSanchalanvalue,
        "GeoUnitID": geoUnitIDnew == "" ? null : geoUnitIDnew,
        "IsPratidnyit": _isPratidnyit,
        "PratidnyaYear": _pratidnyaYearCtrl.text.isEmpty ? null : _pratidnyaYearCtrl.text,
        "IsGanaveshComplete": _isGanveshComplete,
        "NoCap": _noCap,
        "NoShirt": _noShirt,
        "NoPant": _noPant,
        "NoBelt": _noBelt,
        "NoShoes": _noShoes,
        "NoSocks": _noSocks,
        "NoDanda": _noDanda,
        "VehicleType": _vehicleValue == "" ? null : _vehicleValue,
        "HasDriver": _hasVehicleDriver,
        "SanghaShikshanCode": _sanghaShikshaVarsha == "" ? null : _sanghaShikshaVarsha,
        "SanghaShikshanYearFrom": _shikshaFromYearCntrl.text.isEmpty ? null : _shikshaFromYearCntrl.text,
        "SanghaShikshanYearTo": _shikshaToYearCntrl.text.isEmpty ? null : _shikshaToYearCntrl.text,
        "HasBeenOTCShikshak": _hasBeenShikshak,
        "MukhyaShaaririkVishayCodes": mukhyaVishay == "" ? null : mukhyaVishay,
        "AnyaShaaririkVishayCodes": anyaVishay == "" ? null : anyaVishay,
        "PrathamVaadyaCodes": prathamVaadya == "" ? null : prathamVaadya,
        "DwitiyaVaadyaCodes": dwitiyaVaadya == "" ? null : dwitiyaVaadya,
        "TrutiyaVaadyaCodes": trutiyaVaadya == "" ? null : trutiyaVaadya,
        "AnyaVaadyaCodes": anyaVaadya == "" ? null : anyaVaadya,
        "IsUnderstandLipiPrathamVaadya": _isPrathamLipi,
        "IsUnderstandLipiDwitiyaVaadya": _isDwitiyaLipi,
        "IsUnderstandLipiTrutiyaVaadya": _isTrutiyaLipi,
        "IsUnderstandLipiAnyaVaadya": _isAnyaLipi,
        "RachanaaCountPrathamVaadya": _rachanaaCountPrathamCntrl.text.isEmpty ? null : _rachanaaCountPrathamCntrl.text,
        "RachanaaCountDwitiyaVaadya": _rachanaaCountDwitiyaCntrl.text.isEmpty ? null : _rachanaaCountDwitiyaCntrl.text,
        "RachanaaCountTrutiyaVaadya": _rachanaaCountTrutiyaCntrl.text.isEmpty ? null : _rachanaaCountTrutiyaCntrl.text,
        "RachanaaCountAnyaVaadya": _rachanaaCountAnyaCntrl.text.isEmpty ? null : _rachanaaCountAnyaCntrl.text,
        "OccupationCategoryID": _categoryValue == null ? null : _categoryValue!.staticID,
        "EducationUniversityID": _educationUniversityID,
        "EducationUniversityName": _educationUniversityNameCntrl.text.trim() != "Other"
            ? null
            : _educationOthrUniversityNameCntrl.text.trim() == ""
                ? null
                : _educationOthrUniversityNameCntrl.text,
        "EducationInstitutionID": _collegeID,
        "EducationInstitutionName": educationOrgName == "" ? null : educationOrgName,
        "EducationProgramID": _educationProgramID,
        "EducationProgramName": _educationProgramName.text.trim() != "Other"
            ? null
            : _educationOthrProgramName.text.trim() == ""
                ? null
                : _educationOthrProgramName.text,
        "EducationCourseID": _educationCourseID,
        "EducationCourseName": _educationCourseName.text.trim() != "Other"
            ? null
            : _educationOthrCourseName.text.trim() == ""
                ? null
                : _educationOthrCourseName.text,
        "EducationStandardID": _standardValue == null ? null : _standardValue!.staticID,
        "EducationStandardName": _standardValue != null && _standardValue!.code == "Other"
            ? _educationOthrStandardNameCntrl.text.trim() == ""
                ? null
                : _educationStandardNameCntrl.text
            : null,
        "GovernmentDepartment": _govtDeptCtrl.text.isEmpty ? null : _govtDeptCtrl.text,
        "Designation": null,
        "OfficeLocation": _officeLocationCtrl.text.isEmpty ? null : _officeLocationCtrl.text,
        "WeeklyOffDayIDs": _weeklyOffDay,
        "OrganizationName": _organizationNameCtrl.text.isEmpty ? null : _organizationNameCtrl.text,
        "IndustryVertical": _industrialVerticalCtrl.text.isEmpty ? null : _industrialVerticalCtrl.text,
        "OrganizationAtRetirement": _organizationAtRetirementCtrl.text.isEmpty ? null : _organizationAtRetirementCtrl.text,
        "DesignationAtRetirement": _desgAtRetirementCtrl.text.isEmpty ? null : _desgAtRetirementCtrl.text,
        "DepartmentAtRetirement": _deptAtRetirementCtrl.text.isEmpty ? null : _deptAtRetirementCtrl.text,
        "DaayitvaForID": _daayitvaForValue == null ? null : _daayitvaForValue!.staticID,
        "DaayitvaID": _daayitvaValue == "" ? null : _daayitvaValue,
        "DaayitvaLevelID": _levelValue == "" ? null : _levelValue,
        "DaayitvaGeoUnitID": _geoUnitsValue == "" ? null : _geoUnitsValue,
        // "DaayitvaGeoUnitID": geoUnitID == "" ? null : geoUnitID,
        "IsNoDaayitva": _noDaayitva,
        "IsPravaasi": _pravaasi,
        "SanghaPreritSansthaaID": _preritSansthaValue == "" ? null : _preritSansthaValue,
        "SocialOrganizationName": _othOrgNameCtrl.text.isEmpty ? null : _othOrgNameCtrl.text,
        "SortOrder": _sortingOnValue == "Name" ? "FullName" : "SwayamsevakID",
//
        "HasBeenVistaarak": _wasVistaarak,
        "HasBeenPrachaarak": _wasPrachaarak,
        //
        "HasShaakhaaSanchaalanExperience": _hasShaakhaaExperience,
        "HasBaalShaakhaaExperience": _hasBaalShaakhaaExperience,
        "HasTarunVidyaarthiShaakhaaExperience": _hasTarunVidShaakhaaExperience,
        "HasTarunVyavasaayeeShaakhaaExperience": _hasTarunVyavShaakhaaExperience,
        "HasProudhaVyavasaayeeShaakhaaExperience": _hasProudhaVyavShaakhaaExperience,
        //
        "HasFacebook": _isfb,
        "HasInstagram": _isinsta,
        "HasTwitter": _istwt,
        "FacebookUsage": _fbUsage,
        "InstagramUsage": _instaUsage,
        "TwitterUsage": _twtUsage,
        //
        "AreaOfInterestIDs": areaOfInterestIDs.trim() == '' ? null : areaOfInterestIDs,
        "AreaOfExpertiseIDs": areaOfExpertiseIDs.trim() == '' ? null : areaOfExpertiseIDs,
        //
        "shishu": _shishu,
        "baal": _baal,
        "vidhyarthi": _tarunVidyarthi,
        "vyavsai": _taarunVyavsai,
        "proudhvyavsai": _prudhVyavsai,
        "notavaiable": _isDobAvail,
      });
      if (strType == "Search")
        return SwayamsevakProvider().getSwayamsevaks(inputData);
      else if (strType == "Export") log('getSwayamsevaksForExport() Swayamsevaks - ' + inputData);
      return SwayamsevakProvider().getSwayamsevaksForExport(inputData);
    } else {
      Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
      return [];
    }
  }

  void _getCsv() async {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      _isSearching = true;
    });
    List<dynamic> dataList = await _getSwList("Export");
    print("datalist :--   $dataList");
    if (dataList == null || dataList.length == 0) {
      Statics.showMessageDialog(context, Statics.getLabel('noDataFoundTryAnotherSearch'));
      setState(() {
        _isSearching = false;
      });
      return;
    }

    List<List<dynamic>> rows = [];
    List<dynamic> header = [];
    header.add('Full Name');
    header.add("Mobile Number");
    header.add("E-mail");
    header.add("Home GeoUnit Name");
    header.add("Linked Shaakhaa");
    header.add("Preferred Language");
    header.add("Can Use App");
    header.add("Daayitva GeoUnit Name");
    header.add("Level Name");
    header.add("Daayitva Name");
    header.add("Daayitva Start Year");
    header.add("Aayaam Name");
    header.add("Gatividhi Name");

    header.add("Current Address Line 1");
    header.add("Current Address Line 2");
    header.add("Current Graam");
    header.add("Current Post Office");
    header.add("Current City");
    header.add("Current District");
    header.add("Current PinCode");
    header.add("Current State");
    header.add("Permanent Address Line 1");
    header.add("Permanent Address Line 2");
    header.add("Permanent Graam");
    header.add("Permanent Post Office");
    header.add("Permanent City");
    header.add("Permanent District");
    header.add("Permanent PinCode");
    header.add("Permanent State");
    header.add("Secondary Mobile Number");
    header.add("Office Phone Number");
    header.add("Home Phone Number");
    header.add("Whats App Number");
    header.add("Secondary Email");
    header.add("Twitter Handle");
    header.add("Instagram Handle");
    header.add("Koo Handle");
    header.add("Is Pratidnyit");
    header.add("Pratidnya Year");

    header.add("Is Ganavesh Complete");
    header.add("Has Cap");
    header.add("Has Shirt");
    header.add("Has Pant");
    header.add("Has Belt");
    header.add("Has Shoes");
    header.add("Has Socks");
    header.add("Has Danda");

    header.add("Has 2 Wheeleer");
    header.add("Has 3 Wheeleer");
    header.add("Has 4 Wheeleer");
    header.add("Has Vehicle Driver");

    header.add("Blood Group");
    header.add("Mother Tongue");
    header.add("Birth Date");
    header.add("Sangha Pravesh Year");
    header.add("Facebook Usage");
    header.add("Twitter Usage");
    header.add("Koo Usage");
    header.add("Instagram Usage");
    header.add("Education");
    header.add("Shaakhaa Sanchalan Experience");

    header.add("Sangha Prerit Sansthaa Name");
    header.add("Sangha Prerit Sansthaa Designation");
    header.add("Sangha Prerit Sansthaa Remark");
    header.add("Other Social Organization Name");
    header.add("Other Social Organization Designation");
    header.add("Other Social Organization Remark");

    header.add("Praathamik Year");
    header.add("Pratham Varsha Year");
    header.add("Dwitiya Varsha Year");
    header.add("Trutiya Varsha Year");
    header.add("Years As Praathamik Shikshak");
    header.add("Years As Pratham Varsha Shikshak");
    header.add("Years As Dwitiya Varsha Shikshak");
    header.add("Years As Trutiya Varsha Shikshak");

    header.add("Danda");
    header.add("Niyuddha");
    header.add("Yogaasan");
    header.add("Yogachaap");
    header.add("Padavinyas");
    header.add("Danda-Yuddha");

    header.add("Vanshi");
    header.add("Vanshi Rachnaa Count");
    header.add("Vanshi Understand Lipi");

    header.add("Venu");
    header.add("Venu Rachnaa Count");
    header.add("Venu Understand Lipi");

    header.add("Aanak");
    header.add("Aanak Rachnaa Count");
    header.add("Aanak Understand Lipi");

    header.add("Shankha");
    header.add("Shankha Rachnaa Count");
    header.add("Shankha Understand Lipi");

    header.add("Naagaanga");
    header.add("Naagaanga Rachnaa Count");
    header.add("Naagaanga Understand Lipi");

    header.add("Turya");
    header.add("Turya Rachnaa Count");
    header.add("Turya Understand Lipi");

    header.add("Swarada");
    header.add("Swarada Rachnaa Count");
    header.add("Swarada Understand Lipi");

    header.add("Gomukha");
    header.add("Gomukha Rachnaa Count");
    header.add("Gomukha Understand Lipi");

    header.add("Category");
    header.add("Education University Name");
    header.add("Education Institution Name");
    header.add("Education Standard Name");
    header.add("Education Program Name");
    header.add("Education Course Name");
    header.add("Expected Completion Year");
    header.add("Government Department");
    header.add("Oragnization Name");
    header.add("Industrial Vertical");
    header.add("Designation");
    header.add("Office Location");
    header.add("Weekly Off Day");
    header.add("Office Timing From");
    header.add("Office Timing To");
    header.add("Organization At Retirement");
    header.add("Designation At Retirement");
    header.add("Department At Retirement");

    rows.add(header);
    for (int i = 0; i < dataList.length; i++) {
      var data = dataList[i];

      //row refer to each column of a row in csv file and rows refer to each row in a file
      List<dynamic> row = [];
      row.add(data["BasicInfo"]["FullName"].toString());
      row.add(data["BasicInfo"]["MobileNumber"].toString());
      row.add(data["BasicInfo"]["Email"].toString());
      row.add(data["BasicInfo"]["LinkedGeoUnitName"] == null ? "" : data["BasicInfo"]["LinkedGeoUnitName"].toString());
      row.add(data["BasicInfo"]["LinkedShaakhaaName"] == null ? "" : data["BasicInfo"]["LinkedShaakhaaName"].toString());
      row.add(data["BasicInfo"]["PreferredLanguageCode"] == null ? "" : data["BasicInfo"]["PreferredLanguageCode"].toString());
      row.add(data["BasicInfo"]["CanUseApp"] == null
          ? ""
          : data["BasicInfo"]["CanUseApp"] == true
              ? "Yes"
              : "No");
      row.add(data["CurrentDaayitva"]["DaayitvaGeoUnitName"] == null ? "" : data["CurrentDaayitva"]["DaayitvaGeoUnitName"].toString());
      row.add(data["CurrentDaayitva"]["LevelName"] == null ? "" : data["CurrentDaayitva"]["LevelName"].toString());
      row.add(data["CurrentDaayitva"]["DaayitvaName"] == null ? "" : data["CurrentDaayitva"]["DaayitvaName"].toString());
      row.add(data["CurrentDaayitva"]["StartYear"] == null ? "" : data["CurrentDaayitva"]["StartYear"].toString());
      row.add(data["CurrentDaayitva"]["AayaamName"] == null ? "" : data["CurrentDaayitva"]["AayaamName"].toString());
      row.add(data["CurrentDaayitva"]["GatividhiName"] == null ? "" : data["CurrentDaayitva"]["GatividhiName"].toString());

      row.add(data["OtherInfo"]["CurrentAddressLine1"] == null ? "" : data["OtherInfo"]["CurrentAddressLine1"].toString());
      row.add(data["OtherInfo"]["CurrentAddressLine2"] == null ? "" : data["OtherInfo"]["CurrentAddressLine2"].toString());
      row.add(data["OtherInfo"]["CurrentGraamName"] == null ? "" : data["OtherInfo"]["CurrentGraamName"].toString());
      row.add(data["OtherInfo"]["CurrentPostOffice"] == null ? "" : data["OtherInfo"]["CurrentPostOffice"].toString());
      row.add(data["OtherInfo"]["CurrentCity"] == null ? "" : data["OtherInfo"]["CurrentCity"].toString());
      row.add(data["OtherInfo"]["CurrentDistrict"] == null ? "" : data["OtherInfo"]["CurrentDistrict"].toString());
      row.add(data["OtherInfo"]["CurrentPinCode"] == null ? "" : data["OtherInfo"]["CurrentPinCode"].toString());
      row.add(data["OtherInfo"]["CurrentStateName"] == null ? "" : data["OtherInfo"]["CurrentStateName"].toString());

      row.add(data["OtherInfo"]["PermanentAddressLine1"] == null ? "" : data["OtherInfo"]["PermanentAddressLine1"].toString());
      row.add(data["OtherInfo"]["PermanentAddressLine2"] == null ? "" : data["OtherInfo"]["PermanentAddressLine2"].toString());
      row.add(data["OtherInfo"]["PermanentGraamName"] == null ? "" : data["OtherInfo"]["PermanentGraamName"].toString());
      row.add(data["OtherInfo"]["PermanentPostOffice"] == null ? "" : data["OtherInfo"]["PermanentPostOffice"].toString());
      row.add(data["OtherInfo"]["PermanentCity"] == null ? "" : data["OtherInfo"]["PermanentCity"].toString());
      row.add(data["OtherInfo"]["PermanentDistrict"] == null ? "" : data["OtherInfo"]["PermanentDistrict"].toString());
      row.add(data["OtherInfo"]["PermanentPinCode"] == null ? "" : data["OtherInfo"]["PermanentPinCode"].toString());
      row.add(data["OtherInfo"]["PermanentStateName"] == null ? "" : data["OtherInfo"]["PermanentStateName"].toString());

      row.add(data["OtherInfo"]["SecondaryMobileNumber"].toString());
      row.add(data["OtherInfo"]["OfficePhoneNumber"].toString());
      row.add(data["OtherInfo"]["HomePhoneNumber"].toString());
      row.add(data["OtherInfo"]["WhatsAppNumber"].toString());
      row.add(data["OtherInfo"]["SecondaryEmail"].toString());
      row.add(data["OtherInfo"]["TwitterHandle"].toString());
      row.add(data["OtherInfo"]["InstagramHandle"].toString());
      row.add(data["OtherInfo"]["KooHandle"] ?? "");

      row.add(data["OtherInfo"]["IsPratidnyit"] == null
          ? ""
          : data["OtherInfo"]["IsPratidnyit"] == true
              ? "Yes"
              : "No");
      row.add(data["OtherInfo"]["PratidnyaYear"] == null ? "" : data["OtherInfo"]["PratidnyaYear"].toString());

      row.add(data["OtherInfo"]["IsGanaveshComplete"] == null
          ? ""
          : data["OtherInfo"]["IsGanaveshComplete"] == true
              ? "Yes"
              : "No");
      row.add(data["OtherInfo"]["HasCap"] == null
          ? ""
          : data["OtherInfo"]["HasCap"] == true
              ? "Yes"
              : "No");
      row.add(data["OtherInfo"]["HasShirt"] == null
          ? ""
          : data["OtherInfo"]["HasShirt"] == true
              ? "Yes"
              : "No");
      row.add(data["OtherInfo"]["HasPant"] == null
          ? ""
          : data["OtherInfo"]["HasPant"] == true
              ? "Yes"
              : "No");
      row.add(data["OtherInfo"]["HasBelt"] == null
          ? ""
          : data["OtherInfo"]["HasBelt"] == true
              ? "Yes"
              : "No");
      row.add(data["OtherInfo"]["HasShoes"] == null
          ? ""
          : data["OtherInfo"]["HasShoes"] == true
              ? "Yes"
              : "No");
      row.add(data["OtherInfo"]["HasSocks"] == null
          ? ""
          : data["OtherInfo"]["HasSocks"] == true
              ? "Yes"
              : "No");
      row.add(data["OtherInfo"]["HasDanda"] == null
          ? ""
          : data["OtherInfo"]["HasDanda"] == true
              ? "Yes"
              : "No");

      row.add(data["OtherInfo"]["Has2WVehicle"] == null
          ? ""
          : data["OtherInfo"]["Has2WVehicle"] == true
              ? "Yes"
              : "No");

      row.add(data["OtherInfo"]["Has3WVehicle"] == null
          ? ""
          : data["OtherInfo"]["Has3WVehicle"] == true
              ? "Yes"
              : "No");

      row.add(data["OtherInfo"]["Has4WVehicle"] == null
          ? ""
          : data["OtherInfo"]["Has4WVehicle"] == true
              ? "Yes"
              : "No");

      row.add(data["OtherInfo"]["HasVehicleDriver"] == null
          ? ""
          : data["OtherInfo"]["HasVehicleDriver"] == true
              ? "Yes"
              : "No");

      row.add(data["OtherInfo"]["BloodGroupCode"] == null ? "" : data["OtherInfo"]["BloodGroupCode"].toString());
      row.add(data["OtherInfo"]["MotherTongueCode"].toString());
      row.add(data["OtherInfo"]["BirthDateStr"].toString());
      row.add(data["OtherInfo"]["SanghaPraveshYear"] == null ? "" : data["OtherInfo"]["SanghaPraveshYear"].toString());
      row.add(data["OtherInfo"]["FacebookUsage"].toString());
      row.add(data["OtherInfo"]["TwitterUsage"].toString());
      row.add(data["OtherInfo"]["KooUsage"].toString());
      row.add(data["OtherInfo"]["InstagramUsage"].toString());
      row.add(data["OtherInfo"]["Education"].toString());
      row.add(data["OtherInfo"]["ShaakhaaExperience"].toString());

      row.add(data["OtherInfo"]["SanghaPreritSansthaaName"] == null ? "" : data["OtherInfo"]["SanghaPreritSansthaaName"].toString());
      row.add(data["OtherInfo"]["SanghaPreritSansthaaDesignation"].toString());
      row.add(data["OtherInfo"]["SanghaPreritSansthaaRemark"].toString());
      row.add(data["OtherInfo"]["OtherSocialOrganizationName"].toString());
      row.add(data["OtherInfo"]["OtherSocialOrganizationDesignation"].toString());
      row.add(data["OtherInfo"]["OtherSocialOrganizationRemark"].toString());

      row.add(data["SanghaShikshan"]["PraathamikYear"] == null ? "" : data["SanghaShikshan"]["PraathamikYear"].toString());
      row.add(data["SanghaShikshan"]["PrathamVarshaYear"] == null ? "" : data["SanghaShikshan"]["PrathamVarshaYear"].toString());
      row.add(data["SanghaShikshan"]["DwitiyaVarshaYear"] == null ? "" : data["SanghaShikshan"]["DwitiyaVarshaYear"].toString());
      row.add(data["SanghaShikshan"]["TrutiyaVarshaYear"] == null ? "" : data["SanghaShikshan"]["TrutiyaVarshaYear"].toString());
      row.add(data["SanghaShikshan"]["YearsAsPraathamikShikshak"] == null ? "" : data["SanghaShikshan"]["YearsAsPraathamikShikshak"].toString());
      row.add(data["SanghaShikshan"]["YearsAsPrathamVarshaShikshak"] == null ? "" : data["SanghaShikshan"]["YearsAsPrathamVarshaShikshak"].toString());
      row.add(data["SanghaShikshan"]["YearsAsDwitiyaVarshaShikshak"] == null ? "" : data["SanghaShikshan"]["YearsAsDwitiyaVarshaShikshak"].toString());
      row.add(data["SanghaShikshan"]["YearsAsTrutiyaVarshaShikshak"] == null ? "" : data["SanghaShikshan"]["YearsAsTrutiyaVarshaShikshak"].toString());

      row.add(data["AllShaaririkVishay"]["DandaFamiliarity"].toString());
      row.add(data["AllShaaririkVishay"]["NiyuddhaFamiliarity"].toString());
      row.add(data["AllShaaririkVishay"]["YogaasanFamiliarity"].toString());
      row.add(data["AllShaaririkVishay"]["YogaChaapFamiliarity"].toString());
      row.add(data["AllShaaririkVishay"]["PadaVinyaasFamiliarity"].toString());
      row.add(data["AllShaaririkVishay"]["DandaYuddhaFamiliarity"].toString());

      row.add(data["AllGhoshVishay"]["VanshiFamiliarity"].toString());
      row.add(data["AllGhoshVishay"]["VanshiRachanaaCount"] == null ? "" : data["AllGhoshVishay"]["VanshiRachanaaCount"].toString());
      row.add(data["AllGhoshVishay"]["VanshiIsUnderstandLipi"] == null
          ? ""
          : data["AllGhoshVishay"]["VanshiIsUnderstandLipi"] == true
              ? "Yes"
              : "No");

      row.add(data["AllGhoshVishay"]["VenuFamiliarity"].toString());
      row.add(data["AllGhoshVishay"]["VenuRachanaaCount"] == null ? "" : data["AllGhoshVishay"]["VenuRachanaaCount"].toString());
      row.add(data["AllGhoshVishay"]["VenuIsUnderstandLipi"] == null
          ? ""
          : data["AllGhoshVishay"]["VenuIsUnderstandLipi"] == true
              ? "Yes"
              : "No");

      row.add(data["AllGhoshVishay"]["AanakFamiliarity"].toString());
      row.add(data["AllGhoshVishay"]["AanakRachanaaCount"] == null ? "" : data["AllGhoshVishay"]["AanakRachanaaCount"].toString());
      row.add(data["AllGhoshVishay"]["AanakIsUnderstandLipi"] == null
          ? ""
          : data["AllGhoshVishay"]["AanakIsUnderstandLipi"] == true
              ? "Yes"
              : "No");

      row.add(data["AllGhoshVishay"]["ShankhaFamiliarity"].toString());
      row.add(data["AllGhoshVishay"]["ShankhaRachanaaCount"] == null ? "" : data["AllGhoshVishay"]["ShankhaRachanaaCount"].toString());
      row.add(data["AllGhoshVishay"]["ShankhaIsUnderstandLipi"] == null
          ? ""
          : data["AllGhoshVishay"]["ShankhaIsUnderstandLipi"] == true
              ? "Yes"
              : "No");

      row.add(data["AllGhoshVishay"]["NaagaangaFamiliarity"].toString());
      row.add(data["AllGhoshVishay"]["NaagaangaRachanaaCount"] == null ? "" : data["AllGhoshVishay"]["NaagaangaRachanaaCount"].toString());
      row.add(data["AllGhoshVishay"]["NaagaangaIsUnderstandLipi"] == null
          ? ""
          : data["AllGhoshVishay"]["NaagaangaIsUnderstandLipi"] == true
              ? "Yes"
              : "No");

      row.add(data["AllGhoshVishay"]["TuryaFamiliarity"].toString());
      row.add(data["AllGhoshVishay"]["TuryaRachanaaCount"] == null ? "" : data["AllGhoshVishay"]["TuryaRachanaaCount"].toString());
      row.add(data["AllGhoshVishay"]["TuryaIsUnderstandLipi"] == null
          ? ""
          : data["AllGhoshVishay"]["TuryaIsUnderstandLipi"] == true
              ? "Yes"
              : "No");

      row.add(data["AllGhoshVishay"]["SwaradaFamiliarity"].toString());
      row.add(data["AllGhoshVishay"]["SwaradaRachanaaCount"] == null ? "" : data["AllGhoshVishay"]["SwaradaRachanaaCount"].toString());
      row.add(data["AllGhoshVishay"]["SwaradaIsUnderstandLipi"] == null
          ? ""
          : data["AllGhoshVishay"]["SwaradaIsUnderstandLipi"] == true
              ? "Yes"
              : "No");

      row.add(data["AllGhoshVishay"]["GomukhaFamiliarity"].toString());
      row.add(data["AllGhoshVishay"]["GomukhaRachanaaCount"] == null ? "" : data["AllGhoshVishay"]["GomukhaRachanaaCount"].toString());
      row.add(data["AllGhoshVishay"]["GomukhaIsUnderstandLipi"] == null
          ? ""
          : data["AllGhoshVishay"]["GomukhaIsUnderstandLipi"] == true
              ? "Yes"
              : "No");

      row.add(data["Occupation"]["OccupationCategoryCode"].toString());
      row.add(data["Occupation"]["EducationUniversityName"].toString());
      row.add(data["Occupation"]["EducationInstitutionName"].toString());
      row.add(data["Occupation"]["EducationStandardName"].toString());
      row.add(data["Occupation"]["EducationProgramName"].toString());
      row.add(data["Occupation"]["EducationCourseName"].toString());
      row.add(data["Occupation"]["EducationExpectedCompletionYear"] == null ? "" : data["Occupation"]["EducationExpectedCompletionYear"].toString());

      row.add(data["Occupation"]["GovernmentDepartment"].toString());
      row.add(data["Occupation"]["OrganizationName"].toString());
      row.add(data["Occupation"]["IndustryVertical"].toString());
      row.add(data["Occupation"]["Designation"].toString());
      row.add(data["Occupation"]["OfficeLocation"].toString());
      var weekdays = data["Occupation"]["WeeklyOffDayIDs"].toString().split(',');
      var days = "";
      for (int i = 0; i < weekdays.length; i++) {
        if (weekdays[i] == "0") days = days + "Sun,";
        if (weekdays[i] == "1") days = days + "Mon,";
        if (weekdays[i] == "2") days = days + "Tue,";
        if (weekdays[i] == "3") days = days + "Wed,";
        if (weekdays[i] == "4") days = days + "Thu,";
        if (weekdays[i] == "5") days = days + "Fri,";
        if (weekdays[i] == "6") days = days + "Sat,";
      }
      row.add(days == "" ? "" : days.substring(0, days.length - 1));
      row.add(data["Occupation"]["OfficeTimingFrom"].toString());
      row.add(data["Occupation"]["OfficeTimingTo"].toString());
      row.add(data["Occupation"]["OrganizationAtRetirement"].toString());
      row.add(data["Occupation"]["DesignationAtRetirement"].toString());
      row.add(data["Occupation"]["DepartmentAtRetirement"].toString());

      rows.add(row);
    }

    if (rows.length > 1) {
      Statics.convertToCsv(rows, "SwayamSevaksList" + "_" + DateFormat('ddmmyyyyHHmmss').format(DateTime.now()), context);
    }
    setState(() {
      _isSearching = false;
    });
  }

  void onCheckCard(var emailID, var mobileNum, var swId) {
    if (!strEmail!.contains(emailID)) {
      strEmail!.add(emailID);
    }
    if (!strMobile!.contains(mobileNum)) {
      strMobile!.add(mobileNum);
    }
    if (!strSwId!.contains(swId)) {
      strSwId!.add(swId.toString());
    }
    print(strSwId);
  }

  void onUnCheckCard(var emailID, var mobileNum, var swId) {
    if (strEmail!.contains(emailID)) {
      strEmail!.remove(emailID);
    }
    if (strMobile!.contains(mobileNum)) {
      strMobile!.remove(mobileNum);
    }
    if (!strSwId!.contains(swId)) {
      strSwId!.remove(swId.toString());
    }
    print(strSwId);
  }

  void onSelectAll(value) {
    _swList!.then((dataList) {
      for (var data in dataList) {
        if (value == true)
          onCheckCard(data["Email"], data["MobileNumber"], data["SwayamsevakID"]);
        else
          onUnCheckCard(data["Email"], data["MobileNumber"], data["SwayamsevakID"]);
      }
    });
    setState(() {
      _isSelectAll = value;
      _isSelectAll = value;
    });
  }

  void onMenuSelected(MenuChoices choice) async {
    if (choice.menuType == "SendMail") {
      if (strEmail!.length == 0) {
        Statics.showToast("Please select atleast one Member");
        return;
      }
      UrlLauncher.launch("mailto:" + strEmail!.join(','));
    } else if (choice.menuType == "SendSMS") {
      if (strMobile!.length == 0) {
        Statics.showToast("Please select atleast one Member");
        return;
      }
      print(strMobile?.length);
      UrlLauncher.launch("sms:" + strMobile!.join(','));
    } else if (choice.menuType == "EditMenu") {
      print("EditMenu");
      Navigator.of(context).pushNamed(EditSwayamsevakScreen.routeName, arguments: Statics.ScreenArgumentsNew(0, 'EditMenu'));
    } else if (choice.menuType == 'EditMenuNew') {
      print('EditMenuNew');

      Navigator.of(context).pushNamed(EditSwayamsevakBasicInfo.routeName, arguments: Statics.ScreenArguments(0, Statics.getLabel('EditMenu')));
    } else if (choice.menuType == 'AddinSoochi') {
      if (strMobile!.length == 0) {
        Statics.showToast("Please select atleast one Member");
        return;
      }
      Navigator.of(context).pushNamed(EditSwayamsevakSoochiInfo.routeName, arguments: Statics.ScreenArgumentsForSoochi(strSwId!.join(',').toString(), Statics.getLabel('addinSoochi')));
      // Navigator.of(context).pushNamed(EditSwayamsevakSoochiInfo.routeName, arguments: Statics.ScreenArguments(0, Statics.getLabel('EditMenu')));
    }
  }

  Future<List<dynamic>> populateUniversity(String pattern, bool isDistance) async {
    var data3 = await Statics.getUniversity(null, pattern, isDistance);
    return data3;
  }

  Future<List<dynamic>> populateCollege(String universityID, String pattern) async {
    var data3 = await Statics.getCollege(null, universityID, pattern);
    return data3;
  }

  Future<List<dynamic>> populateProgram(String universityID, String pattern) async {
    var data3 = await Statics.getGetEducationProgramsForApp(null, universityID, pattern);
    return data3;
  }

  Future<List<dynamic>> populateCourse(String universityID, String pattern) async {
    var data3 = await Statics.getEducationCoursesForApp(null, universityID, pattern);
    return data3;
  }

  Future<void> _search(String strType) async {
    setState(() {
      _isSearching = true;
    });
    _swList = _getSwList(strType);
    setState(() {
      _isSearching = false;
    });
  }

  final Map<String, String> vehicleTypeMap = {Statics.getLabel('VehicleType2W'): '2-Wheeler', Statics.getLabel('VehicleType3W'): '3-Wheeler', Statics.getLabel('VehicleType4W'): '4-Wheeler'};

  void navigateBack() {
    _tabController!.animateTo(0);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_tabController?.index == 1) {
          navigateBack();
          return false;
        }
        Navigator.popAndPushNamed(context, HomeScreen.routeName);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            Statics.getLabel('searchSwayamsevakScreenLabel'),
            style: TextStyle(fontSize: 24),
          ),
          actions: <Widget>[
            PopupMenuButton<MenuChoices>(
              onSelected: onMenuSelected,
              icon: Icon(FontAwesomeIcons.ellipsisV),
              itemBuilder: (BuildContext context) {
                return choices!.map((MenuChoices choice) {
                  return PopupMenuItem<MenuChoices>(
                    value: choice,
                    child: ListTile(leading: Icon(choice.icon), title: Text(choice.menuText!)),
                  );
                }).toList();
              },
            ),
          ],
          bottom: new TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            onTap: (v) {
              if (v == 1) {
                _search("Search");
                setState(() {});
              }
            },
            physics: NeverScrollableScrollPhysics(),
            tabs: <Widget>[
              Tab(
                child: Wrap(
                  children: [
                    Icon(FontAwesomeIcons.globe),
                    SizedBox(width: 20),
                    Text(
                      Statics.getLabel("Filters"),
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              Tab(
                child: Wrap(
                  children: [
                    Icon(Icons.people),
                    SizedBox(width: 20),
                    Text(
                      Statics.getLabel("searchSwayamsevakScreenLabel"),
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        drawer: AppDrawer(),
        floatingActionButton: Wrap(
          children: [
            FloatingActionButton(
              heroTag: "btn1",
              tooltip: Statics.getLabel("Search"),
              onPressed: () async {
                FocusManager.instance.primaryFocus?.unfocus();
                _isSearching = true;
                setState(() {
                  _isSearching = true;
                });
                _swList = _getSwList("Search");

                // var data = await _getSwList("Search");

                _tabController!.animateTo(1);

                setState(() {
                  _isSearching = false;
                });
              },
              child: Icon(Icons.search),
              backgroundColor: Colors.green,
            ),
            SizedBox(width: 20),
            FloatingActionButton(
              heroTag: "btn2",
              tooltip: Statics.getLabel("Clear"),
              onPressed: () async {
                FocusManager.instance.primaryFocus?.unfocus();
                setState(() {
                  _swList = null;
                  _linkedbhaagValue = null;
                  _linkedshaharValue = null;
                  _linkednagarValue = null;
                  _linkedmandalValue = null;
                  _linkedgraamValue = null;
                  _linkedvastiValue = null;
                  _daayitvaForValue = null;
                  _levelValue = null;
                  _daayitvaValue = null;
                  _geoUnitsValue = null;
                  _categoryValue = null;
                  _sanghaShikshaVarsha = null;
                  _vehicleValue = null;
                  _bldGrpvalue = null;
                  _mthrTngvalue = null;
                  _programValue = null;
                  _program = null;
                  _standard = null;
                  _standardValue = null;

                  _searchController.text = "";
                  _daayitvaController.text = "";
                  _shikshaFromYearCntrl.text = "";
                  _shikshaToYearCntrl.text = "";
                  _pratidnyaYearCtrl.text = "";
                  _schoolNameCntrl.text = "";
                  _collegeNameCntrl.text = "";
                  _govtDeptCtrl.text = "";
                  _organizationNameCtrl.text = "";
                  _industrialVerticalCtrl.text = "";
                  _officeLocationCtrl.text = "";
                  _organizationAtRetirementCtrl.text = "";
                  _desgAtRetirementCtrl.text = "";
                  _deptAtRetirementCtrl.text = "";

                  _isTrainedInMukhyaDanda = null;
                  _isTrainedInMukhyaNiyuddha = null;
                  _isTrainedInMukhyaYogaasan = null;
                  _isTrainedInMukhyaYogachaap = null;
                  _isTrainedInMukhyaPadavinyas = null;
                  _isTrainedInMukhyaDandaYuddha = null;
                  _isTrainedInAnyaDanda = null;
                  _isTrainedInAnyaNiyuddha = null;
                  _isTrainedInAnyaYogaasan = null;
                  _isTrainedInAnyaYogachaap = null;
                  _isTrainedInAnyaPadavinyas = null;
                  _isTrainedInAnyaDandaYuddha = null;
                  _hasVehicleDriver = null;
                  _isPratidnyit = null;
                  _isGanveshComplete = null;
                  _noBelt = null;
                  _noCap = null;
                  _noDanda = null;
                  _noPant = null;
                  _noShirt = null;
                  _noShoes = null;
                  _noSocks = null;
                  _isMon = null;
                  _isTue = null;
                  _isWed = null;
                  _isThu = null;
                  _isFri = null;
                  _isSat = null;
                  _isSun = null;
                  _shaakhaSanchalanvalue = null;

                  _isTrainedInPrathamVanshi = null;
                  _isTrainedInPrathamVenu = null;
                  _isTrainedInPrathamAanak = null;
                  _isTrainedInPrathamShankha = null;
                  _isTrainedInPrathamNaagaanga = null;
                  _isTrainedInPrathamTurya = null;
                  _isTrainedInPrathamSwarad = null;
                  _isTrainedInPrathamGomukha = null;
                  _isTrainedInDwitiyaVanshi = null;
                  _isTrainedInDwitiyaVenu = null;
                  _isTrainedInDwitiyaAanak = null;
                  _isTrainedInDwitiyaShankha = null;
                  _isTrainedInDwitiyaNaagaanga = null;
                  _isTrainedInDwitiyaTurya = null;
                  _isTrainedInDwitiyaSwarad = null;
                  _isTrainedInDwitiyaGomukha = null;
                  _isTrainedInTrutiyaVanshi = null;
                  _isTrainedInTrutiyaVenu = null;
                  _isTrainedInTrutiyaAanak = null;
                  _isTrainedInTrutiyaShankha = null;
                  _isTrainedInTrutiyaNaagaanga = null;
                  _isTrainedInTrutiyaTurya = null;
                  _isTrainedInTrutiyaSwarad = null;
                  _isTrainedInTrutiyaGomukha = null;
                  _isTrainedInAnyaVanshi = null;
                  _isTrainedInAnyaVenu = null;
                  _isTrainedInAnyaAanak = null;
                  _isTrainedInAnyaShankha = null;
                  _isTrainedInAnyaNaagaanga = null;
                  _isTrainedInAnyaTurya = null;
                  _isTrainedInAnyaSwarad = null;
                  _isTrainedInAnyaGomukha = null;
                  _isPrathamLipi = null;
                  _isDwitiyaLipi = null;
                  _isTrutiyaLipi = null;
                  _isAnyaLipi = null;
                  _rachanaaCountPrathamCntrl.text = "";
                  _rachanaaCountDwitiyaCntrl.text = "";
                  _rachanaaCountTrutiyaCntrl.text = "";
                  _rachanaaCountAnyaCntrl.text = "";
                  _educationUniversityID = null;
                  _collegeID = null;
                  _educationProgramID = null;
                  _educationCourseID = null;
                  _progValue = null;
                  _educationOthrUniversityNameCntrl.text = "";
                  _collegeOthrNameCntrl.text = "";
                  _educationOthrProgramName.text = "";
                  _educationOthrCourseName.text = "";
                  _educationUniversityNameCntrl.text = "";
                  _collegeNameCntrl.text = "";
                  _educationProgramName.text = "";
                  _educationCourseName.text = "";
                  _standardValue = null;
                  _educationOthrStandardNameCntrl.text = "";
                  _othOrgNameCtrl.text = "";
                  _preritSansthaValue = "";
                  _hasBeenShikshak = false;
                  _noDaayitva = false;
                  _pravaasi = false;
                  geoUnitIDnew = "";
                  //
                  _wasVistaarak = null;
                  _wasPrachaarak = null;
                  _hasShaakhaaExperience = false;
                  _hasBaalShaakhaaExperience = false;
                  _hasTarunVidShaakhaaExperience = false;
                  _hasTarunVyavShaakhaaExperience = false;
                  _hasProudhaVyavShaakhaaExperience = false;
                  _isfb = null;
                  _isinsta = null;
                  _istwt = null;
                  _fbUsage = null;
                  _instaUsage = null;
                  _twtUsage = null;
                  _areaOfInterestForSearch.forEach((e) => e.isSelected = null);
                  _areaOfExpertiseForSearch.forEach((e) => e.isSelected = null);
                  //
                  _shishu = null;
                  _baal = null;
                  _tarunVidyarthi = null;
                  _taarunVyavsai = null;
                  _prudhVyavsai = null;
                  _isDobAvail = null;
                  // _areaOfInterestForSearch = [];
                  // _areaOfExpertiseForSearch = [];
                });
              },
              child: Icon(Icons.cleaning_services_rounded),
              backgroundColor: Colors.green,
            ),
            SizedBox(width: 20),
            FloatingActionButton(
              heroTag: "btn3",
              tooltip: Statics.getLabel("ExportToExcel"),
              onPressed: _getCsv,
              child: Icon(Icons.download_sharp),
              backgroundColor: Colors.green,
            ),
          ],
        ),
        body: ModalProgressHUD(
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                ///
                SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "${Statics.getLabel('Note')} :- ${Statics.getLabel('searchSwayamsevakScreenTip')}",
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 2),
                            Container(
                              height: 2,
                              width: 300,
                              color: Colors.red,
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        TitleBar(legendString: "searchSwayamsevakScreenBanner", fontsize: 20),
                        // Legend(
                        //     legendString: 'searchSwayamsevakScreenBanner',
                        //     fontsize: 20),
                        DropdownButtonFormField(
                          decoration: InputDecoration(labelText: Statics.getLabel('SortingOn')),
                          isExpanded: true,
                          value: _sortingOnValue == "" ? null : _sortingOnValue,
                          items: _sortingOn,
                          onChanged: (value) {
                            setState(() {
                              _sortingOnValue = value!;
                            });
                          },
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Legend(legendString: "BasicInfo", fontsize: 18),
                        Container(
                          margin: EdgeInsets.only(
                            left: 10,
                          ),
                          width: Statics.getDeviceSize(context).width * 0.85, //300,
                          child: TextFormField(
                            controller: _searchController,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(labelText: Statics.getLabel('searchSwayamsevakLabel')),
                          ),
                        ),
                        if (_bloodGroup != null)
                          DropdownButtonFormField(
                            decoration: InputDecoration(labelText: Statics.getLabel('SelectBloodGroup')),
                            isExpanded: true,
                            value: _bldGrpvalue == "" ? null : _bldGrpvalue,
                            items: _bloodGroup!.map((bg) => DropdownMenuItem(value: bg.staticID.toString(), child: Text(bg.codeForDisplay!))).toList(),
                            onChanged: (value) {
                              setState(() {
                                _bldGrpvalue = value!;
                              });
                            },
                          ),
                        SizedBox(
                          height: 10,
                        ),
                        if (_motherTongue != null)
                          DropdownButtonFormField(
                            decoration: InputDecoration(labelText: Statics.getLabel('SelectMotherTongue')),
                            isExpanded: true,
                            value: _mthrTngvalue == "" ? null : _mthrTngvalue,
                            items: _motherTongue!.map((bg) => DropdownMenuItem(value: bg.staticID.toString(), child: Text(bg.codeForDisplay!))).toList(),
                            onChanged: (value) {
                              setState(() {
                                _mthrTngvalue = value!;
                              });
                            },
                          ),
                        SizedBox(height: 10),
                        // CheckboxListTile(
                        //   contentPadding: EdgeInsets.symmetric(horizontal: 0),
                        //   controlAffinity: ListTileControlAffinity.leading,
                        //   title: Text(Statics.getLabel('ShaakhaaSanchaalan'),
                        //       style: TextStyle(fontSize: 15)),
                        //   checkColor: Colors.white,
                        //   activeColor: Colors.purple,
                        //   value: _isShaakhaaSanchalan == null
                        //       ? false
                        //       : _isShaakhaaSanchalan,
                        //   onChanged: (value) {
                        //     setState(() {
                        //       _isShaakhaaSanchalan = value;
                        //     });
                        //   },
                        // ),
                        if (_shaakhaSanchalan != null)
                          DropdownButtonFormField(
                            decoration: InputDecoration(labelText: Statics.getLabel('ShaakhaaSanchaalan')),
                            isExpanded: true,
                            value: _shaakhaSanchalanvalue == "" ? null : _shaakhaSanchalanvalue,
                            items: _shaakhaSanchalan!.map((bg) => DropdownMenuItem(value: bg.staticID.toString(), child: Text(bg.codeForDisplay!))).toList(),
                            onChanged: (value) {
                              setState(() {
                                _shaakhaSanchalanvalue = value;
                              });
                            },
                          ),
                        SizedBox(height: 30),
                        Legend(legendString: "LinkedGeoUnit", fontsize: 18),
                        SizedBox(height: 10),
                        ExpansionPanelList(
                          expansionCallback: (int index, bool isExpanded) {
                            setState(() {
                              _isExpanded = isExpanded;
                            });
                          },
                          children: [
                            ExpansionPanel(
                              headerBuilder: (BuildContext context, bool isExpanded) {
                                return ListTile(
                                  title: Text(Statics.getLabel('SelectGeoUnit')),
                                );
                              },
                              body: Container(
                                margin: EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    LevelWiseDropdown(
                                      onFinalSelection: (String level, String? geoUnitID) {
                                        print("geoUnitID :- $geoUnitID");
                                        setState(() {
                                          geoUnitIDnew = geoUnitID;
                                          populatelinkedMandalDropdown(geoUnitID!);
                                          populatelinkedVastiDropdown(geoUnitID);
                                        });
                                      },
                                    ),
                                    // if(_linkedbhaag != null)
                                    // DropdownButtonFormField(
                                    //   decoration: InputDecoration(labelText: Statics.getLabel('Bhaag')),
                                    //   isExpanded: true,
                                    //   value: _linkedbhaagValue == "" ? null : _linkedbhaagValue,
                                    //   items:
                                    //       _linkedbhaag!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                                    //   onChanged: (value) {
                                    //     setState(() {
                                    //       _linkedbhaagValue = value;
                                    //       populatelinkedShaharDropdown(value!);
                                    //       populatelinkedNagarDropdown(value, null);
                                    //     });
                                    //   },
                                    // ),
                                    // SizedBox(
                                    //   height: 10,
                                    // ),
                                    // if (_linkedshahar != null && _linkedshahar!.length > 0)
                                    //   DropdownButtonFormField(
                                    //     decoration: InputDecoration(labelText: Statics.getLabel('Shahar')),
                                    //     isExpanded: true,
                                    //     value: _linkedshaharValue == "" ? null : _linkedshaharValue,
                                    //     items: _linkedshahar!
                                    //         .map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!)))
                                    //         .toList(),
                                    //     onChanged: (value) {
                                    //       setState(() {
                                    //         _linkedshaharValue = value;
                                    //         populatelinkedNagarDropdown(null, value);
                                    //       });
                                    //     },
                                    //   ),
                                    // if (_linkedshahar != null && _linkedshahar!.length > 0)
                                    //   SizedBox(
                                    //     height: 10,
                                    //   ),
                                    // if (_linkednagar != null && _linkednagar!.length > 0)
                                    //   DropdownButtonFormField(
                                    //     decoration: InputDecoration(labelText: Statics.getLabel('Nagar')),
                                    //     isExpanded: true,
                                    //     value: _linkednagarValue == "" ? null : _linkednagarValue,
                                    //     items: _linkednagar!
                                    //         .map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!)))
                                    //         .toList(),
                                    //     onChanged: (value) {
                                    //       setState(() {
                                    //         _linkednagarValue = value;
                                    //         populatelinkedMandalDropdown(value!);
                                    //         populatelinkedVastiDropdown(value);
                                    //       });
                                    //     },
                                    //   ),
                                    // if (_linkednagar != null && _linkednagar!.length > 0)
                                    //   SizedBox(
                                    //     height: 10,
                                    //   ),
                                    if (_linkedmandal != null && _linkedmandal!.length > 0)
                                      DropdownButtonFormField(
                                        decoration: InputDecoration(labelText: Statics.getLabel('Mandal')),
                                        isExpanded: true,
                                        value: _linkedmandalValue == "" ? null : _linkedmandalValue,
                                        items: _linkedmandal!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            _linkedmandalValue = value;
                                            populatelinkedGraamDropdown(value!);
                                          });
                                        },
                                      ),
                                    if (_linkedmandal != null && _linkedmandal!.length > 0)
                                      SizedBox(
                                        height: 10,
                                      ),
                                    if (_linkedgraam != null && _linkedgraam!.length > 0)
                                      DropdownButtonFormField(
                                        decoration: InputDecoration(labelText: Statics.getLabel('Graam')),
                                        isExpanded: true,
                                        value: _linkedgraamValue == "" ? null : _linkedgraamValue,
                                        items: _linkedgraam!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            _linkedgraamValue = value;
                                          });
                                        },
                                      ),
                                    if (_linkedvasti != null && _linkedvasti!.length > 0)
                                      DropdownButtonFormField(
                                        decoration: InputDecoration(labelText: Statics.getLabel('Vasti')),
                                        isExpanded: true,
                                        value: _linkedvastiValue == "" ? null : _linkedvastiValue,
                                        items: _linkedvasti!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            _linkedvastiValue = value;
                                          });
                                        },
                                      ),
                                  ],
                                ),
                              ),
                              isExpanded: _isExpanded!,
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                        Legend(legendString: "GhoshVishay", fontsize: 18),
                        SizedBox(
                          height: 5,
                        ),
                        ExpansionPanelList(
                          expansionCallback: (int index, bool isExpanded) {
                            setState(() {
                              _isPrathamGhoshVishayExpanded = isExpanded;
                            });
                          },
                          children: [
                            ExpansionPanel(
                              headerBuilder: (BuildContext context, bool isExpanded) {
                                return ListTile(
                                  title: Text(Statics.getLabel('GhoshPrathamVaadya')),
                                );
                              },
                              body: Container(
                                //margin: EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    Wrap(
                                      direction: Axis.horizontal,
                                      spacing: 10,
                                      children: [
                                        SizedBox(
                                          width: Statics.getDeviceSize(context).width * 0.4,
                                          child: TextFormField(
                                            textInputAction: TextInputAction.next,
                                            controller: _rachanaaCountPrathamCntrl,
                                            decoration: InputDecoration(labelText: Statics.getLabel('RachanaaCount')),
                                            keyboardType: TextInputType.number,
                                            maxLength: 4,
                                          ),
                                        ),
                                        SizedBox(
                                          width: Statics.getDeviceSize(context).width * 0.4,
                                          child: CheckboxListTile(
                                            contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                            title: Text(Statics.getLabel('UnderstandLipi'), style: TextStyle(fontSize: 15)),
                                            checkColor: Colors.white,
                                            activeColor: Colors.purple,
                                            value: _isPrathamLipi == null ? false : _isPrathamLipi,
                                            controlAffinity: ListTileControlAffinity.leading,
                                            onChanged: (value) {
                                              setState(() {
                                                _isPrathamLipi = value;
                                              });
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: (Statics.getDeviceSize(context).width - 20) * 0.3,
                                          child: CheckboxListTile(
                                            contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                            title: Text(Statics.getLabel('Vanshi'), style: TextStyle(fontSize: 15)),
                                            checkColor: Colors.white,
                                            activeColor: Colors.purple,
                                            value: _isTrainedInPrathamVanshi == null ? false : _isTrainedInPrathamVanshi,
                                            controlAffinity: ListTileControlAffinity.leading,
                                            onChanged: (value) {
                                              setState(() {
                                                _isTrainedInPrathamVanshi = value;
                                              });
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: (Statics.getDeviceSize(context).width - 20) * 0.3,
                                          child: CheckboxListTile(
                                            contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                            title: Text(Statics.getLabel('Venu') + '               ', style: TextStyle(fontSize: 15)),
                                            checkColor: Colors.white,
                                            activeColor: Colors.purple,
                                            value: _isTrainedInPrathamVenu == null ? false : _isTrainedInPrathamVenu,
                                            controlAffinity: ListTileControlAffinity.leading,
                                            onChanged: (value) {
                                              setState(() {
                                                _isTrainedInPrathamVenu = value;
                                              });
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: (Statics.getDeviceSize(context).width - 20) * 0.3,
                                          child: CheckboxListTile(
                                              contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                              title: Text(Statics.getLabel('Aanak'), style: TextStyle(fontSize: 15)),
                                              checkColor: Colors.white,
                                              activeColor: Colors.purple,
                                              value: _isTrainedInPrathamAanak == null ? false : _isTrainedInPrathamAanak,
                                              controlAffinity: ListTileControlAffinity.leading,
                                              onChanged: (value) {
                                                setState(() {
                                                  _isTrainedInPrathamAanak = value;
                                                });
                                              }),
                                        ),
                                        SizedBox(
                                          width: (Statics.getDeviceSize(context).width - 20) * 0.3,
                                          child: CheckboxListTile(
                                            contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                            title: Text(Statics.getLabel('Shankha'), style: TextStyle(fontSize: 15)),
                                            checkColor: Colors.white,
                                            activeColor: Colors.purple,
                                            value: _isTrainedInPrathamShankha == null ? false : _isTrainedInPrathamShankha,
                                            controlAffinity: ListTileControlAffinity.leading,
                                            onChanged: (value) {
                                              setState(() {
                                                _isTrainedInPrathamShankha = value;
                                              });
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: (Statics.getDeviceSize(context).width - 20) * 0.3,
                                          child: CheckboxListTile(
                                            contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                            title: Text(Statics.getLabel('Naagaanga'), style: TextStyle(fontSize: 15)),
                                            checkColor: Colors.white,
                                            activeColor: Colors.purple,
                                            value: _isTrainedInPrathamNaagaanga == null ? false : _isTrainedInPrathamNaagaanga,
                                            controlAffinity: ListTileControlAffinity.leading,
                                            onChanged: (value) {
                                              setState(() {
                                                _isTrainedInPrathamNaagaanga = value;
                                              });
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: (Statics.getDeviceSize(context).width - 20) * 0.3,
                                          child: CheckboxListTile(
                                            contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                            title: Text(Statics.getLabel('Turya'), style: TextStyle(fontSize: 15)),
                                            checkColor: Colors.white,
                                            activeColor: Colors.purple,
                                            value: _isTrainedInPrathamTurya == null ? false : _isTrainedInPrathamTurya,
                                            controlAffinity: ListTileControlAffinity.leading,
                                            onChanged: (value) {
                                              setState(() {
                                                _isTrainedInPrathamTurya = value;
                                              });
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: (Statics.getDeviceSize(context).width - 20) * 0.3,
                                          child: CheckboxListTile(
                                            contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                            title: Text(Statics.getLabel('Swarad'), style: TextStyle(fontSize: 15)),
                                            checkColor: Colors.white,
                                            activeColor: Colors.purple,
                                            value: _isTrainedInPrathamSwarad == null ? false : _isTrainedInPrathamSwarad,
                                            controlAffinity: ListTileControlAffinity.leading,
                                            onChanged: (value) {
                                              setState(() {
                                                _isTrainedInPrathamSwarad = value;
                                              });
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: (Statics.getDeviceSize(context).width - 20) * 0.3,
                                          child: CheckboxListTile(
                                            contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                            title: Text(Statics.getLabel('Gomukha') + '      ', style: TextStyle(fontSize: 15)),
                                            checkColor: Colors.white,
                                            activeColor: Colors.purple,
                                            value: _isTrainedInPrathamGomukha == null ? false : _isTrainedInPrathamGomukha,
                                            controlAffinity: ListTileControlAffinity.leading,
                                            onChanged: (value) {
                                              setState(() {
                                                _isTrainedInPrathamGomukha = value;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              isExpanded: _isPrathamGhoshVishayExpanded!,
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        ExpansionPanelList(
                          expansionCallback: (int index, bool isExpanded) {
                            setState(() {
                              _isDwitiyaGhoshVishayExpanded = isExpanded;
                            });
                          },
                          children: [
                            ExpansionPanel(
                              headerBuilder: (BuildContext context, bool isExpanded) {
                                return ListTile(
                                  title: Text(Statics.getLabel('GhoshDwitiyaVaadya')),
                                );
                              },
                              body: Container(
                                //margin: EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    Wrap(
                                      direction: Axis.horizontal,
                                      spacing: 10,
                                      children: [
                                        SizedBox(
                                          width: Statics.getDeviceSize(context).width * 0.4,
                                          child: TextFormField(
                                            textInputAction: TextInputAction.next,
                                            controller: _rachanaaCountDwitiyaCntrl,
                                            decoration: InputDecoration(labelText: Statics.getLabel('RachanaaCount')),
                                            keyboardType: TextInputType.number,
                                            maxLength: 4,
                                          ),
                                        ),
                                        SizedBox(
                                          width: Statics.getDeviceSize(context).width * 0.4,
                                          child: CheckboxListTile(
                                            contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                            title: Text(Statics.getLabel('UnderstandLipi'), style: TextStyle(fontSize: 15)),
                                            checkColor: Colors.white,
                                            activeColor: Colors.purple,
                                            value: _isDwitiyaLipi == null ? false : _isDwitiyaLipi,
                                            controlAffinity: ListTileControlAffinity.leading,
                                            onChanged: (value) {
                                              setState(() {
                                                _isDwitiyaLipi = value;
                                              });
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: (Statics.getDeviceSize(context).width - 20) * 0.3,
                                          child: CheckboxListTile(
                                            contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                            title: Text(Statics.getLabel('Vanshi'), style: TextStyle(fontSize: 15)),
                                            checkColor: Colors.white,
                                            activeColor: Colors.purple,
                                            value: _isTrainedInDwitiyaVanshi == null ? false : _isTrainedInDwitiyaVanshi,
                                            controlAffinity: ListTileControlAffinity.leading,
                                            onChanged: (value) {
                                              setState(() {
                                                _isTrainedInDwitiyaVanshi = value;
                                              });
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: (Statics.getDeviceSize(context).width - 20) * 0.3,
                                          child: CheckboxListTile(
                                            contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                            title: Text(Statics.getLabel('Venu') + '               ', style: TextStyle(fontSize: 15)),
                                            checkColor: Colors.white,
                                            activeColor: Colors.purple,
                                            value: _isTrainedInDwitiyaVenu == null ? false : _isTrainedInDwitiyaVenu,
                                            controlAffinity: ListTileControlAffinity.leading,
                                            onChanged: (value) {
                                              setState(() {
                                                _isTrainedInDwitiyaVenu = value;
                                              });
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: (Statics.getDeviceSize(context).width - 20) * 0.3,
                                          child: CheckboxListTile(
                                              contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                              title: Text(Statics.getLabel('Aanak'), style: TextStyle(fontSize: 15)),
                                              checkColor: Colors.white,
                                              activeColor: Colors.purple,
                                              value: _isTrainedInDwitiyaAanak == null ? false : _isTrainedInDwitiyaAanak,
                                              controlAffinity: ListTileControlAffinity.leading,
                                              onChanged: (value) {
                                                setState(() {
                                                  _isTrainedInDwitiyaAanak = value;
                                                });
                                              }),
                                        ),
                                        SizedBox(
                                          width: (Statics.getDeviceSize(context).width - 20) * 0.3,
                                          child: CheckboxListTile(
                                            contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                            title: Text(Statics.getLabel('Shankha'), style: TextStyle(fontSize: 15)),
                                            checkColor: Colors.white,
                                            activeColor: Colors.purple,
                                            value: _isTrainedInDwitiyaShankha == null ? false : _isTrainedInDwitiyaShankha,
                                            controlAffinity: ListTileControlAffinity.leading,
                                            onChanged: (value) {
                                              setState(() {
                                                _isTrainedInDwitiyaShankha = value;
                                              });
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: (Statics.getDeviceSize(context).width - 20) * 0.3,
                                          child: CheckboxListTile(
                                            contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                            title: Text(Statics.getLabel('Naagaanga'), style: TextStyle(fontSize: 15)),
                                            checkColor: Colors.white,
                                            activeColor: Colors.purple,
                                            value: _isTrainedInDwitiyaNaagaanga == null ? false : _isTrainedInDwitiyaNaagaanga,
                                            controlAffinity: ListTileControlAffinity.leading,
                                            onChanged: (value) {
                                              setState(() {
                                                _isTrainedInDwitiyaNaagaanga = value;
                                              });
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: (Statics.getDeviceSize(context).width - 20) * 0.3,
                                          child: CheckboxListTile(
                                            contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                            title: Text(Statics.getLabel('Turya'), style: TextStyle(fontSize: 15)),
                                            checkColor: Colors.white,
                                            activeColor: Colors.purple,
                                            value: _isTrainedInDwitiyaTurya == null ? false : _isTrainedInDwitiyaTurya,
                                            controlAffinity: ListTileControlAffinity.leading,
                                            onChanged: (value) {
                                              setState(() {
                                                _isTrainedInDwitiyaTurya = value;
                                              });
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: (Statics.getDeviceSize(context).width - 20) * 0.3,
                                          child: CheckboxListTile(
                                            contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                            title: Text(Statics.getLabel('Swarad'), style: TextStyle(fontSize: 15)),
                                            checkColor: Colors.white,
                                            activeColor: Colors.purple,
                                            value: _isTrainedInDwitiyaSwarad == null ? false : _isTrainedInDwitiyaSwarad,
                                            controlAffinity: ListTileControlAffinity.leading,
                                            onChanged: (value) {
                                              setState(() {
                                                _isTrainedInDwitiyaSwarad = value;
                                              });
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: (Statics.getDeviceSize(context).width - 20) * 0.3,
                                          child: CheckboxListTile(
                                            contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                            title: Text(Statics.getLabel('Gomukha') + '      ', style: TextStyle(fontSize: 15)),
                                            checkColor: Colors.white,
                                            activeColor: Colors.purple,
                                            value: _isTrainedInDwitiyaGomukha == null ? false : _isTrainedInDwitiyaGomukha,
                                            controlAffinity: ListTileControlAffinity.leading,
                                            onChanged: (value) {
                                              setState(() {
                                                _isTrainedInDwitiyaGomukha = value;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              isExpanded: _isDwitiyaGhoshVishayExpanded!,
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        ExpansionPanelList(
                          expansionCallback: (int index, bool isExpanded) {
                            setState(() {
                              _isTrutiyaGhoshVishayExpanded = isExpanded;
                            });
                          },
                          children: [
                            ExpansionPanel(
                              headerBuilder: (BuildContext context, bool isExpanded) {
                                return ListTile(
                                  title: Text(Statics.getLabel('GhoshTrutiyaVaadya')),
                                );
                              },
                              body: Container(
                                //margin: EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    Wrap(
                                      direction: Axis.horizontal,
                                      spacing: 10,
                                      children: [
                                        SizedBox(
                                          width: Statics.getDeviceSize(context).width * 0.4,
                                          child: TextFormField(
                                            textInputAction: TextInputAction.next,
                                            controller: _rachanaaCountTrutiyaCntrl,
                                            decoration: InputDecoration(labelText: Statics.getLabel('RachanaaCount')),
                                            keyboardType: TextInputType.number,
                                            maxLength: 4,
                                          ),
                                        ),
                                        SizedBox(
                                          width: Statics.getDeviceSize(context).width * 0.4,
                                          child: CheckboxListTile(
                                            contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                            title: Text(Statics.getLabel('UnderstandLipi'), style: TextStyle(fontSize: 15)),
                                            checkColor: Colors.white,
                                            activeColor: Colors.purple,
                                            value: _isTrutiyaLipi == null ? false : _isTrutiyaLipi,
                                            controlAffinity: ListTileControlAffinity.leading,
                                            onChanged: (value) {
                                              setState(() {
                                                _isTrutiyaLipi = value;
                                              });
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: (Statics.getDeviceSize(context).width - 20) * 0.3,
                                          child: CheckboxListTile(
                                            contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                            title: Text(Statics.getLabel('Vanshi'), style: TextStyle(fontSize: 15)),
                                            checkColor: Colors.white,
                                            activeColor: Colors.purple,
                                            value: _isTrainedInTrutiyaVanshi == null ? false : _isTrainedInTrutiyaVanshi,
                                            controlAffinity: ListTileControlAffinity.leading,
                                            onChanged: (value) {
                                              setState(() {
                                                _isTrainedInTrutiyaVanshi = value;
                                              });
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: (Statics.getDeviceSize(context).width - 20) * 0.3,
                                          child: CheckboxListTile(
                                            contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                            title: Text(Statics.getLabel('Venu') + '               ', style: TextStyle(fontSize: 15)),
                                            checkColor: Colors.white,
                                            activeColor: Colors.purple,
                                            value: _isTrainedInTrutiyaVenu == null ? false : _isTrainedInTrutiyaVenu,
                                            controlAffinity: ListTileControlAffinity.leading,
                                            onChanged: (value) {
                                              setState(() {
                                                _isTrainedInTrutiyaVenu = value;
                                              });
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: (Statics.getDeviceSize(context).width - 20) * 0.3,
                                          child: CheckboxListTile(
                                              contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                              title: Text(Statics.getLabel('Aanak'), style: TextStyle(fontSize: 15)),
                                              checkColor: Colors.white,
                                              activeColor: Colors.purple,
                                              value: _isTrainedInTrutiyaAanak == null ? false : _isTrainedInTrutiyaAanak,
                                              controlAffinity: ListTileControlAffinity.leading,
                                              onChanged: (value) {
                                                setState(() {
                                                  _isTrainedInTrutiyaAanak = value;
                                                });
                                              }),
                                        ),
                                        SizedBox(
                                          width: (Statics.getDeviceSize(context).width - 20) * 0.3,
                                          child: CheckboxListTile(
                                            contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                            title: Text(Statics.getLabel('Shankha'), style: TextStyle(fontSize: 15)),
                                            checkColor: Colors.white,
                                            activeColor: Colors.purple,
                                            value: _isTrainedInTrutiyaShankha == null ? false : _isTrainedInTrutiyaShankha,
                                            controlAffinity: ListTileControlAffinity.leading,
                                            onChanged: (value) {
                                              setState(() {
                                                _isTrainedInTrutiyaShankha = value;
                                              });
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: (Statics.getDeviceSize(context).width - 20) * 0.3,
                                          child: CheckboxListTile(
                                            contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                            title: Text(Statics.getLabel('Naagaanga'), style: TextStyle(fontSize: 15)),
                                            checkColor: Colors.white,
                                            activeColor: Colors.purple,
                                            value: _isTrainedInTrutiyaNaagaanga == null ? false : _isTrainedInTrutiyaNaagaanga,
                                            controlAffinity: ListTileControlAffinity.leading,
                                            onChanged: (value) {
                                              setState(() {
                                                _isTrainedInTrutiyaNaagaanga = value;
                                              });
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: (Statics.getDeviceSize(context).width - 20) * 0.3,
                                          child: CheckboxListTile(
                                            contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                            title: Text(Statics.getLabel('Turya'), style: TextStyle(fontSize: 15)),
                                            checkColor: Colors.white,
                                            activeColor: Colors.purple,
                                            value: _isTrainedInTrutiyaTurya == null ? false : _isTrainedInTrutiyaTurya,
                                            controlAffinity: ListTileControlAffinity.leading,
                                            onChanged: (value) {
                                              setState(() {
                                                _isTrainedInTrutiyaTurya = value;
                                              });
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: (Statics.getDeviceSize(context).width - 20) * 0.3,
                                          child: CheckboxListTile(
                                            contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                            title: Text(Statics.getLabel('Swarad'), style: TextStyle(fontSize: 15)),
                                            checkColor: Colors.white,
                                            activeColor: Colors.purple,
                                            value: _isTrainedInTrutiyaSwarad == null ? false : _isTrainedInTrutiyaSwarad,
                                            controlAffinity: ListTileControlAffinity.leading,
                                            onChanged: (value) {
                                              setState(() {
                                                _isTrainedInTrutiyaSwarad = value;
                                              });
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: (Statics.getDeviceSize(context).width - 20) * 0.3,
                                          child: CheckboxListTile(
                                            contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                            title: Text(Statics.getLabel('Gomukha') + '      ', style: TextStyle(fontSize: 15)),
                                            checkColor: Colors.white,
                                            activeColor: Colors.purple,
                                            value: _isTrainedInTrutiyaGomukha == null ? false : _isTrainedInTrutiyaGomukha,
                                            controlAffinity: ListTileControlAffinity.leading,
                                            onChanged: (value) {
                                              setState(() {
                                                _isTrainedInTrutiyaGomukha = value;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              isExpanded: _isTrutiyaGhoshVishayExpanded!,
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        ExpansionPanelList(
                          expansionCallback: (int index, bool isExpanded) {
                            setState(() {
                              _isAnyaGhoshVishayExpanded = isExpanded;
                            });
                          },
                          children: [
                            ExpansionPanel(
                              headerBuilder: (BuildContext context, bool isExpanded) {
                                return ListTile(
                                  title: Text(Statics.getLabel('GhoshAnyaVaadya')),
                                );
                              },
                              body: Container(
                                //margin: EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    Wrap(
                                      direction: Axis.horizontal,
                                      spacing: 10,
                                      children: [
                                        SizedBox(
                                          width: Statics.getDeviceSize(context).width * 0.4,
                                          child: TextFormField(
                                            textInputAction: TextInputAction.next,
                                            controller: _rachanaaCountAnyaCntrl,
                                            decoration: InputDecoration(labelText: Statics.getLabel('RachanaaCount')),
                                            keyboardType: TextInputType.number,
                                            maxLength: 4,
                                          ),
                                        ),
                                        SizedBox(
                                          width: Statics.getDeviceSize(context).width * 0.4,
                                          child: CheckboxListTile(
                                            contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                            title: Text(Statics.getLabel('UnderstandLipi'), style: TextStyle(fontSize: 15)),
                                            checkColor: Colors.white,
                                            activeColor: Colors.purple,
                                            value: _isAnyaLipi == null ? false : _isAnyaLipi,
                                            controlAffinity: ListTileControlAffinity.leading,
                                            onChanged: (value) {
                                              setState(() {
                                                _isAnyaLipi = value;
                                              });
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: (Statics.getDeviceSize(context).width - 20) * 0.3,
                                          child: CheckboxListTile(
                                            contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                            title: Text(Statics.getLabel('Vanshi'), style: TextStyle(fontSize: 15)),
                                            checkColor: Colors.white,
                                            activeColor: Colors.purple,
                                            value: _isTrainedInAnyaVanshi == null ? false : _isTrainedInAnyaVanshi,
                                            controlAffinity: ListTileControlAffinity.leading,
                                            onChanged: (value) {
                                              setState(() {
                                                _isTrainedInAnyaVanshi = value;
                                              });
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: (Statics.getDeviceSize(context).width - 20) * 0.3,
                                          child: CheckboxListTile(
                                            contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                            title: Text(Statics.getLabel('Venu') + '               ', style: TextStyle(fontSize: 15)),
                                            checkColor: Colors.white,
                                            activeColor: Colors.purple,
                                            value: _isTrainedInAnyaVenu == null ? false : _isTrainedInAnyaVenu,
                                            controlAffinity: ListTileControlAffinity.leading,
                                            onChanged: (value) {
                                              setState(() {
                                                _isTrainedInAnyaVenu = value;
                                              });
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: (Statics.getDeviceSize(context).width - 20) * 0.3,
                                          child: CheckboxListTile(
                                              contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                              title: Text(Statics.getLabel('Aanak'), style: TextStyle(fontSize: 15)),
                                              checkColor: Colors.white,
                                              activeColor: Colors.purple,
                                              value: _isTrainedInAnyaAanak == null ? false : _isTrainedInAnyaAanak,
                                              controlAffinity: ListTileControlAffinity.leading,
                                              onChanged: (value) {
                                                setState(() {
                                                  _isTrainedInAnyaAanak = value;
                                                });
                                              }),
                                        ),
                                        SizedBox(
                                          width: (Statics.getDeviceSize(context).width - 20) * 0.3,
                                          child: CheckboxListTile(
                                            contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                            title: Text(Statics.getLabel('Shankha'), style: TextStyle(fontSize: 15)),
                                            checkColor: Colors.white,
                                            activeColor: Colors.purple,
                                            value: _isTrainedInAnyaShankha == null ? false : _isTrainedInAnyaShankha,
                                            controlAffinity: ListTileControlAffinity.leading,
                                            onChanged: (value) {
                                              setState(() {
                                                _isTrainedInAnyaShankha = value;
                                              });
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: (Statics.getDeviceSize(context).width - 20) * 0.3,
                                          child: CheckboxListTile(
                                            contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                            title: Text(Statics.getLabel('Naagaanga'), style: TextStyle(fontSize: 15)),
                                            checkColor: Colors.white,
                                            activeColor: Colors.purple,
                                            value: _isTrainedInAnyaNaagaanga == null ? false : _isTrainedInAnyaNaagaanga,
                                            controlAffinity: ListTileControlAffinity.leading,
                                            onChanged: (value) {
                                              setState(() {
                                                _isTrainedInAnyaNaagaanga = value;
                                              });
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: (Statics.getDeviceSize(context).width - 20) * 0.3,
                                          child: CheckboxListTile(
                                            contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                            title: Text(Statics.getLabel('Turya'), style: TextStyle(fontSize: 15)),
                                            checkColor: Colors.white,
                                            activeColor: Colors.purple,
                                            value: _isTrainedInAnyaTurya == null ? false : _isTrainedInAnyaTurya,
                                            controlAffinity: ListTileControlAffinity.leading,
                                            onChanged: (value) {
                                              setState(() {
                                                _isTrainedInAnyaTurya = value;
                                              });
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: (Statics.getDeviceSize(context).width - 20) * 0.3,
                                          child: CheckboxListTile(
                                            contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                            title: Text(Statics.getLabel('Swarad'), style: TextStyle(fontSize: 15)),
                                            checkColor: Colors.white,
                                            activeColor: Colors.purple,
                                            value: _isTrainedInAnyaSwarad == null ? false : _isTrainedInAnyaSwarad,
                                            controlAffinity: ListTileControlAffinity.leading,
                                            onChanged: (value) {
                                              setState(() {
                                                _isTrainedInAnyaSwarad = value;
                                              });
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: (Statics.getDeviceSize(context).width - 20) * 0.3,
                                          child: CheckboxListTile(
                                            contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                            title: Text(Statics.getLabel('Gomukha') + '      ', style: TextStyle(fontSize: 15)),
                                            checkColor: Colors.white,
                                            activeColor: Colors.purple,
                                            value: _isTrainedInAnyaGomukha == null ? false : _isTrainedInAnyaGomukha,
                                            controlAffinity: ListTileControlAffinity.leading,
                                            onChanged: (value) {
                                              setState(() {
                                                _isTrainedInAnyaGomukha = value;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              isExpanded: _isAnyaGhoshVishayExpanded!,
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                        Legend(legendString: "ShaaririkVishay", fontsize: 18),
                        SizedBox(height: 5),
                        ExpansionPanelList(
                          expansionCallback: (int index, bool isExpanded) {
                            setState(() {
                              _isMukhyaSharirikVishayExpanded = isExpanded;
                            });
                          },
                          children: [
                            ExpansionPanel(
                              headerBuilder: (BuildContext context, bool isExpanded) {
                                return ListTile(
                                  title: Text(Statics.getLabel('MukhyaShaaririkVishay')),
                                );
                              },
                              body: Container(
                                //margin: EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    Wrap(
                                      direction: Axis.horizontal,
                                      spacing: 10,
                                      children: [
                                        SizedBox(
                                          width: Statics.getDeviceSize(context).width * 0.4,
                                          child: CheckboxListTile(
                                              contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                              title: Text(Statics.getLabel('Danda'), style: TextStyle(fontSize: 15)),
                                              checkColor: Colors.white,
                                              activeColor: Colors.purple,
                                              value: _isTrainedInMukhyaDanda == null ? false : _isTrainedInMukhyaDanda,
                                              controlAffinity: ListTileControlAffinity.leading,
                                              onChanged: (value) {
                                                setState(() {
                                                  _isTrainedInMukhyaDanda = value;
                                                });
                                              }),
                                        ),
                                        SizedBox(
                                          width: Statics.getDeviceSize(context).width * 0.4,
                                          child: CheckboxListTile(
                                              contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                              title: Text(Statics.getLabel('Niyuddha'), style: TextStyle(fontSize: 15)),
                                              checkColor: Colors.white,
                                              activeColor: Colors.purple,
                                              value: _isTrainedInMukhyaNiyuddha == null ? false : _isTrainedInMukhyaNiyuddha,
                                              controlAffinity: ListTileControlAffinity.leading,
                                              onChanged: (value) {
                                                setState(() {
                                                  _isTrainedInMukhyaNiyuddha = value;
                                                });
                                              }),
                                        ),
                                        SizedBox(
                                          width: Statics.getDeviceSize(context).width * 0.4,
                                          child: CheckboxListTile(
                                              contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                              title: Text(Statics.getLabel('Yogaasan'), style: TextStyle(fontSize: 15)),
                                              checkColor: Colors.white,
                                              activeColor: Colors.purple,
                                              value: _isTrainedInMukhyaYogaasan == null ? false : _isTrainedInMukhyaYogaasan,
                                              controlAffinity: ListTileControlAffinity.leading,
                                              onChanged: (value) {
                                                setState(() {
                                                  _isTrainedInMukhyaYogaasan = value;
                                                });
                                              }),
                                        ),
                                        SizedBox(
                                          width: Statics.getDeviceSize(context).width * 0.4,
                                          child: CheckboxListTile(
                                            contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                            title: Text(Statics.getLabel('Yogachaap'), style: TextStyle(fontSize: 15)),
                                            checkColor: Colors.white,
                                            activeColor: Colors.purple,
                                            value: _isTrainedInMukhyaYogachaap == null ? false : _isTrainedInMukhyaYogachaap,
                                            controlAffinity: ListTileControlAffinity.leading,
                                            onChanged: (value) {
                                              setState(() {
                                                _isTrainedInMukhyaYogachaap = value;
                                              });
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: Statics.getDeviceSize(context).width * 0.4,
                                          child: CheckboxListTile(
                                            contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                            title: Text(Statics.getLabel('Padavinyas'), style: TextStyle(fontSize: 15)),
                                            checkColor: Colors.white,
                                            activeColor: Colors.purple,
                                            value: _isTrainedInMukhyaPadavinyas == null ? false : _isTrainedInMukhyaPadavinyas,
                                            controlAffinity: ListTileControlAffinity.leading,
                                            onChanged: (value) {
                                              setState(() {
                                                _isTrainedInMukhyaPadavinyas = value;
                                              });
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: Statics.getDeviceSize(context).width * 0.4,
                                          child: CheckboxListTile(
                                            contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                            title: Text(Statics.getLabel('DandaYuddha'), style: TextStyle(fontSize: 15)),
                                            checkColor: Colors.white,
                                            activeColor: Colors.purple,
                                            value: _isTrainedInMukhyaDandaYuddha == null ? false : _isTrainedInMukhyaDandaYuddha,
                                            controlAffinity: ListTileControlAffinity.leading,
                                            onChanged: (value) {
                                              setState(() {
                                                _isTrainedInMukhyaDandaYuddha = value;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              isExpanded: _isMukhyaSharirikVishayExpanded!,
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        ExpansionPanelList(
                          expansionCallback: (int index, bool isExpanded) {
                            setState(() {
                              _isAnyaSharirikVishayExpanded = isExpanded;
                            });
                          },
                          children: [
                            ExpansionPanel(
                              headerBuilder: (BuildContext context, bool isExpanded) {
                                return ListTile(
                                  title: Text(Statics.getLabel('AnyaShaaririkVishay')),
                                );
                              },
                              body: Container(
                                //margin: EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    Wrap(
                                      direction: Axis.horizontal,
                                      spacing: 10,
                                      children: [
                                        SizedBox(
                                          width: Statics.getDeviceSize(context).width * 0.4,
                                          child: CheckboxListTile(
                                              contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                              title: Text(Statics.getLabel('Danda'), style: TextStyle(fontSize: 15)),
                                              checkColor: Colors.white,
                                              activeColor: Colors.purple,
                                              value: _isTrainedInAnyaDanda == null ? false : _isTrainedInAnyaDanda,
                                              controlAffinity: ListTileControlAffinity.leading,
                                              onChanged: (value) {
                                                setState(() {
                                                  _isTrainedInAnyaDanda = value;
                                                });
                                              }),
                                        ),
                                        SizedBox(
                                          width: Statics.getDeviceSize(context).width * 0.4,
                                          child: CheckboxListTile(
                                              contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                              title: Text(Statics.getLabel('Niyuddha'), style: TextStyle(fontSize: 15)),
                                              checkColor: Colors.white,
                                              activeColor: Colors.purple,
                                              value: _isTrainedInAnyaNiyuddha == null ? false : _isTrainedInAnyaNiyuddha,
                                              controlAffinity: ListTileControlAffinity.leading,
                                              onChanged: (value) {
                                                setState(() {
                                                  _isTrainedInAnyaNiyuddha = value;
                                                });
                                              }),
                                        ),
                                        SizedBox(
                                          width: Statics.getDeviceSize(context).width * 0.4,
                                          child: CheckboxListTile(
                                              contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                              title: Text(Statics.getLabel('Yogaasan'), style: TextStyle(fontSize: 15)),
                                              checkColor: Colors.white,
                                              activeColor: Colors.purple,
                                              value: _isTrainedInAnyaYogaasan == null ? false : _isTrainedInAnyaYogaasan,
                                              controlAffinity: ListTileControlAffinity.leading,
                                              onChanged: (value) {
                                                setState(() {
                                                  _isTrainedInAnyaYogaasan = value;
                                                });
                                              }),
                                        ),
                                        SizedBox(
                                          width: Statics.getDeviceSize(context).width * 0.4,
                                          child: CheckboxListTile(
                                            contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                            title: Text(Statics.getLabel('Yogachaap'), style: TextStyle(fontSize: 15)),
                                            checkColor: Colors.white,
                                            activeColor: Colors.purple,
                                            value: _isTrainedInAnyaYogachaap == null ? false : _isTrainedInAnyaYogachaap,
                                            controlAffinity: ListTileControlAffinity.leading,
                                            onChanged: (value) {
                                              setState(() {
                                                _isTrainedInAnyaYogachaap = value;
                                              });
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: Statics.getDeviceSize(context).width * 0.4,
                                          child: CheckboxListTile(
                                            contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                            title: Text(Statics.getLabel('Padavinyas'), style: TextStyle(fontSize: 15)),
                                            checkColor: Colors.white,
                                            activeColor: Colors.purple,
                                            value: _isTrainedInAnyaPadavinyas == null ? false : _isTrainedInAnyaPadavinyas,
                                            controlAffinity: ListTileControlAffinity.leading,
                                            onChanged: (value) {
                                              setState(() {
                                                _isTrainedInAnyaPadavinyas = value;
                                              });
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: Statics.getDeviceSize(context).width * 0.4,
                                          child: CheckboxListTile(
                                            contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                            title: Text(Statics.getLabel('DandaYuddha'), style: TextStyle(fontSize: 15)),
                                            checkColor: Colors.white,
                                            activeColor: Colors.purple,
                                            value: _isTrainedInAnyaDandaYuddha == null ? false : _isTrainedInAnyaDandaYuddha,
                                            controlAffinity: ListTileControlAffinity.leading,
                                            onChanged: (value) {
                                              setState(() {
                                                _isTrainedInAnyaDandaYuddha = value;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              isExpanded: _isAnyaSharirikVishayExpanded!,
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                        Legend(legendString: "Daayitva", fontsize: 18),
                        SizedBox(height: 12),
                        SizedBox(
                          width: Statics.getDeviceSize(context).width * 0.85,
                          child: CheckboxListTile(
                            contentPadding: EdgeInsets.symmetric(horizontal: 0),
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text(Statics.getLabel('HasBeenVistaarak'), style: TextStyle(fontSize: 15)),
                            checkColor: Colors.white,
                            activeColor: Colors.purple,
                            value: _wasVistaarak == null ? false : _wasVistaarak,
                            onChanged: (value) {
                              setState(() {
                                _wasVistaarak = value;
                              });
                            },
                          ),
                        ),
                        SizedBox(height: 12),
                        SizedBox(
                          width: Statics.getDeviceSize(context).width * 0.85,
                          child: CheckboxListTile(
                            contentPadding: EdgeInsets.symmetric(horizontal: 0),
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text(Statics.getLabel('HasBeenPrachaarak'), style: TextStyle(fontSize: 15)),
                            checkColor: Colors.white,
                            activeColor: Colors.purple,
                            value: _wasPrachaarak == null ? false : _wasPrachaarak,
                            onChanged: (value) {
                              setState(() {
                                _wasPrachaarak = value;
                              });
                            },
                          ),
                        ),
                        SizedBox(height: 12),
                        CheckboxListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Text(Statics.getLabel("NoDaayitva"), style: TextStyle(fontSize: 15)),
                          checkColor: Colors.white,
                          activeColor: Colors.purple,
                          value: _noDaayitva == null ? false : _noDaayitva,
                          onChanged: (value) {
                            setState(() {
                              _noDaayitva = value;
                            });
                          },
                        ),
                        SizedBox(height: 10),
                        CheckboxListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Text(
                            Statics.getLabel("Pravaasi"),
                            style: TextStyle(fontSize: 15),
                          ),
                          checkColor: Colors.white,
                          activeColor: Colors.purple,
                          value: _pravaasi == null ? false : _pravaasi,
                          onChanged: (value) {
                            setState(() {
                              _pravaasi = value;
                              print('Checkbox is now: $value');
                            });
                          },
                        ),
                        if (_daayitvaFor != null)
                          DropdownButtonFormField<StaticMasterBAL>(
                            decoration: InputDecoration(labelText: Statics.getLabel('SelectDaayitvaFor')),
                            isExpanded: true,
                            value: _daayitvaForValue == null || _daayitvaFor == null || _daayitvaFor!.length == 0 ? null : _daayitvaForValue,
                            items: _daayitvaFor!.map((bg) => DropdownMenuItem(value: bg, child: Text(bg.codeForDisplay!))).toList(),
                            onChanged: (value) {
                              setState(() {
                                _daayitvaForValue = value;
                              });
                            },
                          ),
                        SizedBox(height: 10),
                        if (_daayitvaForValue != null)
                          if (_daayitvaForValue!.code == "OtherSocialOrganization")
                            Column(
                              children: [
                                TextFormField(
                                  textInputAction: TextInputAction.next,
                                  controller: _othOrgNameCtrl,
                                  decoration: InputDecoration(labelText: Statics.getLabel('SansthaaName')),
                                  keyboardType: TextInputType.text,
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                        if (_daayitvaForValue != null)
                          if (_daayitvaForValue!.code == "SanghaPreritSansthaa")
                            Column(
                              children: [
                                if (_sanghaPreritSanstha != null)
                                  DropdownButtonFormField<dynamic>(
                                    decoration: InputDecoration(labelText: Statics.getLabel('SansthaaName')),
                                    isExpanded: true,
                                    value: _preritSansthaValue == "" ? null : _preritSansthaValue,
                                    items: _sanghaPreritSanstha!.map((bg) => DropdownMenuItem(value: bg["SanghaPreritSansthaaID"].toString(), child: Text(bg["SansthaaName"]))).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        _preritSansthaValue = value;
                                      });
                                    },
                                  ),
                                SizedBox(height: 10),
                              ],
                            ),
                        if (_daayitvaForValue != null)
                          if (_daayitvaForValue!.code != "SanghaPreritSansthaa" && _daayitvaForValue!.code != "OtherSocialOrganization")
                            Column(
                              children: [
                                if (_level != null)
                                  DropdownButtonFormField(
                                    decoration: InputDecoration(labelText: Statics.getLabel('SelectLevel')),
                                    isExpanded: true,
                                    value: _levelValue == "" ? null : _levelValue,
                                    items: _level!
                                        .map(
                                          (bg) => DropdownMenuItem(
                                            value: bg.levelID.toString(),
                                            child: Text(bg.levelName == "Bhaag"
                                                ? "Bhaag / Jilha"
                                                : bg.levelName == "Nagar"
                                                    ? "Nagar / Taluka"
                                                    : bg.levelName!),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        _levelValue = value;
                                        populateGeoUnitforDaayitva(value!);
                                      });
                                    },
                                  ),
                                SizedBox(height: 10),
                                if (_geoUnits != null)
                                  DropdownButtonFormField(
                                    decoration: InputDecoration(labelText: Statics.getLabel('SelectGeoUnit')),
                                    isExpanded: true,
                                    value: _geoUnitsValue == ""
                                        ? null
                                        : _geoUnits != null
                                            ? _geoUnits!.indexWhere((p) => p.geoUnitID.toString() == _geoUnitsValue) > -1
                                                ? _geoUnitsValue
                                                : null
                                            : null,
                                    items: _geoUnits!.map((bg) => DropdownMenuItem(value: bg.geoUnitID.toString(), child: Text(bg.name!))).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        _geoUnitsValue = value;
                                      });
                                    },
                                  ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Container(
                                      width: Statics.getDeviceSize(context).width * 0.75,
                                      child: TypeAheadField<DaayitvaMasterBAL>(
                                        controller: _daayitvaController,
                                        builder: (context, controller, focusNode) {
                                          return TextField(
                                              controller: _daayitvaController,
                                              focusNode: focusNode,
                                              decoration: InputDecoration(
                                                isDense: true,
                                                border: UnderlineInputBorder(),
                                                labelText: Statics.getLabel('SelectDaayitva'),
                                              ));
                                        },
                                        // textFieldConfiguration: TextFieldConfiguration(
                                        //     controller: this._daayitvaController,
                                        //     decoration: InputDecoration(labelText: Statics.getLabel('SelectDaayitva'))),
                                        suggestionsCallback: (pattern) {
                                          this._daayitvaValue = "";
                                          return populateDaayitva(_daayitvaForValue == null ? "" : _daayitvaForValue!.staticID.toString(), pattern);
                                        },
                                        itemBuilder: (context, suggestion) {
                                          return ListTile(
                                            title: Text(suggestion.daayitvaName!),
                                          );
                                        },
                                        // transitionBuilder: (context, suggestionsBox, controller) {
                                        //   return suggestionsBox;
                                        // },
                                        onSelected: (suggestion) {
                                          this._daayitvaController.text = suggestion.daayitvaName!;
                                          _daayitvaValue = suggestion.daayitvaID.toString();
                                        },
                                      ),
                                    ),
                                    IconButton(
                                        color: Colors.purple,
                                        onPressed: () {
                                          setState(() {
                                            this._daayitvaController.text = "";
                                            _daayitvaValue = "";
                                          });
                                        },
                                        icon: Icon(Icons.cancel)),
                                  ],
                                ),
                              ],
                            ),
                        SizedBox(height: 30),
                        Legend(legendString: "ShaakhaExp", fontsize: 18),
                        SizedBox(height: 5),
                        SizedBox(
                          width: Statics.getDeviceSize(context).width * 0.8,
                          child: CheckboxListTile(
                              contentPadding: EdgeInsets.symmetric(horizontal: 0),
                              title: Text(Statics.getLabel('HasShaakhaaSanchaalanExperience'), style: TextStyle(fontSize: 15)),
                              checkColor: Colors.white,
                              activeColor: Colors.purple,
                              value: _hasShaakhaaExperience == null ? false : _hasShaakhaaExperience,
                              controlAffinity: ListTileControlAffinity.leading,
                              onChanged: (value) {
                                setState(() {
                                  _hasShaakhaaExperience = value!;
                                });
                              }),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        if (_hasShaakhaaExperience == true)
                          Wrap(
                            direction: Axis.horizontal,
                            spacing: 10,
                            children: [
                              SizedBox(
                                width: Statics.getDeviceSize(context).width * 0.4,
                                child: CheckboxListTile(
                                    contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                    title: Text(Statics.getLabel('Baal'), style: TextStyle(fontSize: 15)),
                                    checkColor: Colors.white,
                                    activeColor: Colors.purple,
                                    value: _hasBaalShaakhaaExperience == null ? false : _hasBaalShaakhaaExperience,
                                    controlAffinity: ListTileControlAffinity.leading,
                                    onChanged: (value) {
                                      setState(() {
                                        _hasBaalShaakhaaExperience = value!;
                                      });
                                    }),
                              ),
                              SizedBox(
                                width: Statics.getDeviceSize(context).width * 0.4,
                                child: CheckboxListTile(
                                    contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                    title: Text(Statics.getLabel('TarunVidyaarthi'), style: TextStyle(fontSize: 15)),
                                    checkColor: Colors.white,
                                    activeColor: Colors.purple,
                                    value: _hasTarunVidShaakhaaExperience == null ? false : _hasTarunVidShaakhaaExperience,
                                    controlAffinity: ListTileControlAffinity.leading,
                                    onChanged: (value) {
                                      setState(() {
                                        _hasTarunVidShaakhaaExperience = value!;
                                      });
                                    }),
                              ),
                              SizedBox(
                                width: Statics.getDeviceSize(context).width * 0.4,
                                child: CheckboxListTile(
                                    contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                    title: Text(Statics.getLabel('TarunVyavasaayee'), style: TextStyle(fontSize: 15)),
                                    checkColor: Colors.white,
                                    activeColor: Colors.purple,
                                    value: _hasTarunVyavShaakhaaExperience == null ? false : _hasTarunVyavShaakhaaExperience,
                                    controlAffinity: ListTileControlAffinity.leading,
                                    onChanged: (value) {
                                      setState(() {
                                        _hasTarunVyavShaakhaaExperience = value!;
                                      });
                                    }),
                              ),
                              SizedBox(
                                width: Statics.getDeviceSize(context).width * 0.4,
                                child: CheckboxListTile(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                  title: Text(Statics.getLabel('ProudhVyavasaayee'), style: TextStyle(fontSize: 15)),
                                  checkColor: Colors.white,
                                  activeColor: Colors.purple,
                                  value: _hasProudhaVyavShaakhaaExperience == null ? false : _hasProudhaVyavShaakhaaExperience,
                                  controlAffinity: ListTileControlAffinity.leading,
                                  onChanged: (value) {
                                    setState(() {
                                      _hasProudhaVyavShaakhaaExperience = value!;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        SizedBox(height: 30),
                        Legend(legendString: "Occupation", fontsize: 18),
                        SizedBox(height: 5),
                        if (_category != null)
                          DropdownButtonFormField(
                            decoration: InputDecoration(labelText: Statics.getLabel('SelectCategory')),
                            isExpanded: true,
                            value: _categoryValue,
                            items: _category!.map((bg) => DropdownMenuItem(value: bg, child: Text(bg.codeForDisplay!))).toList(),
                            onChanged: (value) {
                              print(value!.code);
                              setState(() {
                                _categoryValue = value;
                                //populateProgram(value.code);
                                populateStandard(value.code!);
                              });
                            },
                          ),
                        if (_categoryValue != null)
                          if (_categoryValue!.code == 'School Student')
                            Column(
                              children: [
                                TextFormField(
                                  textInputAction: TextInputAction.next,
                                  controller: _schoolNameCntrl,
                                  decoration: InputDecoration(labelText: Statics.getLabel('SchoolName')),
                                  keyboardType: TextInputType.text,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                        if (_categoryValue != null)
                          if (_categoryValue!.code == 'Jr College')
                            Column(
                              children: [
                                TextFormField(
                                  textInputAction: TextInputAction.next,
                                  controller: _collegeNameCntrl,
                                  decoration: InputDecoration(labelText: Statics.getLabel('CollegeName')),
                                  keyboardType: TextInputType.text,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            )
                          else if (_categoryValue!.code == 'Senior College' ||
                              _categoryValue!.code == 'Post Graduate' ||
                              _categoryValue!.code == 'Professional Studies' ||
                              _categoryValue!.code == 'Correspondence Course')
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: Statics.getDeviceSize(context).width * 0.75,
                                      child: TypeAheadField<dynamic>(
                                        controller: _educationUniversityNameCntrl,
                                        builder: (context, controller, focusNode) {
                                          return TextField(
                                              controller: _educationUniversityNameCntrl,
                                              focusNode: focusNode,
                                              decoration: InputDecoration(
                                                isDense: true,
                                                border: UnderlineInputBorder(),
                                                labelText: Statics.getLabel('University'),
                                              ));
                                        },
                                        // textFieldConfiguration: TextFieldConfiguration(
                                        //     controller: this._educationUniversityNameCntrl,
                                        //     decoration: InputDecoration(labelText: Statics.getLabel('University'))),
                                        suggestionsCallback: (pattern) {
                                          this._educationUniversityID = null;
                                          return populateUniversity(pattern, _categoryValue!.code == "Correspondence Course" ? true : false);
                                        },
                                        itemBuilder: (context, suggestion) {
                                          return ListTile(
                                            title: Text(suggestion["UniversityName"]),
                                          );
                                        },
                                        // transitionBuilder: (context, suggestionsBox, controller) {
                                        //   return suggestionsBox;
                                        // },
                                        onSelected: (suggestion) {
                                          _educationUniversityNameCntrl.text = suggestion["UniversityName"];
                                          _educationUniversityID = suggestion["EducationUniversityID"];
                                          _educationOthrUniversityNameCntrl.text = "";
                                          _collegeNameCntrl.text = "";
                                          _collegeOthrNameCntrl.text = "";
                                          _educationStandardNameCntrl.text = "";
                                          _educationOthrStandardNameCntrl.text = "";
                                          _educationProgramName.text = "";
                                          _educationOthrProgramName.text = "";
                                          _educationCourseName.text = "";
                                          _educationOthrCourseName.text = "";
                                          _educationCourseID = _collegeID = _educationStandardID = _educationProgramID = null;
                                          _progValue = null;
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                    IconButton(
                                        color: Colors.purple,
                                        onPressed: () {
                                          setState(() {
                                            this._educationUniversityNameCntrl.text = "";
                                            _educationUniversityID = null;
                                            _educationOthrUniversityNameCntrl.text = "";
                                            _collegeNameCntrl.text = "";
                                            _collegeOthrNameCntrl.text = "";
                                            _educationStandardNameCntrl.text = "";
                                            _educationOthrStandardNameCntrl.text = "";
                                            _educationProgramName.text = "";
                                            _educationOthrProgramName.text = "";
                                            _educationCourseName.text = "";
                                            _educationOthrCourseName.text = "";
                                            _educationCourseID = _collegeID = _educationStandardID = _educationProgramID = null;
                                            _progValue = null;
                                          });
                                        },
                                        icon: Icon(Icons.cancel)),
                                  ],
                                ),
                                if (_educationUniversityNameCntrl.text == "Other") SizedBox(height: 10),
                                if (_educationUniversityNameCntrl.text == "Other")
                                  TextFormField(
                                    textInputAction: TextInputAction.next,
                                    controller: _educationOthrUniversityNameCntrl,
                                    decoration: InputDecoration(labelText: Statics.getLabel('UniversityName')),
                                    keyboardType: TextInputType.text,
                                  ),
                                if (_educationUniversityNameCntrl.text != "Other") SizedBox(height: 10),
                                if (_educationUniversityNameCntrl.text != "Other")
                                  Row(
                                    children: [
                                      Container(
                                        width: Statics.getDeviceSize(context).width * 0.75,
                                        child: TypeAheadField<dynamic>(
                                          controller: _collegeNameCntrl,
                                          builder: (context, controller, focusNode) {
                                            return TextField(
                                                controller: _collegeNameCntrl,
                                                focusNode: focusNode,
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                  border: UnderlineInputBorder(),
                                                  labelText: Statics.getLabel('College'),
                                                ));
                                          },
                                          // textFieldConfiguration: TextFieldConfiguration(
                                          //     controller: this._collegeNameCntrl,
                                          //     decoration: InputDecoration(labelText: Statics.getLabel('College'))),
                                          suggestionsCallback: (pattern) {
                                            this._collegeID = null;
                                            return populateCollege(_educationUniversityID == null ? "0" : _educationUniversityID.toString(), pattern);
                                          },
                                          itemBuilder: (context, suggestion) {
                                            return ListTile(
                                              title: Text(suggestion["InstitutionName"]),
                                            );
                                          },
                                          // transitionBuilder: (context, suggestionsBox, controller) {
                                          //   return suggestionsBox;
                                          // },
                                          onSelected: (suggestion) {
                                            setState(() {
                                              this._collegeNameCntrl.text = suggestion["InstitutionName"];
                                              _collegeID = suggestion["EducationInstitutionID"];
                                            });
                                          },
                                        ),
                                      ),
                                      IconButton(
                                          color: Colors.purple,
                                          onPressed: () {
                                            setState(() {
                                              this._collegeNameCntrl.text = "";
                                              _collegeID = null;
                                            });
                                          },
                                          icon: Icon(Icons.cancel)),
                                    ],
                                  ),
                                if (_educationUniversityNameCntrl.text == "Other" || _collegeNameCntrl.text == "Other") SizedBox(height: 10),
                                if (_educationUniversityNameCntrl.text == "Other" || _collegeNameCntrl.text == "Other")
                                  TextFormField(
                                    textInputAction: TextInputAction.next,
                                    controller: _collegeOthrNameCntrl,
                                    decoration: InputDecoration(labelText: Statics.getLabel('CollegeName')),
                                    keyboardType: TextInputType.text,
                                  ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                        if (_categoryValue != null)
                          if (_categoryValue!.code == 'School Student' || _categoryValue!.code == 'Jr College' || _categoryValue!.code == 'Senior College')
                            Column(
                              children: [
                                if (_standard != null)
                                  DropdownButtonFormField<StaticMasterBAL>(
                                    decoration: InputDecoration(labelText: Statics.getLabel('Standard')),
                                    isExpanded: true,
                                    value: _standardValue == null
                                        ? null
                                        : _standard != null
                                            ? _standard!.indexWhere((p) => p.staticID == _standardValue!.staticID) > -1
                                                ? _standard![_standard!.indexWhere((p) => p.staticID == _standardValue!.staticID)]
                                                : null
                                            : null,
                                    items: _standard!.map((bg) => DropdownMenuItem(value: bg, child: Text(bg.codeForDisplay!))).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        _standardValue = value;
                                      });
                                    },
                                  ),
                                if (_standardValue != null && _standardValue!.code == "Other")
                                  TextFormField(
                                    textInputAction: TextInputAction.next,
                                    controller: _educationOthrStandardNameCntrl,
                                    decoration: InputDecoration(labelText: Statics.getLabel('Standard')),
                                    keyboardType: TextInputType.text,
                                  ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                        if (_categoryValue != null)
                          if (_categoryValue!.code == 'Jr College')
                            DropdownButtonFormField(
                              decoration: InputDecoration(labelText: Statics.getLabel('Program')),
                              isExpanded: true,
                              value: _progValue == ""
                                  ? null
                                  : _prog.indexWhere((p) => p.value == _progValue) > -1
                                      ? _progValue
                                      : null,
                              items: _prog,
                              onChanged: (value) {
                                setState(() {
                                  _progValue = value;
                                });
                              },
                            )
                          else if (_categoryValue!.code == 'Professional Studies' ||
                              _categoryValue!.code == 'Jr College' ||
                              _categoryValue!.code == 'Senior College' ||
                              _categoryValue!.code == 'Post Graduate' ||
                              _categoryValue!.code == 'Correspondence Course')
                            Column(
                              children: [
                                if (_educationUniversityNameCntrl.text != "Other") SizedBox(height: 10),
                                if (_educationUniversityNameCntrl.text != "Other")
                                  Row(
                                    children: [
                                      Container(
                                        width: Statics.getDeviceSize(context).width * 0.75,
                                        child: TypeAheadField<dynamic>(
                                          controller: _educationProgramName,
                                          builder: (context, controller, focusNode) {
                                            return TextField(
                                                controller: controller,
                                                focusNode: focusNode,
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                  border: UnderlineInputBorder(),
                                                  labelText: Statics.getLabel('Program'),
                                                ));
                                          },
                                          // textFieldConfiguration: TextFieldConfiguration(
                                          //     controller: this._educationProgramName,
                                          //     decoration: InputDecoration(labelText: Statics.getLabel('Program'))),
                                          suggestionsCallback: (pattern) {
                                            this._educationProgramID = null;
                                            return populateProgram(_educationUniversityID.toString(), pattern);
                                          },
                                          itemBuilder: (context, suggestion) {
                                            return ListTile(
                                              title: Text(suggestion["ProgramName"]),
                                            );
                                          },
                                          // transitionBuilder: (context, suggestionsBox, controller) {
                                          //   return suggestionsBox;
                                          // },
                                          onSelected: (suggestion) {
                                            setState(() {
                                              this._educationProgramName.text = suggestion["ProgramName"];
                                              _educationProgramID = suggestion["EducationProgramID"];
                                              _educationOthrProgramName.text = "";
                                            });
                                          },
                                        ),
                                      ),
                                      IconButton(
                                          color: Colors.purple,
                                          onPressed: () {
                                            setState(() {
                                              this._educationProgramName.text = "";
                                              _educationProgramID = null;
                                              _educationOthrProgramName.text = "";
                                            });
                                          },
                                          icon: Icon(Icons.cancel)),
                                    ],
                                  ),
                                if (_educationUniversityNameCntrl.text == "Other" || _educationProgramName.text == "Other") SizedBox(height: 10),
                                if (_educationUniversityNameCntrl.text == "Other" || _educationProgramName.text == "Other")
                                  TextFormField(
                                    textInputAction: TextInputAction.next,
                                    controller: _educationOthrProgramName,
                                    decoration: InputDecoration(labelText: Statics.getLabel('ProgramName')),
                                    keyboardType: TextInputType.text,
                                  ),
                                SizedBox(
                                  height: 10,
                                ),
                                if (_educationUniversityNameCntrl.text != "Other") SizedBox(height: 10),
                                if (_educationUniversityNameCntrl.text != "Other")
                                  Row(
                                    children: [
                                      Container(
                                        width: Statics.getDeviceSize(context).width * 0.75,
                                        child: TypeAheadField<dynamic>(
                                          controller: _daayitvaController,
                                          builder: (context, controller, focusNode) {
                                            return TextField(
                                                controller: _educationCourseName,
                                                focusNode: focusNode,
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                  border: UnderlineInputBorder(),
                                                  labelText: Statics.getLabel('Course'),
                                                ));
                                          },
                                          // textFieldConfiguration: TextFieldConfiguration(
                                          //     controller: this._educationCourseName,
                                          //     decoration: InputDecoration(labelText: Statics.getLabel('Course'))),
                                          suggestionsCallback: (pattern) {
                                            this._educationCourseID = null;
                                            return populateCourse(_educationUniversityID.toString(), pattern);
                                          },
                                          itemBuilder: (context, suggestion) {
                                            return ListTile(
                                              title: Text(suggestion["CourseName"]),
                                            );
                                          },
                                          // transitionBuilder: (context, suggestionsBox, controller) {
                                          //   return suggestionsBox;
                                          // },
                                          onSelected: (suggestion) {
                                            setState(() {
                                              this._educationCourseName.text = suggestion["CourseName"];
                                              _educationCourseID = suggestion["EducationCourseID"];
                                            });
                                          },
                                        ),
                                      ),
                                      IconButton(
                                          color: Colors.purple,
                                          onPressed: () {
                                            setState(() {
                                              this._educationCourseName.text = "";
                                              _educationCourseID = null;
                                            });
                                          },
                                          icon: Icon(Icons.cancel)),
                                    ],
                                  ),
                                if (_educationUniversityNameCntrl.text == "Other" || _educationCourseName.text == "Other") SizedBox(height: 10),
                                if (_educationUniversityNameCntrl.text == "Other" || _educationCourseName.text == "Other")
                                  TextFormField(
                                    textInputAction: TextInputAction.next,
                                    controller: _educationOthrCourseName,
                                    decoration: InputDecoration(labelText: Statics.getLabel('CourseName')),
                                    keyboardType: TextInputType.text,
                                  ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                        if (_categoryValue != null)
                          if (_categoryValue!.code == 'Government Employee')
                            Column(
                              children: [
                                TextFormField(
                                  textInputAction: TextInputAction.next,
                                  controller: _govtDeptCtrl,
                                  decoration: InputDecoration(labelText: Statics.getLabel('GovernmentDepartment')),
                                  keyboardType: TextInputType.text,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                        if (_categoryValue != null)
                          if (_categoryValue!.code == 'Private Company' || _categoryValue!.code == 'Business')
                            Column(
                              children: [
                                TextFormField(
                                  textInputAction: TextInputAction.next,
                                  controller: _organizationNameCtrl,
                                  decoration: InputDecoration(labelText: Statics.getLabel('OrganizationName')),
                                  keyboardType: TextInputType.text,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  textInputAction: TextInputAction.next,
                                  controller: _industrialVerticalCtrl,
                                  decoration: InputDecoration(labelText: Statics.getLabel('IndustryVertical')),
                                  keyboardType: TextInputType.text,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                        if (_categoryValue != null)
                          if (_categoryValue!.code == 'Government Employee' || _categoryValue!.code == 'Private Company' || _categoryValue!.code == 'Business')
                            Column(
                              children: <Widget>[
                                TextFormField(
                                  textInputAction: TextInputAction.next,
                                  controller: _officeLocationCtrl,
                                  decoration: InputDecoration(labelText: Statics.getLabel('OfficeLocation')),
                                  keyboardType: TextInputType.text,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Legend(legendString: 'SelectWeeklyOffDay', fontsize: 18),
                                Wrap(
                                  children: [
                                    SizedBox(
                                      width: Statics.getDeviceSize(context).width * 0.25,
                                      child: CheckboxListTile(
                                        contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                        controlAffinity: ListTileControlAffinity.leading,
                                        title: Text(Statics.getLabel('Mon'), style: TextStyle(fontSize: 15)),
                                        checkColor: Colors.white,
                                        activeColor: Colors.purple,
                                        value: _isMon == null ? false : _isMon,
                                        onChanged: (value) {
                                          setState(() {
                                            _isMon = value;
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: Statics.getDeviceSize(context).width * 0.25,
                                      child: CheckboxListTile(
                                        contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                        controlAffinity: ListTileControlAffinity.leading,
                                        title: Text(Statics.getLabel('Tue'), style: TextStyle(fontSize: 15)),
                                        checkColor: Colors.white,
                                        activeColor: Colors.purple,
                                        value: _isTue == null ? false : _isTue,
                                        onChanged: (value) {
                                          setState(() {
                                            _isTue = value;
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: Statics.getDeviceSize(context).width * 0.25,
                                      child: CheckboxListTile(
                                        contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                        controlAffinity: ListTileControlAffinity.leading,
                                        title: Text(Statics.getLabel('Wed'), style: TextStyle(fontSize: 15)),
                                        checkColor: Colors.white,
                                        activeColor: Colors.purple,
                                        value: _isWed == null ? false : _isWed,
                                        onChanged: (value) {
                                          setState(() {
                                            _isWed = value;
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: Statics.getDeviceSize(context).width * 0.25,
                                      child: CheckboxListTile(
                                        contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                        controlAffinity: ListTileControlAffinity.leading,
                                        title: Text(Statics.getLabel('Thu'), style: TextStyle(fontSize: 15)),
                                        checkColor: Colors.white,
                                        activeColor: Colors.purple,
                                        value: _isThu == null ? false : _isThu,
                                        onChanged: (value) {
                                          setState(() {
                                            _isThu = value;
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: Statics.getDeviceSize(context).width * 0.25,
                                      child: CheckboxListTile(
                                        contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                        controlAffinity: ListTileControlAffinity.leading,
                                        title: Text(Statics.getLabel('Fri'), style: TextStyle(fontSize: 15)),
                                        checkColor: Colors.white,
                                        activeColor: Colors.purple,
                                        value: _isFri == null ? false : _isFri,
                                        onChanged: (value) {
                                          setState(() {
                                            _isFri = value;
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: Statics.getDeviceSize(context).width * 0.25,
                                      child: CheckboxListTile(
                                        contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                        controlAffinity: ListTileControlAffinity.leading,
                                        title: Text(Statics.getLabel('Sat'), style: TextStyle(fontSize: 15)),
                                        checkColor: Colors.white,
                                        activeColor: Colors.purple,
                                        value: _isSat == null ? false : _isSat,
                                        onChanged: (value) {
                                          setState(() {
                                            _isSat = value;
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: Statics.getDeviceSize(context).width * 0.25,
                                      child: CheckboxListTile(
                                        contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                        controlAffinity: ListTileControlAffinity.leading,
                                        title: Text(Statics.getLabel('Sun'), style: TextStyle(fontSize: 15)),
                                        checkColor: Colors.white,
                                        activeColor: Colors.purple,
                                        value: _isSun == null ? false : _isSun,
                                        onChanged: (value) {
                                          setState(() {
                                            _isSun = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                        if (_categoryValue != null)
                          if (_categoryValue!.code == 'Retired')
                            Column(
                              children: [
                                TextFormField(
                                  textInputAction: TextInputAction.next,
                                  controller: _organizationAtRetirementCtrl,
                                  decoration: InputDecoration(labelText: Statics.getLabel('OrganizationAtRetirement')),
                                  keyboardType: TextInputType.text,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  textInputAction: TextInputAction.next,
                                  controller: _desgAtRetirementCtrl,
                                  decoration: InputDecoration(labelText: Statics.getLabel('DesignationAtRetirement')),
                                  keyboardType: TextInputType.text,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  textInputAction: TextInputAction.next,
                                  controller: _deptAtRetirementCtrl,
                                  decoration: InputDecoration(labelText: Statics.getLabel('GovernmentDepartmentRetirement')),
                                  keyboardType: TextInputType.text,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                        SizedBox(height: 30),
                        Legend(legendString: "PratidnyaDetails", fontsize: 18),
                        Wrap(
                          children: [
                            SizedBox(
                              width: Statics.getDeviceSize(context).width * 0.4,
                              child: CheckboxListTile(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                  controlAffinity: ListTileControlAffinity.leading,
                                  title: Text(Statics.getLabel('IsPratidnyit'), style: TextStyle(fontSize: 15)),
                                  checkColor: Colors.white,
                                  activeColor: Colors.purple,
                                  value: _isPratidnyit == null ? false : _isPratidnyit,
                                  onChanged: (value) {
                                    setState(() {
                                      _isPratidnyit = value;
                                    });
                                  }),
                            ),
                            SizedBox(
                              width: Statics.getDeviceSize(context).width * 0.4,
                              child: TextFormField(
                                textInputAction: TextInputAction.next,
                                controller: _pratidnyaYearCtrl,
                                decoration: InputDecoration(labelText: Statics.getLabel('PratidnyaYear')),
                                keyboardType: TextInputType.number,
                                enabled: _isPratidnyit == null ? false : _isPratidnyit,
                                maxLength: 4,
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 30),
                        Legend(legendString: "SanghaShikshan", fontsize: 18),
                        SizedBox(height: 5),
                        // DropdownButtonFormField(
                        //   decoration: InputDecoration(labelText: Statics.getLabel('SanghaShikshaVarsha')),
                        //   isExpanded: true,
                        //   value: _sanghaShikshaVarsha == "" ? null : _sanghaShikshaVarsha,
                        //   // items: <String>['Praathamik-प्राथमिक', 'Pratham-प्रथम', 'Dwitiya-द्वितीय', 'Trutiya-तृतीय', 'None-अशिक्षित']
                        //   items: <String>['प्रारंभिक', 'प्राथमिक', 'प्रथम वर्ष / संघ शिक्षा वर्ग', 'द्वितीय वर्ष / कार्यकर्ता विकास वर्ग प्रथम', 'तृतीय वर्ष / कार्यकर्ता विकास वर्ग द्वितीय']
                        //       .map((String value) {
                        //     return DropdownMenuItem<String>(
                        //       value: value.split('-')[0],
                        //       child: Text(value),
                        //     );
                        //   }).toList(),
                        //   onChanged: (value) {
                        //     setState(() {
                        //       _sanghaShikshaVarsha = value;
                        //     });
                        //   },
                        // ),
                        DropdownButtonFormField(
                          decoration: InputDecoration(labelText: Statics.getLabel('SanghaShikshaVarsha')),
                          isExpanded: true,
                          value: _sanghaShikshaVarsha == "" ? null : _sanghaShikshaVarsha,
                          items: _sanghashikshanItems.keys.map((String key) {
                            return DropdownMenuItem<String>(
                              value: _sanghashikshanItems[key],
                              child: Text(key),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _sanghaShikshaVarsha = value;
                            });
                          },
                        ),
                        SizedBox(height: 10),
                        Wrap(
                          children: [
                            SizedBox(
                              width: Statics.getDeviceSize(context).width * 0.4,
                              child: TextFormField(
                                textInputAction: TextInputAction.next,
                                controller: _shikshaFromYearCntrl,
                                decoration: InputDecoration(labelText: Statics.getLabel('FromYear')),
                                keyboardType: TextInputType.number,
                                maxLength: 4,
                              ),
                            ),
                            SizedBox(width: Statics.getDeviceSize(context).width * 0.1),
                            SizedBox(
                              width: Statics.getDeviceSize(context).width * 0.4,
                              child: TextFormField(
                                textInputAction: TextInputAction.next,
                                controller: _shikshaToYearCntrl,
                                decoration: InputDecoration(labelText: Statics.getLabel('ToYear')),
                                keyboardType: TextInputType.number,
                                maxLength: 4,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        CheckboxListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Text(Statics.getLabel("HasbeenShikshakinSanghaShikshaVarga"), style: TextStyle(fontSize: 15)),
                          checkColor: Colors.white,
                          activeColor: Colors.purple,
                          value: _hasBeenShikshak == null ? false : _hasBeenShikshak,
                          onChanged: (value) {
                            setState(() {
                              _hasBeenShikshak = value;
                            });
                          },
                        ),
                        SizedBox(height: 30),
                        Legend(legendString: "Vehicle", fontsize: 18),
                        SizedBox(height: 5),
                        // DropdownButtonFormField(
                        //   decoration: InputDecoration(labelText: Statics.getLabel('TypeOfVehicle')),
                        //   isExpanded: true,
                        //   value: _vehicleValue == "" ? null : _vehicleValue,
                        //   items: <String>[Statics.getLabel('VehicleType2W'), Statics.getLabel('VehicleType3W'), Statics.getLabel('VehicleType4W')]
                        //       .map((String value) {
                        //     return new DropdownMenuItem<String>(
                        //       value: value,
                        //       child: new Text(value),
                        //     );
                        //   }).toList(),
                        //   onChanged: (value) {
                        //     setState(() {
                        //       _vehicleValue = value;
                        //     });
                        //   },
                        // ),
                        DropdownButtonFormField(
                          decoration: InputDecoration(labelText: Statics.getLabel('TypeOfVehicle')),
                          isExpanded: true,
                          value: _vehicleValue == "" ? null : _vehicleValue,
                          items: vehicleTypeMap.keys.map((String key) {
                            return DropdownMenuItem<String>(
                              value: vehicleTypeMap[key],
                              child: Text(key),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _vehicleValue = value;
                            });
                          },
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Text(Statics.getLabel('HasVehicleDriver')),
                            Checkbox(
                                checkColor: Colors.white,
                                activeColor: Colors.purple,
                                value: _hasVehicleDriver == null ? false : _hasVehicleDriver,
                                onChanged: (value) {
                                  setState(() {
                                    _hasVehicleDriver = value;
                                  });
                                }),
                          ],
                        ),
                        SizedBox(height: 30),
                        Legend(legendString: "GanveshDetails", fontsize: 18),
                        SizedBox(height: 5),
                        SizedBox(
                          width: Statics.getDeviceSize(context).width * 0.4,
                          child: CheckboxListTile(
                            contentPadding: EdgeInsets.symmetric(horizontal: 0),
                            title: Text(Statics.getLabel('IsGanveshComplete'), style: TextStyle(fontSize: 15)),
                            checkColor: Colors.white,
                            activeColor: Colors.purple,
                            value: _isGanveshComplete == null ? false : _isGanveshComplete,
                            controlAffinity: ListTileControlAffinity.leading,
                            onChanged: (value) {
                              setState(() {
                                _isGanveshComplete = value;
                                if (value == true) {
                                  _noCap = _noBelt = _noDanda = _noPant = _noShirt = _noShoes = _noSocks = false;
                                }
                              });
                            },
                          ),
                        ),
                        SizedBox(height: 5),
                        AbsorbPointer(
                          absorbing: _isGanveshComplete == true ? true : false,
                          child: Wrap(
                            direction: Axis.horizontal,
                            spacing: 10,
                            children: [
                              SizedBox(
                                width: Statics.getDeviceSize(context).width * 0.4,
                                child: CheckboxListTile(
                                    contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                    title: Text(Statics.getLabel('NoCap'), style: TextStyle(fontSize: 15)),
                                    checkColor: Colors.white,
                                    activeColor: Colors.purple,
                                    value: _noCap == null ? false : _noCap,
                                    controlAffinity: ListTileControlAffinity.leading,
                                    onChanged: (value) {
                                      setState(() {
                                        _noCap = value;
                                      });
                                    }),
                              ),
                              SizedBox(
                                width: Statics.getDeviceSize(context).width * 0.4,
                                child: CheckboxListTile(
                                    contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                    title: Text(Statics.getLabel('NoShirt'), style: TextStyle(fontSize: 15)),
                                    checkColor: Colors.white,
                                    activeColor: Colors.purple,
                                    value: _noShirt == null ? false : _noShirt,
                                    controlAffinity: ListTileControlAffinity.leading,
                                    onChanged: (value) {
                                      setState(() {
                                        _noShirt = value;
                                      });
                                    }),
                              ),
                              SizedBox(
                                width: Statics.getDeviceSize(context).width * 0.4,
                                child: CheckboxListTile(
                                    contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                    title: Text(Statics.getLabel('NoPant'), style: TextStyle(fontSize: 15)),
                                    checkColor: Colors.white,
                                    activeColor: Colors.purple,
                                    value: _noPant == null ? false : _noPant,
                                    controlAffinity: ListTileControlAffinity.leading,
                                    onChanged: (value) {
                                      setState(() {
                                        _noPant = value;
                                      });
                                    }),
                              ),
                              SizedBox(
                                width: Statics.getDeviceSize(context).width * 0.4,
                                child: CheckboxListTile(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                  title: Text(Statics.getLabel('NoBelt'), style: TextStyle(fontSize: 15)),
                                  checkColor: Colors.white,
                                  activeColor: Colors.purple,
                                  value: _noBelt == null ? false : _noBelt,
                                  controlAffinity: ListTileControlAffinity.leading,
                                  onChanged: (value) {
                                    setState(() {
                                      _noBelt = value;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(
                                width: Statics.getDeviceSize(context).width * 0.4,
                                child: CheckboxListTile(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                  title: Text(Statics.getLabel('NoShoes'), style: TextStyle(fontSize: 15)),
                                  checkColor: Colors.white,
                                  activeColor: Colors.purple,
                                  value: _noShoes == null ? false : _noShoes,
                                  controlAffinity: ListTileControlAffinity.leading,
                                  onChanged: (value) {
                                    setState(() {
                                      _noShoes = value;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(
                                width: Statics.getDeviceSize(context).width * 0.4,
                                child: CheckboxListTile(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                  title: Text(Statics.getLabel('NoSocks'), style: TextStyle(fontSize: 15)),
                                  checkColor: Colors.white,
                                  activeColor: Colors.purple,
                                  value: _noSocks == null ? false : _noSocks,
                                  controlAffinity: ListTileControlAffinity.leading,
                                  onChanged: (value) {
                                    setState(() {
                                      _noSocks = value;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(
                                width: Statics.getDeviceSize(context).width * 0.4,
                                child: CheckboxListTile(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                  title: Text(Statics.getLabel('NoDanda'), style: TextStyle(fontSize: 15)),
                                  checkColor: Colors.white,
                                  activeColor: Colors.purple,
                                  value: _noDanda == null ? false : _noDanda,
                                  controlAffinity: ListTileControlAffinity.leading,
                                  onChanged: (value) {
                                    setState(() {
                                      _noDanda = value;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 18),
                        Legend(legendString: "SocialMediaUsage", fontsize: 18),
                        SizedBox(height: 5),
                        Container(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                      child: reusableCheckbox(
                                    title: Statics.getLabel("Facebook"),
                                    value: _isfb,
                                    onChanged: (value) {
                                      setState(() {
                                        _isfb = value;
                                      });
                                    },
                                  )),
                                  if (_isfb == true)
                                    Expanded(
                                      child: DropdownButtonFormField(
                                        decoration: InputDecoration(labelText: Statics.getLabel('SelectFacebookUsage')),
                                        isExpanded: true,
                                        value: _fbUsage,
                                        items: _usage,
                                        onChanged: (value) {
                                          setState(() {
                                            _fbUsage = value;
                                          });
                                        },
                                      ),
                                    ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: reusableCheckbox(
                                    title: Statics.getLabel("Insta"),
                                    value: _isinsta,
                                    onChanged: (value) {
                                      setState(() {
                                        _isinsta = value;
                                      });
                                    },
                                  )),
                                  if (_isinsta == true)
                                    Expanded(
                                      child: DropdownButtonFormField(
                                        decoration: InputDecoration(labelText: Statics.getLabel('SelectInstaUsage')),
                                        isExpanded: true,
                                        value: _instaUsage,
                                        items: _usage,
                                        onChanged: (value) {
                                          setState(() {
                                            _instaUsage = value;
                                          });
                                        },
                                      ),
                                    ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: reusableCheckbox(
                                    title: Statics.getLabel("Twitter"),
                                    value: _istwt,
                                    onChanged: (value) {
                                      setState(() {
                                        _istwt = value;
                                      });
                                    },
                                  )),
                                  if (_istwt == true)
                                    Expanded(
                                        child: DropdownButtonFormField(
                                      decoration: InputDecoration(labelText: Statics.getLabel('SelectTwitterUsage')),
                                      isExpanded: true,
                                      value: _twtUsage,
                                      items: _usage,
                                      onChanged: (value) {
                                        setState(() {
                                          _twtUsage = value;
                                        });
                                      },
                                    )),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 18),
                        Legend(legendString: "AreasOfInterestShort", fontsize: 18),
                        SizedBox(height: 5),
                        Container(
                          width: Statics.getDeviceSize(context).width * 0.8,
                          height: Statics.getDeviceSize(context).height * 0.3,
                          child: ListView(
                            children: _areaOfInterestForSearch.map((area) {
                              return reusableCheckbox(
                                title: area.codeForDisplay,
                                value: area.isSelected,
                                onChanged: (bool? value) {
                                  setState(() {
                                    area.isSelected = value;
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(height: 18),
                        Legend(legendString: "AreaOfExpertiseShort", fontsize: 18),
                        SizedBox(height: 5),
                        Container(
                          width: Statics.getDeviceSize(context).width * 0.8,
                          height: Statics.getDeviceSize(context).height * 0.3,
                          child: ListView(
                            children: _areaOfExpertiseForSearch.map((area) {
                              return reusableCheckbox(
                                title: area.codeForDisplay,
                                value: area.isSelected,
                                onChanged: (bool? value) {
                                  setState(() {
                                    area.isSelected = value;
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(height: 18),
                        Legend(legendString: "selectVayogat", fontsize: 18),
                        SizedBox(height: 5),
                        Wrap(
                          direction: Axis.horizontal,
                          spacing: 10,
                          children: [
                            SizedBox(
                              width: Statics.getDeviceSize(context).width * 0.4,
                              child: CheckboxListTile(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                  title: Text(Statics.getLabel('Shishu'), style: TextStyle(fontSize: 15)),
                                  checkColor: Colors.white,
                                  activeColor: Colors.purple,
                                  value: _shishu == null ? false : _shishu,
                                  controlAffinity: ListTileControlAffinity.leading,
                                  onChanged: (value) {
                                    setState(() {
                                      _shishu = value;
                                    });
                                  }),
                            ),
                            SizedBox(
                              width: Statics.getDeviceSize(context).width * 0.4,
                              child: CheckboxListTile(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                  title: Text(Statics.getLabel('Baal'), style: TextStyle(fontSize: 15)),
                                  checkColor: Colors.white,
                                  activeColor: Colors.purple,
                                  value: _baal == null ? false : _baal,
                                  controlAffinity: ListTileControlAffinity.leading,
                                  onChanged: (value) {
                                    setState(() {
                                      _baal = value;
                                    });
                                  }),
                            ),
                            SizedBox(
                              width: Statics.getDeviceSize(context).width * 0.4,
                              child: CheckboxListTile(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                  title: Text(Statics.getLabel('TarunVidyaarthi'), style: TextStyle(fontSize: 15)),
                                  checkColor: Colors.white,
                                  activeColor: Colors.purple,
                                  value: _tarunVidyarthi == null ? false : _tarunVidyarthi,
                                  controlAffinity: ListTileControlAffinity.leading,
                                  onChanged: (value) {
                                    setState(() {
                                      _tarunVidyarthi = value;
                                    });
                                  }),
                            ),
                            SizedBox(
                              width: Statics.getDeviceSize(context).width * 0.4,
                              child: CheckboxListTile(
                                contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                title: Text(Statics.getLabel('TarunVyavasaayee'), style: TextStyle(fontSize: 15)),
                                checkColor: Colors.white,
                                activeColor: Colors.purple,
                                value: _taarunVyavsai == null ? false : _taarunVyavsai,
                                controlAffinity: ListTileControlAffinity.leading,
                                onChanged: (value) {
                                  setState(() {
                                    _taarunVyavsai = value;
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              width: Statics.getDeviceSize(context).width * 0.4,
                              child: CheckboxListTile(
                                contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                title: Text(Statics.getLabel('ProudhaVyavasaayeeLabel'), style: TextStyle(fontSize: 15)),
                                checkColor: Colors.white,
                                activeColor: Colors.purple,
                                value: _prudhVyavsai == null ? false : _prudhVyavsai,
                                controlAffinity: ListTileControlAffinity.leading,
                                onChanged: (value) {
                                  setState(() {
                                    _prudhVyavsai = value;
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              width: Statics.getDeviceSize(context).width * 0.4,
                              child: CheckboxListTile(
                                contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                title: Text(Statics.getLabel('UnkownAge'), style: TextStyle(fontSize: 15)),
                                checkColor: Colors.white,
                                activeColor: Colors.purple,
                                value: _isDobAvail == null ? false : _isDobAvail,
                                controlAffinity: ListTileControlAffinity.leading,
                                onChanged: (value) {
                                  setState(() {
                                    _isDobAvail = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),

                ///
                SwayamsevakListContainer(
                  swList: _swList,
                  isSelectAll: _isSelectAll,
                  onSelectAll: (value) {
                    setState(() {
                      _isSelectAll = value;
                      onSelectAll(value);
                    });
                  },
                  onCheckCard: onCheckCard,
                  onUnCheckCard: onUnCheckCard,
                  search: _search,
                ),
              ],
            ),
            inAsyncCall: _isSearching!),
      ),
    );
  }

  Widget reusableCheckbox({required String? title, required bool? value, void Function(bool?)? onChanged, Color? activeColor, Color? checkColor}) {
    return CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      title: Text(title ?? "--"),
      value: value ?? false,
      activeColor: activeColor ?? Colors.purple,
      checkColor: checkColor ?? Colors.white,
      onChanged: onChanged ??
          (bool? val) {
            setState(() {
              value = val;
            });
          },
    );
  }
}
