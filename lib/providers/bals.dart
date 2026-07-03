import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SwayamsevakBAL {
  int? swayamsevakID;
  int? praantID;
  String? fullName;
  String? mobileNumber;
  String? email;
  String? birthDate;
  int? linkedGeoUnitID;
  String? linkedGeoUnitName;
  int? linkedShaakhaaID;
  String? linkedShaakhaaName;
  int? preferredLanguageID;
  String? preferredLanguageCode;
  bool? canUseApp;
  bool? canEdit;

  SwayamsevakBAL(this.swayamsevakID, this.praantID, this.fullName, this.mobileNumber, this.email, this.birthDate, this.linkedGeoUnitID, this.linkedGeoUnitName, this.linkedShaakhaaID,
      this.linkedShaakhaaName, this.preferredLanguageID, this.preferredLanguageCode, this.canUseApp, this.canEdit);
}

class SwayamsevakOtherInfoBAL {
  int? swayamsevakID;
  int? swayamsevakOtherInfoID;
  int? praantID;
  String? currentAddressLine1;
  String? currentAddressLine2;
  String? currentGraamCityName;
  String? currentPostOffice;
  String? currentPinCode;
  int? currentStateID;
  int? currentDistrictID;
  String? permanentAddressLine1;
  String? permanentAddressLine2;
  String? permanentGraamCityName;
  String? permanentPostOffice;
  String? permanentPinCode;
  int? permanentStateID;
  int? permanentDistrictID;
  bool? isPratidnyit;
  int? pratidnyaYear;
  bool? isGanaveshComplete;
  bool? hasCap;
  bool? hasShirt;
  bool? hasPant;
  bool? hasBelt;
  bool? hasShoes;
  bool? hasSocks;
  bool? hasDanda;
  bool? has2WVehicle;
  bool? has3WVehicle;
  bool? has4WVehicle;
  bool? hasVehicleDriver;
  int? bloodGroupID;
  String? bloodGroupCode;
  int? motherTongueID;
  String? motherTongueCode;
  String? birthDate;
  int? sanghaPraveshYear;
  String? facebookUsage;
  String? twitterUsage;
  String? instagramUsage;
  String? kooUsage;
  bool? hasShaakhaaExperience;
  bool? hasBaalShaakhaaExperience;
  bool? hasTarunVidyaarthiShaakhaaExperience;
  bool? hasTarunVyavasaayeeShaakhaaExperience;
  bool? hasProudhaVyavasaayeeShaakhaaExperience;
  int? shaakhaaExperienceYearID;
  bool? hasShaakhaaOpeningExperience;
  bool? hasBaalShaakhaaOpeningExperience;
  bool? hasTarunVidyaarthiShaakhaaOpeningExperience;
  bool? hasTarunVyavasaayeeShaakhaaOpeningExperience;
  bool? hasProudhaVyavasaayeeShaakhaaOpeningExperience;

  String? areasOfInterestIDs;
  String? areasOfExpertiseIDs;

  String? secondaryMobileNumber;
  String? officePhoneNumber;
  String? homePhoneNumber;
  String? whatsAppNumber;
  String? secondaryEmail;
  String? twitterHandle;
  String? instagramHandle;
  String? kooHandle;

  String? maxDaayitva;
  bool? hasBeenVistaarak;
  bool? hasBeenPrachaarak;
  int? vistaarakWeekCount;
  int? vistaarakMonthCount;
  int? vistaarakYearCount;
  int? prachaarakYearCount;
  String? facebookPage;

  SwayamsevakOtherInfoBAL(
      this.swayamsevakID,
      this.swayamsevakOtherInfoID,
      this.praantID,
      this.currentAddressLine1,
      this.currentAddressLine2,
      this.currentGraamCityName,
      this.currentPostOffice,
      this.currentDistrictID,
      this.currentPinCode,
      this.currentStateID,
      this.permanentAddressLine1,
      this.permanentAddressLine2,
      this.permanentGraamCityName,
      this.permanentPostOffice,
      this.permanentDistrictID,
      this.permanentPinCode,
      this.permanentStateID,
      this.isPratidnyit,
      this.pratidnyaYear,
      this.isGanaveshComplete,
      this.hasCap,
      this.hasShirt,
      this.hasPant,
      this.hasBelt,
      this.hasShoes,
      this.hasSocks,
      this.hasDanda,
      this.has2WVehicle,
      this.has3WVehicle,
      this.has4WVehicle,
      this.hasVehicleDriver,
      this.bloodGroupID,
      this.bloodGroupCode,
      this.motherTongueID,
      this.motherTongueCode,
      this.birthDate,
      this.sanghaPraveshYear,
      this.facebookUsage,
      this.twitterUsage,
      this.instagramUsage,
      this.kooUsage,
      this.hasShaakhaaExperience,
      this.hasBaalShaakhaaExperience,
      this.hasTarunVidyaarthiShaakhaaExperience,
      this.hasTarunVyavasaayeeShaakhaaExperience,
      this.hasProudhaVyavasaayeeShaakhaaExperience,
      this.shaakhaaExperienceYearID,
      this.hasShaakhaaOpeningExperience,
      this.hasBaalShaakhaaOpeningExperience,
      this.hasTarunVidyaarthiShaakhaaOpeningExperience,
      this.hasTarunVyavasaayeeShaakhaaOpeningExperience,
      this.hasProudhaVyavasaayeeShaakhaaOpeningExperience,
      this.areasOfInterestIDs,
      this.areasOfExpertiseIDs,
      this.secondaryMobileNumber,
      this.officePhoneNumber,
      this.homePhoneNumber,
      this.whatsAppNumber,
      this.secondaryEmail,
      this.twitterHandle,
      this.instagramHandle,
      this.kooHandle,
      this.maxDaayitva,
      this.hasBeenVistaarak,
      this.hasBeenPrachaarak,
      this.vistaarakWeekCount,
      this.vistaarakMonthCount,
      this.vistaarakYearCount,
      this.prachaarakYearCount,
      this.facebookPage);
}

class SwayamsevakSanghaShikshanBAL {
  int? swayamsevakID;
  int? swayamsevakSanghaShikshanID;
  int? praantID;
  int? prarambhikYear;
  int? praathamikYear;
  int? prathamVarshaYear;
  int? dwitiyaVarshaYear;
  int? trutiyaVarshaYear;
  int? yearsAsPraathamikShikshak;
  int? yearsAsPrathamVarshaShikshak;
  int? yearsAsDwityaVarshaShikshak;
  int? yearsAsTrutiyaVarshaShikshak;

  SwayamsevakSanghaShikshanBAL(this.swayamsevakID, this.swayamsevakSanghaShikshanID, this.praantID, this.prarambhikYear, this.praathamikYear, this.prathamVarshaYear, this.dwitiyaVarshaYear,
      this.trutiyaVarshaYear, this.yearsAsPraathamikShikshak, this.yearsAsPrathamVarshaShikshak, this.yearsAsDwityaVarshaShikshak, this.yearsAsTrutiyaVarshaShikshak);
}

class SwayamsevakOccupationBAL {
  int? swayamsevakID;
  int? swayamsevakOccupationID;
  int? praantID;
  int? occupationCategoryID;
  int? educationUniversityID;
  String? educationUniversityName;
  int? educationInstitutionID;
  String? educationInstitutionName;
  int? educationStandardID;
  String? educationStandardName;
  int? educationProgramID;
  String? educationProgramName;
  int? educationCourseID;
  String? educationCourseName;
  int? expectedCompletionYear;
  String? governmentDepartment;
  String? designation;
  String? officeLocation;
  String? weeklyOffDay;
  String? officeTimingFrom;
  String? officeTimingTo;
  String? industryVertical;
  String? organizationName;
  String? organizationAtRetirement;
  String? designationAtRetirement;
  String? departmentAtRetirement;
  String? education;
  int? weeklyOffCycle;
  bool? isShiftDuty;
  String? schoolJuniorCollegeName;
  String? juniorCollegeProgramName;

  SwayamsevakOccupationBAL(
      this.swayamsevakID,
      this.swayamsevakOccupationID,
      this.praantID,
      this.occupationCategoryID,
      this.educationUniversityID,
      this.educationUniversityName,
      this.educationInstitutionID,
      this.educationInstitutionName,
      this.educationStandardID,
      this.educationStandardName,
      this.educationProgramID,
      this.educationProgramName,
      this.educationCourseID,
      this.educationCourseName,
      this.expectedCompletionYear,
      this.governmentDepartment,
      this.designation,
      this.officeLocation,
      this.weeklyOffDay,
      this.officeTimingFrom,
      this.officeTimingTo,
      this.industryVertical,
      this.organizationName,
      this.organizationAtRetirement,
      this.designationAtRetirement,
      this.departmentAtRetirement,
      this.education,
      this.weeklyOffCycle,
      this.isShiftDuty,
      this.schoolJuniorCollegeName,
      this.juniorCollegeProgramName);
}

class SwayamsevakLinkedGeoUnitBAL {
  int? swayamsevakID;
  int? praantID;
  int? linkedVastiID;
  String? linkedVastiName;
  int? linkedGraamID;
  String? linkedGraamName;
  int? linkedShaakhaaID;
  String? linkedShaakhaaName;

  SwayamsevakLinkedGeoUnitBAL(this.swayamsevakID, this.praantID, this.linkedVastiID, this.linkedVastiName, this.linkedGraamID, this.linkedGraamName, this.linkedShaakhaaID, this.linkedShaakhaaName);
}

class SwayamsevakSharirikGhoshVishayBAL {
  List<GhoshVishayBAL>? ghoshVishay;
  List<ShaaririkVishayBAL>? sharirikVishay;

  SwayamsevakSharirikGhoshVishayBAL(this.ghoshVishay, this.sharirikVishay);
}

class SwayamsevakSanghaShikshanSharirikVishayBAL {
  SwayamsevakSanghaShikshanBAL sanghaShikshan;
  List<ShaaririkVishayBAL> sharirikVishay;

  SwayamsevakSanghaShikshanSharirikVishayBAL(this.sanghaShikshan, this.sharirikVishay);
}

class GhoshVishayBAL {
  int? swayamsevakGhoshVishayID;
  int? vaadyaID;
  int? praantID;
  String? vaadyaCode;
  int? vaadyaFamiliarity;
  int? rachanaaCount;
  int? swayamsevakID;
  bool? isUnderstandLipi;

  GhoshVishayBAL(this.swayamsevakGhoshVishayID, this.vaadyaID, this.praantID, this.vaadyaCode, this.vaadyaFamiliarity, this.rachanaaCount, this.swayamsevakID, this.isUnderstandLipi);
}

class ShaaririkVishayBAL {
  int? swayamsevakShaaririkVishayID;
  int? shaaririkVishayID;
  int? praantID;
  String? shaaririkVishayCode;
  int? vishayFamiliarity;
  int? swayamsevakID;

  ShaaririkVishayBAL(this.swayamsevakShaaririkVishayID, this.shaaririkVishayID, this.praantID, this.shaaririkVishayCode, this.vishayFamiliarity, this.swayamsevakID);
}

class SwayamsevakDaayitvaBAL {
  int? swayamsevakID;
  int? praantID;
  int? daayitvaFor;
  int? daayitvaID;
  String? daayitvaName;
  int? levelID;
  int? daayitvaGeoUnitID;
  int? gatividhiID;
  int? aayaamID;
  int? startYear;
  int? endYear;
  int? sanghaPreritSansthaaID;
  String? sanghaPreritSansthaaDesignation;
  String? sanghaPreritSansthaaRemark;

  String? otherSocialOrganizationName;
  String? otherSocialOrganizationDesignation;
  String? otherSocialOrganizationRemark;
  bool? isCurrent;
  String? areaOfOperationIDs;

  SwayamsevakDaayitvaBAL(
      this.swayamsevakID,
      this.praantID,
      this.daayitvaFor,
      this.daayitvaID,
      this.daayitvaName,
      this.levelID,
      this.daayitvaGeoUnitID,
      this.gatividhiID,
      this.aayaamID,
      this.startYear,
      this.endYear,
      this.sanghaPreritSansthaaID,
      this.sanghaPreritSansthaaDesignation,
      this.sanghaPreritSansthaaRemark,
      this.otherSocialOrganizationName,
      this.otherSocialOrganizationDesignation,
      this.otherSocialOrganizationRemark,
      this.isCurrent,
      this.areaOfOperationIDs);

  Map<String, dynamic> toJson() {
    return {
      'swayamsevakID': swayamsevakID,
      'praantID': praantID,
      'daayitvaFor': daayitvaFor,
      'daayitvaID': daayitvaID,
      'daayitvaName': daayitvaName,
      'levelID': levelID,
      'daayitvaGeoUnitID': daayitvaGeoUnitID,
      'gatividhiID': gatividhiID,
      'aayaamID': aayaamID,
      'startYear': startYear,
      'endYear': endYear,
      'sanghaPreritSansthaaID': sanghaPreritSansthaaID,
      'sanghaPreritSansthaaDesignation': sanghaPreritSansthaaDesignation,
      'sanghaPreritSansthaaRemark': sanghaPreritSansthaaRemark,
      'otherSocialOrganizationName': otherSocialOrganizationName,
      'otherSocialOrganizationDesignation': otherSocialOrganizationDesignation,
      'otherSocialOrganizationRemark': otherSocialOrganizationRemark,
      'isCurrent': isCurrent,
      'areaOfOperationIDs': areaOfOperationIDs,
    };
  }
}

class StaticMasterBAL {
  int? staticID;
  int? praantID;
  String? entityType;
  String? code;
  String? codeForDisplay;
  int? displaySequence;
  int? ViewOnly;
  String? showAnnualBaithakkey;
  String? monthYear;

  StaticMasterBAL(this.staticID, this.praantID, this.entityType, this.code, this.codeForDisplay, this.displaySequence, this.ViewOnly, this.showAnnualBaithakkey, this.monthYear);

  StaticMasterBAL.fromMap(Map<String, dynamic> map) {
    staticID = map["StaticID"];
    praantID = map["PraantID"];
    entityType = map["EntityType"];
    code = map["Code"];
    codeForDisplay = map["CodeForDisplay"];
    displaySequence = map["DisplaySequence"];
    ViewOnly = map["ViewOnly"];
    showAnnualBaithakkey = map["showAnnualBaithak"];
    monthYear = map["myear"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['StaticID'] = this.staticID;
    data['PraantID'] = this.praantID;
    data['EntityType'] = this.entityType;
    data['Code'] = this.code;
    data['CodeForDisplay'] = this.codeForDisplay;
    data['DisplaySequence'] = this.displaySequence;
    data['ViewOnly'] = this.ViewOnly;
    data['showAnnualBaithak'] = this.showAnnualBaithakkey;
    data['myear'] = this.monthYear;
    return data;
  }
}

class AayaamMasterBAL {
  int? aayaamID;
  int? praantID;
  String? aayaamName;

  AayaamMasterBAL(this.aayaamID, this.praantID, this.aayaamName);

  AayaamMasterBAL.fromMap(Map<String, dynamic> map) {
    aayaamID = map["AayaamID"];
    praantID = map["PraantID"];
    aayaamName = map["AayaamName"];
  }
}

class GatividhiMasterBAL {
  int? gatividhiID;
  int? praantID;
  String? gatividhiName;

  GatividhiMasterBAL(this.gatividhiID, this.praantID, this.gatividhiName);

  GatividhiMasterBAL.fromMap(Map<String, dynamic> map) {
    gatividhiID = map["GatividhiID"];
    praantID = map["PraantID"];
    gatividhiName = map["GatividhiName"];
  }
}

class StateMasterBAL {
  int? stateID;
  String? gSTStateCode;
  String? code;
  String? stateName;

  StateMasterBAL(this.stateID, this.gSTStateCode, this.code, this.stateName);

  StateMasterBAL.fromMap(Map<String, dynamic> map) {
    stateID = map["StateID"];
    gSTStateCode = map["GSTStateCode"];
    code = map["Code"];
    stateName = map["StateName"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['StateID'] = this.stateID;
    data['GSTStateCode'] = this.gSTStateCode;
    data['Code'] = this.code;
    data['StateName'] = this.stateName;
    return data;
  }
}

class GeoUnitMasterBAL {
  int? geoUnitID;
  int? praantID;
  int? levelID;

  int? isnew;

  String? name;
  String? fullName;
  String? levelName;
  String? geoUnitName;

  //String? levelNameForDisplay;
  int? displaySequence;
  bool? hasGraaminKshetra;
  int? parentKshetraID;
  int? parentPraantID;
  int? parentMahaanagarID;
  int? parentVibhaagID;
  int? parentBhaagID;
  int? parentNagarID;
  int? parentShaharID;
  int? parentMandalID;
  int? parentVastiID;
  int? parentGraamID;
  int? parentUpaNagarID;
  int? issankalpit;

  // bool? canEdit;

  GeoUnitMasterBAL(
    this.geoUnitID,
    this.praantID,
    this.levelID,
    this.isnew,
    this.name,
    this.fullName,
    this.levelName,
    this.geoUnitName,
    //this.levelNameForDisplay,
    this.displaySequence,
    this.hasGraaminKshetra,
    this.parentKshetraID,
    this.parentPraantID,
    this.parentMahaanagarID,
    this.parentVibhaagID,
    this.parentBhaagID,
    this.parentNagarID,
    this.parentShaharID,
    this.parentMandalID,
    this.parentVastiID,
    this.parentGraamID,
    this.parentUpaNagarID,
    this.issankalpit,
    // this.canEdit,
  );

  GeoUnitMasterBAL.fromJson(Map<String, dynamic> map) {
    geoUnitID = map["GeoUnitID"];
    praantID = map["PraantID"];
    levelID = map["LevelID"];
    isnew = map["isnew"];
    name = map["Name"];
    fullName = map["FullName"];
    levelName = map["LevelName"];
    geoUnitName = map["GeoUnitName"];
    //levelNameForDisplay = map["LevelNameForDisplay"];
    displaySequence = map["DisplaySequence"];
    hasGraaminKshetra = map["HasGraaminKshetra"];
    parentKshetraID = map["ParentKshetraID"];
    parentPraantID = map["ParentPraantID"];
    parentMahaanagarID = map["ParentMahaanagarID"];
    parentVibhaagID = map["ParentVibhaagID"];
    parentBhaagID = map["ParentBhaagID"];
    parentNagarID = map["ParentNagarID"];
    parentShaharID = map["ParentShaharID"];
    parentMandalID = map["ParentMandalID"];
    parentVastiID = map["ParentVastiID"];
    parentGraamID = map["ParentGraamID"];
    parentUpaNagarID = map["parentUpaNagarID"];
    issankalpit = map["issankalpit"];
    // canEdit = map["canEdit"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DisplaySequence'] = this.displaySequence;
    data['GeoUnitID'] = this.geoUnitID;
    data['isnew'] = this.isnew;
    data['GeoUnitName'] = this.geoUnitName;
    data['HasGraaminKshetra'] = this.hasGraaminKshetra;
    data['LevelID'] = this.levelID;
    data['LevelName'] = this.levelName;
    data['ParentBhaagID'] = this.parentBhaagID;
    data['ParentGraamID'] = this.parentGraamID;
    data['ParentKshetraID'] = this.parentKshetraID;
    data['ParentMahaanagarID'] = this.parentMahaanagarID;
    data['ParentMandalID'] = this.parentMandalID;
    data['ParentNagarID'] = this.parentNagarID;
    data['ParentPraantID'] = this.parentPraantID;
    data['ParentShaharID'] = this.parentShaharID;
    data['ParentVastiID'] = this.parentVastiID;
    data['ParentVibhaagID'] = this.parentVibhaagID;
    data['PraantID'] = this.praantID;
    data['parentUpaNagarID'] = this.parentUpaNagarID;
    // data['canEdit'] = this.canEdit;
    return data;
  }
}

class LevelMasterBAL {
  int? levelID;
  int? praantID;
  String? levelName;

  //String? levelNameForDisplay;
  int? hierarchy;

  LevelMasterBAL(this.levelID, this.praantID, this.levelName, this.hierarchy);

  LevelMasterBAL.fromMap(Map<String, dynamic> map) {
    levelID = map["LevelID"];
    praantID = map["PraantID"];
    levelName = map["LevelName"];
    //levelNameForDisplay = map["LevelNameForDisplay"];
    hierarchy = map["Hierarchy"];
  }

  Map<String, dynamic> toJson() {
    return {
      "LevelID": levelID,
      "PraantID": praantID,
      "LevelName": levelName,
      //"LevelNameForDisplay": levelNameForDisplay,
      "Hierarchy": hierarchy,
    };
  }
}

class DaayitvaMasterBAL {
  int? daayitvaID;
  int? praantID;
  int? daayitvaForID;
  String? daayitvaName;
  int? isPravaasiDaayitva;

  DaayitvaMasterBAL(this.daayitvaID, this.praantID, this.daayitvaForID, this.daayitvaName, this.isPravaasiDaayitva);

  DaayitvaMasterBAL.fromMap(Map<String, dynamic> map) {
    daayitvaID = map["DaayitvaID"];
    praantID = map["PraantID"];
    daayitvaForID = map["DaayitvaForID"];
    daayitvaName = map["DaayitvaName"];
    isPravaasiDaayitva = map["IsPravaasiDaayitva"];
  }
}

class UserDataBAL {
  int? swayamsevakID;
  int? swayamsevakDaayitvaID;
  int? preferredLanguageID;
  String? preferredLanguageCode;
  int? praantID;
  String? mobileNumber;
  String? linkedVastiName;
  int? linkedVastiID;
  String? linkedShaakhaaName;
  int? linkedShaakhaaID;
  String? linkedGraamName;
  int? linkedGraamID;
  String? levelName;

  //String? levelNameForDisplay;
  int? levelID;
  String? fullName;
  String? email;
  String? birthDate;
  int? daayitvaStartYear;
  String? daayitvaName;
  String? daayitvaNameforshow;
  int? daayitvaID;
  String? daayitvaGeoUnitName;
  int? daayitvaGeoUnitID;
  int? bhaagID;
  String? linkedGeoUnitHierarchy;
  bool? isFirstLogin;
  String? lastLoginTimeStamp;
  String? isLoggedIn;
  bool? isPravaasiKaaryakartaa;
  bool? canEdit;

  UserDataBAL(
      this.swayamsevakID,
      this.swayamsevakDaayitvaID,
      this.preferredLanguageID,
      this.preferredLanguageCode,
      this.praantID,
      this.mobileNumber,
      this.linkedVastiName,
      this.linkedVastiID,
      this.linkedShaakhaaName,
      this.linkedShaakhaaID,
      this.linkedGraamName,
      this.linkedGraamID,
      this.levelName,
      //this.levelNameForDisplay,
      this.levelID,
      this.fullName,
      this.email,
      this.daayitvaStartYear,
      this.daayitvaName,
      this.daayitvaNameforshow,
      this.daayitvaID,
      this.daayitvaGeoUnitName,
      this.daayitvaGeoUnitID,
      this.bhaagID,
      this.birthDate,
      this.linkedGeoUnitHierarchy,
      this.isFirstLogin,
      this.lastLoginTimeStamp,
      this.isLoggedIn,
      this.isPravaasiKaaryakartaa,
      this.canEdit);

  UserDataBAL.fromMap(Map<String, dynamic> map) {
    swayamsevakID = map["SwayamsevakID"];
    swayamsevakDaayitvaID = map["SwayamsevakDaayitvaID"];
    preferredLanguageID = map["PreferredLanguageID"];
    preferredLanguageCode = map["PreferredLanguageCode"];
    praantID = map["PraantID"];
    mobileNumber = map["MobileNumber"];
    linkedVastiName = map["LinkedVastiName"];
    linkedVastiID = map["LinkedVastiID"];
    linkedShaakhaaName = map["LinkedShaakhaaName"];
    linkedShaakhaaID = map["LinkedShaakhaaID"];
    linkedGraamName = map["LinkedGraamName"];
    linkedGraamID = map["LinkedGraamID"];
    levelName = map["LevelName"];
    //levelNameForDisplay = map["LevelNameForDisplay"];
    levelID = map["LevelID"];
    fullName = map["FullName"];
    email = map["Email"];
    daayitvaStartYear = map["DaayitvaStartYear"];
    daayitvaName = map["DaayitvaName"];
    daayitvaNameforshow = map["DaayitvaNameforshow"];
    daayitvaID = map["DaayitvaID"];
    daayitvaGeoUnitName = map["DaayitvaGeoUnitName"];
    daayitvaGeoUnitID = map["DaayitvaGeoUnitID"];
    bhaagID = map["BhaagID"];
    birthDate = map["BirthDate"];
    linkedGeoUnitHierarchy = map['LinkedGeoUnitHierarchy'];
    isFirstLogin = map['IsFirstLogin'] == 1 ? true : false;
    lastLoginTimeStamp = map['LastLoginTimeStamp'];
    isLoggedIn = map['IsLoggedIn'];
    isPravaasiKaaryakartaa = map['IsPravaasiKaaryakartaa'] == 1 ? true : false;
    canEdit = map['can_edit'] == 1 ? true : false;
  }
}

class AbhiyaanUserDataBAL {
  int? abhiyaDaayitvaID;
  int? abhiyanSwayamsevakID;
  String? daayityaName;
  String? email;
  String? birthDate;
  String? fullName;
  int? geoUnitID;
  String? geoUnitName;
  String? levelName;
  String? mobileNumber;
  int? parentBhaagID;
  int? parentMahaanagarID;
  int? parentMandalID;
  int? parentNagarID;
  int? parentVibhaagID;
  String? preferredLanguageCode;
  int? preferredLanguageID;

  AbhiyaanUserDataBAL(
      {this.abhiyaDaayitvaID,
      this.abhiyanSwayamsevakID,
      this.daayityaName,
      this.email,
      this.birthDate,
      this.fullName,
      this.geoUnitID,
      this.geoUnitName,
      this.levelName,
      this.mobileNumber,
      this.parentBhaagID,
      this.parentMahaanagarID,
      this.parentMandalID,
      this.parentNagarID,
      this.parentVibhaagID,
      this.preferredLanguageCode,
      this.preferredLanguageID});

  AbhiyaanUserDataBAL.fromJson(Map<String, dynamic> json) {
    abhiyaDaayitvaID = json['AbhiyaDaayitvaID'];
    abhiyanSwayamsevakID = json['AbhiyanSwayamsevakID'];
    daayityaName = json['DaayityaName'];
    email = json['Email'];
    birthDate = json['BirthDate'];
    fullName = json['FullName'];
    geoUnitID = json['GeoUnitID'];
    geoUnitName = json['GeoUnitName'];
    levelName = json['LevelName'];
    mobileNumber = json['MobileNumber'];
    parentBhaagID = json['ParentBhaagID'];
    parentMahaanagarID = json['ParentMahaanagarID'];
    parentMandalID = json['ParentMandalID'];
    parentNagarID = json['ParentNagarID'];
    parentVibhaagID = json['ParentVibhaagID'];
    preferredLanguageCode = json['PreferredLanguageCode'];
    preferredLanguageID = json['PreferredLanguageID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AbhiyaDaayitvaID'] = this.abhiyaDaayitvaID;
    data['AbhiyanSwayamsevakID'] = this.abhiyanSwayamsevakID;
    data['DaayityaName'] = this.daayityaName;
    data['Email'] = this.email;
    data['BirthDate'] = this.birthDate;
    data['FullName'] = this.fullName;
    data['GeoUnitID'] = this.geoUnitID;
    data['GeoUnitName'] = this.geoUnitName;
    data['LevelName'] = this.levelName;
    data['MobileNumber'] = this.mobileNumber;
    data['ParentBhaagID'] = this.parentBhaagID;
    data['ParentMahaanagarID'] = this.parentMahaanagarID;
    data['ParentMandalID'] = this.parentMandalID;
    data['ParentNagarID'] = this.parentNagarID;
    data['ParentVibhaagID'] = this.parentVibhaagID;
    data['PreferredLanguageCode'] = this.preferredLanguageCode;
    data['PreferredLanguageID'] = this.preferredLanguageID;
    return data;
  }
}

class ShaakhaaMasterBAL {
  int? shaakhaaID;
  int? praantID;
  int? geoUnitID;
  String? geoUnitName;
  int? frequencyID;
  String? dayOfWeek;
  String? dayOfMonth;
  int? vayogatID;
  String? location;
  String? timing;
  String? remark;
  int? statusID;
  int? bhaagID;
  int? nagarID;
  int? shaharID;
  int? mandalID;
  int? graamID;
  int? vastiID;
  bool? isSankalpit;
  String? sankalpAadhaar; //20
  String? sankalpAadhaar1;
  String? sankalpAadhaar2;
  String? sankalpAadhaar3;
  int? sankalpAadhaarSwayamsevakID;
  int? sankalpAadhaarSwayamsevakID1;
  int? sankalpAadhaarSwayamsevakID2;
  int? sankalpAadhaarSwayamsevakID3;
  String? sankalpAadhaarSwayamsevakName;
  String? sankalpAadhaarSwayamsevakName1;
  String? sankalpAadhaarSwayamsevakName2;
  String? sankalpAadhaarSwayamsevakName3;
  int? sankalpAadhaarShaakhaaID;
  int? sankalpAadhaarShaakhaaID1;
  int? sankalpAadhaarShaakhaaID2;
  int? sankalpAadhaarShaakhaaID3;
  String? sankalpAadhaarShaakhaaName;
  String? sankalpAadhaarShaakhaaName1;
  String? sankalpAadhaarShaakhaaName2;
  String? sankalpAadhaarShaakhaaName3;
  int? sankalpCompletionMonth;
  int? sankalpCompletionMonth1;
  int? sankalpCompletionMonth2;
  int? sankalpCompletionMonth3;
  int? sankalpCompletionYear;
  int? sankalpCompletionYear1;
  int? sankalpCompletionYear2;
  int? sankalpCompletionYear3;
  bool? hasToli;
  bool? hasPaalak;
  int? shaaririkVishayID;
  String? otherShaaririkVishay;
  String? fromTime;
  String? toTime;

  ShaakhaaMasterBAL(
      this.shaakhaaID,
      this.praantID,
      this.geoUnitID,
      this.geoUnitName,
      this.frequencyID,
      this.dayOfWeek,
      this.dayOfMonth,
      this.vayogatID,
      this.location,
      this.timing,
      this.remark,
      this.statusID,
      this.bhaagID,
      this.nagarID,
      this.shaharID,
      this.mandalID,
      this.graamID,
      this.vastiID,
      this.isSankalpit,
      this.sankalpAadhaar,
      this.sankalpAadhaar1,
      this.sankalpAadhaar2,
      this.sankalpAadhaar3,
      this.sankalpAadhaarSwayamsevakID,
      this.sankalpAadhaarSwayamsevakID1,
      this.sankalpAadhaarSwayamsevakID2,
      this.sankalpAadhaarSwayamsevakID3,
      this.sankalpAadhaarSwayamsevakName,
      this.sankalpAadhaarSwayamsevakName1,
      this.sankalpAadhaarSwayamsevakName2,
      this.sankalpAadhaarSwayamsevakName3,
      this.sankalpAadhaarShaakhaaID,
      this.sankalpAadhaarShaakhaaID1,
      this.sankalpAadhaarShaakhaaID2,
      this.sankalpAadhaarShaakhaaID3,
      this.sankalpAadhaarShaakhaaName,
      this.sankalpAadhaarShaakhaaName1,
      this.sankalpAadhaarShaakhaaName2,
      this.sankalpAadhaarShaakhaaName3,
      this.sankalpCompletionMonth,
      this.sankalpCompletionMonth1,
      this.sankalpCompletionMonth2,
      this.sankalpCompletionMonth3,
      this.sankalpCompletionYear,
      this.sankalpCompletionYear1,
      this.sankalpCompletionYear2,
      this.sankalpCompletionYear3,
      this.hasToli,
      this.hasPaalak,
      this.shaaririkVishayID,
      this.otherShaaririkVishay,
      this.fromTime,
      this.toTime);
}

class SwayamsevakTransferBAL {
  int? swayamsevakTransferID;
  int? swayamsevakID;
  String? swayamsevakName;
  String? mobileNumber;
  int? sourceBhaagID;
  String? sourceBhaagName;
  int? sourceLinkedGeoUnitID;
  int? destinationBhaagID;
  String? destinationBhaagName;
  int? destinationLinkedGeoUnitID;
  int? shaharID;
  int? nagarID;
  int? mandalID;
  int? graamID;
  int? vastiID;
  int? statusID;
  String? statusCode;
  String? initiatedDate;
  String? completeDate;
  String? remark;

  SwayamsevakTransferBAL(
      this.swayamsevakTransferID,
      this.swayamsevakID,
      this.swayamsevakName,
      this.mobileNumber,
      this.sourceBhaagID,
      this.sourceBhaagName,
      this.sourceLinkedGeoUnitID,
      this.destinationBhaagID,
      this.destinationBhaagName,
      this.destinationLinkedGeoUnitID,
      this.shaharID,
      this.nagarID,
      this.mandalID,
      this.graamID,
      this.vastiID,
      this.statusID,
      this.statusCode,
      this.initiatedDate,
      this.completeDate,
      this.remark);

  SwayamsevakTransferBAL.fromMap(Map<String, dynamic> map) {
    swayamsevakTransferID = map["SwayamsevakTransferID"];
    swayamsevakID = map["SwayamsevakID"];
    swayamsevakName = map["FullName"];
    mobileNumber = map["MobileNumber"];
    sourceBhaagID = map["SourceBhaagID"];
    sourceBhaagName = map["SourceBhaagName"];
    sourceLinkedGeoUnitID = map["SourceLinkedGeoUnitID"];
    destinationBhaagID = map["DestinationBhaagID"];
    destinationBhaagName = map["DestinationBhaagName"];
    destinationLinkedGeoUnitID = map["DestinationLinkedGeoUnitID"];
    graamID = map["GraamID"];
    vastiID = map["VastiID"];
    shaharID = map["ShaharID"];
    mandalID = map["MandalID"];
    nagarID = map["NagarID"];
    statusID = map["StatusID"];
    statusCode = map["StatusCode"];
    initiatedDate = map["TransferInitiatedDateStr"];
    completeDate = map["TransferCompleteDateStr"];
    remark = map["Remark"];
  }
}

class SoochiMasterBAL {
  int? soochiID;
  int? praantID;
  String? soochiName;
  int? ownerSwayamsevakID;
  String? ownerSwayamsevakFullName;
  int? statusID;
  String? statusCode;
  String? remark;

  SoochiMasterBAL(this.soochiID, this.praantID, this.soochiName, this.ownerSwayamsevakID, this.ownerSwayamsevakFullName, this.statusID, this.statusCode, this.remark);
}

class AbhiyaanVruttaBAL {
  int? abhiyaanVruttaID;
  int? praantID;
  int? levelID;
  int? abhiyaanID;
  String? vruttaDate;
  int? geoUnitID;
  String? geoUnitname;
  int? menCount;
  int? womenCount;
  int? houseCount;
  int? c1;
  int? c2;
  int? c3;
  int? cashOnCoupon;
  int? cashOnRcpt;
  int? cashRcptCount;
  int? chqRcptCount;
  int? chqCount;
  int? chqAmount;
  var children;
  bool? isInSync;
  int? totalAmt;
  String? levelName;
  int? kaaryakartaaCount;

  AbhiyaanVruttaBAL(this.abhiyaanVruttaID, this.praantID, this.levelID, this.abhiyaanID, this.vruttaDate, this.geoUnitID, this.geoUnitname, this.menCount, this.womenCount, this.houseCount, this.c1,
      this.c2, this.c3, this.cashOnCoupon, this.cashOnRcpt, this.cashRcptCount, this.chqRcptCount, this.chqCount, this.chqAmount, this.isInSync, this.totalAmt, this.levelName);

  /*AbhiyaanVruttaBAL.fromMapRecursive(Map<String, dynamic> map) {
    geoUnitID = map["GeoUnitID"];
    levelID = map["LevelID"];
    geoUnitname = map["GeoUnitName"];
    houseCount = map["HouseCount"];
    c1 = map["C1"];
    c2 = map["C2"];
    c3 = map["C3"];
    cashOnCoupon = map["CashOnCoupon"];
    cashOnRcpt = map["CashOnRcpt"];
    cashRcptCount = map["CashRcptCount"];
    chqRcptCount = map["ChqRcptCount"];
    chqCount = map["ChqCount"];
    chqAmount = map["ChqAmount"];
    vruttaDate = map["VruttaDate"];
    totalAmt = map["TotalAmt"];
    levelName = map["LevelName"].toString();
    menCount = map["MenCount"];
    womenCount = map["WomenCount"];
    kaaryakartaaCount = map["KaaryakartaaCount"];
    levelName = map["LevelName"].toString();
    children = Statics.getRecursiveAbhiyaan(
        map["GeoUnitID"].toString(), map["LevelName"].toString());
  }*/

  AbhiyaanVruttaBAL.fromMap(Map<String, dynamic> map) {
    abhiyaanVruttaID = map["AbhiyaanVruttaID"];
    praantID = map["PraantID"];
    abhiyaanID = map["AbhiyaanID"];
    vruttaDate = map["VruttaDate"];
    geoUnitID = map["GeoUnitID"];
    menCount = map["MenCount"];
    womenCount = map["WomenCount"];
    houseCount = map["HouseCount"];
    c1 = map["C1"];
    c2 = map["C2"];
    c3 = map["C3"];
    cashOnCoupon = map["CashOnCoupon"];
    cashOnRcpt = map["CashOnRcpt"];
    cashRcptCount = map["CashRcptCount"];
    chqRcptCount = map["ChqRcptCount"];
    chqCount = map["ChqCount"];
    chqAmount = map["ChqAmount"];
    isInSync = map["IsInSync"] == 1 ? true : false;
  }

  AbhiyaanVruttaBAL.fromMapCloud(Map<String, dynamic> map) {
    abhiyaanVruttaID = map["AbhiyaanVruttaID"];
    praantID = map["PraantID"];
    abhiyaanID = map["AbhiyaanID"];
    vruttaDate = map["VruttaDateStr"];
    geoUnitID = map["GeoUnitID"];
    menCount = map["MenCount"];
    womenCount = map["WomenCount"];
    houseCount = map["HouseCount"];
    c1 = map["C1"];
    c2 = map["C2"];
    c3 = map["C3"];
    cashOnCoupon = map["CashOnCoupon"];
    cashOnRcpt = map["CashOnRcpt"];
    cashRcptCount = map["CashRcptCount"];
    chqRcptCount = map["ChqRcptCount"];
    chqCount = map["ChqCount"];
    chqAmount = map["ChqAmount"];
    isInSync = map["IsInSync"] == 1 ? true : false;
  }

  AbhiyaanVruttaBAL.fromMapView(Map<String, dynamic> map) {
    geoUnitID = map["GeoUnitID"];
    levelID = map["LevelID"];
    geoUnitname = map["GeoUnitName"];
    houseCount = map["HouseCount"];
    c1 = map["C1"];
    c2 = map["C2"];
    c3 = map["C3"];
    cashOnCoupon = map["CashOnCoupon"];
    cashOnRcpt = map["CashOnRcpt"];
    cashRcptCount = map["CashRcptCount"];
    chqRcptCount = map["ChqRcptCount"];
    chqCount = map["ChqCount"];
    chqAmount = map["ChqAmount"];
    vruttaDate = map["VruttaDate"];
    totalAmt = map["TotalAmt"];
    menCount = map["MenCount"];
    womenCount = map["WomenCount"];
    kaaryakartaaCount = map["KaaryakartaaCount"];
    levelName = map["LevelName"].toString();
  }
}

class VisheshVyaktiBAL {
  int? visheshVyaktiID;
  int? praantID;
  String? visheshVyaktiName;
  int? visheshVyaktiCategoryID;
  String? visheshVyaktiCategoryCode;
  String? mobileNumber;
  String? otherCategoryCode;
  String? remark;
  String? geoUnitName;
  int? geoUnitID;
  int? createdBy;
  String? createdByName;
  String? createdByMobileNumber;

  VisheshVyaktiBAL(this.visheshVyaktiID, this.praantID, this.visheshVyaktiName, this.visheshVyaktiCategoryID, this.visheshVyaktiCategoryCode, this.mobileNumber, this.otherCategoryCode, this.remark,
      this.geoUnitName, this.geoUnitID, this.createdBy, this.createdByName, this.createdByMobileNumber);

  VisheshVyaktiBAL.fromMap(Map<String, dynamic> map) {
    visheshVyaktiID = map["VisheshVyaktiID"];
    praantID = map["PraantID"];
    visheshVyaktiName = map["VisheshVyaktiName"];
    visheshVyaktiCategoryID = map["VisheshVyaktiCategoryID"];
    geoUnitID = map["GeoUnitID"];
    mobileNumber = map["MobileNumber"];
    otherCategoryCode = map["OtherCategoryCode"];
    remark = map["Remark"];
    createdBy = map["AppUserID"];
  }
}

class AbhiyaanParticipantBAL {
  int? abhiyaanParticipantID;
  int? praantID;
  int? geoUnitID;
  int? abhiyaanID;
  String? participantName;
  String? mobileNumber;
  int? genderID;
  String? genderCode;
  String? geoUnitName;

  AbhiyaanParticipantBAL(this.abhiyaanParticipantID, this.praantID, this.geoUnitID, this.abhiyaanID, this.participantName, this.mobileNumber, this.genderID, this.genderCode);

  AbhiyaanParticipantBAL.fromMap(Map<String, dynamic> map) {
    abhiyaanParticipantID = map["AbhiyaanParticipantID"];
    praantID = map["PraantID"];
    geoUnitID = map["GeoUnitID"];
    abhiyaanID = map["AbhiyaanID"];
    participantName = map["ParticipantName"];
    mobileNumber = map["MobileNumber"];
    genderID = map["GenderID"];
    genderCode = map["GenderCode"];
    geoUnitName = map["GeoUnitName"];
  }
}

class JoinRSSBAL {
  int? joinRSSID;
  int? praantID;
  int? bhaagID;
  int? shaharID;
  int? nagarID;
  int? statusID;
  String? name;
  String? mobileNumber;
  String? email;
  String? address;
  int? genderID;
  String? genderCode;
  String? districtName;
  String? cityName;
  String? stateName;
  String? country;
  String? age;
  String? occupation;
  String? remark;
  String? statusRemark;
  String? jRSRemark;
  String? joiningDate;
  String? statusDate;

  JoinRSSBAL(this.joinRSSID, this.praantID, this.bhaagID, this.shaharID, this.nagarID, this.statusID, this.name, this.mobileNumber, this.email, this.address, this.genderID, this.genderCode,
      this.districtName, this.cityName, this.stateName, this.country, this.age, this.occupation, this.remark, this.statusRemark, this.jRSRemark, this.joiningDate, this.statusDate);

  JoinRSSBAL.fromMap(Map<String, dynamic> map) {
    joinRSSID = map["JoinRSSID"];
    praantID = map["PraantID"];
    bhaagID = map["BhaagID"];
    shaharID = map["ShaharID"];
    nagarID = map["NagarID"];
    statusID = map["StatusID"];
    name = map["Name"];
    mobileNumber = map["MobileNumber"];
    email = map["Email"];
    address = map["Address"];
    genderID = map["GenderID"];
    genderCode = map["GenderCode"];
    districtName = map["DistrictName"];
    cityName = map["CityName"];
    stateName = map["StateName"];
    country = map["Country"];
    age = map["Age"];
    occupation = map["Occupation"];
    remark = map["Remark"];
    statusRemark = map["StatusRemark"];
    jRSRemark = map["JRSRemark"];
    joiningDate = map["JoiningDateStr"];
    statusDate = map["StatusDateStr"];
  }
}

class EventMasterBAL {
  int? eventID;
  int? praantID;
  int? eventTypeID;
  String? eventName;
  String? description;
  String? fromDate;
  String? toDate;
  String? fromTime;
  String? toTime;
  int? geoUnitID;
  int? ownerSwayamsevakID;
  String? ownerSwayamsevakName;
  String? ownerSwayamsevakMobileNumber;
  String? preparationDetail;
  String? venue;

  EventMasterBAL(
    this.eventID,
    this.praantID,
    this.eventTypeID,
    this.eventName,
    this.description,
    this.fromDate,
    this.toDate,
    this.fromTime,
    this.toTime,
    this.geoUnitID,
    this.ownerSwayamsevakID,
    this.ownerSwayamsevakName,
    this.ownerSwayamsevakMobileNumber,
    this.preparationDetail,
    this.venue,
  );

  EventMasterBAL.fromMap(Map<String, dynamic> map) {
    eventID = map["EventID"];
    praantID = map["PraantID"];
    eventTypeID = map["EventTypeID"];
    eventName = map["EventName"];
    description = map["Description"];
    fromDate = map["FromDateStr"];
    toDate = map["ToDateStr"];
    fromTime = map["FromTimeStr"];
    toTime = map["ToTimeStr"];
    geoUnitID = map["GeoUnitID"];
    ownerSwayamsevakID = map["OwnerSwayamsevakID"];
    ownerSwayamsevakName = map["OwnerSwayamsevakName"];
    ownerSwayamsevakMobileNumber = map["OwnerSwayamsevakMobileNumber"];
    preparationDetail = map["PreparationDetail"];
    venue = map["Venue"];
  }
}

class AbhiyaanAttendanceBAL {
  int? abhiyaanAttendanceID;
  int? praantID;
  int? geoUnitID;
  int? abhiyaanID;
  int? abhiyaanParticipantID;
  String? participantName;
  String? workDate;
  bool? isPresent;

  AbhiyaanAttendanceBAL(this.abhiyaanAttendanceID, this.praantID, this.geoUnitID, this.abhiyaanID, this.abhiyaanParticipantID, this.workDate, this.isPresent);

  AbhiyaanAttendanceBAL.fromMap(Map<String, dynamic> map) {
    abhiyaanAttendanceID = map["AbhiyaanAttendanceID"];
    praantID = map["PraantID"];
    geoUnitID = map["GeoUnitID"];
    abhiyaanID = map["AbhiyaanID"];
    abhiyaanParticipantID = map["AbhiyaanParticipantID"];
    participantName = map["ParticipantName"];
    workDate = map["WorkDate"];
    isPresent = map["IsPresent"] == true ? true : false;
  }
}

class TempDates {
  String? abhiyaanDate;

  TempDates(this.abhiyaanDate);

  TempDates.fromMap(Map<String, dynamic> map) {
    abhiyaanDate = map["AbhiyaanDate"].toString();
  }
}

class ChartData {
  String? abhiyaanDate;
  DateTime? dblabhiyaanDate;
  int? samparkitHomes;
  int? sankalan;
  int? karyakarta;
  String? geoUnitName;
  int? geoUnitID;

  ChartData(this.abhiyaanDate, this.dblabhiyaanDate, this.samparkitHomes, this.sankalan, this.karyakarta, this.geoUnitName, this.geoUnitID);

  ChartData.fromMap(Map<String, dynamic> map) {
    abhiyaanDate = DateFormat("dd-MMM").format(DateTime.parse(map["VruttaDateStr"].toString()));
    dblabhiyaanDate = DateTime.parse(map["VruttaDateStr"].toString());
    samparkitHomes = map["HouseCount"] == null ? 0 : map["HouseCount"];
    sankalan = map["TotalAmount"] == null ? 0 : map["TotalAmount"];
    karyakarta = map["ParticipantCount"] == null ? 0 : map["ParticipantCount"];
    geoUnitName = map["GeoUnitName"].toString();
    geoUnitID = map["GeoUnitID"];
  }
}

class DashboardDataBAL {
  String? shishuCount;
  String? baalCount;
  String? tarunVidyaarthiCount;
  String? tarunVyavasaayeeCount;
  String? proudhaVyavasaayeeCount;
  String? unknownAgeCount;
  String? trutiyaVarshaShikshitCount;
  String? dwitiyaVarshaShikshitCount;
  String? prathamVarshaShikshitCount;
  String? praathamikShikshitCount;
  String? noShikshanCount;
  String? shaakhaaKaaryakartaaCount;
  String? vastiKaaryakartaaCount;
  String? graamKaaryakartaaCount;
  String? mandalKaaryakartaaCount;
  String? nagarKaaryakartaaCount;
  String? shaharKaaryakartaaCount;
  String? bhaagKaaryakartaaCount;
  String? vibhaagKaaryakartaaCount;
  String? mahaanagarKaaryakartaaCount;
  String? praantKaaryakartaaCount;
  String? notificationCount;
  String? kshetraKaaryakartaaCount;
  String? pravaseeKaaryakartaaCount;
  String? gatividhiKaaryakartaaCount;
  String? aayaamKaaryakartaaCount;
  String? sanghaPreritSansthaaKaaryakartaaCount;
  String? totalKaaryakartaaCount;
  String? socialOrganizationKaaryakartaaCount;
  String? pratidnyitCount;
  String? dailyShaakhaaKaaryakartaaCount;
  String? saaptaahikMilanKaaryakartaaCount;
  String? maasikMilanKaaryakartaaCount;
  String? akhilBhaaratiyaKaaryakartaaCount;
  String? totalSwayamsevakCount;

  DashboardDataBAL(
      this.shishuCount,
      this.baalCount,
      this.tarunVidyaarthiCount,
      this.tarunVyavasaayeeCount,
      this.proudhaVyavasaayeeCount,
      this.unknownAgeCount,
      this.trutiyaVarshaShikshitCount,
      this.dwitiyaVarshaShikshitCount,
      this.prathamVarshaShikshitCount,
      this.praathamikShikshitCount,
      this.noShikshanCount,
      this.shaakhaaKaaryakartaaCount,
      this.vastiKaaryakartaaCount,
      this.graamKaaryakartaaCount,
      this.mandalKaaryakartaaCount,
      this.nagarKaaryakartaaCount,
      this.shaharKaaryakartaaCount,
      this.bhaagKaaryakartaaCount,
      this.vibhaagKaaryakartaaCount,
      this.mahaanagarKaaryakartaaCount,
      this.praantKaaryakartaaCount,
      this.notificationCount,
      this.kshetraKaaryakartaaCount,
      this.pravaseeKaaryakartaaCount,
      this.gatividhiKaaryakartaaCount,
      this.aayaamKaaryakartaaCount,
      this.sanghaPreritSansthaaKaaryakartaaCount,
      this.totalKaaryakartaaCount,
      this.socialOrganizationKaaryakartaaCount,
      this.pratidnyitCount,
      this.dailyShaakhaaKaaryakartaaCount,
      this.saaptaahikMilanKaaryakartaaCount,
      this.maasikMilanKaaryakartaaCount,
      this.akhilBhaaratiyaKaaryakartaaCount,
      this.totalSwayamsevakCount);

  DashboardDataBAL.fromMap(Map<String, dynamic> map) {
    shishuCount = map["ShishuCount"] == null ? "0" : map["ShishuCount"].toString();
    baalCount = map["BaalCount"] == null ? "0" : map["BaalCount"].toString();
    tarunVidyaarthiCount = map["TarunVidyaarthiCount"] == null ? "0" : map["TarunVidyaarthiCount"].toString();
    tarunVyavasaayeeCount = map["TarunVyavasaayeeCount"] == null ? "0" : map["TarunVyavasaayeeCount"].toString();
    proudhaVyavasaayeeCount = map["ProudhaVyavasaayeeCount"] == null ? "0" : map["ProudhaVyavasaayeeCount"].toString();
    unknownAgeCount = map["UnknownAgeCount"] == null ? "0" : map["UnknownAgeCount"].toString();
    trutiyaVarshaShikshitCount = map["TrutiyaVarshaShikshitCount"] == null ? "0" : map["TrutiyaVarshaShikshitCount"].toString();
    dwitiyaVarshaShikshitCount = map["DwitiyaVarshaShikshitCount"] == null ? "0" : map["DwitiyaVarshaShikshitCount"].toString();
    prathamVarshaShikshitCount = map["PrathamVarshaShikshitCount"] == null ? "0" : map["PrathamVarshaShikshitCount"].toString();
    praathamikShikshitCount = map["PraathamikShikshitCount"] == null ? "0" : map["PraathamikShikshitCount"].toString();
    noShikshanCount = map["NoShikshanCount"] == null ? "0" : map["NoShikshanCount"].toString();
    shaakhaaKaaryakartaaCount = map["ShaakhaaKaaryakartaaCount"] == null ? "0" : map["ShaakhaaKaaryakartaaCount"].toString();
    vastiKaaryakartaaCount = map["VastiKaaryakartaaCount"] == null ? "0" : map["VastiKaaryakartaaCount"].toString();
    graamKaaryakartaaCount = map["GraamKaaryakartaaCount"] == null ? "0" : map["GraamKaaryakartaaCount"].toString();
    mandalKaaryakartaaCount = map["MandalKaaryakartaaCount"] == null ? "0" : map["MandalKaaryakartaaCount"].toString();
    nagarKaaryakartaaCount = map["NagarKaaryakartaaCount"] == null ? "0" : map["NagarKaaryakartaaCount"].toString();
    shaharKaaryakartaaCount = map["ShaharKaaryakartaaCount"] == null ? "0" : map["ShaharKaaryakartaaCount"].toString();
    bhaagKaaryakartaaCount = map["BhaagKaaryakartaaCount"] == null ? "0" : map["BhaagKaaryakartaaCount"].toString();
    vibhaagKaaryakartaaCount = map["VibhaagKaaryakartaaCount"] == null ? "0" : map["VibhaagKaaryakartaaCount"].toString();
    mahaanagarKaaryakartaaCount = map["MahaanagarKaaryakartaaCount"] == null ? "0" : map["MahaanagarKaaryakartaaCount"].toString();
    praantKaaryakartaaCount = map["PraantKaaryakartaaCount"] == null ? "0" : map["PraantKaaryakartaaCount"].toString();
    notificationCount = map["Notificationcount"] == null ? "0" : map["Notificationcount"].toString();
    kshetraKaaryakartaaCount = map["KshetraKaaryakartaaCount"] == null ? "0" : map["KshetraKaaryakartaaCount"].toString();
    pravaseeKaaryakartaaCount = map["PravaseeKaaryakartaaCount"] == null ? "0" : map["PravaseeKaaryakartaaCount"].toString();
    gatividhiKaaryakartaaCount = map["GatividhiKaaryakartaaCount"] == null ? "0" : map["GatividhiKaaryakartaaCount"].toString();
    aayaamKaaryakartaaCount = map["AayaamKaaryakartaaCount"] == null ? "0" : map["AayaamKaaryakartaaCount"].toString();
    sanghaPreritSansthaaKaaryakartaaCount = map["SanghaPreritSansthaaKaaryakartaaCount"] == null ? "0" : map["SanghaPreritSansthaaKaaryakartaaCount"].toString();
    totalKaaryakartaaCount = map["TotalKaaryakartaaCount"] == null ? "0" : map["TotalKaaryakartaaCount"].toString();
    socialOrganizationKaaryakartaaCount = map["SocialOrganizationKaaryakartaaCount"] == null ? "0" : map["SocialOrganizationKaaryakartaaCount"].toString();
    pratidnyitCount = map["PratidnyitCount"] == null ? "0" : map["PratidnyitCount"].toString();

    dailyShaakhaaKaaryakartaaCount = map["DailyShaakhaaKaaryakartaaCount"] == null ? "0" : map["DailyShaakhaaKaaryakartaaCount"].toString();
    saaptaahikMilanKaaryakartaaCount = map["SaaptaahikMilanKaaryakartaaCount"] == null ? "0" : map["SaaptaahikMilanKaaryakartaaCount"].toString();
    maasikMilanKaaryakartaaCount = map["MaasikMilanKaaryakartaaCount"] == null ? "0" : map["MaasikMilanKaaryakartaaCount"].toString();
    akhilBhaaratiyaKaaryakartaaCount = map["AkhilBhaaratiyaKaaryakartaaCount"] == null ? "0" : map["AkhilBhaaratiyaKaaryakartaaCount"].toString();
  }
}

class AnnualBaithakNagarVruttaBAL {
  int? annualBaithakNagarVruttaID;
  int? geoUnitID;
  String? geoUnitName;
  int? annualBaithakTypeID;
  String? annualBaithakTypeCode;
  int? sewaVastiCount;
  int? shaakhaaYuktaSewaVastiCount;
  int? sewaKaaryaYuktaSewaVastiCount;
  bool? isNiyojanDone;
  bool? isSankalpaPoorna;

  AnnualBaithakNagarVruttaBAL(
    this.annualBaithakNagarVruttaID,
    this.geoUnitID,
    this.geoUnitName,
    this.annualBaithakTypeID,
    this.annualBaithakTypeCode,
    this.sewaVastiCount,
    this.shaakhaaYuktaSewaVastiCount,
    this.sewaKaaryaYuktaSewaVastiCount,
    this.isNiyojanDone,
    this.isSankalpaPoorna,
  );

  AnnualBaithakNagarVruttaBAL.fromMap(Map<String, dynamic> map) {
    annualBaithakNagarVruttaID = map['AnnualBaithakNagarVruttaID'];
    geoUnitID = map['GeoUnitID'];
    geoUnitName = map['GeoUnitName'];
    annualBaithakTypeID = map['AnnualBaithakTypeID'];
    annualBaithakTypeCode = map['AnnualBaithakTypeCode'];
    sewaVastiCount = map['SewaVastiCount'];
    shaakhaaYuktaSewaVastiCount = map['ShaakhaaYuktaSewaVastiCount'];
    sewaKaaryaYuktaSewaVastiCount = map['SewaKaaryaYuktaSewaVastiCount'];
    isNiyojanDone = map['IsNiyojanDone'];
    isSankalpaPoorna = map['IsSankalpaPoorna'];
  }
}

class AnnualBaithakEkatritVruttaBAL {
  int? sambhagSam;
  int? vibhaagSam;
  int? jilhaSam;
  int? bhaagCount;
  int? nagarCount;
  int? vastiCount;
  int? graaminVibhaagCount;
  int? graaminJilhaCount;
  int? graaminTaalukaaCount;
  int? graaminMandalCount;
  int? graaminNagarCount;
  int? graaminVastiCount;
  int? mahaanagarShaakhaaYuktaNagarCount;
  int? mahaanagarSamparkYuktaNagarCount;
  int? mahaanagarShaakhaaYuktaVastiCount;
  int? mahaanagarSamparkYuktaVastiCount;
  int? anyaNagarShaakhaaYuktaNagarCount;
  int? anyaNagarSamparkYuktaNagarCount;
  int? anyaNagarMinTwoShaakhaaCount;
  int? anyaNagarShaakhaaYuktaVastiCount;
  int? anyaNagarSamparkYuktaVastiCount;
  int? shaakhaaYuktaJilhaCount;
  int? minFiveShaakhaaJilhaKendraCount;
  int? shaakhaaYuktaTaalukaaCount;
  int? shaakhaaYuktaTaalukaaKendraCount;
  int? shaakhaaYuktaMandalCount;
  int? saaptaahikYuktaMandalCount;
  int? samparkYuktaMandalCount;
  int? sewaVastiCount;
  int? shaakhaaYuktaSewaVastiCount;
  int? sewaKaaryaYuktaSewaVastiCount;
  int? sewaVastiSamparkShaakhaaCount;
  int? sewaUpakramCount;
  int? anyaUpakramCount;
  int? totalUpakramCount;
  int? praathamikPratinidhitShaakhaaCount;
  int? praathamikPratinidhitAnyaSthaanCount;
  int? praathamikPratinidhitTotalCount;
  int? poornaJilhaKendraCount;
  int? poornaJilhaCount;
  int? poornaTaalukaaCount;
  int? jilhaWithPoornaTaalukaaCount;
  int? totalTaalukaaCountOfJilhaWithPoornaTaalukaa;
  int? poornaMandalCount;
  int? taalukaaWithPoornaMandalCount;
  int? samparkPoornaJilhaKendraCount;
  int? samparkPoornaJilhaCount;
  int? samparkPoornaTaalukaaCount;
  int? samparkJilhaWithPoornaTaalukaaCount;
  int? samparkTotalTaalukaaCountOfJilhaWithPoornaTaalukaa;
  int? samparkPoornaMandalCount;
  int? samparkTaalukaaWithPoornaMandalCount;
  int? mukhyaMaargCount;
  int? mukhyaMaargGraamPramukhCount;
  int? mukhyaMaargGraamCount;
  int? mukhyaMaargShaakhaaYuktaGraamCount;
  int? mukhyaMaargSaaptaahikYuktaGraamCount;
  int? mukhyaMaargKaaryaViheenGraamWithGraamPramukhCount;
  int? mukhyaMaargKaaryaViheenGraamCount;
  int? mukhyaMaargPastShaakhaaCount;

  AnnualBaithakEkatritVruttaBAL(
    this.sambhagSam,
    this.vibhaagSam,
    this.jilhaSam,
    this.bhaagCount,
    this.nagarCount,
    this.vastiCount,
    this.graaminVibhaagCount,
    this.graaminJilhaCount,
    this.graaminTaalukaaCount,
    this.graaminMandalCount,
    this.graaminNagarCount,
    this.graaminVastiCount,
    this.mahaanagarShaakhaaYuktaNagarCount,
    this.mahaanagarSamparkYuktaNagarCount,
    this.mahaanagarShaakhaaYuktaVastiCount,
    this.mahaanagarSamparkYuktaVastiCount,
    this.anyaNagarShaakhaaYuktaNagarCount,
    this.anyaNagarSamparkYuktaNagarCount,
    this.anyaNagarMinTwoShaakhaaCount,
    this.anyaNagarShaakhaaYuktaVastiCount,
    this.anyaNagarSamparkYuktaVastiCount,
    this.shaakhaaYuktaJilhaCount,
    this.minFiveShaakhaaJilhaKendraCount,
    this.shaakhaaYuktaTaalukaaCount,
    this.shaakhaaYuktaTaalukaaKendraCount,
    this.shaakhaaYuktaMandalCount,
    this.saaptaahikYuktaMandalCount,
    this.samparkYuktaMandalCount,
    this.sewaVastiCount,
    this.shaakhaaYuktaSewaVastiCount,
    this.sewaKaaryaYuktaSewaVastiCount,
    this.sewaVastiSamparkShaakhaaCount,
    this.sewaUpakramCount,
    this.anyaUpakramCount,
    this.totalUpakramCount,
    this.praathamikPratinidhitShaakhaaCount,
    this.praathamikPratinidhitAnyaSthaanCount,
    this.praathamikPratinidhitTotalCount,
    this.poornaJilhaKendraCount,
    this.poornaJilhaCount,
    this.poornaTaalukaaCount,
    this.jilhaWithPoornaTaalukaaCount,
    this.totalTaalukaaCountOfJilhaWithPoornaTaalukaa,
    this.poornaMandalCount,
    this.taalukaaWithPoornaMandalCount,
    this.samparkPoornaJilhaKendraCount,
    this.samparkPoornaJilhaCount,
    this.samparkPoornaTaalukaaCount,
    this.samparkJilhaWithPoornaTaalukaaCount,
    this.samparkTotalTaalukaaCountOfJilhaWithPoornaTaalukaa,
    this.samparkPoornaMandalCount,
    this.samparkTaalukaaWithPoornaMandalCount,
    this.mukhyaMaargCount,
    this.mukhyaMaargGraamPramukhCount,
    this.mukhyaMaargGraamCount,
    this.mukhyaMaargShaakhaaYuktaGraamCount,
    this.mukhyaMaargSaaptaahikYuktaGraamCount,
    this.mukhyaMaargKaaryaViheenGraamWithGraamPramukhCount,
    this.mukhyaMaargKaaryaViheenGraamCount,
    this.mukhyaMaargPastShaakhaaCount,
  );

  AnnualBaithakEkatritVruttaBAL.fromMap(Map<String, dynamic> map) {
    sambhagSam = map['SambhagSam'];
    vibhaagSam = map['VibhaagSam'];
    jilhaSam = map['JilhaSam'];
    bhaagCount = map['BhaagCount'];
    nagarCount = map['NagarCount'];
    vastiCount = map['VastiCount'];
    graaminVibhaagCount = map['GraaminVibhaagCount'];
    graaminJilhaCount = map['GraaminJilhaCount'];
    graaminTaalukaaCount = map['GraaminTaalukaaCount'];
    graaminMandalCount = map['GraaminMandalCount'];
    graaminNagarCount = map['GraaminNagarCount'];
    graaminVastiCount = map['GraaminVastiCount'];
    mahaanagarShaakhaaYuktaNagarCount = map['MahaanagarShaakhaaYuktaNagarCount'];
    mahaanagarSamparkYuktaNagarCount = map['MahaanagarSamparkYuktaNagarCount'];
    mahaanagarShaakhaaYuktaVastiCount = map['MahaanagarShaakhaaYuktaVastiCount'];
    mahaanagarSamparkYuktaVastiCount = map['MahaanagarSamparkYuktaVastiCount'];
    anyaNagarShaakhaaYuktaNagarCount = map['AnyaNagarShaakhaaYuktaNagarCount'];
    anyaNagarSamparkYuktaNagarCount = map['AnyaNagarSamparkYuktaNagarCount'];
    anyaNagarMinTwoShaakhaaCount = map['AnyaNagarMinTwoShaakhaaCount'];
    anyaNagarShaakhaaYuktaVastiCount = map['AnyaNagarShaakhaaYuktaVastiCount'];
    anyaNagarSamparkYuktaVastiCount = map['AnyaNagarSamparkYuktaVastiCount'];
    shaakhaaYuktaJilhaCount = map['ShaakhaaYuktaJilhaCount'];
    minFiveShaakhaaJilhaKendraCount = map['MinFiveShaakhaaJilhaKendraCount'];
    shaakhaaYuktaTaalukaaCount = map['ShaakhaaYuktaTaalukaaCount'];
    shaakhaaYuktaTaalukaaKendraCount = map['ShaakhaaYuktaTaalukaaKendraCount'];
    shaakhaaYuktaMandalCount = map['ShaakhaaYuktaMandalCount'];
    saaptaahikYuktaMandalCount = map['SaaptaahikYuktaMandalCount'];
    samparkYuktaMandalCount = map['SamparkYuktaMandalCount'];
    sewaVastiCount = map['SewaVastiCount'];
    shaakhaaYuktaSewaVastiCount = map['ShaakhaaYuktaSewaVastiCount'];
    sewaKaaryaYuktaSewaVastiCount = map['SewaKaaryaYuktaSewaVastiCount'];
    sewaVastiSamparkShaakhaaCount = map['SewaVastiSamparkShaakhaaCount'];
    sewaUpakramCount = map['SewaUpakramCount'];
    anyaUpakramCount = map['AnyaUpakramCount'];
    totalUpakramCount = map['TotalUpakramCount'];
    praathamikPratinidhitShaakhaaCount = map['PraathamikPratinidhitShaakhaaCount'];
    praathamikPratinidhitAnyaSthaanCount = map['PraathamikPratinidhitAnyaSthaanCount'];
    praathamikPratinidhitTotalCount = map['PraathamikPratinidhitTotalCount'];
    poornaJilhaKendraCount = map['PoornaJilhaKendraCount'];
    poornaJilhaCount = map['PoornaJilhaCount'];
    poornaTaalukaaCount = map['PoornaTaalukaaCount'];
    jilhaWithPoornaTaalukaaCount = map['JilhaWithPoornaTaalukaaCount'];
    totalTaalukaaCountOfJilhaWithPoornaTaalukaa = map['TotalTaalukaaCountOfJilhaWithPoornaTaalukaa'];
    poornaMandalCount = map['PoornaMandalCount'];
    taalukaaWithPoornaMandalCount = map['TaalukaaWithPoornaMandalCount'];
    samparkPoornaJilhaKendraCount = map['SamparkPoornaJilhaKendraCount'];
    samparkPoornaJilhaCount = map['SamparkPoornaJilhaCount'];
    samparkPoornaTaalukaaCount = map['SamparkPoornaTaalukaaCount'];
    samparkJilhaWithPoornaTaalukaaCount = map['SamparkJilhaWithPoornaTaalukaaCount'];
    samparkTotalTaalukaaCountOfJilhaWithPoornaTaalukaa = map['SamparkTotalTaalukaaCountOfJilhaWithPoornaTaalukaa'];
    samparkPoornaMandalCount = map['SamparkPoornaMandalCount'];
    samparkTaalukaaWithPoornaMandalCount = map['SamparkTaalukaaWithPoornaMandalCount'];
    mukhyaMaargCount = map['MukhyaMaargCount'];
    mukhyaMaargGraamPramukhCount = map['MukhyaMaargGraamPramukhCount'];
    mukhyaMaargGraamCount = map['MukhyaMaargGraamCount'];
    mukhyaMaargShaakhaaYuktaGraamCount = map['MukhyaMaargShaakhaaYuktaGraamCount'];
    mukhyaMaargSaaptaahikYuktaGraamCount = map['MukhyaMaargSaaptaahikYuktaGraamCount'];
    mukhyaMaargKaaryaViheenGraamWithGraamPramukhCount = map['MukhyaMaargKaaryaViheenGraamWithGraamPramukhCount'];
    mukhyaMaargKaaryaViheenGraamCount = map['MukhyaMaargKaaryaViheenGraamCount'];
    mukhyaMaargPastShaakhaaCount = map['MukhyaMaargPastShaakhaaCount'];
  }
}

class AnnualBaithakShaakhaaVruttaBAL {
  int? annualBaithakShaakhaaVruttaID;
  int? geoUnitID;
  String? geoUnitName;
  int? annualBaithakTypeID;
  String? annualBaithakTypeCode;
  int? frequencyID;
  String? frequencyCode;
  int? vayogatID;
  String? vayogatCode;
  int? conductingDayCount;
  int? conductingDaysCtrlGetfromAPI;
  int? conductingSewaDayCount;
  int? conductingSewaDaysCtrlGetfromAPI;
  int? baalAverage;
  int? tarunVidyaarthiAverage;
  int? tarunVyavasaayeeAverage;
  int? proudhVyavasaayeeAverage;
  int? vaarshikotsavMonth;
  bool? isSewaVastiDefined;
  int? isSadhyaSuruAahe;
  int? sewaVastiSamparkCount;
  bool? isSewaKaaryakartaaDefined;
  int? sewaUpakramCount;
  int? anyaUpakramCount;
  int? praathamikCount;
  int? praathamikSakriyaCount;
  int? prathamGeneralCount;
  int? prathamGeneralSakriyaCount;
  int? prathamSpecialCount;
  int? prathamSpecialSakriyaCount;
  int? dwitiyaGeneralCount;
  int? dwitiyaGeneralSakriyaCount;
  int? dwitiyaSpecialCount;
  int? dwitiyaSpecialSakriyaCount;
  int? trutiyaGeneralCount;
  int? trutiyaGeneralSakriyaCount;
  int? trutiyaSpecialCount;
  int? trutiyaSpecialSakriyaCount;
  bool? isShaakhaaToli;
  bool? isShaakhaaPaalak;
  int? patSankhyaa;
  int? sanghaDaayitvawaanSwCount;
  int? preritSansthaaSangathanDaayitvawaanSwCount;
  int? gatividhiDaayitvawaanSwCount;
  int? aayaamDaayitvawaanSwCount;
  int? sociallyActiveSwCount;
  int? shishuAverage;
  bool? isVaarshikNiyojanDone;
  int? shaakhaaToliBaithakCount;
  int? vaartaapatraCount;

  int? parentPraantID;
  int? parentMahaanagarID;
  int? parentVibhaagID;
  int? parentBhaagID;
  int? parentNagarID;
  int? parentShaharID;
  int? parentMandalID;
  int? parentGraamID;
  int? parentVastiID;

  String? prantName;
  String? mahaanagarName;
  String? vibhaagName;
  String? bhaagName;
  String? nagarName;
  String? mandalName;
  String? graamName;
  String? vastiName;

  int? viewOnly;

  AnnualBaithakShaakhaaVruttaBAL(
    this.annualBaithakShaakhaaVruttaID,
    this.geoUnitID,
    this.geoUnitName,
    this.annualBaithakTypeID,
    this.annualBaithakTypeCode,
    this.frequencyID,
    this.frequencyCode,
    this.vayogatID,
    this.vayogatCode,
    this.conductingDayCount,
    this.conductingDaysCtrlGetfromAPI,
    this.conductingSewaDayCount,
    this.conductingSewaDaysCtrlGetfromAPI,
    this.baalAverage,
    this.tarunVidyaarthiAverage,
    this.tarunVyavasaayeeAverage,
    this.proudhVyavasaayeeAverage,
    this.vaarshikotsavMonth,
    this.isSewaVastiDefined,
    this.isSadhyaSuruAahe,
    this.sewaVastiSamparkCount,
    this.isSewaKaaryakartaaDefined,
    this.sewaUpakramCount,
    this.anyaUpakramCount,
    this.praathamikCount,
    this.praathamikSakriyaCount,
    this.prathamGeneralCount,
    this.prathamGeneralSakriyaCount,
    this.prathamSpecialCount,
    this.prathamSpecialSakriyaCount,
    this.dwitiyaGeneralCount,
    this.dwitiyaGeneralSakriyaCount,
    this.dwitiyaSpecialCount,
    this.dwitiyaSpecialSakriyaCount,
    this.trutiyaGeneralCount,
    this.trutiyaGeneralSakriyaCount,
    this.trutiyaSpecialCount,
    this.trutiyaSpecialSakriyaCount,
    this.isShaakhaaToli,
    this.isShaakhaaPaalak,
    this.patSankhyaa,
    this.sanghaDaayitvawaanSwCount,
    this.preritSansthaaSangathanDaayitvawaanSwCount,
    this.gatividhiDaayitvawaanSwCount,
    this.aayaamDaayitvawaanSwCount,
    this.sociallyActiveSwCount,
    this.shishuAverage,
    this.isVaarshikNiyojanDone,
    this.shaakhaaToliBaithakCount,
    this.vaartaapatraCount,
    this.parentMahaanagarID,
    this.parentBhaagID,
    this.parentGraamID,
    this.parentMandalID,
    this.parentNagarID,
    this.parentPraantID,
    this.parentShaharID,
    this.parentVastiID,
    this.parentVibhaagID,
    this.prantName,
    this.mahaanagarName,
    this.vibhaagName,
    this.bhaagName,
    this.nagarName,
    this.mandalName,
    this.graamName,
    this.vastiName,
    this.viewOnly,
  );

  AnnualBaithakShaakhaaVruttaBAL.fromMap(Map<String, dynamic> map) {
    annualBaithakShaakhaaVruttaID = map['AnnualBaithakShaakhaaVruttaID'];
    geoUnitID = map['GeoUnitID'];
    geoUnitName = map['GeoUnitName'];
    annualBaithakTypeID = map['AnnualBaithakTypeID'];
    annualBaithakTypeCode = map['AnnualBaithakTypeCode'];
    frequencyID = map['FrequencyID'];
    frequencyCode = map['FrequencyCode'];
    vayogatID = map['VayogatID'];
    vayogatCode = map['VayogatCode'];
    conductingDayCount = map['ConductingDayCount'];
    conductingDaysCtrlGetfromAPI = map['GetSewaDivasKitiVela'];
    conductingSewaDayCount = map['SewaDivasKitiVela'];
    conductingSewaDaysCtrlGetfromAPI = map['ShaakhaaVruttaCount'];
    baalAverage = map['BaalAverage'];
    tarunVidyaarthiAverage = map['TarunVidyaarthiAverage'];
    tarunVyavasaayeeAverage = map['TarunVyavasaayeeAverage'];
    proudhVyavasaayeeAverage = map['ProudhVyavasaayeeAverage'];
    vaarshikotsavMonth = map['VaarshikotsavMonth'];
    isSewaVastiDefined = map['IsSewaVastiDefined'];
    isSadhyaSuruAahe = map['IsSadhyaSuruAahe'];
    sewaVastiSamparkCount = map['SewaVastiSamparkCount'];
    isSewaKaaryakartaaDefined = map['IsSewaKaaryakartaaDefined'];
    sewaUpakramCount = map['SewaUpakramCount'];
    anyaUpakramCount = map['AnyaUpakramCount'];
    praathamikCount = map['PraathamikCount'];
    praathamikSakriyaCount = map['PraathamikSakriyaCount'];
    prathamGeneralCount = map['PrathamGeneralCount'];
    prathamGeneralSakriyaCount = map['PrathamGeneralSakriyaCount'];
    prathamSpecialCount = map['PrathamSpecialCount'];
    prathamSpecialSakriyaCount = map['PrathamSpecialSakriyaCount'];
    dwitiyaGeneralCount = map['DwitiyaGeneralCount'];
    dwitiyaGeneralSakriyaCount = map['DwitiyaGeneralSakriyaCount'];
    dwitiyaSpecialCount = map['DwitiyaSpecialCount'];
    dwitiyaSpecialSakriyaCount = map['DwitiyaSpecialSakriyaCount'];
    trutiyaGeneralCount = map['TrutiyaGeneralCount'];
    trutiyaGeneralSakriyaCount = map['TrutiyaGeneralSakriyaCount'];
    trutiyaSpecialCount = map['TrutiyaSpecialCount'];
    trutiyaSpecialSakriyaCount = map['TrutiyaSpecialSakriyaCount'];
    isShaakhaaToli = map['IsShaakhaaToli'];
    isShaakhaaPaalak = map['IsShaakhaaPaalak'];
    patSankhyaa = map['PatSankhyaa'];
    sanghaDaayitvawaanSwCount = map['SanghaDaayitvawaanSwCount'];
    preritSansthaaSangathanDaayitvawaanSwCount = map['PreritSansthaaSangathanDaayitvawaanSwCount'];
    gatividhiDaayitvawaanSwCount = map['GatividhiDaayitvawaanSwCount'];
    aayaamDaayitvawaanSwCount = map['AayaamDaayitvawaanSwCount'];
    sociallyActiveSwCount = map['SociallyActiveSwCount'];
    shishuAverage = map['ShishuAverage'];
    isVaarshikNiyojanDone = map['IsVaarshikNiyojanDone'];
    shaakhaaToliBaithakCount = map['ShaakhaaToliBaithakCount'];
    vaartaapatraCount = map['VaartaapatraCount'];

    parentPraantID = map['ParentPraantID'];
    parentMahaanagarID = map['ParentMahaanagarID'];
    parentVibhaagID = map['ParentVibhaagID'];
    parentBhaagID = map['ParentBhaagID'];
    parentNagarID = map['ParentNagarID'];
    parentShaharID = map['ParentShaharID'];
    parentMandalID = map['ParentMandalID'];
    parentGraamID = map['ParentGraamID'];
    parentVastiID = map['ParentVastiID'];

    prantName = map['PrantName'];
    mahaanagarName = map['MahaanagarName'];
    vibhaagName = map['VibhaagName'];
    bhaagName = map['BhaagName'];
    nagarName = map['NagarName'];
    mandalName = map['MandalName'];
    graamName = map['GraamName'];
    vastiName = map['VastiName'];

    viewOnly = map['viewOnly'] ?? 0;
  }
}

class AnnualBaithakShaakhaaViheenBAL {
  int? annualBaithakShaakhaaViheenVruttaID;
  int? geoUnitID;
  String? geoUnitName;
  int? annualBaithakTypeID;
  String? annualBaithakTypeCode;
  bool? isShaakhaaInPast;
  bool? isSaaptaahikInPast;
  bool? isMandaliInPast;
  int? praathamikCount;
  int? praathamikSakriyaCount;
  int? prathamGeneralCount;
  int? prathamGeneralSakriyaCount;
  int? prathamSpecialCount;
  int? prathamSpecialSakriyaCount;
  int? dwitiyaGeneralCount;
  int? dwitiyaGeneralSakriyaCount;
  int? dwitiyaSpecialCount;
  int? dwitiyaSpecialSakriyaCount;
  int? trutiyaGeneralCount;
  int? trutiyaGeneralSakriyaCount;
  int? trutiyaSpecialCount;
  int? trutiyaSpecialSakriyaCount;
  int? vaartaapatraCount;

  AnnualBaithakShaakhaaViheenBAL(
    this.annualBaithakShaakhaaViheenVruttaID,
    this.geoUnitID,
    this.geoUnitName,
    this.annualBaithakTypeID,
    this.annualBaithakTypeCode,
    this.isShaakhaaInPast,
    this.isSaaptaahikInPast,
    this.isMandaliInPast,
    this.praathamikCount,
    this.praathamikSakriyaCount,
    this.prathamGeneralCount,
    this.prathamGeneralSakriyaCount,
    this.prathamSpecialCount,
    this.prathamSpecialSakriyaCount,
    this.dwitiyaGeneralCount,
    this.dwitiyaGeneralSakriyaCount,
    this.dwitiyaSpecialCount,
    this.dwitiyaSpecialSakriyaCount,
    this.trutiyaGeneralCount,
    this.trutiyaGeneralSakriyaCount,
    this.trutiyaSpecialCount,
    this.trutiyaSpecialSakriyaCount,
    this.vaartaapatraCount,
  );

  AnnualBaithakShaakhaaViheenBAL.fromMap(Map<String, dynamic> map) {
    annualBaithakShaakhaaViheenVruttaID = map['AnnualBaithakShaakhaaViheenVruttaID'];
    geoUnitID = map['GeoUnitID'];
    geoUnitName = map['GeoUnitName'];
    annualBaithakTypeID = map['AnnualBaithakTypeID'];
    annualBaithakTypeCode = map['AnnualBaithakTypeCode'];
    isShaakhaaInPast = map['IsShaakhaaInPast'];
    isSaaptaahikInPast = map['IsSaaptaahikInPast'];
    ;
    isMandaliInPast = map['IsMandaliInPast'];
    praathamikCount = map['PraathamikCount'];
    praathamikSakriyaCount = map['PraathamikSakriyaCount'];
    prathamGeneralCount = map['PrathamGeneralCount'];
    prathamGeneralSakriyaCount = map['PrathamGeneralSakriyaCount'];
    prathamSpecialCount = map['PrathamSpecialCount'];
    prathamSpecialSakriyaCount = map['PrathamSpecialSakriyaCount'];
    dwitiyaGeneralCount = map['DwitiyaGeneralCount'];
    dwitiyaGeneralSakriyaCount = map['DwitiyaGeneralSakriyaCount'];
    dwitiyaSpecialCount = map['DwitiyaSpecialCount'];
    dwitiyaSpecialSakriyaCount = map['DwitiyaSpecialSakriyaCount'];
    trutiyaGeneralCount = map['TrutiyaGeneralCount'];
    trutiyaGeneralSakriyaCount = map['TrutiyaGeneralSakriyaCount'];
    trutiyaSpecialCount = map['TrutiyaSpecialCount'];
    trutiyaSpecialSakriyaCount = map['TrutiyaSpecialSakriyaCount'];
    vaartaapatraCount = map['VaartaapatraCount'];
  }
}

class AnnualBaithakMukhyaMaargBAL {
  int? annualBaithakMukhyaMaargVruttaID;
  int? geoUnitID;
  String? geoUnitName;
  int? annualBaithakTypeID;
  String? annualBaithakTypeCode;
  String? mukhyaMaargName;
  int? shaakhaaCount;
  int? saaptaahikCount;
  int? maasikCount;
  String? graamPramukhName;

  AnnualBaithakMukhyaMaargBAL(
    this.annualBaithakMukhyaMaargVruttaID,
    this.geoUnitID,
    this.geoUnitName,
    this.annualBaithakTypeID,
    this.annualBaithakTypeCode,
    this.mukhyaMaargName,
    this.shaakhaaCount,
    this.saaptaahikCount,
    this.maasikCount,
    this.graamPramukhName,
  );

  AnnualBaithakMukhyaMaargBAL.fromMap(Map<String, dynamic> map) {
    annualBaithakMukhyaMaargVruttaID = map['AnnualBaithakMukhyaMaargVruttaID'];
    geoUnitID = map['GeoUnitID'];
    geoUnitName = map['GeoUnitName'];
    annualBaithakTypeID = map['AnnualBaithakTypeID'];
    annualBaithakTypeCode = map['AnnualBaithakTypeCode'];
    mukhyaMaargName = map['MukhyaMaargName'];
    shaakhaaCount = map['ShaakhaaCount'];
    saaptaahikCount = map['SaaptaahikCount'];
    maasikCount = map['MaasikCount'];
    graamPramukhName = map['GraamPramukhName'];
  }
}

class AnnualBaithakGraamVikasBAL {
  int? annualBaithakGraamVikasVruttaID;
  int? geoUnitID;
  String? geoUnitName;

  //String? mandalGraamName;
  int? annualBaithakTypeID;
  String? annualBaithakTypeCode;
  bool? isUdayGraam;
  bool? isPrabhaatGraam;

  AnnualBaithakGraamVikasBAL(
    this.annualBaithakGraamVikasVruttaID,
    this.geoUnitID,
    this.geoUnitName,
    //this.mandalGraamName,
    this.annualBaithakTypeID,
    this.annualBaithakTypeCode,
    this.isUdayGraam,
    this.isPrabhaatGraam,
  );

  AnnualBaithakGraamVikasBAL.fromMap(Map<String, dynamic> map) {
    annualBaithakGraamVikasVruttaID = map['AnnualBaithakGraamVikasVruttaID'];
    geoUnitID = map['GeoUnitID'];
    geoUnitName = map['GeoUnitName'];
    //mandalGraamName = map['MandalGraamName'];
    annualBaithakTypeID = map['AnnualBaithakTypeID'];
    annualBaithakTypeCode = map['AnnualBaithakTypeCode'];
    isUdayGraam = map['IsUdayGraam'];
    isPrabhaatGraam = map['IsPrabhaatGraam'];
  }
}

class ShaakhaaVruttaBAL {
  int? shaakhaaVruttaID;
  int? praantID;
  int? shaakhaaID;
  String? vruttaDate;
  int? shishuCount;
  int? newshishuCount;
  int? baalVidyaarthiCount;
  int? newbaalVidyaarthiCount;
  int? tarunVidyaarthiCount;
  int? newtarunVidyaarthiCount;
  int? tarunVyavasaayeeCount;
  int? newtarunVyavasaayeeCount;
  int? proudhaVyavasaayeeCount;
  int? newproudhaVyavasaayeeCount;
  int? matruskatiCount;
  int? newmatruskatiCount;
  int? pravasiKaryakartaCount;
  int? anyaPravasiKaryakartaCount;
  int? abhyaagatCount;
  String? remark;

  bool? isMandatoryShaaririk = false;
  bool? isMandatoryBouddhik = false;
  bool? isOptionalShaaririk = false;
  bool? isOptionalOther = false;

  bool? isDoneDeepBreathing = false;
  bool? isDoneDandaPrahaar = false;
  bool? isDoneSooryaNamaskaar = false;
  bool? isDoneSanchalanAbhyaas = false;
  bool? isDoneSaanghikGeet = false;
  bool? isDoneAmrutaVachan = false;
  bool? isDoneSubhaashit = false;
  bool? isDoneUrdhvapad = false;
  bool? isDoneBoodhKatha = false;
  bool? isDoneBoudhikDays = false;
  String? SelectedBoudhikDaysId;
  String? AnyaBoudhikDays;
  bool? isDoneSewaDays = false;
  String? SelectedSewaDaysId;

  ShaakhaaVruttaBAL(
      this.shaakhaaVruttaID,
      this.praantID,
      this.shaakhaaID,
      this.vruttaDate,
      this.shishuCount,
      this.newshishuCount,
      this.baalVidyaarthiCount,
      this.newbaalVidyaarthiCount,
      this.tarunVidyaarthiCount,
      this.newtarunVidyaarthiCount,
      this.tarunVyavasaayeeCount,
      this.newtarunVyavasaayeeCount,
      this.proudhaVyavasaayeeCount,
      this.newproudhaVyavasaayeeCount,
      this.matruskatiCount,
      this.newmatruskatiCount,
      this.abhyaagatCount,
      this.pravasiKaryakartaCount,
      this.anyaPravasiKaryakartaCount,
      this.remark,
      this.isMandatoryShaaririk,
      this.isMandatoryBouddhik,
      this.isOptionalShaaririk,
      this.isOptionalOther,
      this.isDoneDeepBreathing,
      this.isDoneDandaPrahaar,
      this.isDoneSooryaNamaskaar,
      this.isDoneSanchalanAbhyaas,
      this.isDoneSaanghikGeet,
      this.isDoneAmrutaVachan,
      this.isDoneSubhaashit,
      this.isDoneUrdhvapad,
      this.isDoneBoodhKatha,
      this.isDoneBoudhikDays,
      this.SelectedBoudhikDaysId,
      this.AnyaBoudhikDays,
      this.isDoneSewaDays,
      this.SelectedSewaDaysId);

  ShaakhaaVruttaBAL.fromMap(Map<String, dynamic> map) {
    shaakhaaVruttaID = map["ShaakhaaVruttaID"];
    praantID = map["PraantID"];
    shaakhaaID = map["ShaakhaaID"];
    vruttaDate = map["VruttaDateStr"];
    shishuCount = map["ShishuCount"];
    newshishuCount = map["NewShishuCount"];
    baalVidyaarthiCount = map["BaalVidyaarthiCount"];
    newbaalVidyaarthiCount = map["NewBaalVidyaarthiCount"];
    tarunVidyaarthiCount = map["TarunVidyaarthiCount"];
    newtarunVidyaarthiCount = map["NewTarunVidyaarthiCount"];
    tarunVyavasaayeeCount = map["TarunVyavasaayeeCount"];
    newtarunVyavasaayeeCount = map["NewTarunVyavasaayeeCount"];
    proudhaVyavasaayeeCount = map["ProudhaVyavasaayeeCount"];
    newproudhaVyavasaayeeCount = map["NewProudhaVyavasaayeeCount"];
    matruskatiCount = map["matruskatiCount"] ?? map["MatruskatiCountCount"];
    newmatruskatiCount = map["newmatruskatiCount"] ?? map["NewMatruskatiCountCount"];
    abhyaagatCount = map["AbhyaagatCount"];
    pravasiKaryakartaCount = map["PravasiKaryakartaCount"];
    anyaPravasiKaryakartaCount = map["AnyaPravasiKaryakartaCount"];
    isMandatoryShaaririk = map["IsMandatoryShaaririk"];
    isMandatoryBouddhik = map["IsMandatoryBouddhik"];
    isOptionalShaaririk = map["IsOptionalShaaririk"];
    isOptionalOther = map["IsOptionalOther"];
    remark = map["Remark"];
    isDoneAmrutaVachan = map["IsDoneAmrutaVachan"];
    isDoneDandaPrahaar = map["IsDoneDandaPrahaar"];
    isDoneDeepBreathing = map["IsDoneDeepBreathing"];
    isDoneSaanghikGeet = map["IsDoneSaanghikGeet"];
    isDoneSanchalanAbhyaas = map["IsDoneSanchalanAbhyaas"];
    isDoneSooryaNamaskaar = map["IsDoneSooryaNamaskaar"];
    isDoneSubhaashit = map["IsDoneSubhaashit"];
    isDoneUrdhvapad = map["IsDoneUrdhvapad"];
    isDoneBoodhKatha = map["IsDoneBoodhKatha"];
    isDoneBoudhikDays = map["IsDoneBoudhikDays"];
    SelectedBoudhikDaysId = map["BoudhikDaysId"].toString();
    AnyaBoudhikDays = map["AnyaBoudhikDays"];
    isDoneSewaDays = map["IsDoneSewaDays"];
    SelectedSewaDaysId = map["SewaDaysId"].toString();
  }
}

class SwayamsevakDaayitvaPageBAL {
  int? swayamsevakID;
  String? maxPastDaayitva;
  int? maxPastDaayitvaFromYear;
  int? maxPastDaayitvaToYear;
  bool? hasBeenVistaarak;
  int? vistaarakWeekCount;
  int? vistaarakMonthCount;
  int? vistaarakYearCount;
  bool? hasBeenPrachaarak;
  int? prachaarakYearCount;
  String? maxDaayitvaWhenPrachaarak;

  SwayamsevakDaayitvaPageBAL(this.swayamsevakID, this.maxPastDaayitva, this.maxPastDaayitvaFromYear, this.maxPastDaayitvaToYear, this.hasBeenVistaarak, this.vistaarakWeekCount,
      this.vistaarakMonthCount, this.vistaarakYearCount, this.hasBeenPrachaarak, this.prachaarakYearCount, this.maxDaayitvaWhenPrachaarak);
}

class DashboardSadyaSthitiDataBAL {
  int? vayogatID;
  String? vayogatCode;
  int? shaakhaaCount;
  int? sankalpitShaakhaaCount;

  int? maasikMilanCount;
  int? sankalpitMaasikMilanCount;

  int? sanghaMandaliCount;
  int? sankalpitSanghaMandaliCount;

  int? saaptaahikCount;
  int? sankalpitSaaptaahikCount;

  DashboardSadyaSthitiDataBAL(this.vayogatID, this.vayogatCode, this.shaakhaaCount, this.sanghaMandaliCount, this.saaptaahikCount, this.maasikMilanCount, this.sankalpitShaakhaaCount,
      this.sankalpitSaaptaahikCount, this.sankalpitMaasikMilanCount, this.sankalpitSanghaMandaliCount);
}

class SankalpByAadhaarBAL {
  int? vayogatID;
  String? vayogatCode;
  String? sankalpAadhaar;
  int? sankalpitShaakhaaCount;
  int? sankalpitSaaptaahikCount;
  int? sankalpitMasikMilankCount;
  int? sankalpitSanghaMandalikCount;

  SankalpByAadhaarBAL(
      this.vayogatID, this.vayogatCode, this.sankalpAadhaar, this.sankalpitShaakhaaCount, this.sankalpitSaaptaahikCount, this.sankalpitMasikMilankCount, this.sankalpitSanghaMandalikCount);
}

class BhaugolikVistaarBAL {
  String? levelName;
  int? totalCount;
  int? shaakhaaYuktaCount;
  int? saaptaahikYuktaCount;
  int? mandaliYuktaCount;
  int? gatividhiYuktaCount;

  BhaugolikVistaarBAL(
    this.levelName,
    this.totalCount,
    this.shaakhaaYuktaCount,
    this.saaptaahikYuktaCount,
    this.mandaliYuktaCount,
    this.gatividhiYuktaCount,
  );
}

class AppVersionBAL {
  String? versionNumber;
  String? buildNumber;

  AppVersionBAL(
    this.versionNumber,
    this.buildNumber,
  );
}

class GatividhiKaaryakartaaCountBAL {
  int? gatividhiID;
  String? gatividhiName;
  int? kaaryakartaaCount;

  GatividhiKaaryakartaaCountBAL(this.gatividhiID, this.gatividhiName, this.kaaryakartaaCount);
}

class AayaamKaaryakartaaCountBAL {
  int? aayaamID;
  String? aayaamName;
  int? kaaryakartaaCount;

  AayaamKaaryakartaaCountBAL(this.aayaamID, this.aayaamName, this.kaaryakartaaCount);
}

class PreritKaaryakartaaCountBAL {
  int? preritAOOID;
  String? preritAOOName;
  int? kaaryakartaaCount;

  PreritKaaryakartaaCountBAL(this.preritAOOID, this.preritAOOName, this.kaaryakartaaCount);
}

class SocialOrgKaaryakartaaCountBAL {
  int? mainAOOID;
  String? mainAOOName;
  int? kaaryakartaaCount;

  SocialOrgKaaryakartaaCountBAL(this.mainAOOID, this.mainAOOName, this.kaaryakartaaCount);
}

class StudentCategoryCountBAL {
  int? studentCategoryID;
  String? studentCategoryName;
  int? countByStudentCategory;

  StudentCategoryCountBAL(this.studentCategoryID, this.studentCategoryName, this.countByStudentCategory);
}

class VyavasaayeeCategoryCountBAL {
  int? vyavasaayeeCategoryID;
  String? vyavasaayeeCategoryName;
  int? countByVyavasaayeeCategory;

  VyavasaayeeCategoryCountBAL(this.vyavasaayeeCategoryID, this.vyavasaayeeCategoryName, this.countByVyavasaayeeCategory);
}

class YesterdayVruttaSummaryBAL {
  int? geoUnitID;
  String? geoUnitName;
  int? vayogatID;
  String? vayogatCode;
  int? shaakhaaCount;
  int? saaptaahikCount;
  int? milanMandaliCount;

  YesterdayVruttaSummaryBAL(this.geoUnitID, this.geoUnitName, this.vayogatID, this.vayogatCode, this.shaakhaaCount, this.saaptaahikCount, this.milanMandaliCount);
}

class YesterdayVruttaDetailBAL {
  int? geoUnitID;
  int? shaakhaaID;
  String? geoUnitName;
  int? frequencyID;
  String? frequencyCode;
  int? vayogatID;
  String? vayogatCode;
  int? shishuCount;
  int? baalVidyaarthiCount;
  int? tarunVidyaarthiCount;
  int? tarunVyavasaayeeCount;
  int? proudhaVyavasaayeeCount;
  int? abhyaagatCount;

  YesterdayVruttaDetailBAL(this.geoUnitID, this.shaakhaaID, this.geoUnitName, this.frequencyID, this.frequencyCode, this.vayogatID, this.vayogatCode, this.shishuCount, this.baalVidyaarthiCount,
      this.tarunVidyaarthiCount, this.tarunVyavasaayeeCount, this.proudhaVyavasaayeeCount, this.abhyaagatCount);
}

class YesterdayVruttaByGeoUnit {
  String? geoUnitName;
  int? displaySequence;
  String? vayogatName;
  int? vayogatID;
  int? shaakhaaCount;
  int? saaptaahikCount;
  int? maasikCount;

  YesterdayVruttaByGeoUnit(this.geoUnitName, this.displaySequence, this.vayogatName, this.vayogatID, this.shaakhaaCount, this.saaptaahikCount, this.maasikCount);
}

class MenuChoices {
  String? menuType;
  IconData icon;
  String? menuText;

  MenuChoices(this.menuType, this.icon, this.menuText);
}

class AreaOfInterestBAL {
  int? staticID;
  String? code;
  String? codeForDisplay;
  bool? isSelected;

  AreaOfInterestBAL(this.staticID, this.code, this.codeForDisplay, this.isSelected);

  AreaOfInterestBAL.fromMap(Map<String, dynamic> map) {
    staticID = map["StaticID"];
    code = map["Code"];
    codeForDisplay = map["CodeForDisplay"];
  }
}

class AreaOfExpertiseBAL {
  int? staticID;
  String? code;
  String? codeForDisplay;
  bool? isSelected;

  AreaOfExpertiseBAL(this.staticID, this.code, this.codeForDisplay, this.isSelected);

  AreaOfExpertiseBAL.fromMap(Map<String, dynamic> map) {
    staticID = map["StaticID"];
    code = map["Code"];
    codeForDisplay = map["CodeForDisplay"];
  }
}

class AreaOfOperationsBAL {
  int? staticID;
  String? code;
  String? codeForDisplay;
  bool? isSelected;

  AreaOfOperationsBAL(this.staticID, this.code, this.codeForDisplay, this.isSelected);

  AreaOfOperationsBAL.fromMap(Map<String, dynamic> map) {
    staticID = map["StaticID"];
    code = map["Code"];
    codeForDisplay = map["CodeForDisplay"];
  }
}

class NecessitiesBAL {
  int? staticID;
  String? code;
  String? codeForDisplay;
  bool? isSelected;

  NecessitiesBAL(this.staticID, this.code, this.codeForDisplay, this.isSelected);

  NecessitiesBAL.fromMap(Map<String, dynamic> map) {
    staticID = map["StaticID"];
    code = map["Code"];
    codeForDisplay = map["CodeForDisplay"];
  }
}

// class SewaVastiBAL {
//   int? praantID;
//   int? sewaVastiID;
//   String? sewaVastiName;
//   int? bhaagID;
//   int? nagarID;
//   int? shaharID;
//   String? necessarySewaTypeIDs;
//   String? population;
//   String? remark;
//
//   SewaVastiBAL(this.praantID, this.sewaVastiID, this.sewaVastiName, this.bhaagID, this.nagarID, this.shaharID, this.necessarySewaTypeIDs,
//       this.population, this.remark);
//
//   SewaVastiBAL.fromMap(Map<String, dynamic> map) {
//     praantID = map["PraantID"];
//     sewaVastiID = map["SewaVastiID"];
//     sewaVastiName = map["SewaVastiName"];
//     bhaagID = map["BhaagID"];
//     shaharID = map["ShaharID"];
//     nagarID = map["NagarID"];
//     necessarySewaTypeIDs = map["NecessarySewaTypeIDs"];
//     population = map["Population"];
//     remark = map["Remark"];
//   }
// }
class SewaVastiBAL {
  String? message;
  List<SewaVastiList>? sewaVastiList;
  String? status;

  SewaVastiBAL({this.message, this.sewaVastiList, this.status});

  SewaVastiBAL.fromJson(Map<String, dynamic> json) {
    message = json['Message'];
    if (json['SewaVastiList'] != null) {
      sewaVastiList = <SewaVastiList>[];
      json['SewaVastiList'].forEach((v) {
        sewaVastiList!.add(new SewaVastiList.fromJson(v));
      });
    }
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Message'] = this.message;
    if (this.sewaVastiList != null) {
      data['SewaVastiList'] = this.sewaVastiList!.map((v) => v.toJson()).toList();
    }
    data['Status'] = this.status;
    return data;
  }
}

class SewaVastiList {
  int? bhaagID;
  String? bhaagName;
  String? graamID;
  String? graamName;
  int? mahaanagarID;
  String? mahaanagarName;
  String? mandalID;
  String? mandalName;
  int? nagarID;
  String? nagarName;
  String? necessarySewaTypeIDs;
  String? population;
  int? praantID;
  String? remark;
  int? sewaVastiID;
  String? sewaVastiName;
  String? shaharID;
  String? shaharName;
  int? vastiID;
  String? vastiName;
  int? vibhaagID;
  String? vibhaagName;

  SewaVastiList(
      {this.bhaagID,
      this.bhaagName,
      this.graamID,
      this.graamName,
      this.mahaanagarID,
      this.mahaanagarName,
      this.mandalID,
      this.mandalName,
      this.nagarID,
      this.nagarName,
      this.necessarySewaTypeIDs,
      this.population,
      this.praantID,
      this.remark,
      this.sewaVastiID,
      this.sewaVastiName,
      this.shaharID,
      this.shaharName,
      this.vastiID,
      this.vastiName,
      this.vibhaagID,
      this.vibhaagName});

  SewaVastiList.fromJson(Map<String, dynamic> json) {
    bhaagID = json['BhaagID'];
    bhaagName = json['BhaagName'];
    graamID = json['GraamID'];
    graamName = json['GraamName'];
    mahaanagarID = json['MahaanagarID'];
    mahaanagarName = json['MahaanagarName'];
    mandalID = json['MandalID'];
    mandalName = json['MandalName'];
    nagarID = json['NagarID'];
    nagarName = json['NagarName'];
    necessarySewaTypeIDs = json['NecessarySewaTypeIDs'];
    population = json['Population'];
    praantID = json['PraantID'];
    remark = json['Remark'];
    sewaVastiID = json['SewaVastiID'];
    sewaVastiName = json['SewaVastiName'];
    shaharID = json['ShaharID'];
    shaharName = json['ShaharName'];
    vastiID = json['VastiID'];
    vastiName = json['VastiName'];
    vibhaagID = json['VibhaagID'];
    vibhaagName = json['VibhaagName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['BhaagID'] = this.bhaagID;
    data['BhaagName'] = this.bhaagName;
    data['GraamID'] = this.graamID;
    data['GraamName'] = this.graamName;
    data['MahaanagarID'] = this.mahaanagarID;
    data['MahaanagarName'] = this.mahaanagarName;
    data['MandalID'] = this.mandalID;
    data['MandalName'] = this.mandalName;
    data['NagarID'] = this.nagarID;
    data['NagarName'] = this.nagarName;
    data['NecessarySewaTypeIDs'] = this.necessarySewaTypeIDs;
    data['Population'] = this.population;
    data['PraantID'] = this.praantID;
    data['Remark'] = this.remark;
    data['SewaVastiID'] = this.sewaVastiID;
    data['SewaVastiName'] = this.sewaVastiName;
    data['ShaharID'] = this.shaharID;
    data['ShaharName'] = this.shaharName;
    data['VastiID'] = this.vastiID;
    data['VastiName'] = this.vastiName;
    data['VibhaagID'] = this.vibhaagID;
    data['VibhaagName'] = this.vibhaagName;
    return data;
  }
}
