import 'dart:convert';

import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/static_data.dart' as Statics;
import '../../providers/bals.dart';
import '../../providers/login.dart';
import '../../providers/swayamsevak_provider.dart';

class SwayamsevakOcuupation extends StatefulWidget {
  var swId;
  var onSaveSwDetails;
  var viewType;

  SwayamsevakOcuupation({Key? key, this.swId, this.onSaveSwDetails, this.viewType}) : super(key: key);

  State<StatefulWidget> createState() {
    return new SwayamsevakOcuupationState();
  }
}

class SwayamsevakOcuupationState extends State<SwayamsevakOcuupation> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  var _isLoading = false;
  bool _isFetchingData = false;

  SwayamsevakOccupationBAL? swOccupation;

  List<StaticMasterBAL>? _category;

  List<StaticMasterBAL>? _standard;

  List<StaticMasterBAL>? _weeklyOffCycle;

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
  String _otpUser = '';

  int? _othrcollegeID = null;
  int? _educationOthrProgramID = null;
  int? _educationOthrCourseID = null;

  var _educationCtrl = TextEditingController();

  // List<DropdownMenuItem> _weeklyOff = [
  //   new DropdownMenuItem(
  //     child: Text("Sunday"),
  //     value: "1",
  //   ),
  //   new DropdownMenuItem(
  //     child: Text("Monday"),
  //     value: "2",
  //   ),
  //   new DropdownMenuItem(
  //     child: Text("Tuesday"),
  //     value: "3",
  //   ),
  //   new DropdownMenuItem(
  //     child: Text("Wednesday"),
  //     value: "4",
  //   ),
  //   new DropdownMenuItem(
  //     child: Text("Thursday"),
  //     value: "5",
  //   ),
  //   new DropdownMenuItem(
  //     child: Text("Friday"),
  //     value: "6",
  //   ),
  //   new DropdownMenuItem(
  //     child: Text("Saturday"),
  //     value: "7",
  //   ),
  // ];

  bool? _isMon = false;
  bool? _isTue = false;
  bool? _isWed = false;
  bool? _isThu = false;
  bool? _isFri = false;
  bool? _isSat = false;
  bool? _isSun = false;
  bool? _isShiftDuty = false;

  StaticMasterBAL? _categoryValue;
  StaticMasterBAL? _programValue;
  StaticMasterBAL? _standardValue;
  StaticMasterBAL? _weeklyOffCycleValue;

  String? _weeklyOffValue;
  String? _progValue;

  var _schoolNameCntrl = TextEditingController();

  var _expectedCompletionYearCntrl = TextEditingController();
  var _govtDeptCtrl = TextEditingController();
  var _organizationNameCtrl = TextEditingController();
  var _industrialVerticalCtrl = TextEditingController();
  var _designationCtrl = TextEditingController();
  var _officeLocationCtrl = TextEditingController();
  var _dutyHoursFrmCtrl = TextEditingController();
  var _dutyHoursToCtrl = TextEditingController();
  var _organizationAtRetirementCtrl = TextEditingController();
  var _desgAtRetirementCtrl = TextEditingController();
  var _deptAtRetirementCtrl = TextEditingController();

  List<DropdownMenuItem> _prog = [
    new DropdownMenuItem(child: Text(Statics.getLabel('Science')), value: "Science"),
    new DropdownMenuItem(child: Text(Statics.getLabel('Commerce')), value: "Commerce"),
    new DropdownMenuItem(child: Text(Statics.getLabel('Arts')), value: "Arts"),
  ];
  String otpUser = '';

  @override
  void initState() {
    super.initState();
    populateDropdown();
    int swID = int.parse(widget.swId);
    if (swID > 0) {
      getSwDetails(widget.swId);
    } else {
      if (!mounted) return;
      setState(() {
        swOccupation = new SwayamsevakOccupationBAL(swID, null, 1, null, null, "", null, "", null, "", null, "", null, "", null, "", "", "", "", "", "", "", "", "", "", "", "", null, false, "", "");
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
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
    _expectedCompletionYearCntrl.dispose();
    _govtDeptCtrl.dispose();
    _organizationNameCtrl.dispose();
    _industrialVerticalCtrl.dispose();
    _designationCtrl.dispose();
    _officeLocationCtrl.dispose();
    _dutyHoursFrmCtrl.dispose();
    _dutyHoursToCtrl.dispose();
    _organizationAtRetirementCtrl.dispose();
    _desgAtRetirementCtrl.dispose();
    _deptAtRetirementCtrl.dispose();
    _educationCtrl.dispose();
  }

  populateDropdown() async {
    var data = await Statics.getStaticLDB('OccupationCategory');
    var data2 = await Statics.getStaticLDB('WeeklyOffCycle');
    var data5 = await Statics.getSanghaPreritSanstha("1", null, null);
    if (!mounted) return;
    setState(() {
      _category = data;
      _weeklyOffCycle = data2;
    });
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

  populateStandard(String? strType) async {
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

  populateEducationDetails() async {
    if (_educationUniversityID != null) {
      bool isForDistanceLearning = _categoryValue == null
          ? false
          : _categoryValue!.code == "Correspondence Course"
              ? true
              : false;
      var university = await Statics.getUniversity(_educationUniversityID, null, isForDistanceLearning);
      if (university.length > 0)
        setState(() {
          _educationUniversityNameCntrl.text = university[0]["UniversityName"];
        });
    }
    if (_collegeID != null) {
      var college = await Statics.getCollege(_collegeID, null, null);
      if (college.length > 0)
        setState(() {
          _collegeNameCntrl.text = college[0]["InstitutionName"];
        });
    } else {
      if (_categoryValue != null)
        _collegeNameCntrl.text = ((_categoryValue!.code == 'Jr College' || _categoryValue!.code == 'School Student')
            ? swOccupation!.schoolJuniorCollegeName == null
                ? ""
                : swOccupation!.schoolJuniorCollegeName
            : "")!;
    }
    if (_educationProgramID != null) {
      var program = await Statics.getGetEducationProgramsForApp(_educationProgramID, null, null);
      if (program.length > 0)
        setState(() {
          _educationProgramName.text = program[0]["ProgramName"];
        });
    }
    if (_educationCourseID != null) {
      var course = await Statics.getEducationCoursesForApp(_educationCourseID, null, null);
      if (course.length > 0)
        setState(() {
          _educationCourseName.text = course[0]["CourseName"];
        });
    }
  }

  void getSwDetails(var theId) async {
    setState(() {
      _isFetchingData = true;
    });
    bool isConnected = await Statics.isInternetConnected();
    if (!isConnected) {
      Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
    } else {
      var data = await SwayamsevakProvider().getSwayamSevakByID(theId, "OccupationDetails");
      await populateDropdown();
      if (!mounted) return;
      setState(() {
        swOccupation = data;
        if (swOccupation != null) {
          if (_category != null) {
            if (swOccupation!.occupationCategoryID != null) {
              var index = _category!.indexWhere((p) => p.staticID == swOccupation!.occupationCategoryID);
              _categoryValue = _category![index];
            } else {
              _categoryValue = null;
            }
          }
          _educationUniversityID = swOccupation!.educationUniversityID;

          getOtherIDs(_educationUniversityID);
          _collegeID = swOccupation!.educationInstitutionID;
          _educationProgramID = swOccupation!.educationProgramID;
          _educationCourseID = swOccupation!.educationCourseID;

          _educationOthrUniversityNameCntrl.text = swOccupation!.educationUniversityName ?? "";
          _collegeOthrNameCntrl.text = swOccupation!.educationInstitutionName ?? "";
          _educationOthrProgramName.text = swOccupation!.educationProgramName ?? "";
          _educationOthrCourseName.text = swOccupation!.educationCourseName ?? "";

          _deptAtRetirementCtrl.text = swOccupation!.departmentAtRetirement ?? "";
          _designationCtrl.text = swOccupation!.designation ?? "";
          _desgAtRetirementCtrl.text = swOccupation!.designationAtRetirement ?? "";
          _dutyHoursFrmCtrl.text = swOccupation!.officeTimingFrom ?? "";
          _dutyHoursToCtrl.text = swOccupation!.officeTimingTo ?? "";
          _govtDeptCtrl.text = swOccupation!.governmentDepartment ?? "";
          _industrialVerticalCtrl.text = swOccupation!.industryVertical ?? "";
          _officeLocationCtrl.text = swOccupation!.officeLocation ?? "";
          _organizationAtRetirementCtrl.text = swOccupation!.organizationAtRetirement ?? "";
          _organizationNameCtrl.text = swOccupation!.organizationName ?? "";
          _schoolNameCntrl.text = swOccupation!.schoolJuniorCollegeName ?? "";

          _progValue = swOccupation!.juniorCollegeProgramName;

          _educationCtrl.text = swOccupation!.education == null ? "" : swOccupation!.education!;

          _expectedCompletionYearCntrl.text = swOccupation!.expectedCompletionYear.toString();

          if (_weeklyOffCycle != null) {
            if (swOccupation!.weeklyOffCycle != null) {
              var index = _weeklyOffCycle!.indexWhere((p) => p.staticID == swOccupation!.weeklyOffCycle);
              _weeklyOffCycleValue = _weeklyOffCycle![index];
            } else {
              _weeklyOffCycleValue = null;
            }
          }

          _weeklyOffValue = swOccupation!.weeklyOffDay == null ? null : swOccupation!.weeklyOffDay.toString();
          if (_weeklyOffValue != null) {
            var arr = _weeklyOffValue!.split(',');
            _isSun = arr.contains("0") ? true : false;
            _isMon = arr.contains("1") ? true : false;
            _isTue = arr.contains("2") ? true : false;
            _isWed = arr.contains("3") ? true : false;
            _isThu = arr.contains("4") ? true : false;
            _isFri = arr.contains("5") ? true : false;
            _isSat = arr.contains("6") ? true : false;
          } else {
            _isSun = _isMon = _isTue = _isWed = _isThu = _isFri = _isSat = false;
          }
          _isShiftDuty = (swOccupation!.isShiftDuty == null ? false : swOccupation!.isShiftDuty);
        }
      });
    }
    await populateEducationDetails();
    await populateStandardDetails();
    setState(() {
      _isFetchingData = false;
    });
  }

  void repopulateFields() async {
    setState(() {
      _educationUniversityID = null;
      _collegeID = null;
      _educationProgramID = null;
      _educationCourseID = null;

      _educationOthrUniversityNameCntrl.text = "";
      _collegeOthrNameCntrl.text = "";
      _educationOthrProgramName.text = "";
      _educationOthrCourseName.text = "";

      _deptAtRetirementCtrl.text = "";
      _designationCtrl.text = "";
      _desgAtRetirementCtrl.text = "";
      _dutyHoursFrmCtrl.text = "";
      _dutyHoursToCtrl.text = "";
      _govtDeptCtrl.text = "";
      _industrialVerticalCtrl.text = "";
      _officeLocationCtrl.text = "";
      _organizationAtRetirementCtrl.text = "";
      _organizationNameCtrl.text = "";
      _schoolNameCntrl.text = "";

      _educationStandardNameCntrl.text = "";
      _educationOthrStandardNameCntrl.text = "";

      _expectedCompletionYearCntrl.text = "";

      _weeklyOffValue = null;
      _isSun = _isMon = _isTue = _isWed = _isThu = _isFri = _isSat = false;

      _educationUniversityNameCntrl.text = "";

      _collegeNameCntrl.text = "";
      _educationProgramName.text = "";
      _educationCourseName.text = "";
      _standardValue = null;
    });
  }

  populateStandardDetails() async {
    if (_categoryValue != null) {
      await populateStandard(_categoryValue!.code);
      setState(() {
        if (_standard != null) if (swOccupation!.educationStandardID != null) {
          var stindex = _standard!.indexWhere((p) => p.staticID == swOccupation!.educationStandardID);
          if (stindex > -1) _standardValue = _standard![stindex];
        }
        if (_categoryValue!.code == "Senior College") {
          _educationOthrStandardNameCntrl.text = swOccupation!.educationStandardName!;
        }
      });
    }
  }

  saveSwDetails() async {
    String otpUser = '';
    SharedPreferences pref = await SharedPreferences.getInstance();
    otpUser = pref.getString("otpuser") ?? '';
    var _weeklyOffDay = "";
    if (_isSun == true) _weeklyOffDay = _weeklyOffDay + "0,";
    if (_isMon == true) _weeklyOffDay = _weeklyOffDay + "1,";
    if (_isTue == true) _weeklyOffDay = _weeklyOffDay + "2,";
    if (_isWed == true) _weeklyOffDay = _weeklyOffDay + "3,";
    if (_isThu == true) _weeklyOffDay = _weeklyOffDay + "4,";
    if (_isFri == true) _weeklyOffDay = _weeklyOffDay + "5,";
    if (_isSat == true) _weeklyOffDay = _weeklyOffDay + "6,";

    if (_weeklyOffDay != "")
      swOccupation!.weeklyOffDay = _weeklyOffDay.substring(0, _weeklyOffDay.length - 1);
    else
      swOccupation!.weeklyOffDay = null;

    await getOtherIDs(swOccupation!.educationUniversityID);

    var inputData = json.encode({
      "Occupation": {
        "SwayamsevakID": int.parse(widget.swId),
        "PraantID": 1,
        "OccupationCategoryID": swOccupation!.occupationCategoryID,
        "EducationUniversityID":
            (_categoryValue!.code == 'Senior College' || _categoryValue!.code == 'Post Graduate' || _categoryValue!.code == 'Professional Studies' || _categoryValue!.code == 'Correspondence Course')
                ? swOccupation!.educationUniversityID
                : null,
        "EducationUniversityName":
            (_categoryValue!.code == 'Senior College' || _categoryValue!.code == 'Post Graduate' || _categoryValue!.code == 'Professional Studies' || _categoryValue!.code == 'Correspondence Course')
                ? swOccupation!.educationUniversityName
                : null,
        "EducationInstitutionID":
            (_categoryValue!.code == 'Senior College' || _categoryValue!.code == 'Post Graduate' || _categoryValue!.code == 'Professional Studies' || _categoryValue!.code == 'Correspondence Course')
                ? _educationUniversityNameCntrl.text == "Other"
                    ? _othrcollegeID
                    : swOccupation!.educationInstitutionID
                : null,
        "EducationInstitutionName":
            (_categoryValue!.code == 'Senior College' || _categoryValue!.code == 'Post Graduate' || _categoryValue!.code == 'Professional Studies' || _categoryValue!.code == 'Correspondence Course')
                ? swOccupation!.educationInstitutionName
                : null,
        "EducationStandardID":
            (_categoryValue!.code == 'School Student' || _categoryValue!.code == 'Jr College' || _categoryValue!.code == 'Senior College') ? swOccupation!.educationStandardID : null,
        "EducationStandardName":
            (_categoryValue!.code == 'School Student' || _categoryValue!.code == 'Jr College' || _categoryValue!.code == 'Senior College') ? swOccupation!.educationStandardName : null,
        "EducationProgramID":
            (_categoryValue!.code == 'Professional Studies' || _categoryValue!.code == 'Senior College' || _categoryValue!.code == 'Post Graduate' || _categoryValue!.code == 'Correspondence Course')
                ? _educationUniversityNameCntrl.text == "Other"
                    ? _educationOthrProgramID
                    : swOccupation!.educationProgramID
                : null,
        "EducationProgramName": (_categoryValue!.code == 'Senior College' ||
                _categoryValue!.code == 'Post Graduate' ||
                _categoryValue!.code == 'Professional Studies' ||
                _categoryValue!.code == 'Correspondence Course' ||
                _categoryValue!.code == 'Jr College')
            ? swOccupation!.educationProgramName
            : null,
        "EducationCourseID":
            (_categoryValue!.code == 'Professional Studies' || _categoryValue!.code == 'Senior College' || _categoryValue!.code == 'Post Graduate' || _categoryValue!.code == 'Correspondence Course')
                ? (_educationUniversityNameCntrl.text == "Other" || _categoryValue!.code == 'Correspondence Course')
                    ? _educationOthrCourseID
                    : swOccupation!.educationCourseID
                : null,
        "EducationCourseName":
            (_categoryValue!.code == 'Professional Studies' || _categoryValue!.code == 'Senior College' || _categoryValue!.code == 'Post Graduate' || _categoryValue!.code == 'Correspondence Course')
                ? swOccupation!.educationCourseName
                : null,
        "EducationExpectedCompletionYear":
            (_categoryValue!.code == 'Professional Studies' || _categoryValue!.code == 'Senior College' || _categoryValue!.code == 'Post Graduate' || _categoryValue!.code == 'Correspondence Course')
                ? swOccupation!.expectedCompletionYear
                : null,
        "SchoolJuniorCollegeName": (_categoryValue!.code == 'School Student' || _categoryValue!.code == 'Jr College') ? swOccupation!.schoolJuniorCollegeName : null,
        "JuniorCollegeProgramName": (_categoryValue!.code == 'Jr College') ? swOccupation!.juniorCollegeProgramName : null,
        "GovernmentDepartment": (_categoryValue!.code == 'Government Employee') ? swOccupation!.governmentDepartment : null,
        "Designation": (_categoryValue!.code == 'Government Employee' || _categoryValue!.code == 'Private Company' || _categoryValue!.code == 'Business') ? swOccupation!.designation : null,
        "OfficeLocation": (_categoryValue!.code == 'Government Employee' || _categoryValue!.code == 'Private Company' || _categoryValue!.code == 'Business') ? swOccupation!.officeLocation : null,
        "WeeklyOffDayIDs": (_categoryValue!.code == 'Government Employee' || _categoryValue!.code == 'Private Company' || _categoryValue!.code == 'Business') ? swOccupation!.weeklyOffDay : null,
        "WeeklyOffCycleID": (_categoryValue!.code == 'Government Employee' || _categoryValue!.code == 'Private Company' || _categoryValue!.code == 'Business') ? swOccupation!.weeklyOffCycle : null,
        "IsShiftDuty": (_categoryValue!.code == 'Government Employee' || _categoryValue!.code == 'Private Company' || _categoryValue!.code == 'Business') ? _isShiftDuty : null,
        "OfficeTimingFrom": (_categoryValue!.code == 'Government Employee' || _categoryValue!.code == 'Private Company' || _categoryValue!.code == 'Business')
            ? _isShiftDuty == false
                ? swOccupation!.officeTimingFrom
                : null
            : null,
        "OfficeTimingTo": (_categoryValue!.code == 'Government Employee' || _categoryValue!.code == 'Private Company' || _categoryValue!.code == 'Business')
            ? _isShiftDuty == false
                ? swOccupation!.officeTimingTo
                : null
            : null,
        "OrganizationName": (_categoryValue!.code == 'Private Company' || _categoryValue!.code == 'Business') ? swOccupation!.organizationName : null,
        "IndustryVertical": (_categoryValue!.code == 'Private Company' || _categoryValue!.code == 'Business') ? swOccupation!.industryVertical : null,
        "OrganizationAtRetirement": _categoryValue!.code == 'Retired' ? swOccupation!.organizationAtRetirement : null,
        "DesignationAtRetirement": _categoryValue!.code == 'Retired' ? swOccupation!.designationAtRetirement : null,
        "DepartmentAtRetirement": _categoryValue!.code == 'Retired' ? swOccupation!.departmentAtRetirement : null,
        "Education": (_categoryValue!.code == 'Government Employee' || _categoryValue!.code == 'Private Company' || _categoryValue!.code == 'Business' || _categoryValue!.code == 'Retired')
            ? swOccupation!.education
            : null
      },
      "ModifiedBy": Statics.userDetails["userID"].toString()
    });

    var data = await SwayamsevakProvider().saveSwayamsevakOccupationForApp(inputData);
    setState(() {
      widget.swId = data;
      widget.onSaveSwDetails(widget.swId);
    });
    if (otpUser != null && otpUser == "true") {
      Statics.showToast(Statics.getLabel('dataSavedSuccessfully'));
      await LogIn().logOut();
      BackgroundFetch.stop().then((int status) {
        print('[BackgroundFetch] stop success: $status');
      });
      Navigator.of(context).pushReplacementNamed('/');
    }
    Statics.showToast(Statics.getLabel('dataSavedSuccessfully'));
    // BackgroundFetch.stop().then((int status) {
    //   print('[BackgroundFetch] stop success: $status');
    // });
    // // Navigator.of(context).pushReplacementNamed('/');
    // Navigator.popAndPushNamed(context, HomeScreen.routeName);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      bool isConnected = await Statics.isInternetConnected();
      if (!isConnected) {
        Statics.showMessageDialog(context, Statics.getLabel('internetNotConnected'));
      } else {
        await saveSwDetails();
      }
    } on Exception catch (error) {
      _showErrorDialog(Statics.getLabel('unableToCompleteProcess'));
    } catch (error) {
      _showErrorDialog(Statics.getLabel('unableToCompleteProcess'));
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(Statics.getLabel('errorOccurred')),
        content: Text(message),
        actions: <Widget>[
          MaterialButton(
            child: Text(Statics.getLabel('okay')),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<List<dynamic>> populateUniversity(String pattern, bool isForDistanceLearning) async {
    var data3 = await Statics.getUniversity(null, pattern, isForDistanceLearning);
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

  getOtherIDs(var universityID) async {
    var data1 = await Statics.getEducationCoursesForApp(null, universityID, "Other");
    var data2 = await Statics.getCollege(null, universityID, "Other");
    var data3 = await Statics.getGetEducationProgramsForApp(null, universityID, "Other");

    if (data1.length > 0) _educationOthrCourseID = data1[0]["EducationCourseID"];
    if (data2.length > 0) _othrcollegeID = data2[0]["EducationInstitutionID"];
    if (data3.length > 0) _educationOthrProgramID = data3[0]["EducationProgramID"];
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            width: Statics.getDeviceSize(context).width,
            child: AbsorbPointer(
              absorbing: widget.viewType == "ViewMenu" ? true : false,
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    if (_category != null)
                      DropdownButtonFormField<StaticMasterBAL>(
                        decoration: InputDecoration(labelText: Statics.getLabel('SelectCategory')),
                        isExpanded: true,
                        value: _categoryValue == null ? null : _categoryValue,
                        validator: (value) {
                          if (value == null) return (Statics.getLabel('CategoryValidationMessage'));
                          return null;
                        },
                        items: _category!.map((bg) => DropdownMenuItem(value: bg, child: Text(bg.codeForDisplay!))).toList(),
                        onChanged: (value) {
                          setState(() {
                            _categoryValue = value;
                            // populateProgram(value.code);
                            repopulateFields();
                            populateStandard(value!.code);
                          });
                        },
                        onSaved: (value) {
                          _categoryValue = value;
                          swOccupation!.occupationCategoryID = value!.staticID;
                        },
                      ),
                    SizedBox(
                      height: 10,
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
                              validator: (value) {
                                if (value!.isEmpty) return (Statics.getLabel('SchoolNameValidationMessage'));
                                return null;
                              },
                              onSaved: (value) {
                                if (value != null && value.isNotEmpty)
                                  swOccupation!.schoolJuniorCollegeName = value;
                                else
                                  swOccupation!.schoolJuniorCollegeName = null;
                              },
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
                              validator: (value) {
                                if (value!.isEmpty) return (Statics.getLabel('CollegeNameValidationMessage'));
                                return null;
                              },
                              onSaved: (value) {
                                if (value != null && value.isNotEmpty)
                                  swOccupation!.schoolJuniorCollegeName = value;
                                else
                                  swOccupation!.schoolJuniorCollegeName = null;
                              },
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
                                          controller: controller,
                                          focusNode: focusNode,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            border: UnderlineInputBorder(),
                                            labelText: Statics.getLabel('University'),
                                          ));
                                    },
                                    // textFieldConfiguration:
                                    //     TextFieldConfiguration(
                                    //         controller: this
                                    //             ._educationUniversityNameCntrl,
                                    //         decoration: InputDecoration(
                                    //             labelText: Statics.getLabel(
                                    //                 'University'))),
                                    suggestionsCallback: (pattern) {
                                      this._educationUniversityID = null;
                                      return populateUniversity(pattern, _categoryValue!.code == "Correspondence Course" ? true : false);
                                    },
                                    itemBuilder: (context, suggestion) {
                                      return ListTile(
                                        title: Text(suggestion["UniversityName"]),
                                      );
                                    },
                                    // validator: (value) {
                                    //   if ((value!.isEmpty ||
                                    //       _educationUniversityID == null ||
                                    //       _educationUniversityID < 0)) {
                                    //     return Statics.getLabel(
                                    //         'UniversityValidationMessage');
                                    //   }
                                    //   return null;
                                    // },
                                    // transitionBuilder:
                                    //     (context, suggestionsBox, controller) {
                                    //   return suggestionsBox;
                                    // },
                                    onSelected: (suggestion) {
                                      setState(() {
                                        this._educationUniversityNameCntrl.text = suggestion["UniversityName"];
                                        _educationUniversityID = suggestion["EducationUniversityID"];
                                        _educationOthrUniversityNameCntrl.text = "";
                                        _collegeNameCntrl.text = "";
                                        _collegeOthrNameCntrl.text = "";
                                        _educationStandardNameCntrl.text = "";
                                        _educationOthrUniversityNameCntrl.text = "";
                                        _educationOthrStandardNameCntrl.text = "";
                                        _educationProgramName.text = "";
                                        _educationOthrProgramName.text = "";
                                        _educationCourseName.text = "";
                                        _educationOthrCourseName.text = "";
                                        _educationCourseID = _collegeID = _educationStandardID = _educationProgramID = null;
                                        getOtherIDs(suggestion["EducationUniversityID"]);
                                      });
                                    },
                                    // onSaved: (value) {
                                    //   if (_educationUniversityID != null &&
                                    //       _educationUniversityID > 0)
                                    //     swOccupation!.educationUniversityID =
                                    //         _educationUniversityID;
                                    //   else
                                    //     swOccupation!.educationUniversityID =
                                    //         null;
                                    // },
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
                                        _educationOthrUniversityNameCntrl.text = "";
                                        _educationOthrStandardNameCntrl.text = "";
                                        _educationProgramName.text = "";
                                        _educationOthrProgramName.text = "";
                                        _educationCourseName.text = "";
                                        _educationOthrCourseName.text = "";
                                        _educationCourseID = _collegeID = _educationStandardID = _educationProgramID = null;
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
                                validator: (value) {
                                  if (value!.isEmpty) return (Statics.getLabel('UniversityNameValidationMessage'));
                                  return null;
                                },
                                onSaved: (value) {
                                  if (value != null && value.isNotEmpty)
                                    swOccupation!.educationUniversityName = value;
                                  else
                                    swOccupation!.educationUniversityName = null;
                                },
                              ),
                            if (_educationUniversityNameCntrl.text != "Other" && _categoryValue!.code != 'Correspondence Course') SizedBox(height: 10),
                            if (_educationUniversityNameCntrl.text != "Other" && _categoryValue!.code != 'Correspondence Course')
                              Row(
                                children: [
                                  Container(
                                    width: Statics.getDeviceSize(context).width * 0.75,
                                    child: TypeAheadField<dynamic>(
                                      controller: _collegeNameCntrl,
                                      builder: (context, controller, focusNode) {
                                        return TextField(
                                            controller: controller,
                                            focusNode: focusNode,
                                            decoration: InputDecoration(
                                              isDense: true,
                                              border: UnderlineInputBorder(),
                                              labelText: Statics.getLabel('College'),
                                            ));
                                      },
                                      // textFieldConfiguration:
                                      //     TextFieldConfiguration(
                                      //         controller:
                                      //             this._collegeNameCntrl,
                                      //         decoration: InputDecoration(
                                      //             labelText: Statics.getLabel(
                                      //                 'College'))),
                                      suggestionsCallback: (pattern) {
                                        this._collegeID = null;
                                        return populateCollege(_educationUniversityID == null ? "0" : _educationUniversityID.toString(), pattern);
                                      },
                                      itemBuilder: (context, suggestion) {
                                        return ListTile(
                                          title: Text(suggestion["InstitutionName"]),
                                        );
                                      },
                                      // validator: (value) {
                                      //   if ((value!.isEmpty ||
                                      //       _collegeID == null ||
                                      //       _collegeID < 0)) {
                                      //     return Statics.getLabel(
                                      //         'CollegeValidationMessage');
                                      //   }
                                      //   return null;
                                      // },
                                      // transitionBuilder: (context,
                                      //     suggestionsBox, controller) {
                                      //   return suggestionsBox;
                                      // },
                                      onSelected: (suggestion) {
                                        setState(() {
                                          this._collegeNameCntrl.text = suggestion["InstitutionName"];
                                          _collegeID = suggestion["EducationInstitutionID"];
                                        });
                                      },
                                      // onSaved: (value) {
                                      //   if (_collegeID != null &&
                                      //       _collegeID > 0)
                                      //     swOccupation!.educationInstitutionID =
                                      //         _collegeID;
                                      //   else
                                      //     swOccupation!.educationInstitutionID =
                                      //         null;
                                      // },
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
                            if ((_educationUniversityNameCntrl.text == "Other" || _collegeNameCntrl.text == "Other") && _categoryValue!.code != 'Correspondence Course') SizedBox(height: 10),
                            if ((_educationUniversityNameCntrl.text == "Other" || _collegeNameCntrl.text == "Other") && _categoryValue!.code != 'Correspondence Course')
                              TextFormField(
                                textInputAction: TextInputAction.next,
                                controller: _collegeOthrNameCntrl,
                                decoration: InputDecoration(labelText: Statics.getLabel('CollegeName')),
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value!.isEmpty) return (Statics.getLabel('CollegeNameValidationMessage'));
                                  return null;
                                },
                                onSaved: (value) {
                                  if (value != null && value.isNotEmpty)
                                    swOccupation!.educationInstitutionName = value;
                                  else
                                    swOccupation!.educationInstitutionName = null;
                                },
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
                              validator: (value) {
                                if (value == null) return (Statics.getLabel('StandardValidationMessage'));
                                return null;
                              },
                              items: _standard!.map((bg) => DropdownMenuItem(value: bg, child: Text(bg.codeForDisplay!))).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _standardValue = value;
                                });
                              },
                              onSaved: (value) {
                                _standardValue = value;
                                swOccupation!.educationStandardID = value!.staticID;
                              },
                            ),
                            if (_standardValue != null && _standardValue!.code == "Other")
                              TextFormField(
                                textInputAction: TextInputAction.next,
                                controller: _educationOthrStandardNameCntrl,
                                decoration: InputDecoration(labelText: Statics.getLabel('Standard')),
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value!.isEmpty) return (Statics.getLabel('StandardValidationMessage'));
                                  return null;
                                },
                                onSaved: (value) {
                                  if (value != null && value.isNotEmpty)
                                    swOccupation!.educationStandardName = value;
                                  else
                                    swOccupation!.educationStandardName = null;
                                },
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
                          validator: (value) {
                            if (value == null || value!.isEmpty) {
                              return Statics.getLabel('ProgramValidationMessage');
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              _progValue = value;
                            });
                          },
                          onSaved: (value) {
                            if (value != null && value.isNotEmpty)
                              swOccupation!.juniorCollegeProgramName = value;
                            else
                              swOccupation!.juniorCollegeProgramName = null;
                          },
                        )
                      else if (_categoryValue!.code == 'Professional Studies' ||
                          _categoryValue!.code == 'Senior College' ||
                          _categoryValue!.code == 'Post Graduate' ||
                          _categoryValue!.code == 'Correspondence Course')
                        Column(
                          children: [
                            if (_educationUniversityNameCntrl.text != "Other" && _categoryValue!.code != 'Correspondence Course') SizedBox(height: 10),
                            if (_educationUniversityNameCntrl.text != "Other" && _categoryValue!.code != 'Correspondence Course')
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
                                      // textFieldConfiguration:
                                      //     TextFieldConfiguration(
                                      //         controller:
                                      //             this._educationProgramName,
                                      //         decoration: InputDecoration(
                                      //             labelText: Statics.getLabel(
                                      //                 'Program'))),
                                      suggestionsCallback: (pattern) {
                                        this._educationProgramID = null;
                                        return populateProgram(_educationUniversityID.toString(), pattern);
                                      },
                                      itemBuilder: (context, suggestion) {
                                        return ListTile(
                                          title: Text(suggestion["ProgramName"]),
                                        );
                                      },
                                      // validator: (value) {
                                      //   if ((value!.isEmpty ||
                                      //       _educationProgramID == null ||
                                      //       _educationProgramID < 0)) {
                                      //     return Statics.getLabel(
                                      //         'ProgramValidationMessage');
                                      //   }
                                      //   return null;
                                      // },
                                      // transitionBuilder: (context,
                                      //     suggestionsBox, controller) {
                                      //   return suggestionsBox;
                                      // },
                                      onSelected: (suggestion) {
                                        setState(() {
                                          this._educationProgramName.text = suggestion["ProgramName"];
                                          _educationProgramID = suggestion["EducationProgramID"];
                                          _educationOthrProgramName.text = "";
                                        });
                                      },
                                      // onSaved: (value) {
                                      //   if (_educationProgramID != null &&
                                      //       _educationProgramID > 0)
                                      //     swOccupation!.educationProgramID =
                                      //         _educationProgramID;
                                      //   else
                                      //     swOccupation!.educationProgramID =
                                      //         null;
                                      // },
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
                            if ((_educationUniversityNameCntrl.text == "Other" || _educationProgramName.text == "Other") && _categoryValue!.code != 'Correspondence Course') SizedBox(height: 10),
                            if ((_educationUniversityNameCntrl.text == "Other" || _educationProgramName.text == "Other") && _categoryValue!.code != 'Correspondence Course')
                              TextFormField(
                                textInputAction: TextInputAction.next,
                                controller: _educationOthrProgramName,
                                decoration: InputDecoration(labelText: Statics.getLabel('ProgramName')),
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value!.isEmpty) return (Statics.getLabel('ProgramNameValidationMessage'));
                                  return null;
                                },
                                onSaved: (value) {
                                  if (value != null && value.isNotEmpty)
                                    swOccupation!.educationProgramName = value;
                                  else
                                    swOccupation!.educationProgramName = null;
                                },
                              ),
                            SizedBox(
                              height: 10,
                            ),
                            if (_categoryValue != null)
                              if (_educationUniversityNameCntrl.text != "Other" && _categoryValue!.code != 'Correspondence Course') SizedBox(height: 10),
                            if (_categoryValue != null)
                              if (_educationUniversityNameCntrl.text != "Other" && _categoryValue!.code != 'Correspondence Course')
                                Row(
                                  children: [
                                    Container(
                                      width: Statics.getDeviceSize(context).width * 0.75,
                                      child: TypeAheadField<dynamic>(
                                        controller: _educationCourseName,
                                        builder: (context, controller, focusNode) {
                                          return TextField(
                                              controller: controller,
                                              focusNode: focusNode,
                                              decoration: InputDecoration(
                                                isDense: true,
                                                border: UnderlineInputBorder(),
                                                labelText: Statics.getLabel('Course'),
                                              ));
                                        },
                                        // textFieldConfiguration:
                                        //     TextFieldConfiguration(
                                        //         controller:
                                        //             this._educationCourseName,
                                        //         decoration: InputDecoration(
                                        //             labelText: Statics.getLabel(
                                        //                 'Course'))),
                                        suggestionsCallback: (pattern) {
                                          this._educationCourseID = null;
                                          return populateCourse(_educationUniversityID.toString(), pattern);
                                        },
                                        itemBuilder: (context, suggestion) {
                                          return ListTile(
                                            title: Text(suggestion["CourseName"]),
                                          );
                                        },
                                        // validator: (value) {
                                        //   if ((value!.isEmpty ||
                                        //       _educationCourseID == null ||
                                        //       _educationCourseID < 0)) {
                                        //     return Statics.getLabel(
                                        //         'CourseValidationMessage');
                                        //   }
                                        //   return null;
                                        // },
                                        // transitionBuilder: (context,
                                        //     suggestionsBox, controller) {
                                        //   return suggestionsBox;
                                        // },
                                        onSelected: (suggestion) {
                                          setState(() {
                                            this._educationCourseName.text = suggestion["CourseName"];
                                            _educationCourseID = suggestion["EducationCourseID"];
                                          });
                                        },
                                        // onSaved: (value) {
                                        //   if (_educationCourseID != null &&
                                        //       _educationCourseID > 0)
                                        //     swOccupation!.educationCourseID =
                                        //         _educationCourseID;
                                        //   else
                                        //     swOccupation!.educationCourseID =
                                        //         null;
                                        // },
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
                            if (_categoryValue != null)
                              if (_educationUniversityNameCntrl.text == "Other" || _educationCourseName.text == "Other" || _categoryValue!.code == 'Correspondence Course') SizedBox(height: 10),
                            if (_categoryValue != null)
                              if (_educationUniversityNameCntrl.text == "Other" || _educationCourseName.text == "Other" || _categoryValue!.code == 'Correspondence Course')
                                TextFormField(
                                  textInputAction: TextInputAction.next,
                                  controller: _educationOthrCourseName,
                                  decoration: InputDecoration(labelText: Statics.getLabel('CourseName')),
                                  keyboardType: TextInputType.text,
                                  validator: (value) {
                                    if (value!.isEmpty) return (Statics.getLabel('CourseNameValidationMessage'));
                                    return null;
                                  },
                                  onSaved: (value) {
                                    if (value != null && value.isNotEmpty)
                                      swOccupation!.educationCourseName = value;
                                    else
                                      swOccupation!.educationCourseName = null;
                                  },
                                ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                    if (_categoryValue != null)
                      if (_categoryValue!.code == 'Professional Studies' ||
                          _categoryValue!.code == 'Senior College' ||
                          _categoryValue!.code == 'Post Graduate' ||
                          _categoryValue!.code == 'Correspondence Course')
                        Column(
                          children: [
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              controller: _expectedCompletionYearCntrl,
                              decoration: InputDecoration(labelText: Statics.getLabel('ExpectedCompletionYear')),
                              keyboardType: TextInputType.number,
                              maxLength: 4,
                              validator: (value) {
                                if (value!.isEmpty) return (Statics.getLabel('ExpectedCompletionYearValidationMessage'));
                                return null;
                              },
                              onSaved: (value) {
                                if (value != null && value.isNotEmpty)
                                  swOccupation!.expectedCompletionYear = int.parse(value);
                                else
                                  swOccupation!.expectedCompletionYear = null;
                              },
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
                              validator: (value) {
                                if (value!.isEmpty) return (Statics.getLabel('GovernmentDepartmentValidationMessage'));
                                return null;
                              },
                              onSaved: (value) {
                                if (value != null && value.isNotEmpty)
                                  swOccupation!.governmentDepartment = value;
                                else
                                  swOccupation!.governmentDepartment = null;
                              },
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
                              validator: (value) {
                                if (value!.isEmpty) return (Statics.getLabel('OrganizationNameValidationMessage'));
                                return null;
                              },
                              onSaved: (value) {
                                if (value != null && value.isNotEmpty)
                                  swOccupation!.organizationName = value;
                                else
                                  swOccupation!.organizationName = null;
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              controller: _industrialVerticalCtrl,
                              decoration: InputDecoration(labelText: Statics.getLabel('IndustryVertical')),
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value!.isEmpty) return (Statics.getLabel('IndustryVerticalValidationMessage'));
                                return null;
                              },
                              onSaved: (value) {
                                if (value != null && value.isNotEmpty)
                                  swOccupation!.industryVertical = value;
                                else
                                  swOccupation!.industryVertical = null;
                              },
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
                              controller: _designationCtrl,
                              decoration: InputDecoration(labelText: Statics.getLabel('Designation')),
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value!.isEmpty) return (Statics.getLabel('DesignationValidationMessage'));
                                return null;
                              },
                              onSaved: (value) {
                                if (value != null && value.isNotEmpty)
                                  swOccupation!.designation = value;
                                else
                                  swOccupation!.designation = null;
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              controller: _officeLocationCtrl,
                              decoration: InputDecoration(labelText: Statics.getLabel('OfficeLocation')),
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value!.isEmpty) return (Statics.getLabel('OfficeLocationValidationMessage'));
                                return null;
                              },
                              onSaved: (value) {
                                if (value != null && value.isNotEmpty)
                                  swOccupation!.officeLocation = value;
                                else
                                  swOccupation!.officeLocation = null;
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            DropdownButtonFormField<StaticMasterBAL>(
                              decoration: InputDecoration(labelText: Statics.getLabel('WeeklyOffCycle')),
                              isExpanded: true,
                              value: _weeklyOffCycleValue == null ? null : _weeklyOffCycleValue,
                              validator: (value) {
                                if (value == null) return (Statics.getLabel('WeeklyOffCycleValidationMessage'));
                                return null;
                              },
                              items: _weeklyOffCycle!.map((bg) => DropdownMenuItem(value: bg, child: Text(bg.codeForDisplay!))).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _weeklyOffCycleValue = value;
                                });
                              },
                              onSaved: (value) {
                                _weeklyOffCycleValue = value;
                                swOccupation!.weeklyOffCycle = value!.staticID;
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            if (_weeklyOffCycleValue != null)
                              if (_weeklyOffCycleValue!.code != "Rotating")
                                Column(
                                  children: [
                                    Text(
                                      Statics.getLabel('SelectWeeklyOffDay'),
                                    ),
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
                            // DropdownButtonFormField(
                            //   decoration: InputDecoration(
                            //       labelText:
                            //           Statics.getLabel('SelectWeeklyOffDay')),
                            //   isExpanded: true,
                            //   value:
                            //       _weeklyOffValue == null ? null : _weeklyOffValue,
                            //   items: _weeklyOff,
                            //   validator: (value) {
                            //     if (value == "" || value == null)
                            //       return (Statics.getLabel(
                            //           'WeeklyOffDayValidationMessage'));
                            //     return null;
                            //   },
                            //   onChanged: (value) {
                            //     setState(() {
                            //       _weeklyOffValue = value;
                            //     });
                            //   },
                            //   onSaved: (value) {
                            //     if (value != null && value.isNotEmpty)
                            //       swOccupation!.weeklyOffDay = int.parse(value);
                            //     else
                            //       swOccupation!.weeklyOffDay = null;
                            //   },
                            // ),
                            // SizedBox(
                            //   height: 10,
                            // ),

                            SizedBox(
                              width: Statics.getDeviceSize(context).width * 0.8,
                              child: CheckboxListTile(
                                contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                controlAffinity: ListTileControlAffinity.leading,
                                title: Text(Statics.getLabel("IsShiftDuty"), style: TextStyle(fontSize: 15)),
                                checkColor: Colors.white,
                                activeColor: Colors.purple,
                                value: _isShiftDuty == null ? false : _isShiftDuty,
                                onChanged: (value) {
                                  setState(() {
                                    _isShiftDuty = value;
                                  });
                                },
                              ),
                            ),
                            SizedBox(height: 10),
                            if (_isShiftDuty == false)
                              TextFormField(
                                textInputAction: TextInputAction.next,
                                controller: _dutyHoursFrmCtrl,
                                decoration: InputDecoration(labelText: Statics.getLabel('DutyHoursFrom')),
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value!.isEmpty) return (Statics.getLabel('DutyHoursFromValidationMessage'));
                                  return null;
                                },
                                onSaved: (value) {
                                  if (value != null && value.isNotEmpty)
                                    swOccupation!.officeTimingFrom = value;
                                  else
                                    swOccupation!.officeTimingFrom = null;
                                },
                              ),
                            if (_isShiftDuty == false)
                              SizedBox(
                                height: 10,
                              ),
                            if (_isShiftDuty == false)
                              TextFormField(
                                textInputAction: TextInputAction.next,
                                controller: _dutyHoursToCtrl,
                                decoration: InputDecoration(labelText: Statics.getLabel('DutyHoursTo')),
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value!.isEmpty) return (Statics.getLabel('DutyHoursToValidationMessage'));
                                  return null;
                                },
                                onSaved: (value) {
                                  if (value != null && value.isNotEmpty)
                                    swOccupation!.officeTimingTo = value;
                                  else
                                    swOccupation!.officeTimingTo = null;
                                },
                              ),
                            if (_isShiftDuty == true)
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
                              validator: (value) {
                                if (value!.isEmpty) return (Statics.getLabel('OrganizationAtRetirementValidationMessage'));
                                return null;
                              },
                              onSaved: (value) {
                                if (value != null && value.isNotEmpty)
                                  swOccupation!.organizationAtRetirement = value;
                                else
                                  swOccupation!.organizationAtRetirement = null;
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              controller: _desgAtRetirementCtrl,
                              decoration: InputDecoration(labelText: Statics.getLabel('DesignationAtRetirement')),
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value!.isEmpty) return (Statics.getLabel('DesignationAtRetirementValidationMessage'));
                                return null;
                              },
                              onSaved: (value) {
                                if (value != null && value.isNotEmpty)
                                  swOccupation!.designationAtRetirement = value;
                                else
                                  swOccupation!.designationAtRetirement = null;
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              controller: _deptAtRetirementCtrl,
                              decoration: InputDecoration(labelText: Statics.getLabel('GovernmentDepartmentRetirement')),
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value!.isEmpty) return (Statics.getLabel('GovernmentDepartmentRetirementValidationMessage'));
                                return null;
                              },
                              onSaved: (value) {
                                if (value != null && value.isNotEmpty)
                                  swOccupation!.departmentAtRetirement = value;
                                else
                                  swOccupation!.departmentAtRetirement = null;
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                    if (_categoryValue != null)
                      if (_categoryValue!.code == 'Government Employee' || _categoryValue!.code == 'Private Company' || _categoryValue!.code == 'Business' || _categoryValue!.code == 'Retired')
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: _educationCtrl,
                          decoration: InputDecoration(labelText: Statics.getLabel('Education')),
                          keyboardType: TextInputType.text,
                          maxLength: 100,
                          onSaved: (value) {
                            if (value != null && value.isNotEmpty)
                              swOccupation!.education = value;
                            else
                              swOccupation!.education = null;
                          },
                        ),
                    SizedBox(
                      height: 10,
                    ),
                    if (_isLoading)
                      CircularProgressIndicator()
                    else if (int.parse(widget.swId) == 0)
                      Text(Statics.getLabel('saveBasicInfo'))
                    else if (widget.viewType == "ViewMenu")
                      Text(Statics.getLabel('canNotMakeChanges'))
                    else
                      MaterialButton(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        padding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 8,
                        ),
                        color: Theme.of(context).primaryColor,
                        textColor: Theme.of(context).primaryTextTheme.labelMedium?.color,
                        onPressed: _submit,
                        child: Text(
                          Statics.getLabel('Submit'),
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
        inAsyncCall: _isFetchingData);
  }
}
