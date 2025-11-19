import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../assets/strings/strings.dart';
import '../helpers/static_data.dart' as Statics;
import '../models/response_model/AbhiyaanSwayamsevakListResponse.dart';
import '../models/response_model/TulnatmakResponseModel.dart';
import '../models/response_model/abiyaan_geo_unit_model.dart';
import '../models/response_model/geounit_name_model.dart';
import '../models/response_model/get_vasti_data_by_id_model.dart';
import '../models/response_model/get_vijaya_dashami_geounit_data.dart';
import '../models/response_model/get_vijayadashmi_report_resp_model.dart';
import '../models/response_model/gruh_abhiyaan_vrutta_data_model.dart';
import '../models/response_model/mandalVastisarvekshanReportModel.dart';
import '../models/response_model/nagar_vasti_model.dart';
import '../models/response_model/nirikshan_baithak_vrutta.dart';
import '../models/response_model/notification_list_model.dart';
import '../models/response_model/sankalit_data_names_model.dart';
import '../models/response_model/search_abhiyaan_karyakarta_model.dart';
import '../models/response_model/taluka_mandal_model.dart';
import '../models/response_model/upkhanda_upnagar_report_data_model.dart';
import '../models/response_model/vasti_sarvekshan_dropdown_model.dart';
import '../models/response_model/vasti_survey_report_model.dart';
import '../models/response_model/vasti_up_data_model.dart';
import '../models/response_model/vijayaDashamiInitModel.dart';
import '../models/response_model/vijayadashmi_excel_resp_model.dart';
import '../providers/bals.dart';
import './database_helper.dart';

///Production
// const String baseUrl = 'http://114.79.135.131:8014';
// const String baseUrlAPI = 'http://114.79.135.131:8014/WCFServices/NiyojakProdMobileApp.svc';

/// Development
const String baseUrl = 'http://108.181.165.29:8027';
const String baseUrlAPI = 'http://108.181.165.29:8027/WCFServices/NiyojakProdMobileApp.svc';
// ========================================================================================

const String urlCheckLoginDate = baseUrlAPI + '/checklogoutdate';
const String urlGetAbhiyaanList = baseUrlAPI + '/GetAbhiyan';
const String urlSaveAbhiyaanSwayamsevak = baseUrlAPI + '/SaveAbhiyanSwayamsevak';
const String urlGetAbhiyaanSwayamsevakList = baseUrlAPI + '/getAbhiyanSwayamsevak';
const String urlGetAbhiyaanGruhaSamparkList = baseUrlAPI + '/GetAbhiyanGruhasamparkResponse';
const String urlGetVisheshVyaktiList = baseUrlAPI + '/GruhasamparkVisheshVyakti';
const String urlSaveAbhiyaanGruhaSampark = baseUrlAPI + '/SaveUpdateAbhiyanGruhasampark';
const String updatevayktivishesh = baseUrlAPI + '/updatevayktivishesh';
const String urlValidateUser = baseUrlAPI + '/ValidateAppUser';
const String urlGetHelpVideosForApp = baseUrlAPI + '/GetHelpVideosForApp';
const String urlGetAnnualBaithakEkatritVruttaForApp = baseUrlAPI + '/GetAnnualBaithakEkatritVruttaForApp';
const String getSankalitBaithakVruttaDeatilsNames = baseUrlAPI + '/GetSankalitBaithakVruttaDeatilsNames';
const String urlSendMail = baseUrlAPI + '/sendmail';

//========================================================================================

const String urlUpdatedVersion = 'https://play.google.com/store/apps/details?id=com.softiq.niyojak_prod';
const String urlIOSUpdatedVersion = 'https://apps'
    '.apple.com/us/app/niyojak/id6451251464';
const String urlUserCanUseApp = baseUrlAPI + '/UserCanUseApp';
const String urlGetSwayamsevakBasicInfoForApp = baseUrlAPI + '/GetSwayamsevakBasicInfoForApp';
const String urlGetSwayamsevakOtherInfoForApp = baseUrlAPI + '/GetSwayamsevakOtherInfoForApp';
const String urlGetSwayamsevakSanghaShikshanShaaririkVishayForApp = baseUrlAPI + '/GetSwayamsevakSanghaShikshanShaaririkVishayForApp';
const String urlGetSwayamsevakOccupationForApp = baseUrlAPI + '/GetSwayamsevakOccupationForApp';
const String urlGetSwayamsevakDaayitvaForApp = baseUrlAPI + '/GetSwayamsevakDaayitvaForApp';
const String urlGetSwayamsevakGhoshForApp = baseUrlAPI + '/GetSwayamsevakGhoshForApp';
const String urlGetSwayamsevaksForAppGrid = baseUrlAPI + '/GetSwayamsevaksForAppGrid';
const String urlSwayamsevakExportForApp = baseUrlAPI + '/SwayamsevakExportForApp';
const String urlSaveSwayamsevakBasicInfoForApp = baseUrlAPI + '/SaveSwayamsevakBasicInfoForApp';
const String urlSaveSwayamsevakOtherInfoForApp = baseUrlAPI + '/SaveSwayamsevakOtherInfoForApp';
const String urlSaveSwayamsevakSanghaShikshanShaaririkVishayForApp = baseUrlAPI + '/SaveSwayamsevakSanghaShikshanShaaririkVishayForApp';
const String urlSaveSaveSwayamsevakOccupationForApp = baseUrlAPI + '/SaveSwayamsevakOccupationForApp';
const String urlSaveSwayamsevakDaayitvaForApp = baseUrlAPI + '/SaveSwayamsevakDaayitvaForApp';
const String urlSaveSwayamsevakGhoshForApp = baseUrlAPI + '/SaveSwayamsevakGhoshForApp';
const String urlGetSwayamsevakTransferForAppGrid = baseUrlAPI + '/GetSwayamsevakTransferForAppGrid';
const String urlGetSwayamsevakTransferDetailsForApp = baseUrlAPI + '/GetSwayamsevakTransferDetailsForApp';
const String urlSaveSwayamsevakTransferForApp = baseUrlAPI + '/SaveSwayamsevakTransferForApp';
const String urlDeleteSwayamsevakTransferForApp = baseUrlAPI + '/DeleteSwayamsevakTransferForApp';
const String deleteabhiyangruhasampark = baseUrlAPI + '/deleteabhiyangruhasampark';
const String deleteabhiyanswayamsevak = baseUrlAPI + '/deleteabhiyanswayamsevak';
const String urlResetDataForApp = baseUrlAPI + '/ResetDataForApp';
const String deleteUserDeviceToken = baseUrlAPI + '/logoutappuser';
const String urlGetShaakhaasForAppGrid = baseUrlAPI + '/GetShaakhaasForAppGrid';
const String urlGetAnnualBaithakNagarVruttaForApp = baseUrlAPI + '/GetAnnualBaithakNagarVruttaForApp';
const String urlSaveAnnualBaithakNagarVruttaForApp = baseUrlAPI + '/SaveAnnualBaithakNagarVruttaForApp';
const String urlGetAnnualBaithakShaakhaaVruttaForApp = baseUrlAPI + '/GetAnnualBaithakShaakhaaVruttaForApp';
const String GetAnnualBaithakShaakhaaVruttaForAppbyid = baseUrlAPI + '/GetAnnualBaithakShaakhaaVruttaForAppbyid';
const String urlSaveAnnualBaithakShaakhaaVruttaForApp = baseUrlAPI + '/SaveAnnualBaithakShaakhaaVruttaForApp';
const String urlGetAnnualBaithakShaakhaaViheenForApp = baseUrlAPI + '/GetAnnualBaithakShaakhaaViheenVruttaForApp';
const String urlSaveAnnualBaithakShaakhaaViheenForApp = baseUrlAPI + '/SaveAnnualBaithakShaakhaaViheenVruttaForApp';
const String urlGetAnnualBaithakMukhyaMaargForApp = baseUrlAPI + '/GetAnnualBaithakMukhyaMaargVruttaForApp';
const String urlSaveAnnualBaithakMukhyaMaargForApp = baseUrlAPI + '/SaveAnnualBaithakMukhyaMaargVruttaForApp';
const String urlGetAnnualBaithakGraamVikasForApp = baseUrlAPI + '/GetAnnualBaithakGraamVikasVruttaForApp';
const String urlSaveAnnualBaithakGraamVikasForApp = baseUrlAPI + '/SaveAnnualBaithakGraamVikasVruttaForApp';
const String urlGetShaakhaaDetailsForApp = baseUrlAPI + '/GetShaakhaaDetailsForApp';
const String urlSaveShaakhaaAppData = baseUrlAPI + '/SaveShaakhaaAppData';
const String urlGetSoochisForAppGrid = baseUrlAPI + '/GetSoochisForAppGrid';
const String urlGetSoochiDetailsForApp = baseUrlAPI + '/GetSoochiDetailsForApp';
const String urlGetSoochiMembersForApp = baseUrlAPI + '/GetSoochiMembersForApp';
const String urlGetSoochiSharingsForApp = baseUrlAPI + '/GetSoochiSharingsForApp';
const String urlSaveSoochiAppData = baseUrlAPI + '/SaveSoochiAppData';
const String urlSaveSoochiMemberAppData = baseUrlAPI + '/SaveSoochiMemberAppData';
const String urlSaveSoochiSharingAppData = baseUrlAPI + '/SaveSoochiSharingAppData';
const String urlDeleteSoochiMemberAppData = baseUrlAPI + '/DeleteSoochiMemberAppData';
const String urlDeleteSoochiSharingAppData = baseUrlAPI + '/DeleteSoochiSharingAppData';
const String urlDeleteSwayamsevakDaayitvaForApp = baseUrlAPI + '/DeleteSwayamsevakDaayitvaForApp';
const String urlIsVersionCompatibleForApp = baseUrlAPI + '/IsVersionCompatibleForApp';
const String urlChangePasswordForApp = baseUrlAPI + '/ChangePasswordForApp';
const String urlSaveMyProfileAppData = baseUrlAPI + '/SaveMyProfileAppData';
const String urlResetAppPassword = baseUrlAPI + '/ResetAppPassword';
const String urlGetJoinRSSGridForApp = baseUrlAPI + '/GetJoinRSSGridForApp';
const String urlSaveJoinRSSForApp = baseUrlAPI + '/SaveJoinRSSForApp';
const String saveupdatevijayadashamiutsav = baseUrlAPI + '/saveupdatevijayadashamiutsav';
const String savevijayadashamiutsavfiles = baseUrlAPI + '/savevijayadashamiutsavfiles';
const String deletevijayadashamiutsavfiles = baseUrlAPI + '/Deletevijayadashamiutsavfiles';
const String savesajjanskhatianyapravbhavilok = baseUrlAPI + '/savesajjanskhatianyapravbhavilok';
const String getvijayadashamiutsavbyid = baseUrlAPI + '/getvijayadashamiutsavbyid';
const String getvijayadashamiutsavreport = baseUrlAPI + '/vijayadashamiutsavreport';
const String vijayadashamiReportApi = baseUrlAPI + '/vijayadashamiReport';
const String urlGetJoinRSSDataForApp = baseUrlAPI + '/GetJoinRSSDataForApp';
const String urlDeleteJoinRSSForApp = baseUrlAPI + '/DeleteJoinRSSForApp';
const String urlRefreshHomeScreenForApp = baseUrlAPI + '/RefreshHomeScreenForApp';
const String urlUpkhandupnagarreport = baseUrlAPI + '/upkhandupnagarreport';
const String urlUpkhandupnagarreportforexcel = baseUrlAPI + '/upkhandupnagarreportforexcel';
const String urlVastisarvekshanReport = baseUrlAPI + '/VastisarvekshanReport';
const String urlNagarVastisarvekshanReport = baseUrlAPI + '/NagarVastisarvekshanReport';
const String getDataWhileAddUpdateUPLevel = baseUrlAPI + '/GetDataWhileAddUpdateUPLevel';
const String mandalVastisarvekshanReport = baseUrlAPI + '/mandalVastisarvekshanReport';
const String urlNagarVastisarvekshanReportForMandal = baseUrlAPI + '/NagarVastisarvekshanReportformandal';
const String urlGetShaakhaaPatForApp = baseUrlAPI + '/GetShaakhaaPatForApp';
const String urlGetSanghaPreritSansthaaForApp = baseUrlAPI + '/GetSanghaPreritSansthaaForApp';
const String urlGetEventListForApp = baseUrlAPI + '/GetEventListForApp';
const String urlSaveEventDataForApp = baseUrlAPI + '/SaveEventDataForApp';
const String urlGetSwayamsevakCalendarForApp = baseUrlAPI + '/GetSwayamsevakCalendarForApp';
const String urlGetEventApekshitListForApp = baseUrlAPI + '/GetEventApekshitListForApp';
const String urlSaveEventApekshitSwayamsevakForApp = baseUrlAPI + '/SaveEventApekshitSwayamsevakForApp';
const String urlDeleteEventApekshitSwayamsevakForApp = baseUrlAPI + '/DeleteEventApekshitSwayamsevakForApp';
const String urlChangeEventOwnerForApp = baseUrlAPI + '/ChangeEventOwnerForApp';
const String urlGetEventVruttaListForApp = baseUrlAPI + '/GetEventVruttaListForApp';
const String urlSaveEventVruttaForApp = baseUrlAPI + '/SaveEventVruttaForApp';
const String urlDeleteEventVruttaForApp = baseUrlAPI + '/DeleteEventVruttaForApp';
const String urlGetShaakhaaVruttaListForApp = baseUrlAPI + '/GetShaakhaaVruttaListForApp';
const String urlSaveShaakhaaVruttaForApp = baseUrlAPI + '/SaveShaakhaaVruttaForApp';
const String urlGetgeounitNamebyid = baseUrlAPI + '/GetgeounitNamebyid';
const String getupnagarmandaldataagainstnagar = baseUrlAPI + '/getupnagarmandaldataagainstnagar';
const String urlDeleteShaakhaaVruttaForApp = baseUrlAPI + '/DeleteShaakhaaVruttaForApp';
const String urlGetSwayamsevakSoochisForApp = baseUrlAPI + '/GetSwayamsevakSoochisForApp';
const String urlSaveShaakhaaCoordinatesForApp = baseUrlAPI + '/SaveShaakhaaCoordinatesForApp';
const String urlGetEducationUniversitysForApp = baseUrlAPI + '/GetEducationUniversitysForApp';
const String urlGetEducationInstitutionsForApp = baseUrlAPI + '/GetEducationInstitutionsForApp';
const String urlGetEducationProgramsForApp = baseUrlAPI + '/GetEducationProgramsForApp';
const String urlGetEducationCoursesForApp = baseUrlAPI + '/GetEducationCoursesForApp';
const String urlGetDistrictsForApp = baseUrlAPI + '/GetDistrictsForApp';
const String urlGetGeoUnitMasterForApp = baseUrlAPI + '/GetGeoUnitMasterForApp';
const String urlGetSwayamsevakDaayitvaPageData = baseUrlAPI + '/GetSwayamsevakDaayitvaPageData';
const String urlSaveSwayamsevakDaayitvaPageData = baseUrlAPI + '/SaveSwayamsevakDaayitvaPageData';
const String urlGetSwayamsevakDaayitvaDetailForApp = baseUrlAPI + '/GetSwayamsevakDaayitvaDetailForApp';
const String urlDeleteSoochiForApp = baseUrlAPI + '/DeleteSoochiForApp';
const String urlDeleteShaakhaaForApp = baseUrlAPI + '/DeleteShaakhaaForApp';
const String urlGetShaakhaaSewaVastiLinksForApp = baseUrlAPI + '/GetShaakhaaSewaVastiLinksForApp';
const String urlSaveShaakhaaSewaVastiLinkForApp = baseUrlAPI + '/SaveShaakhaaSewaVastiLinkForApp';
const String urlUpdategeounitNamebyid = baseUrlAPI + '/UpdategeounitNamebyid';
const String updatevastimasndalparent = baseUrlAPI + '/updatevastimasndalparent';
const String urlGetJoinRSSGridByStatus = baseUrlAPI + '/GetJoinRSSGridByStatus';
const String urlGetSewaVastiForApp = baseUrlAPI + '/GetSewaVastiForApp';
const String urlSaveSewaVastiForApp = baseUrlAPI + '/SaveSewaVastiForApp';
const String urlDeleteSewaVastiForApp = baseUrlAPI + '/DeleteSewaVastiForApp';
const String urlUserManualEnglish = baseUrl + '/UserManualEnglish.html';
const String urlUserManualMarathi = baseUrl + '/UserManualMarathi.html';
const String urlUserManualHindi = baseUrl + '/UserManualHindi.html';
const String urlDeleteSwayamsevakDataForApp = baseUrlAPI + '/DeleteSwayamsevakDataForApp';
const String urlGetNidhiSankalanVruttaForApp = baseUrlAPI + '/GetNidhiSankalanParticipantVisheshVyaktiForApp';
const String urlGetShaakhaaToliSadasyaForApp = baseUrlAPI + '/GetShaakhaaToliSadasyaForApp';
const String urlGetSankalpForApp = baseUrlAPI + '/GetSankalpAndKaaryaSthitiForApp';
const String urlSaveSankalForApp = baseUrlAPI + '/SaveSankalpForApp';
const String changesavamsevakcanedit = baseUrlAPI + '/changesavamsevakcanedit';
const String getnirikshanbhaithakvruttaforapp = baseUrlAPI + '/getvarshikbhaithakvruttaforapp';
const String tulnatmakEkatritVruttaForApp = baseUrlAPI + '/tulnatmakEkatritVruttaForApp';
const String getvastiSarvekshan = baseUrlAPI + '/getvastiSarvekshan';
const String getOtpForForgetPassWord = baseUrlAPI + '/sendotpforforgetpass';
const String forgotPasswordApi = baseUrlAPI + '/saveSwayamsevakpassword';
const String getofflinenotificationlist = baseUrlAPI + '/getofflinenotificationlist';
const String getVastisarvekshanmasterdata = baseUrlAPI + '/Vastisarvekshanmasterdata';
const String getMandalsarvekshanmasterdata = baseUrlAPI + '/Mandalsarvekshanmasterdata';
const String changenotificationstatus = baseUrlAPI + '/changenotificationstatus';
const String getJoinRSSGridForAppbyid = baseUrlAPI + '/GetJoinRSSGridForAppbyid';
const String vastiSarvekshanstep1Submit = baseUrlAPI + '/vastiSarvekshanstep1';
const String vastiSarvekshanstep2Submit = baseUrlAPI + '/vastiSarvekshanstep2';
const String vastiSarvekshanstep3Submit = baseUrlAPI + '/vastiSarvekshanstep3';
const String mandalSarvekshanstep1Submit = baseUrlAPI + '/mandalSarvekshanstep1';
const String mandalSarvekshanstep2Submit = baseUrlAPI + '/mandalSarvekshanstep2';
const String mandalSarvekshanstep3Submit = baseUrlAPI + '/mandalSarvekshanstep3';

const String getSwayamsevakForGruhApi = baseUrlAPI + '/GetSwayamsevaksForGruh';
const String searchPramukhForGruhApi = baseUrlAPI + '/searchSwayamsevakforpramukh';
const String saveSwayamsevakForGruhApi = baseUrlAPI + '/saveabhiyaanKaryakarta'; //'/SaveAbhiyanSwayamsevakForGruh';
const String saveAsPramukhForGruhApi = baseUrlAPI + '/addpramukhtogruh'; //'/SaveAbhiyanSwayamsevakForGruh';
const String addSwayamsevakInListForGruhApi = baseUrlAPI + '/SaveAbhiyanSwayamsevakForGruh';
const String getDataforGruhAbhiyaanApi = baseUrlAPI + '/GetDataforGruhAbhiyaan';
const String getAbhiyaanGeoUnitListApi = baseUrlAPI + '/getgeounitdataforabhiyaangruh';
const String addToToliListApi = baseUrlAPI + '/addtotoli';
const String saveDataforGruhAbhiyaanApi = baseUrlAPI + '/SaveDataforGruhAbhiyaan';
const String getDataWhileAddUpdateUPLevelForGruh = baseUrlAPI + '/GetDataWhileAddUpdateUPLevelForGruh';
const String urlCheckExistsAbhiyaanKaryakarta = baseUrlAPI + '/checkexistsabhiyaankaryakarta';

//////////////////////////////////////////////////////////////////////////////////////////
const String patchSuffix = '';
const String dbVersion = '4';
const int shaakhaaFrequencyDaily = 34;
const int shaakhaaFrequencyWeekly = 35;
const int shaakhaaFrequencyMonthly = 36;
const int baalSanyuktaVayogatID = 37;
const int tarunVidyaarthiVayogatID = 38;
const int tarunVyavasaayeeVayogatID = 39;
const int proudhaVyavasaayeeVayogatID = 40;
const int abPratinidhiSabhaa = 233;
const int praantikBaithak1 = 234;
const int praantikBaithak2 = 235;
// const int prachaarakBaithak = 236;
// const int kaaryakaariMandalBaithak = 237;
const int prachaarakBaithak = 238;
// const int kaaryakaariMandalBaithak = 242;

Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

Map<String, String> months = {'1': 'Jan', '2': 'Feb', '3': 'Mar', '4': 'Apr', '5': 'May', '6': 'Jun', '7': 'Jul', '8': 'Aug', '9': 'Sept', '10': 'Oct', '11': 'Nov', '12': 'Dec'};

Map<String, String> vaarshikotsavMonths = {
  '0': 'NotConducted',
  '1': 'Jan',
  '2': 'Feb',
  '3': 'Mar',
  '4': 'Apr',
  '5': 'May',
  '6': 'Jun',
  '7': 'Jul',
  '8': 'Aug',
  '9': 'Sept',
  '10': 'Oct',
  '11': 'Nov',
  '12': 'Dec',
};

Map<String, dynamic> userDetails = {
  'userID': '',
  'MobileNumber': '',
  'languagePreference': 'Marathi',
  'isAuthorized': false,
  'isFirstLogin': false,
  'DaayitvaGeoUnitID': '',
  'DaayitvaGeoUnitName': '',
  'DaayitvaName': '',
  'LevelID': '',
  'LevelName': '',
  //'LevelNameForDisplay': '',
  'FullName': '',
  'isUpdatedVersion': false,
  'LinkedVastiID': '',
  'LinkedVastiName': '',
  'LinkedGraamID': '',
  'LinkedGraamName': '',
  'LinkedShaakhaaID': '',
  'LinkedShaakhaaName': '',
  'LinkedGeoUnitHierarchy': '',
  'LastLoginTimeStamp': '',
  'isLoggedIn': 'false',
  'IsPravaasiKaaryakartaa': false,
  'can_edit': '',
  'DaayitvaNameforshow': '',
  'DaayitvaId': '',
};

Map<String, dynamic> abhiyaanUserDetails = {
  "isEmpty": false,
  "AbhiyaDaayitvaID": 0,
  "AbhiyanSwayamsevakID": 0,
  "DaayityaName": "",
  "Email": "",
  "FullName": "",
  "GeoUnitID": 0,
  "GeoUnitName": "",
  "LevelName": "",
  "MobileNumber": "",
  "ParentBhaagID": 0,
  "ParentMahaanagarID": 0,
  "ParentMandalID": 0,
  "ParentNagarID": 0,
  "ParentVibhaagID": 0,
  "PreferredLanguageCode": "",
  "PreferredLanguageID": 0
};

Map<String, dynamic> levels = {
  'KshetraLevelID': '',
  'PraantLevelID': '',
  'MahaanagarLevelID': '',
  'VibhaagLevelID': '',
  'BhaagLevelID': '',
  'ShaharLevelID': '',
  'NagarLevelID': '',
  'MandalLevelID': '',
  'GraamLevelID': '',
  'VastiLevelID': '',
  'ShaakhaaLevelID': '',
};

Map<String, dynamic> abhiyaanGeoLevels = {
  'KshetraLevelID': '',
  'PraantLevelID': '',
  'MahaanagarLevelID': '',
  'VibhaagLevelID': '',
  'BhaagLevelID': '',
  'ShaharLevelID': '',
  'NagarLevelID': '',
  'MandalLevelID': '',
  'GraamLevelID': '',
  'VastiLevelID': '',
  'ShaakhaaLevelID': '',
};

Map<String, dynamic> dashboardData = {
  'ShishuCount': '',
  'BaalCount': '',
  'TarunVidyaarthiCount': '',
  'TarunVyavasaayeeCount': '',
  'ProudhaVyavasaayeeCount': '',
  'UnknownAgeCount': '',
  'TrutiyaVarshaShikshitCount': '',
  'DwitiyaVarshaShikshitCount': '',
  'PrathamVarshaShikshitCount': '',
  'PraathamikShikshitCount': '',
  'NoShikshanCount': '',
  'ShaakhaaKaaryakartaaCount': '',
  'VastiKaaryakartaaCount': '',
  'GraamKaaryakartaaCount': '',
  'MandalKaaryakartaaCount': '',
  'NagarKaaryakartaaCount': '',
  'ShaharKaaryakartaaCount': '',
  'BhaagKaaryakartaaCount': '',
  'VibhaagKaaryakartaaCount': '',
  'MahaanagarKaaryakartaaCount': '',
  'PraantKaaryakartaaCount': '',
  'Notificationcount': '',
  'KshetraKaaryakartaaCount': '',
  'PravaseeKaaryakartaaCount': '',
  'GatividhiKaaryakartaaCount': '',
  'AayaamKaaryakartaaCount': '',
  'SanghaPreritSansthaaKaaryakartaaCount': '',
  'TotalKaaryakartaaCount': '',
  'SocialOrganizationKaaryakartaaCount': '',
  'PratidnyitCount': '',
  'TotalSwayamsevakCount': '',
};

Map<String, dynamic> packageInfo = {'versionNumber': ''};

// List<ShaakhaaVruttaBAL> lstShaakhaaVrutta = [];

List<DashboardSadyaSthitiDataBAL> lstdashboardSadyaSthitiData = [];
List<GatividhiKaaryakartaaCountBAL> lstGatividhiKaaryakartaa = [];
List<AayaamKaaryakartaaCountBAL> lstAayaamKaaryakartaa = [];
List<PreritKaaryakartaaCountBAL> lstPreritKaaryakartaa = [];
List<SocialOrgKaaryakartaaCountBAL> lstSocialOrgKaaryakartaa = [];
List<StudentCategoryCountBAL> lstStudentCategory = [];
List<VyavasaayeeCategoryCountBAL> lstVyavasaayeeCategory = [];
List<YesterdayVruttaDetailBAL> lstYesterdayVruttaDetail = [];
List<YesterdayVruttaSummaryBAL> lstYesterdayVruttaSummary = [];
List<DashboardSadyaSthitiDataBAL> lstYesterdayPraantData = [];
List<SankalpByAadhaarBAL> lstSankalpByAadhaarData = [];
List<BhaugolikVistaarBAL> lstBhaugolikVistaar = [];
// List<BhaugolikVistaarBAL> lstLastMonthBhaugolikVistaar = [];
List<AppVersionBAL> lstAppVersion = [];

List<DashboardSadyaSthitiDataBAL> tgLstdashboardSadyaSthitiData = [];
List<GatividhiKaaryakartaaCountBAL> tgLstGatividhiKaaryakartaa = [];
List<AayaamKaaryakartaaCountBAL> tgLstAayaamKaaryakartaa = [];
List<PreritKaaryakartaaCountBAL> tgLstPreritKaaryakartaa = [];
List<SocialOrgKaaryakartaaCountBAL> tgLstSocialOrgKaaryakartaa = [];
List<StudentCategoryCountBAL> tgLstStudentCategory = [];
List<VyavasaayeeCategoryCountBAL> tgLstVyavasaayeeCategory = [];
List<YesterdayVruttaDetailBAL> tgLstYesterdayVruttaDetail = [];
List<YesterdayVruttaSummaryBAL> tgLstYesterdayVruttaSummary = [];
List<SankalpByAadhaarBAL> tgLstSankalpByAadhaarData = [];
List<BhaugolikVistaarBAL> tgLstBhaugolikVistaar = [];
// List<BhaugolikVistaarBAL> tgLstLastMonthBhaugolikVistaar = [];

// String getLabel(String key) {
//   if (userDetails['languagePreference'] == 'English')
//     return resEnglish[key].toString();
//   if (userDetails['languagePreference'] == 'Marathi')
//     return resMarathi[key].toString();
//   if (userDetails['languagePreference'] == 'Hindi')
//     return resHindi[key].toString();
//   return resMarathi[key].toString();
// }

String getLabel(String key, {bool returnKey = false}) {
  String language = userDetails['languagePreference'];

  if (language == 'English') {
    return resEnglish[key] ?? (returnKey ? key : "");
  }
  if (language == 'Marathi') {
    return resMarathi[key] ?? (returnKey ? key : "");
  }
  if (language == 'Hindi') {
    return resHindi[key] ?? (returnKey ? key : "");
  }

  // Default to Marathi if language not matched
  return resMarathi[key] ?? (returnKey ? key : "");
}

Size getDeviceSize(BuildContext context) {
  return MediaQuery.of(
    context,
    //nullOk: true,
  ).size;
}

Future<bool> isInternetConnected() async {
  // final Connectivity _connectivity = Connectivity();
  // ConnectivityResult result = await _connectivity.checkConnectivity();
  // if (result == ConnectivityResult.mobile ||
  //     result == ConnectivityResult.wifi) {
  //   if (await DataConnectionChecker().hasConnection) return true;
  // }
  // return false;

  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  } on SocketException catch (_) {
    return false;
  }
}

void showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(getLabel('errorOccurred')),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          child: Text(getLabel('okay')),
          onPressed: () {
            Navigator.of(ctx).pop();
          },
        ),
      ],
    ),
  );
}

void showConfirmationBox(BuildContext context, String message, String action, String val) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(Statics.getLabel('AskConfirmation')),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          child: Text(Statics.getLabel('ConfirmationYes')),
          onPressed: () async {
            if (action == "ResetPassword") {
              var data = await resetPassword(val);
              if (data == "Password Reset Successfully")
                showToast(getLabel('PasswordResetSuccessfully'));
              else
                showToast(getLabel('CouldNotResetPassword'));
            } else if (action == "DeleteMember") {
              var data = await deleteSoochiMembers(val);
              if (data == "Soochi Member Deleted Successfully ")
                showToast(getLabel('SoochiMemberDeletedSuccessfully'));
              else
                showToast(getLabel('CouldnotDeleteSoochiMember'));
            }
            Navigator.of(ctx).pop();
          },
        ),
        TextButton(
          child: Text(Statics.getLabel('ConfirmationNo')),
          onPressed: () {
            Navigator.of(ctx).pop();
          },
        ),
      ],
    ),
  );
}

void showMessageDialog(BuildContext context, String message, {String title = ""}) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title == "" ? getLabel('alert') : title),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          child: Text(getLabel('okay')),
          onPressed: () {
            Navigator.of(ctx).pop();
          },
        ),
      ],
    ),
  );
}

void showHelpDialog(BuildContext context, String message, String title, String videoLabel, String videoLink) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(getLabel(title)),
      content: SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Html(data: message)])),
      actions: <Widget>[
        if (videoLabel != '')
          TextButton(
            child: Text(videoLabel),
            onPressed: () {
              //launch('https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4');
              //launch('https://drive.google.com/file/d/16bQa5O280mnBxT3w1PXXIpwIrdsWIx62/view?ts=633ea5fd');
              launch(videoLink);
              //launch(baseUrl + '/Images/1Hindi.mp4');
            },
          ),
        TextButton(
          child: Text(getLabel('okay')),
          onPressed: () {
            Navigator.of(ctx).pop();
          },
        ),
      ],
    ),
  );
}

void showToast(var message) {
  Fluttertoast.showToast(msg: message, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: Colors.black, textColor: Colors.white, fontSize: 16.0);
}

Future<void> populateUserDetailsMap() async {
  var result = await DatabaseHelper.getData('Select * from UserDataMaster;');

  result.forEach((element) {
    var uData = UserDataBAL.fromMap(element);
    userDetails['userID'] = uData.swayamsevakID.toString();
    userDetails['MobileNumber'] = uData.mobileNumber.toString();
    userDetails['languagePreference'] = uData.preferredLanguageCode.toString();
    userDetails['isAuthorized'] = true;
    userDetails['isLoggedIn'] = 'true';
    userDetails['isFirstLogin'] = uData.isFirstLogin;

    userDetails['DaayitvaGeoUnitID'] = uData.daayitvaGeoUnitID.toString();
    userDetails['DaayitvaGeoUnitName'] = uData.daayitvaGeoUnitName.toString();
    userDetails['DaayitvaName'] = uData.daayitvaName.toString();
    userDetails['DaayitvaNameforshow'] = uData.daayitvaNameforshow.toString();
    userDetails['DaayitvaId'] = uData.daayitvaID.toString();

    userDetails['LevelID'] = uData.levelID.toString();
    userDetails['LevelName'] = uData.levelName.toString();
    //userDetails['LevelNameForDisplay'] = uData.levelNameForDisplay.toString();
    userDetails['FullName'] = uData.fullName.toString();
    userDetails['isUpdatedVersion'] = true;

    userDetails['LinkedVastiID'] = uData.linkedVastiID.toString();
    userDetails['LinkedVastiName'] = uData.linkedVastiName.toString();
    userDetails['LinkedGraamID'] = uData.linkedGraamID.toString();
    userDetails['LinkedGraamName'] = uData.linkedGraamName.toString();
    userDetails['LinkedShaakhaaID'] = uData.linkedShaakhaaID.toString();
    userDetails['LinkedShaakhaaName'] = uData.linkedShaakhaaName.toString();
    userDetails['LinkedGeoUnitHierarchy'] = uData.linkedGeoUnitHierarchy.toString();
    userDetails['LastLoginTimeStamp'] = uData.lastLoginTimeStamp;
    userDetails['isLoggedIn'] = uData.isLoggedIn;
    userDetails['IsPravaasiKaaryakartaa'] = uData.isPravaasiKaaryakartaa;
  });

  var resultLevels = await DatabaseHelper.getData('Select * from LevelMaster;');
  resultLevels.forEach((element) {
    var lvlItem = LevelMasterBAL.fromMap(element);
    if (lvlItem.levelName == 'Kshetra') {
      levels['KshetraLevelID'] = lvlItem.levelID.toString();
    } else if (lvlItem.levelName == 'Praant') {
      levels['PraantLevelID'] = lvlItem.levelID.toString();
    } else if (lvlItem.levelName == 'Mahaanagar') {
      levels['MahaanagarLevelID'] = lvlItem.levelID.toString();
    } else if (lvlItem.levelName == 'Vibhaag') {
      levels['VibhaagLevelID'] = lvlItem.levelID.toString();
    } else if (lvlItem.levelName == 'Bhaag') {
      levels['BhaagLevelID'] = lvlItem.levelID.toString();
    } else if (lvlItem.levelName == 'Shahar') {
      levels['ShaharLevelID'] = lvlItem.levelID.toString();
    } else if (lvlItem.levelName == 'Nagar') {
      levels['NagarLevelID'] = lvlItem.levelID.toString();
    } else if (lvlItem.levelName == 'Mandal') {
      levels['MandalLevelID'] = lvlItem.levelID.toString();
    } else if (lvlItem.levelName == 'Graam') {
      levels['GraamLevelID'] = lvlItem.levelID.toString();
    } else if (lvlItem.levelName == 'Vasti') {
      levels['VastiLevelID'] = lvlItem.levelID.toString();
    } else if (lvlItem.levelName == 'Shaakhaa') {
      levels['ShaakhaaLevelID'] = lvlItem.levelID.toString();
    }
  });
}

Future<void> populateUserAbhiyaanDetailsMap() async {
  var result = await DatabaseHelper.getData('Select * from AbhiyanSwayamsevakData;');

  if (result.isEmpty) {
    abhiyaanUserDetails["isEmpty"] = true;
  } else {
    result.forEach((element) {
      var uData = AbhiyaanUserDataBAL.fromJson(element);
      abhiyaanUserDetails['AbhiyaDaayitvaID'] = uData.abhiyaDaayitvaID;
      abhiyaanUserDetails['AbhiyanSwayamsevakID'] = uData.abhiyanSwayamsevakID;
      abhiyaanUserDetails['DaayityaName'] = uData.daayityaName;
      abhiyaanUserDetails['Email'] = uData.email;
      abhiyaanUserDetails['FullName'] = uData.fullName;
      abhiyaanUserDetails['GeoUnitID'] = uData.geoUnitID;

      abhiyaanUserDetails['GeoUnitName'] = uData.geoUnitName;
      abhiyaanUserDetails['LevelName'] = uData.levelName;
      abhiyaanUserDetails['MobileNumber'] = uData.mobileNumber;
      abhiyaanUserDetails['ParentBhaagID'] = uData.parentBhaagID;
      abhiyaanUserDetails['ParentMahaanagarID'] = uData.parentMahaanagarID;

      abhiyaanUserDetails['ParentMandalID'] = uData.parentMandalID;
      abhiyaanUserDetails['ParentNagarID'] = uData.parentNagarID;
      abhiyaanUserDetails['ParentVibhaagID'] = uData.parentVibhaagID;
      abhiyaanUserDetails['PreferredLanguageCode'] = uData.preferredLanguageCode;

      abhiyaanUserDetails['PreferredLanguageID'] = uData.preferredLanguageID;
      abhiyaanUserDetails["isEmpty"] = false;
    });
  }
}

Future<void> populateDashboardDetailsMap() async {
  var result = await DatabaseHelper.getData('Select * from HomeScreenData;');

  result.forEach((element) {
    var uData = DashboardDataBAL.fromMap(element);
    dashboardData["ShishuCount"] = uData.shishuCount.toString();
    dashboardData["BaalCount"] = uData.baalCount.toString();
    dashboardData["TarunVidyaarthiCount"] = uData.tarunVidyaarthiCount.toString();
    dashboardData["TarunVyavasaayeeCount"] = uData.tarunVyavasaayeeCount.toString();
    dashboardData["ProudhaVyavasaayeeCount"] = uData.proudhaVyavasaayeeCount.toString();
    dashboardData["UnknownAgeCount"] = uData.unknownAgeCount.toString();
    dashboardData["TrutiyaVarshaShikshitCount"] = uData.trutiyaVarshaShikshitCount.toString();
    dashboardData["DwitiyaVarshaShikshitCount"] = uData.dwitiyaVarshaShikshitCount.toString();
    dashboardData["PrathamVarshaShikshitCount"] = uData.prathamVarshaShikshitCount.toString();
    dashboardData["PraathamikShikshitCount"] = uData.praathamikShikshitCount.toString();
    dashboardData["NoShikshanCount"] = uData.noShikshanCount.toString();
    dashboardData["ShaakhaaKaaryakartaaCount"] = uData.shaakhaaKaaryakartaaCount.toString();
    dashboardData["VastiKaaryakartaaCount"] = uData.vastiKaaryakartaaCount.toString();
    dashboardData["GraamKaaryakartaaCount"] = uData.graamKaaryakartaaCount.toString();
    dashboardData["MandalKaaryakartaaCount"] = uData.mandalKaaryakartaaCount.toString();
    dashboardData["NagarKaaryakartaaCount"] = uData.nagarKaaryakartaaCount.toString();
    dashboardData["ShaharKaaryakartaaCount"] = uData.shaharKaaryakartaaCount.toString();
    dashboardData["BhaagKaaryakartaaCount"] = uData.bhaagKaaryakartaaCount.toString();
    dashboardData["VibhaagKaaryakartaaCount"] = uData.vibhaagKaaryakartaaCount.toString();
    dashboardData["MahaanagarKaaryakartaaCount"] = uData.mahaanagarKaaryakartaaCount.toString();
    dashboardData["PraantKaaryakartaaCount"] = uData.praantKaaryakartaaCount.toString();
    dashboardData["Notificationcount"] = uData.notificationCount.toString();
    dashboardData["KshetraKaaryakartaaCount"] = uData.kshetraKaaryakartaaCount.toString();
    dashboardData["PravaseeKaaryakartaaCount"] = uData.pravaseeKaaryakartaaCount.toString();
    dashboardData["GatividhiKaaryakartaaCount"] = uData.gatividhiKaaryakartaaCount.toString();
    dashboardData["AayaamKaaryakartaaCount"] = uData.aayaamKaaryakartaaCount.toString();
    dashboardData["SanghaPreritSansthaaKaaryakartaaCount"] = uData.sanghaPreritSansthaaKaaryakartaaCount.toString();
    dashboardData["TotalKaaryakartaaCount"] = uData.totalKaaryakartaaCount.toString();
    dashboardData["SocialOrganizationKaaryakartaaCount"] = uData.socialOrganizationKaaryakartaaCount.toString();
    dashboardData["PratidnyitCount"] = uData.pratidnyitCount.toString();
    dashboardData["DailyShaakhaaKaaryakartaaCount"] = uData.dailyShaakhaaKaaryakartaaCount.toString();
    dashboardData["SaaptaahikMilanKaaryakartaaCount"] = uData.saaptaahikMilanKaaryakartaaCount.toString();
    dashboardData["MaasikMilanKaaryakartaaCount"] = uData.maasikMilanKaaryakartaaCount.toString();
    dashboardData["AkhilBhaaratiyaKaaryakartaaCount"] = uData.akhilBhaaratiyaKaaryakartaaCount.toString();
    dashboardData["TotalSwayamsevakCount"] = uData.totalSwayamsevakCount.toString();
  });
}

Future<List<StaticMasterBAL>> getStaticLDB(String entityType) async {
  print("getStaticLDB == $entityType");
  List<StaticMasterBAL> _staticMaster = [];
  var result = await DatabaseHelper.getData("Select * from StaticMaster Where EntityType='" + entityType + "' ORDER BY DisplaySequence;");
  // log("resultresult =-=->  ${result}");
  result.forEach((element) {
    var info = StaticMasterBAL.fromMap(element);
    _staticMaster.add(info);
  });
  return _staticMaster;
}

Future<List<StateMasterBAL>> getStateLDB(String type) async {
  List<StateMasterBAL> _stateMaster = [];
  try {
    var result = await DatabaseHelper.getData(
      "Select * from StateMaster" + (type == "Current" ? " Where StateName = 'MAHARASHTRA' OR  StateName = 'GOA' OR StateName = 'महाराष्ट्र' OR StateName = 'गोवा';" : ";"),
    );

    result.forEach((element) {
      var info = StateMasterBAL.fromMap(element);
      _stateMaster.add(info);
    });
  } on Exception catch (error) {
    showToast(error);
  }
  return _stateMaster;
}

Future<List<GeoUnitMasterBAL>> getGeoUnitsLDB(String levelID, String unitName) async {
  List<GeoUnitMasterBAL> _geoUnitMasterBAL = [];
  var result;

  result = await DatabaseHelper.getData(
    "Select GeoUnitMaster.* , " +
        " CASE GeoUnitMaster.LevelID WHEN 9 THEN GeoUnitMaster.GeoUnitName  " +
        " WHEN 8 THEN GeoUnitMaster.GeoUnitName || '-' ||Mahaanagar.GeoUnitName  " +
        " WHEN 7 THEN GeoUnitMaster.GeoUnitName || '-' || Vibhaag.GeoUnitName || '-' ||Mahaanagar.GeoUnitName " +
        " WHEN 6 THEN GeoUnitMaster.GeoUnitName || '-' || Bhaag.GeoUnitName " +
        " || '-' || Vibhaag.GeoUnitName || '-' ||Mahaanagar.GeoUnitName " +
        " WHEN 5 THEN GeoUnitMaster.GeoUnitName || '-' || IFNULL(Nagar.GeoUnitName,'') || '-' || Bhaag.GeoUnitName " +
        " || '-' || Vibhaag.GeoUnitName || '-' ||Mahaanagar.GeoUnitName  " +
        " WHEN 4 THEN GeoUnitMaster.GeoUnitName || '-' || IFNULL(Shahar.GeoUnitName,'') || '-' || IFNULL(Nagar.GeoUnitName,'') || '-' || Bhaag.GeoUnitName " +
        " || '-' || Vibhaag.GeoUnitName || '-' ||Mahaanagar.GeoUnitName " +
        " WHEN 3 THEN GeoUnitMaster.GeoUnitName || '-' || IFNULL(Mandal.GeoUnitName,'') || '-' || IFNULL(Shahar.GeoUnitName,'') || '-' || IFNULL(Nagar.GeoUnitName,'') || '-' || Bhaag.GeoUnitName " +
        " || '-' || Vibhaag.GeoUnitName || '-' ||Mahaanagar.GeoUnitName  " +
        " WHEN 2 THEN GeoUnitMaster.GeoUnitName || (CASE WHEN GeoUnitMaster.HasGraaminKshetra THEN '-' || IFNULL(Mandal.GeoUnitName,'') || '-' || IFNULL(Shahar.GeoUnitName,'')  ELSE '' END) || '-' || IFNULL(Nagar.GeoUnitName,'') || '-' || Bhaag.GeoUnitName " +
        " || '-' || Vibhaag.GeoUnitName || '-' ||Mahaanagar.GeoUnitName  " +
        " WHEN 1 THEN GeoUnitMaster.GeoUnitName || '-' || IFNULL(Vasti.GeoUnitName,'') || (CASE WHEN GeoUnitMaster.HasGraaminKshetra THEN '-' || IFNULL(Graam.GeoUnitName,'') || '-' || IFNULL(Mandal.GeoUnitName,'') || '-' || IFNULL(Shahar.GeoUnitName,'') ELSE '' END) || '-' || IFNULL(Nagar.GeoUnitName,'') || '-' || Bhaag.GeoUnitName " +
        " || '-' || Vibhaag.GeoUnitName || '-' ||Mahaanagar.GeoUnitName  " +
        " ELSE  GeoUnitMaster.GeoUnitName END as FullName from GeoUnitMaster " +
        " LEFT JOIN LevelMaster ON LevelMaster.LevelID = GeoUnitMaster.LevelID " +
        " LEFT JOIN GeoUnitMaster AS Kshetra ON Kshetra.GeoUnitID = GeoUnitMaster.ParentKshetraID " +
        " LEFT JOIN GeoUnitMaster AS Praant ON Praant.GeoUnitID = GeoUnitMaster.ParentPraantID " +
        " LEFT JOIN GeoUnitMaster AS Mahaanagar ON Mahaanagar.GeoUnitID = GeoUnitMaster.ParentMahaanagarID " +
        " LEFT JOIN GeoUnitMaster AS Vibhaag ON Vibhaag.GeoUnitID = GeoUnitMaster.ParentVibhaagID " +
        " LEFT JOIN GeoUnitMaster AS Bhaag ON Bhaag.GeoUnitID = GeoUnitMaster.ParentBhaagID " +
        " LEFT JOIN GeoUnitMaster AS Nagar ON Nagar.GeoUnitID = GeoUnitMaster.ParentNagarID " +
        " LEFT JOIN GeoUnitMaster AS Shahar ON Shahar.GeoUnitID = GeoUnitMaster.ParentShaharID " +
        " LEFT JOIN GeoUnitMaster AS Mandal ON Mandal.GeoUnitID = GeoUnitMaster.ParentMandalID " +
        " LEFT JOIN GeoUnitMaster AS Graam ON Graam.GeoUnitID = GeoUnitMaster.ParentGraamID " +
        " LEFT JOIN GeoUnitMaster AS Vasti ON Vasti.GeoUnitID = GeoUnitMaster.ParentVastiID " +
        " where GeoUnitMaster.LevelID = " +
        levelID +
        (unitName == "" ? "" : " AND GeoUnitMaster.GeoUnitName LIKE \'$unitName%\'") +
        ";",
  );

  result.forEach((element) {
    var info = GeoUnitMasterBAL.fromJson(element);
    _geoUnitMasterBAL.add(info);
  });
  return _geoUnitMasterBAL;
}

Future<List<LevelMasterBAL>> getLevelLDB() async {
  List<LevelMasterBAL> _levelMasterBAL = [];
  var result = await DatabaseHelper.getData("Select * from LevelMaster;");

  result.forEach((element) {
    var info = LevelMasterBAL.fromMap(element);
    _levelMasterBAL.add(info);
  });

  return _levelMasterBAL;
}

Future<List<AayaamMasterBAL>> getAayamLDB() async {
  List<AayaamMasterBAL> _aayamMasterBAL = [];
  var result = await DatabaseHelper.getData("Select * from AayaamMaster;");

  result.forEach((element) {
    var info = AayaamMasterBAL.fromMap(element);
    _aayamMasterBAL.add(info);
  });

  return _aayamMasterBAL;
}

Future<List<GatividhiMasterBAL>> getGatividhiLDB() async {
  List<GatividhiMasterBAL> _gatividhiMasterBAL = [];
  var result = await DatabaseHelper.getData("Select * from GatividhiMaster;");

  result.forEach((element) {
    var info = GatividhiMasterBAL.fromMap(element);
    _gatividhiMasterBAL.add(info);
  });

  return _gatividhiMasterBAL;
}

Future<List<GeoUnitMasterBAL>> getGeoUnitsByLevel(String levelID) async {
  var result = await DatabaseHelper.getData('Select * from GeoUnitMaster WHERE LevelID=' + levelID + '  ORDER BY GeoUnitMaster.DisplaySequence;');

  List<GeoUnitMasterBAL> _geounitList = <GeoUnitMasterBAL>[];
  result.forEach((data) {
    var info = GeoUnitMasterBAL(
      data['GeoUnitID'],
      data['PraantID'],
      data['LevelID'],
      data['GeoUnitName'],
      "",
      "",
      data['GeoUnitName'],
      data['DisplaySequence'],
      null,
      data['ParentKshetraID'],
      data['ParentPraantID'],
      data['ParentMahaanagarID'],
      data['ParentVibhaagID'],
      data['ParentBhaagID'],
      data['ParentNagarID'],
      data['ParentShaharID'],
      data['ParentMandalID'],
      data['ParentVastiID'],
      data['ParentGraamID'],
    );
    _geounitList.add(info);
  });
  return _geounitList;
}

//===================================================================================================================================================================
Future<List<GeoUnitMasterBAL>> getGeoUnitsByLevelAndParentForVasti(String levelID, String parentID, String parentType, String pattern) async {
  String? add = '';
  if (levelID == "9") {
    add = " AND GeoUnitID in  (select ParentMahaanagarID from GeoUnitMaster where LevelID=2)";
  } else if (levelID == "8") {
    add = " AND  GeoUnitID in  (select ParentVibhaagID from GeoUnitMaster where LevelID=2)";
  } else if (levelID == "7") {
    add = " AND GeoUnitID in  (select ParentBhaagID from GeoUnitMaster where LevelID=2)";
  } else if (levelID == "6") {
    add = " AND GeoUnitID in  (select ParentNagarID from GeoUnitMaster where LevelID=2)";
  }

  if (parentID == '') parentID = '0';
  String strSql = "Select * from GeoUnitMaster WHERE LevelID=" +
      levelID +
      add +
      (parentType != ""
          ? parentType == "Praant"
              ? " AND ParentPraantID=" + parentID
              : parentType == "Mahaanagar"
                  ? " AND ParentMahaanagarID=" + parentID
                  : parentType == "Vibhaag"
                      ? " AND COALESCE(ParentVibhaagID,0)=" + parentID
                      : parentType == "Bhaag"
                          ? " AND ParentBhaagID=" + parentID
                          : parentType == "Shahar"
                              ? " AND ParentShaharID=" + parentID
                              : parentType == "Nagar"
                                  ? " AND ParentNagarID=" + parentID
                                  : parentType == "Mandal"
                                      ? " AND ParentMandalID=" + parentID
                                      : parentType == "Graam"
                                          ? " AND ParentGraamID=" + parentID
                                          : parentType == "Vasti"
                                              ? " AND ParentVastiID=" + parentID
                                              : ""
          : "") +
      (pattern == "" ? "" : " AND GeoUnitMaster.GeoUnitName LIKE \'$pattern%\'") +
      " ORDER BY GeoUnitMaster.DisplaySequence;";
  print("strSql ==> $strSql");
  var result = await DatabaseHelper.getData(strSql);

  List<GeoUnitMasterBAL> _geounitList = <GeoUnitMasterBAL>[];
  result.forEach((data) {
    var info = GeoUnitMasterBAL(
      data['GeoUnitID'],
      data['PraantID'],
      data['LevelID'],
      data['GeoUnitName'],
      "",
      "",
      data['GeoUnitName'],
      data['DisplaySequence'],
      null,
      data['ParentKshetraID'],
      data['ParentPraantID'],
      data['ParentMahaanagarID'],
      data['ParentVibhaagID'],
      data['ParentBhaagID'],
      data['ParentNagarID'],
      data['ParentShaharID'],
      data['ParentMandalID'],
      data['ParentVastiID'],
      data['ParentGraamID'],
    );
    _geounitList.add(info);
  });
  return _geounitList;
}

Future<List<GeoUnitMasterBAL>> getGeoUnitsByLevelAndParentForMandal(String levelID, String parentID, String parentType, String pattern) async {
  String? add = '';
  if (levelID == "9") {
    // add = "AND GeoUnitID in  (select ParentMahaanagarID from GeoUnitMaster where LevelID=2)";
  } else if (levelID == "8") {
    add = " AND  GeoUnitID in  (select ParentVibhaagID from GeoUnitMaster where LevelID=4)";
  } else if (levelID == "7") {
    add = " AND GeoUnitID in  (select ParentBhaagID from GeoUnitMaster where LevelID=4)";
  } else if (levelID == "6") {
    add = " AND GeoUnitID in  (select ParentNagarID from GeoUnitMaster where LevelID=4)";
  }

  if (parentID == '') parentID = '0';
  String strSql = "Select * from GeoUnitMaster WHERE LevelID=" +
      levelID +
      add +
      (parentType != ""
          ? parentType == "Praant"
              ? " AND ParentPraantID=" + parentID
              : parentType == "Mahaanagar"
                  ? " AND ParentMahaanagarID=" + parentID
                  : parentType == "Vibhaag"
                      ? " AND COALESCE(ParentVibhaagID,0)=" + parentID
                      : parentType == "Bhaag"
                          ? " AND ParentBhaagID=" + parentID
                          : parentType == "Shahar"
                              ? " AND ParentShaharID=" + parentID
                              : parentType == "Nagar"
                                  ? " AND ParentNagarID=" + parentID
                                  : parentType == "Mandal"
                                      ? " AND ParentMandalID=" + parentID
                                      : parentType == "Graam"
                                          ? " AND ParentGraamID=" + parentID
                                          : parentType == "Vasti"
                                              ? " AND ParentVastiID=" + parentID
                                              : ""
          : "") +
      (pattern == "" ? "" : " AND GeoUnitMaster.GeoUnitName LIKE \'$pattern%\'") +
      " ORDER BY GeoUnitMaster.DisplaySequence;";
  // print("strSql ==> $strSql");
  var result = await DatabaseHelper.getData(strSql);

  List<GeoUnitMasterBAL> _geounitList = <GeoUnitMasterBAL>[];
  result.forEach((data) {
    var info = GeoUnitMasterBAL(
      data['GeoUnitID'],
      data['PraantID'],
      data['LevelID'],
      data['GeoUnitName'],
      "",
      "",
      data['GeoUnitName'],
      data['DisplaySequence'],
      null,
      data['ParentKshetraID'],
      data['ParentPraantID'],
      data['ParentMahaanagarID'],
      data['ParentVibhaagID'],
      data['ParentBhaagID'],
      data['ParentNagarID'],
      data['ParentShaharID'],
      data['ParentMandalID'],
      data['ParentVastiID'],
      data['ParentGraamID'],
    );
    _geounitList.add(info);
  });
  return _geounitList;
}

//===================================================================================================================================================================

Future<List<GeoUnitMasterBAL>> getGeoUnitsByLevelAndParent(String levelID, String parentID, String parentType, String pattern, {bool isAbhiyaan = false}) async {
  if (parentID == '') parentID = '0';
  String strSql = "Select * from ${isAbhiyaan ? "AbhiyaanGeoUnitMaster" : "GeoUnitMaster"} WHERE LevelID=" +
      levelID +
      (parentType != ""
          ? parentType == "Praant"
              ? " AND ParentPraantID=" + parentID
              : parentType == "Mahaanagar"
                  ? " AND ParentMahaanagarID=" + parentID
                  : parentType == "Vibhaag"
                      ? " AND ParentVibhaagID=" + parentID
                      : parentType == "Bhaag"
                          ? " AND ParentBhaagID=" + parentID
                          : parentType == "Shahar"
                              ? " AND ParentShaharID=" + parentID
                              : parentType == "Nagar"
                                  ? " AND ParentNagarID=" + parentID
                                  : parentType == "Mandal"
                                      ? " AND ParentMandalID=" + parentID
                                      : parentType == "Graam"
                                          ? " AND ParentGraamID=" + parentID
                                          : parentType == "Vasti"
                                              ? " AND ParentVastiID=" + parentID
                                              : ""
          : "") +
      (pattern == "" ? "" : " AND ${isAbhiyaan ? "AbhiyaanGeoUnitMaster" : "GeoUnitMaster"}.GeoUnitName LIKE \'$pattern%\'") +
      " ORDER BY ${isAbhiyaan ? "AbhiyaanGeoUnitMaster" : "GeoUnitMaster"}.DisplaySequence;";
  // print("strSql ==> $strSql");
  var result = await DatabaseHelper.getData(strSql);

  List<GeoUnitMasterBAL> _geounitList = <GeoUnitMasterBAL>[];
  result.forEach((data) {
    var info = GeoUnitMasterBAL(
      data['GeoUnitID'],
      data['PraantID'],
      data['LevelID'],
      data['GeoUnitName'],
      "",
      "",
      data['GeoUnitName'],
      data['DisplaySequence'],
      null,
      data['ParentKshetraID'],
      data['ParentPraantID'],
      data['ParentMahaanagarID'],
      data['ParentVibhaagID'],
      data['ParentBhaagID'],
      data['ParentNagarID'],
      data['ParentShaharID'],
      data['ParentMandalID'],
      data['ParentVastiID'],
      data['ParentGraamID'],
    );
    _geounitList.add(info);
  });
  return _geounitList;
}

Future<GeoUnitMasterBAL?> getGeoUnitsByID(String geoUnitID) async {
  var result = await DatabaseHelper.getData(
    " Select GeoUnitMaster.*,GeoUnitMaster.GeoUnitName || '-' || LevelMaster.LevelName AS FullName, LevelMaster.LevelName " +
        "  from GeoUnitMaster Left JOIN LevelMaster ON LevelMaster.LevelID = GeoUnitMaster.LevelID " +
        " WHERE GeoUnitID=" +
        geoUnitID +
        ";",
  );

  GeoUnitMasterBAL _geounit;

  if (result.isNotEmpty) {
    _geounit = GeoUnitMasterBAL(
      result[0]['GeoUnitID'],
      result[0]['PraantID'],
      result[0]['LevelID'],
      result[0]['GeoUnitName'],
      result[0]['FullName'],
      result[0]['LevelName'],
      result[0]['GeoUnitName'],
      result[0]['DisplaySequence'],
      null,
      result[0]['ParentKshetraID'],
      result[0]['ParentPraantID'],
      result[0]['ParentMahaanagarID'],
      result[0]['ParentVibhaagID'],
      result[0]['ParentBhaagID'],
      result[0]['ParentNagarID'],
      result[0]['ParentShaharID'],
      result[0]['ParentMandalID'],
      result[0]['ParentVastiID'],
      result[0]['ParentGraamID'],
    );
    return _geounit;
  } else {
    return null;
  }
}

Future<List<DaayitvaMasterBAL>> getDaayitvaLDB(String _daayitvaForValue, String pattern, String _daayitvaValue) async {
  List<DaayitvaMasterBAL> _daayitvaMasterBAL = [];
  var result;
  if (_daayitvaValue != "") {
    result = await DatabaseHelper.getData("Select * from DaayitvaMaster WHERE DaayitvaID = " + _daayitvaValue + ";");
  } else if (_daayitvaForValue == "") {
    result = await DatabaseHelper.getData("Select * from DaayitvaMaster " + (pattern == "" ? "" : " WHERE DaayitvaName LIKE \'$pattern%\'") + ";");
  } else {
    result = await DatabaseHelper.getData("Select * from DaayitvaMaster where DaayitvaForID = " + _daayitvaForValue + (pattern == "" ? "" : " AND DaayitvaName LIKE \'$pattern%\'") + ";");
  }

  result.forEach((element) {
    var info = DaayitvaMasterBAL.fromMap(element);
    _daayitvaMasterBAL.add(info);
  });

  return _daayitvaMasterBAL;
}

Future<List<UserDataBAL>> getUserDataLDB() async {
  List<UserDataBAL> _userData = [];
  var result = await DatabaseHelper.getData("Select * from UserDataMaster;");

  result.forEach((element) {
    var info = UserDataBAL.fromMap(element);
    _userData.add(info);
  });

  return _userData;
}

Future<List<dynamic>> getHelpVideoList(String strInput) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(Uri.parse(urlGetHelpVideosForApp), headers: jHeaders, body: strInput);
  print(Uri.parse(urlGetHelpVideosForApp));
  print(strInput.toString());
  var responseBody = json.decode(response.body);
  log("Print the body for getHelpVideoList >>>>>>>>>>>>>>>>> $responseBody");

  return responseBody['HelpVideoList'];
}

Future<List<dynamic>> getShaakhaaList(String strInput) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(Uri.parse(urlGetShaakhaasForAppGrid), headers: jHeaders, body: strInput);

  var responseBody = json.decode(response.body);
  log("strInput  ==> $strInput");
  log("responseBody ===>  $responseBody");
  return responseBody['ShaakhaaList'];
}

Future<dynamic> getShaakhaaByID(String shaakhaaID) async {
  print("Shakha IDD :-  {$shaakhaaID}");
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(Uri.parse(urlGetShaakhaaDetailsForApp), headers: jHeaders, body: json.encode({"ShaakhaaID": shaakhaaID}));

  var responseBody = json.decode(response.body);
  var data = responseBody['ShaakhaaItem'];
  print("Search:- $data");

  return ShaakhaaMasterBAL(
    data['ShaakhaaID'],
    data['PraantID'],
    data['GeoUnitID'],
    data['GeoUnitName'],
    data['FrequencyID'],
    data['DaysOfWeek'],
    // dayOfWeek
    data['DayOfMonth'],
    data['VayogatID'],
    data['Location'],
    data['Timing'],
    data['Remark'],
    data['StatusID'],
    data['ParentBhaagID'],
    data['ParentNagarID'],
    data['ParentShaharID'],
    data['ParentMandalID'],
    data['ParentGraamID'],
    data['ParentVastiID'],
    data['IsSankalpit'],
    data['SankalpAadhaar'],
    data['SankalpAadhaar1'],
    data['SankalpAadhaar2'],
    data['SankalpAadhaar3'],
    data['SankalpAadhaarSwayamsevakID'],
    data['SankalpAadhaarSwayamsevakID1'],
    data['SankalpAadhaarSwayamsevakID2'],
    data['SankalpAadhaarSwayamsevakID3'],
    data['SankalpAadhaarSwayamsevakName'],
    data['SankalpAadhaarSwayamsevakName1'],
    data['SankalpAadhaarSwayamsevakName2'],
    data['SankalpAadhaarSwayamsevakName3'],
    data['SankalpAadhaarShaakhaaID'],
    data['SankalpAadhaarShaakhaaID1'],
    data['SankalpAadhaarShaakhaaID2'],
    data['SankalpAadhaarShaakhaaID3'],
    data['SankalpAadhaarShaakhaaName'],
    data['SankalpAadhaarShaakhaaName1'],
    data['SankalpAadhaarShaakhaaName2'],
    data['SankalpAadhaarShaakhaaName3'],
    data['SankalpCompletionMonth'],
    data['SankalpCompletionMonth1'],
    data['SankalpCompletionMonth2'],
    data['SankalpCompletionMonth3'],
    data['SankalpCompletionYear'],
    data['SankalpCompletionYear1'],
    data['SankalpCompletionYear2'],
    data['SankalpCompletionYear3'],
    data['HasToli'],
    data['HasPaalak'],
    data['OptionalShaaririkVishayID'],
    data['OtherOptionalVishay'],
    data['StartTimeStr'],
    // fromTime
    data['EndTimeStr'],
  ); // toTime
}

Future<String> saveShaakhaaDetails(String inputJson) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};
  print("saveShaakhaaDetails:- $inputJson");
  var response = await http.post(Uri.parse(urlSaveShaakhaaAppData), headers: jHeaders, body: inputJson);
  print("saveShaakhaaDetails :- ${response.body.toString()}");
  var responseBody = json.decode(response.body);

  return responseBody['OutputShaakhaaID'].toString();
}

Future<List<dynamic>> getSoochiList(String searchPattern, bool includeOwnedSoochi, bool includeSharedSoochi) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(
    Uri.parse(urlGetSoochisForAppGrid),
    headers: jHeaders,
    body: json.encode({"AppUserID": userDetails['userID'], "SearchCriteria": searchPattern, "IncludeOwned": includeOwnedSoochi, "IncludeShared": includeSharedSoochi}),
  );

  print("Request ==>  ${{"AppUserID": userDetails['userID'], "SearchCriteria": searchPattern, "IncludeOwned": includeOwnedSoochi, "IncludeShared": includeSharedSoochi}}");
  var responseBody = json.decode(response.body);
  // print("getSoochiList ==> ${responseBody['SoochiList']}");
  return responseBody['SoochiList'];
}

Future<dynamic> getSoochiDetails(var soochiID) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(Uri.parse(urlGetSoochiDetailsForApp), headers: jHeaders, body: json.encode({"SoochiID": soochiID}));

  var responseBody = json.decode(response.body);

  var data = responseBody['SoochiItem'];

  return SoochiMasterBAL(data["SoochiID"], data["PraantID"], data["SoochiName"], data["OwnerSwayamsevakID"], data["OwnerSwayamsevakFullName"], data["StatusID"], data["StatusCode"], data["Remark"]);
}

Future<List<dynamic>> getSoochiMembers(var soochiID) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(Uri.parse(urlGetSoochiMembersForApp), headers: jHeaders, body: json.encode({"SoochiID": soochiID}));

  var responseBody = json.decode(response.body);

  return responseBody['MembersList'];
}

Future<List<dynamic>> getSoochiSharing(var soochiID) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(Uri.parse(urlGetSoochiSharingsForApp), headers: jHeaders, body: json.encode({"SoochiID": soochiID}));

  var responseBody = json.decode(response.body);
  print("responseBodyresponseBody ==> $responseBody");

  return responseBody['SharingsList'];
}

Future<String> saveSoochiDetails(String inputJson) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(Uri.parse(urlSaveSoochiAppData), headers: jHeaders, body: inputJson);

  var responseBody = json.decode(response.body);
  print("responseBodyresponseBody ==? $responseBody");
  return responseBody['OutputSoochiID'].toString();
}

Future<String> saveSoochiMembers(String inputJson) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(Uri.parse(urlSaveSoochiMemberAppData), headers: jHeaders, body: inputJson);
  print("responseresponseresponseresponse==>>  ${response.body}");
  var responseBody = json.decode(response.body);
  print("responseBodyresponseBodyresponseBodyresponseBody ::::---- $responseBody");
  return responseBody['OutputSoochiMemberID'].toString();
}

Future<String> saveSoochiSharing(String inputJson) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(Uri.parse(urlSaveSoochiSharingAppData), headers: jHeaders, body: inputJson);
  print("responseresponse ==> $response");
  var responseBody = json.decode(response.body);

  return responseBody['OutputSoochiSharingID'].toString();
}

Future<String> deleteSoochiMembers(String inputJson) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(Uri.parse(urlDeleteSoochiMemberAppData), headers: jHeaders, body: inputJson);

  var responseBody = json.decode(response.body);

  return responseBody['Message'].toString();
}

Future<String> deleteSoochiSharing(String inputJson) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(Uri.parse(urlDeleteSoochiSharingAppData), headers: jHeaders, body: inputJson);

  var responseBody = json.decode(response.body);

  return responseBody['Message'].toString();
}

Future<String> deleteSWDaayitva(String inputJson) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(Uri.parse(urlDeleteSwayamsevakDaayitvaForApp), headers: jHeaders, body: inputJson);

  var responseBody = json.decode(response.body);

  return responseBody['Message'].toString();
}

Future<String> deleteJoinRSS(String inputJson) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};
  print(inputJson);
  var response = await http.post(Uri.parse(urlDeleteJoinRSSForApp), headers: jHeaders, body: inputJson);
  print(response.body);
  var responseBody = json.decode(response.body);

  return responseBody['Message'].toString();
}

Future<String> deleteSoochiForApp(String inputJson) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(Uri.parse(urlDeleteSoochiForApp), headers: jHeaders, body: inputJson);

  var responseBody = json.decode(response.body);

  return responseBody['Message'].toString();
}

Future<String> deleteShaakhaaForApp(String inputJson) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(Uri.parse(urlDeleteShaakhaaForApp), headers: jHeaders, body: inputJson);

  var responseBody = json.decode(response.body);

  return responseBody['Message'].toString();
}

//Future<bool> isCompatibleVersion(String inputJson) async {
Future<dynamic> isCompatibleVersion(String inputJson) async {
  // This method checks if version is compatible and if data sync is required
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(Uri.parse(urlIsVersionCompatibleForApp), headers: jHeaders, body: inputJson);

  var responseBody = json.decode(response.body);
  print(Uri.parse(urlIsVersionCompatibleForApp));
  // log(responseBody);
  //return responseBody['IsVersionCompatible'];
  return responseBody;
}

Future<String> updatePassword(String oldPass, String newpass) async {
  String strInput = "";

  strInput = json.encode({"AppUserID": userDetails["userID"], "PraantID": 1, "OldPassword": oldPass, "NewPassword": newpass});
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(Uri.parse(urlChangePasswordForApp), headers: jHeaders, body: strInput);

  var responseBody = json.decode(response.body);
  print("Update Password ---   strInput => $strInput  \n   responseBody  $responseBody");
  var message = responseBody["Message"];
  if (message == "Operation failed - Incorrect Data; Please try again" || message == "Operation failed - Incorrect Old Password") {
    message = "Incorrect Old Password";
  } else {
    String strSql = "UPDATE UserDataMaster SET " +
        " IsFirstLogin = 0 "
            " WHERE SwayamsevakID = " +
        userDetails["userID"] +
        ";";
    await DatabaseHelper.executeQuery(strSql);
    message = "Password Changed sucessfully";
  }
  return message;
}

Future<bool> checkForTableExists(String table) async {
  String sql = "SELECT name, sql FROM sqlite_master WHERE type='table' AND name='" + table + "'";
  var result = await DatabaseHelper.getData(sql);
  if (result.length > 0) {
    //String fieldList = result.first.values.toList()[1];
    return true;
  }
  return false;
}

Future<String> updateProfileData(String strFieldName, String strFieldValue, String strFieldValueCode) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  String strInput = json.encode({"SwayamsevakID": int.parse(userDetails["userID"]), "FieldName": strFieldName, "FieldValue": strFieldValue});

  var response = await http.post(Uri.parse(urlSaveMyProfileAppData), headers: jHeaders, body: strInput);

  var responseBody = json.decode(response.body);

  var message = responseBody["Message"];
  if (message.toString().startsWith("Operation failed")) {
    message = "Cannot Update Settings";
  } else {
    String strSql = "UPDATE UserDataMaster SET " +
        strFieldName +
        " = " +
        strFieldValue +
        (strFieldValueCode == "" ? "" : ", PreferredLanguageCode  = '" + strFieldValueCode + "' ") +
        " WHERE SwayamsevakID = " +
        userDetails["userID"] +
        ";";
    await DatabaseHelper.executeQuery(strSql);
    await populateUserDetailsMap();
    await populateUserAbhiyaanDetailsMap();
    message = "Data Saved sucessfully";
  }
  return message;
}

Future<String> resetPassword(String swayamSevakID) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(Uri.parse(urlResetAppPassword), headers: jHeaders, body: json.encode({"SwayamsevakID": swayamSevakID}));

  var responseBody = json.decode(response.body);

  return responseBody['Message'];
}

Future<String> refreshData() async {
  print("started");
  try {
    Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

    var response = await http.post(Uri.parse(urlResetDataForApp), headers: jHeaders, body: json.encode({"AppUserID": userDetails["userID"]}));

    print(response.request!.url);

    var responseBody = json.decode(response.body);
    print(response.body);
    var dataList = responseBody['ResetData']['GeoUnitList'];
    var dataStaticMaster = responseBody['ResetData']['StaticMasterList'];

    if (dataList.length > 0) {
      print(dataList.length);
      await DatabaseHelper.reCreate('GeoUnitMaster', dataList);
    }

    if (dataStaticMaster.length > 0) {
      await DatabaseHelper.reCreate('StaticMaster', dataStaticMaster);
    }
    return "Successfull";
  } catch (e) {
    print(e);
    return "Failed";
  }
}

Future<dynamic> refreshDashboardData(String? userID, String? targetGeoUnitID) async {
  print("${userID}  --- $targetGeoUnitID  ");
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(Uri.parse(urlRefreshHomeScreenForApp), headers: jHeaders, body: json.encode({"AppUserID": userID, "TargetGeoUnitID": targetGeoUnitID}));

  print(json.encode({"AppUserID": userID, "TargetGeoUnitID": targetGeoUnitID}));

  var responseBody = json.decode(response.body);

  var dataList = responseBody['HomeScreenData'];
  var listShaakhaaCountByVayogat = responseBody['HomeScreenData']['ListShaakhaaCountByVayogat'];
  var listKaaryakartaaCountByGatividhi = responseBody['HomeScreenData']['ListKaaryakartaaCountByGatividhi'];
  var listKaaryakartaaCountByAayaam = responseBody['HomeScreenData']['ListKaaryakartaaCountByAayaam'];
  var listKaaryakartaaCountByPreritSansthaa = responseBody['HomeScreenData']['ListSanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation'];
  var listKaaryakartaaCountBySocialOrg = responseBody['HomeScreenData']['ListSocialOrganizationKaaryakartaaCountByAreaOfOperation'];
  var listStudentCountByCategory = responseBody['HomeScreenData']['ListSwayamsevakCountByStudentCategory'];
  var listVyavasaayeeCountByCategory = responseBody['HomeScreenData']['ListSwayamsevakCountByVyavasaayeeCategory'];
  var listYesterdayVruttaDetail = responseBody['HomeScreenData']['ListYesterdayVrutta'];
  var listYesterdayVruttaSummary = responseBody['HomeScreenData']['ListYesterdayVruttaSummary'];
  var listYesterdayPraantShaakhaaCountByVayogat = responseBody['HomeScreenData']['ListYesterdayPraantShaakhaaCountByVayogat'];
  var listSankalpByAadhaar = responseBody['HomeScreenData']['ListSankalpByAadhaar'];
  var listBhaugolikVistaar = responseBody['HomeScreenData']['BhaugolikVistaarData'];
  // var listLastMonthBhaugolikVistaar = responseBody['HomeScreenData']['LastMonthBhaugolikVistaarData'];
  var listAppVersion = responseBody['HomeScreenData']['AppVersion'];
  var message = responseBody['Message'];

  if (message == "Home Screen Data Returned") {
    lstdashboardSadyaSthitiData = [];
    if (listShaakhaaCountByVayogat.length > 0) {
      int shaakhaa = 0, mandali = 0, maasik = 0, saaptaa = 0, sankalpitShaakhaa = 0, sankalpitSaaptaa = 0;
      int sankalpitMaasikMilanCount = 0, sankalpitSanghaMandaliCount = 0, registersanghMandali = 0, registermasikMilan = 0;

      int shaakhaaTotal = 0, mandaliTotal = 0, maasikTotal = 0, saaptaaTotal = 0, sankalpitMaasikMilanCountTotal = 0, sankalpitSanghaMandaliCountTotal = 0;
      int sankalpitShaakhaaTotal = 0, sankalpitSaaptaaTotal = 0;
      for (var data in listShaakhaaCountByVayogat) {
        shaakhaa = data['ShaakhaaCount'] == null ? 0 : data['ShaakhaaCount'];
        shaakhaaTotal = shaakhaaTotal + shaakhaa;

        mandali = data['SanghaMandaliCount'] == null ? 0 : data['SanghaMandaliCount'];
        mandaliTotal = mandaliTotal + mandali;

        saaptaa = data['SaaptaahikCount'] == null ? 0 : data['SaaptaahikCount'];
        saaptaaTotal = saaptaaTotal + saaptaa;

        maasik = data['MaasikMilanCount'] == null ? 0 : data['MaasikMilanCount'];
        maasikTotal = maasikTotal + maasik;

        sankalpitShaakhaa = data['SankalpitShaakhaaCount'] == null ? 0 : data['SankalpitShaakhaaCount'];
        sankalpitShaakhaaTotal = sankalpitShaakhaaTotal + sankalpitShaakhaa;

        sankalpitSaaptaa = data['SankalpitSaaptaahikCount'] == null ? 0 : data['SankalpitSaaptaahikCount'];
        sankalpitSaaptaaTotal = sankalpitSaaptaaTotal + sankalpitSaaptaa;

        sankalpitMaasikMilanCount = data['SankalpitMaasikMilanCount'] == null ? 0 : data['SankalpitMaasikMilanCount'];
        sankalpitMaasikMilanCountTotal = sankalpitMaasikMilanCountTotal + sankalpitMaasikMilanCount;

        sankalpitSanghaMandaliCount = data['SankalpitSanghaMandaliCount'] == null ? 0 : data['SankalpitSanghaMandaliCount'];
        sankalpitSanghaMandaliCountTotal = sankalpitSanghaMandaliCountTotal + sankalpitSanghaMandaliCount;

        lstdashboardSadyaSthitiData.add(
          new DashboardSadyaSthitiDataBAL(
            data['VayogatID'],
            data['VayogatCode'],
            shaakhaa,
            mandali,
            saaptaa,
            maasik,
            sankalpitShaakhaa,
            sankalpitSaaptaa,
            sankalpitMaasikMilanCount,
            sankalpitSanghaMandaliCount,
          ),
        );
      }
      // Totals row
      lstdashboardSadyaSthitiData.add(
        new DashboardSadyaSthitiDataBAL(
          -1,
          getLabel('Total'),
          shaakhaaTotal,
          mandaliTotal,
          saaptaaTotal,
          maasikTotal,
          sankalpitShaakhaaTotal,
          sankalpitSaaptaaTotal,
          sankalpitMaasikMilanCountTotal,
          sankalpitSanghaMandaliCountTotal,
        ),
      );
    }

    lstGatividhiKaaryakartaa = [];
    if (listKaaryakartaaCountByGatividhi.length > 0) {
      int kartaaCount = 0, totalCount = 0;
      for (var data in listKaaryakartaaCountByGatividhi) {
        kartaaCount = (data['KaaryakartaaCount'] == null ? 0 : data['KaaryakartaaCount']);
        totalCount = totalCount + kartaaCount;
        lstGatividhiKaaryakartaa.add(new GatividhiKaaryakartaaCountBAL(data['GatividhiID'], data['GatividhiName'], kartaaCount));
      }
      // Totals row
      lstGatividhiKaaryakartaa.add(new GatividhiKaaryakartaaCountBAL(0, getLabel('Total'), totalCount));
    }

    lstAayaamKaaryakartaa = [];
    if (listKaaryakartaaCountByAayaam.length > 0) {
      int kartaaCount = 0, totalCount = 0;
      for (var data in listKaaryakartaaCountByAayaam) {
        kartaaCount = (data['KaaryakartaaCount'] == null ? 0 : data['KaaryakartaaCount']);
        totalCount = totalCount + kartaaCount;
        lstAayaamKaaryakartaa.add(new AayaamKaaryakartaaCountBAL(data['AayaamID'], data['AayaamName'], kartaaCount));
      }
      // Totals row
      lstAayaamKaaryakartaa.add(new AayaamKaaryakartaaCountBAL(0, getLabel('Total'), totalCount));
    }

    lstPreritKaaryakartaa = [];
    if (listKaaryakartaaCountByPreritSansthaa.length > 0) {
      int kartaaCount = 0, totalCount = 0;
      for (var data in listKaaryakartaaCountByPreritSansthaa) {
        kartaaCount = (data['KaaryakartaaCount'] == null ? 0 : data['KaaryakartaaCount']);
        totalCount = totalCount + kartaaCount;
        lstPreritKaaryakartaa.add(
          new PreritKaaryakartaaCountBAL(
            // data['PreritAOOID'],
            // data['PreritAOOName'],
            data['AreaOfOperationID'],
            data['AreaOfOperation'],
            kartaaCount,
          ),
        );
      }
      // Totals row
      lstPreritKaaryakartaa.add(
        new PreritKaaryakartaaCountBAL(
          // data['PreritAOOID'],
          // data['PreritAOOName'],
          0,
          getLabel('Total'),
          totalCount,
        ),
      );
    }

    lstSocialOrgKaaryakartaa = [];
    if (listKaaryakartaaCountBySocialOrg.length > 0) {
      int kartaaCount = 0, totalCount = 0;
      for (var data in listKaaryakartaaCountBySocialOrg) {
        kartaaCount = (data['KaaryakartaaCount'] == null ? 0 : data['KaaryakartaaCount']);
        totalCount = totalCount + kartaaCount;
        lstSocialOrgKaaryakartaa.add(
          new SocialOrgKaaryakartaaCountBAL(
            // data['MainAOOID'],
            // data['MainAOOName'],
            data['MainAreaOfOperationID'],
            data['AreaOfOperation'],
            kartaaCount,
          ),
        );
      }
      // Totals row
      lstSocialOrgKaaryakartaa.add(
        new SocialOrgKaaryakartaaCountBAL(
          // data['MainAOOID'],
          // data['MainAOOName'],
          0,
          getLabel('Total'),
          totalCount,
        ),
      );
    }

    lstStudentCategory = [];
    if (listStudentCountByCategory.length > 0) {
      int studentCount = 0, totalStudent = 0;
      for (var data in listStudentCountByCategory) {
        studentCount = (data['CountByStudentCategory'] == null ? 0 : data['CountByStudentCategory']);
        totalStudent = totalStudent + studentCount;
        lstStudentCategory.add(new StudentCategoryCountBAL(data['StudentCategoryID'], data['StudentCategoryName'], studentCount));
      }
      // Totals row
      lstStudentCategory.add(new StudentCategoryCountBAL(0, getLabel('Total'), totalStudent));
    }

    lstVyavasaayeeCategory = [];
    if (listVyavasaayeeCountByCategory.length > 0) {
      int vyavasaayeeCount = 0, totalVyavasaayee = 0;
      for (var data in listVyavasaayeeCountByCategory) {
        vyavasaayeeCount = (data['CountByVyavasaayeeCategory'] == null ? 0 : data['CountByVyavasaayeeCategory']);
        totalVyavasaayee = totalVyavasaayee + vyavasaayeeCount;
        lstVyavasaayeeCategory.add(new VyavasaayeeCategoryCountBAL(data['VyavasaayeeCategoryID'], data['VyavasaayeeCategoryName'], vyavasaayeeCount));
      }
      // Totals row
      lstVyavasaayeeCategory.add(new VyavasaayeeCategoryCountBAL(0, getLabel('Total'), totalVyavasaayee));
    }

    lstYesterdayVruttaDetail = [];
    if (listYesterdayVruttaDetail.length > 0) {
      int baalCnt = 0, totalBaal = 0, tarunVidyaarthiCnt = 0, totalTarunVidyaarthi = 0;
      int tarunVyavasaayeeCnt = 0, totalTarunVyavasaayee = 0, proudhCnt = 0, totalProudh = 0;
      int shishuCnt = 0, totalShishu = 0, abhyaagatCnt = 0, totalAbhyaagat = 0;
      for (var data in listYesterdayVruttaDetail) {
        baalCnt = (data['BaalVidyaarthiCount'] == null ? 0 : data['BaalVidyaarthiCount']);
        totalBaal = totalBaal + baalCnt;
        tarunVidyaarthiCnt = (data['TarunVidyaarthiCount'] == null ? 0 : data['TarunVidyaarthiCount']);
        totalTarunVidyaarthi = totalTarunVidyaarthi + tarunVidyaarthiCnt;
        tarunVyavasaayeeCnt = (data['TarunVyavasaayeeCount'] == null ? 0 : data['TarunVyavasaayeeCount']);
        totalTarunVyavasaayee = totalTarunVyavasaayee + tarunVyavasaayeeCnt;
        proudhCnt = (data['ProudhaVyavasaayeeCount'] == null ? 0 : data['ProudhaVyavasaayeeCount']);
        totalProudh = totalProudh + proudhCnt;
        shishuCnt = (data['ShishuCount'] == null ? 0 : data['ShishuCount']);
        totalShishu = totalShishu + shishuCnt;
        abhyaagatCnt = (data['AbhyaagatCount'] == null ? 0 : data['AbhyaagatCount']);
        totalAbhyaagat = totalAbhyaagat + abhyaagatCnt;
        lstYesterdayVruttaDetail.add(
          new YesterdayVruttaDetailBAL(
            data['GeoUnitID'],
            data['ShaakhaaID'],
            data['GeoUnitName'],
            data['FrequencyID'],
            data['FrequencyCode'],
            data['VayogatID'],
            data['VayogatCode'],
            shishuCnt,
            baalCnt,
            tarunVidyaarthiCnt,
            tarunVyavasaayeeCnt,
            proudhCnt,
            abhyaagatCnt,
          ),
        );
      }
      // Totals row
      lstYesterdayVruttaDetail.add(
        new YesterdayVruttaDetailBAL(0, 0, getLabel('Total'), 0, '', 0, '', totalShishu, totalBaal, totalTarunVidyaarthi, totalTarunVyavasaayee, totalProudh, totalAbhyaagat),
      );
    }

    lstYesterdayVruttaSummary = [];
    if (listYesterdayVruttaSummary.length > 0) {
      int shCnt = 0, totalShaakhaa = 0, spCnt = 0, totalSaaptaa = 0, mdCnt = 0, totalMandali = 0;
      for (var data in listYesterdayVruttaSummary) {
        shCnt = (data['ShaakhaaCount'] == null ? 0 : data['ShaakhaaCount']);
        totalShaakhaa = totalShaakhaa + shCnt;
        spCnt = (data['SaaptaahikCount'] == null ? 0 : data['SaaptaahikCount']);
        totalSaaptaa = totalSaaptaa + spCnt;
        mdCnt = (data['MilanMandaliCount'] == null ? 0 : data['MilanMandaliCount']);
        totalMandali = totalMandali + mdCnt;
        lstYesterdayVruttaSummary.add(new YesterdayVruttaSummaryBAL(data['GeoUnitID'], data['GeoUnitName'], data['VayogatID'], data['VayogatCode'], shCnt, spCnt, mdCnt));
      }
      // Totals row
      lstYesterdayVruttaSummary.add(new YesterdayVruttaSummaryBAL(0, getLabel('Total'), 0, '', totalShaakhaa, totalSaaptaa, totalMandali));
    }

    lstYesterdayPraantData = [];
    if (listYesterdayPraantShaakhaaCountByVayogat.length > 0) {
      int shaakhaa = 0, saaptaa = 0;
      int shaakhaaTotal = 0, saaptaaTotal = 0;
      for (var data in listYesterdayPraantShaakhaaCountByVayogat) {
        shaakhaa = data['ShaakhaaCount'] == null ? 0 : data['ShaakhaaCount'];
        shaakhaaTotal = shaakhaaTotal + shaakhaa;
        saaptaa = data['SaaptaahikCount'] == null ? 0 : data['SaaptaahikCount'];
        saaptaaTotal = saaptaaTotal + saaptaa;
        lstYesterdayPraantData.add(new DashboardSadyaSthitiDataBAL(data['VayogatID'], data['VayogatCode'], shaakhaa, null, saaptaa, null, null, null, null, null));
      }
      // Totals row
      lstYesterdayPraantData.add(new DashboardSadyaSthitiDataBAL(0, getLabel('Total'), shaakhaaTotal, null, saaptaaTotal, null, null, null, null, null));
    }

    lstSankalpByAadhaarData = [];
    if (listSankalpByAadhaar.length > 0) {
      int maasikMilanCount = 0,
          sanghaMandaliCount = 0,
          shaakhaa = 0,
          saaptaa = 0,
          totalShaakhaa = 0,
          totalSaaptaa = 0,
          totalmaasikMilanCount = 0,
          totalsanghaMandaliCount = 0,
          totalsankalpitSanghaMandalikCount = 0,
          totalsankalpitMasikMilankCount = 0,
          sankalpitSanghaMandalikCount = 0,
          sankalpitMasikMilankCount = 0;
      for (var data in listSankalpByAadhaar) {
        shaakhaa = (data['SankalpitShaakhaaCount'] == null ? 0 : data['SankalpitShaakhaaCount']);
        totalShaakhaa = totalShaakhaa + shaakhaa;

        saaptaa = (data['SankalpitSaaptaahikCount'] == null ? 0 : data['SankalpitSaaptaahikCount']);
        totalSaaptaa = totalSaaptaa + saaptaa;

        sankalpitMasikMilankCount = (data['SankalpitMasikMilankCount'] == null ? 0 : data['SankalpitMasikMilankCount']);
        totalsankalpitMasikMilankCount = totalsankalpitMasikMilankCount + sankalpitMasikMilankCount;

        sankalpitSanghaMandalikCount = (data['SankalpitSanghaMandalikCount'] == null ? 0 : data['SankalpitSanghaMandalikCount']);
        totalsankalpitSanghaMandalikCount = totalsankalpitSanghaMandalikCount + sankalpitSanghaMandalikCount;

        if (shaakhaa == 0 && saaptaa == 0) continue;
        lstSankalpByAadhaarData.add(
          new SankalpByAadhaarBAL(data['VayogatID'], data['VayogatCode'], data['SankalpAadhaar'], shaakhaa, saaptaa, sankalpitMasikMilankCount, sankalpitSanghaMandalikCount),
        );
      }
      // Totals row
      lstSankalpByAadhaarData.add(new SankalpByAadhaarBAL(0, getLabel('Total'), '', totalShaakhaa, totalSaaptaa, totalsankalpitMasikMilankCount, totalsankalpitSanghaMandalikCount));
    }

    lstBhaugolikVistaar = [];
    if (listBhaugolikVistaar.length > 0) {
      if (listBhaugolikVistaar['TotalNagarCount'] != null && listBhaugolikVistaar['TotalNagarCount'] > 0) {
        lstBhaugolikVistaar.add(
          new BhaugolikVistaarBAL(
            'Nagar',
            listBhaugolikVistaar['TotalNagarCount'],
            listBhaugolikVistaar['ShaakhaaYuktaNagarCount'],
            listBhaugolikVistaar['SaaptaahikYuktaNagarCount'],
            listBhaugolikVistaar['MandaliYuktaNagarCount'],
            listBhaugolikVistaar['GatividhiYuktaNagarCount'],
          ),
        );
      }
      if (listBhaugolikVistaar['TotalNagarCountGraamin'] != null && listBhaugolikVistaar['TotalNagarCountGraamin'] > 0) {
        lstBhaugolikVistaar.add(
          new BhaugolikVistaarBAL(
            'NagarGraamin',
            listBhaugolikVistaar['TotalNagarCountGraamin'],
            listBhaugolikVistaar['ShaakhaaYuktaNagarCountGraamin'],
            listBhaugolikVistaar['SaaptaahikYuktaNagarCountGraamin'],
            listBhaugolikVistaar['MandaliYuktaNagarCountGraamin'],
            listBhaugolikVistaar['GatividhiYuktaNagarCountGraamin'],
          ),
        );
      }
      if (listBhaugolikVistaar['TotalNagarCountShahari'] != null && listBhaugolikVistaar['TotalNagarCountShahari'] > 0) {
        lstBhaugolikVistaar.add(
          new BhaugolikVistaarBAL(
            'NagarShahari',
            listBhaugolikVistaar['TotalNagarCountShahari'],
            listBhaugolikVistaar['ShaakhaaYuktaNagarCountShahari'],
            listBhaugolikVistaar['SaaptaahikYuktaNagarCountShahari'],
            listBhaugolikVistaar['MandaliYuktaNagarCountShahari'],
            listBhaugolikVistaar['GatividhiYuktaNagarCountShahari'],
          ),
        );
      }
      // if (listBhaugolikVistaar['TotalShaharCount'] != null && listBhaugolikVistaar['TotalShaharCount'] > 0){
      //   lstBhaugolikVistaar.add(new BhaugolikVistaarBAL(
      //     'Shahar',
      //     listBhaugolikVistaar['TotalShaharCount'],
      //     listBhaugolikVistaar['ShaakhaaYuktaShaharCount'],
      //     listBhaugolikVistaar['SaaptaahikYuktaShaharCount'],
      //     listBhaugolikVistaar['MandaliYuktaShaharCount'],
      //     listBhaugolikVistaar['GatividhiYuktaShaharCount']
      //   ));
      // }
      if (listBhaugolikVistaar['TotalMandalCount'] != null && listBhaugolikVistaar['TotalMandalCount'] > 0) {
        lstBhaugolikVistaar.add(
          new BhaugolikVistaarBAL(
            'Mandal',
            listBhaugolikVistaar['TotalMandalCount'],
            listBhaugolikVistaar['ShaakhaaYuktaMandalCount'],
            listBhaugolikVistaar['SaaptaahikYuktaMandalCount'],
            listBhaugolikVistaar['MandaliYuktaMandalCount'],
            listBhaugolikVistaar['GatividhiYuktaMandalCount'],
          ),
        );
      }
      if (listBhaugolikVistaar['TotalGraamCount'] != null && listBhaugolikVistaar['TotalGraamCount'] > 0) {
        lstBhaugolikVistaar.add(
          new BhaugolikVistaarBAL(
            'Graam',
            listBhaugolikVistaar['TotalGraamCount'],
            listBhaugolikVistaar['ShaakhaaYuktaGraamCount'],
            listBhaugolikVistaar['SaaptaahikYuktaGraamCount'],
            listBhaugolikVistaar['MandaliYuktaGraamCount'],
            listBhaugolikVistaar['GatividhiYuktaGraamCount'],
          ),
        );
      }
      if (listBhaugolikVistaar['TotalVastiCount'] != null && listBhaugolikVistaar['TotalVastiCount'] > 0) {
        lstBhaugolikVistaar.add(
          new BhaugolikVistaarBAL(
            'Vasti',
            listBhaugolikVistaar['TotalVastiCount'],
            listBhaugolikVistaar['ShaakhaaYuktaVastiCount'],
            listBhaugolikVistaar['SaaptaahikYuktaVastiCount'],
            listBhaugolikVistaar['MandaliYuktaVastiCount'],
            listBhaugolikVistaar['GatividhiYuktaVastiCount'],
          ),
        );
      }
    }

    // lstLastMonthBhaugolikVistaar = [];
    // if (listLastMonthBhaugolikVistaar != null && listLastMonthBhaugolikVistaar.length > 0) {
    //   if (listLastMonthBhaugolikVistaar['TotalNagarCount'] != null && listLastMonthBhaugolikVistaar['TotalNagarCount'] > 0){
    //     lstLastMonthBhaugolikVistaar.add(new BhaugolikVistaarBAL(
    //       'Nagar',
    //       listLastMonthBhaugolikVistaar['TotalNagarCount'],
    //       listLastMonthBhaugolikVistaar['ShaakhaaYuktaNagarCount'],
    //       listLastMonthBhaugolikVistaar['SaaptaahikYuktaNagarCount'],
    //       listLastMonthBhaugolikVistaar['MandaliYuktaNagarCount'],
    //       listLastMonthBhaugolikVistaar['GatividhiYuktaNagarCount']
    //     ));
    //   }
    //   if (listLastMonthBhaugolikVistaar['TotalNagarCountGraamin'] != null && listLastMonthBhaugolikVistaar['TotalNagarCountGraamin'] > 0){
    //     lstLastMonthBhaugolikVistaar.add(new BhaugolikVistaarBAL(
    //       'NagarGraamin',
    //       listLastMonthBhaugolikVistaar['TotalNagarCountGraamin'],
    //       listLastMonthBhaugolikVistaar['ShaakhaaYuktaNagarCountGraamin'],
    //       listLastMonthBhaugolikVistaar['SaaptaahikYuktaNagarCountGraamin'],
    //       listLastMonthBhaugolikVistaar['MandaliYuktaNagarCountGraamin'],
    //       listLastMonthBhaugolikVistaar['GatividhiYuktaNagarCountGraamin']
    //     ));
    //   }
    //   if (listLastMonthBhaugolikVistaar['TotalNagarCountShahari'] != null && listLastMonthBhaugolikVistaar['TotalNagarCountShahari'] > 0){
    //     lstLastMonthBhaugolikVistaar.add(new BhaugolikVistaarBAL(
    //       'NagarShahari',
    //       listLastMonthBhaugolikVistaar['TotalNagarCountShahari'],
    //       listLastMonthBhaugolikVistaar['ShaakhaaYuktaNagarCountShahari'],
    //       listLastMonthBhaugolikVistaar['SaaptaahikYuktaNagarCountShahari'],
    //       listLastMonthBhaugolikVistaar['MandaliYuktaNagarCountShahari'],
    //       listLastMonthBhaugolikVistaar['GatividhiYuktaNagarCountShahari']
    //     ));
    //   }
    //   // if (listLastMonthBhaugolikVistaar['TotalShaharCount'] != null && listLastMonthBhaugolikVistaar['TotalShaharCount'] > 0){
    //   //   lstLastMonthBhaugolikVistaar.add(new BhaugolikVistaarBAL(
    //   //     'Shahar',
    //   //     listLastMonthBhaugolikVistaar['TotalShaharCount'],
    //   //     listLastMonthBhaugolikVistaar['ShaakhaaYuktaShaharCount'],
    //   //     listLastMonthBhaugolikVistaar['SaaptaahikYuktaShaharCount'],
    //   //     listLastMonthBhaugolikVistaar['MandaliYuktaShaharCount'],
    //   //     listLastMonthBhaugolikVistaar['GatividhiYuktaShaharCount']
    //   //   ));
    //   // }
    //   if (listLastMonthBhaugolikVistaar['TotalMandalCount'] != null && listLastMonthBhaugolikVistaar['TotalMandalCount'] > 0) {
    //     lstLastMonthBhaugolikVistaar.add(new BhaugolikVistaarBAL(
    //       'Mandal',
    //       listLastMonthBhaugolikVistaar['TotalMandalCount'],
    //       listLastMonthBhaugolikVistaar['ShaakhaaYuktaMandalCount'],
    //       listLastMonthBhaugolikVistaar['SaaptaahikYuktaMandalCount'],
    //       listLastMonthBhaugolikVistaar['MandaliYuktaMandalCount'],
    //       listLastMonthBhaugolikVistaar['GatividhiYuktaMandalCount']
    //     ));
    //   }
    //   if (listLastMonthBhaugolikVistaar['TotalGraamCount'] != null && listLastMonthBhaugolikVistaar['TotalGraamCount'] > 0) {
    //     lstLastMonthBhaugolikVistaar.add(new BhaugolikVistaarBAL(
    //       'Graam',
    //       listLastMonthBhaugolikVistaar['TotalGraamCount'],
    //       listLastMonthBhaugolikVistaar['ShaakhaaYuktaGraamCount'],
    //       listLastMonthBhaugolikVistaar['SaaptaahikYuktaGraamCount'],
    //       listLastMonthBhaugolikVistaar['MandaliYuktaGraamCount'],
    //       listLastMonthBhaugolikVistaar['GatividhiYuktaGraamCount']
    //     ));
    //   }
    //   if (listLastMonthBhaugolikVistaar['TotalVastiCount'] != null && listLastMonthBhaugolikVistaar['TotalVastiCount'] > 0) {
    //     lstLastMonthBhaugolikVistaar.add(new BhaugolikVistaarBAL(
    //       'Vasti',
    //       listLastMonthBhaugolikVistaar['TotalVastiCount'],
    //       listLastMonthBhaugolikVistaar['ShaakhaaYuktaVastiCount'],
    //       listLastMonthBhaugolikVistaar['SaaptaahikYuktaVastiCount'],
    //       listLastMonthBhaugolikVistaar['MandaliYuktaVastiCount'],
    //       listLastMonthBhaugolikVistaar['GatividhiYuktaVastiCount']
    //     ));
    //   }
    // }

    lstAppVersion = [];
    if (listAppVersion.length > 0) {
      for (var data in listAppVersion) {
        lstAppVersion.add(new AppVersionBAL(data['VersionNumber'], data['BuildNumber']));
      }
    }

    await DatabaseHelper.reCreate('HomeScreenData', dataList);
  }
  //return "Successfull";
  return responseBody;
}

Future<UpnagarUpkhandaReportModel?> upkhandUpnagarReportData({required String userID, required String? targetGeoUnitID, required String? type}) async {
  print("${userID}  --- $targetGeoUnitID  ");
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  log("API >>>>>>>>>>>>>> $urlUpkhandupnagarreport");

  print(json.encode({"iAppUserID": userID, "iGeoUnitID": targetGeoUnitID, "type": type}));

  var response = await http.post(Uri.parse(urlUpkhandupnagarreport), headers: jHeaders, body: json.encode({"iAppUserID": userID, "iGeoUnitID": targetGeoUnitID, "type": type}));

  if (response.statusCode == 200) {
    var responseBody = json.decode(response.body);
    final respData = UpnagarUpkhandaReportModel.fromJson(responseBody);
    log("Print the body for urlUpkhandupnagarreport >>>>>>>>>>>>>>>>> $responseBody");
    if (respData.status == "Success") {
      return respData;
    }
    return null;
  }
  return null;
}

Future<UpnagarUpkhandaReportModel?> upkhandUpnagarReportForExcelData({required String userID, required String? targetGeoUnitID, BuildContext? context}) async {
  if (context != null) showLoaderDialog(context);
  print("${userID}  --- $targetGeoUnitID  ");
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  log("API >>>>>>>>>>>>>> $urlUpkhandupnagarreportforexcel");

  print(json.encode({"iAppUserID": userID, "iGeoUnitID": targetGeoUnitID, "type": ""}));

  var response = await http.post(Uri.parse(urlUpkhandupnagarreportforexcel), headers: jHeaders, body: json.encode({"iAppUserID": userID, "iGeoUnitID": targetGeoUnitID, "type": ""}));
  if (context != null) Navigator.of(context, rootNavigator: true).pop();
  if (response.statusCode == 200) {
    var responseBody = json.decode(response.body);
    final respData = UpnagarUpkhandaReportModel.fromJson(responseBody);
    log("Print the body for upkhandUpnagarReportForExcelData >>>>>>>>>>>>>>>>> $responseBody");
    if (respData.status == "Success") {
      return respData;
    }
    return null;
  }
  return null;
}

//===================================  NEW VastisarvekshanReport by Dom ===========================================================
Future<VastiSurveyReportModel?> vastisarvekshanReportData(context, String? userID, String? targetGeoUnitID) async {
  showLoaderDialog(context);

  print("${userID}  --- $targetGeoUnitID  ");
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(Uri.parse(urlVastisarvekshanReport), headers: jHeaders, body: json.encode({"AppUserID": userID, "TargetGeoUnitID": targetGeoUnitID}));

  print(json.encode({"AppUserID": userID, "TargetGeoUnitID": targetGeoUnitID}));

  if (response.statusCode == 200) {
    var responseBody = json.decode(response.body);

    Fluttertoast.showToast(msg: "माहिती प्राप्त झाली.", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
    Navigator.of(context, rootNavigator: true).pop();

    return VastiSurveyReportModel.fromJson(responseBody);
  } else {
    log("Error: ${response.statusCode}");
    Navigator.of(context, rootNavigator: true).pop();

    return null;
  }
}

Future<NagarVastiSampurnaModel?> vastisarvekshanAllReportData(context, String? userID, String? targetGeoUnitID, String? levelType) async {
  showLoaderDialog(context);

  print("${userID}  --- $targetGeoUnitID  ");
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(Uri.parse(urlNagarVastisarvekshanReport), headers: jHeaders, body: json.encode({"AppUserID": userID, "GeoUnitID": int.parse(targetGeoUnitID!), "type": levelType}));

  print(json.encode({"AppUserID": userID, "GeoUnitID": int.parse(targetGeoUnitID), "type": levelType}));
  log("response ==>  $response");
  // log("response ==>  ${jsonEncode(response.body)}");

  if (response.statusCode == 200) {
    var responseBody = json.decode(response.body);
    Fluttertoast.showToast(msg: "माहिती प्राप्त झाली.", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
    Navigator.of(context, rootNavigator: true).pop();

    return NagarVastiSampurnaModel.fromJson(responseBody);
  } else {
    log("Error: ${response.statusCode}");
    Navigator.of(context, rootNavigator: true).pop();

    return null;
  }
}

Future<GetVijayadashamiInitModel?> getSajjanAndAnyaGuestData(context, String? userID, String? targetGeoUnitID, String? levelID) async {
  showLoaderDialog(context);

  print("${userID}  --- $targetGeoUnitID  ");
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  log(getDataWhileAddUpdateUPLevelForGruh);
  print(json.encode({"AppUserID": userID, "GeoUnitID": targetGeoUnitID ?? "0", "isnagar": int.parse(levelID ?? "6")}));

  var response = await http.post(
    Uri.parse(getDataWhileAddUpdateUPLevelForGruh),
    headers: jHeaders,
    body: json.encode({"AppUserID": userID, "GeoUnitID": targetGeoUnitID ?? "0", "isnagar": int.parse(levelID ?? "6")}),
  );
  // log("response ==>  $response");
  log("response ==>  ${jsonDecode(response.body)}");

  if (response.statusCode == 200) {
    var responseBody = json.decode(response.body);
    Fluttertoast.showToast(msg: "माहिती प्राप्त झाली.", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
    Navigator.of(context, rootNavigator: true).pop();

    return GetVijayadashamiInitModel.fromJson(responseBody);
  } else {
    log("Error: ${response.statusCode}");
    Navigator.of(context, rootNavigator: true).pop();

    return null;
  }
}

Future<int?> checkExistAbhiyanKaryakartaData(int? userID, String searchCriteria, {BuildContext? context}) async {
  if (context != null) showLoaderDialog(context);

  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  log(urlCheckExistsAbhiyaanKaryakarta);
  print(json.encode({"AppUserID": userID ?? 0, "SearchCriteria": searchCriteria}));

  var response = await http.post(
    Uri.parse(urlCheckExistsAbhiyaanKaryakarta),
    headers: jHeaders,
    body: json.encode({"AppUserID": userID, "SearchCriteria": searchCriteria}),
  );
  // log("response ==>  $response");
  log("response ==>  ${jsonDecode(response.body)}");
  if (context != null) Navigator.of(context, rootNavigator: true).pop();

  if (response.statusCode == 200) {
    var responseBody = json.decode(response.body);
    Fluttertoast.showToast(msg: "माहिती प्राप्त झाली.", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);

    return responseBody["alreadyexists"]; //1 means exists
  } else {
    log("Error: ${response.statusCode}");

    return null;
  }
}

Future<GetVijayadashamiInitModel?> getVijayadashamiInitData(context, String? userID, String? targetGeoUnitID, String? levelID) async {
  showLoaderDialog(context);

  print("${userID}  --- $targetGeoUnitID  ");
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  log(getDataWhileAddUpdateUPLevel);
  print(json.encode({"AppUserID": userID, "GeoUnitID": targetGeoUnitID ?? "0", "isnagar": int.parse(levelID ?? "6")}));

  var response = await http.post(
    Uri.parse(getDataWhileAddUpdateUPLevel),
    headers: jHeaders,
    body: json.encode({"AppUserID": userID, "GeoUnitID": targetGeoUnitID ?? "0", "isnagar": int.parse(levelID ?? "6")}),
  );
  // log("response ==>  $response");
  log("response ==>  ${jsonDecode(response.body)}");

  if (response.statusCode == 200) {
    var responseBody = json.decode(response.body);
    Fluttertoast.showToast(msg: "माहिती प्राप्त झाली.", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
    Navigator.of(context, rootNavigator: true).pop();

    return GetVijayadashamiInitModel.fromJson(responseBody);
  } else {
    log("Error: ${response.statusCode}");
    Navigator.of(context, rootNavigator: true).pop();

    return null;
  }
}

Future<MandalVastisarvekshanReportModel?> vastisarvekshanOnlyMandalReportData(context, String? userID, String? targetGeoUnitID, String? levelType) async {
  showLoaderDialog(context);

  print("${userID}  --- $targetGeoUnitID  ");
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(Uri.parse(mandalVastisarvekshanReport), headers: jHeaders, body: json.encode({"AppUserID": userID, "GeoUnitID": int.parse(targetGeoUnitID!), "type": levelType}));

  print(json.encode({"AppUserID": userID, "GeoUnitID": int.parse(targetGeoUnitID), "type": levelType}));
  log("response ==>  $response");
  // log("response ==>  ${jsonEncode(response.body)}");

  if (response.statusCode == 200) {
    var responseBody = json.decode(response.body);
    Fluttertoast.showToast(msg: "माहिती प्राप्त झाली.", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
    Navigator.of(context, rootNavigator: true).pop();

    return MandalVastisarvekshanReportModel.fromJson(responseBody);
  } else {
    log("Error: ${response.statusCode}");
    Navigator.of(context, rootNavigator: true).pop();

    return null;
  }
}

Future<TalukaMandalSampurnaModel?> vastisarvekshanAllReportDataForMandal(context, String? userID, String? targetGeoUnitID, String? levelType) async {
  showLoaderDialog(context);

  print("${userID}  --- $targetGeoUnitID  ");
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(
    Uri.parse(urlNagarVastisarvekshanReportForMandal),
    headers: jHeaders,
    body: json.encode({"AppUserID": userID, "GeoUnitID": int.parse(targetGeoUnitID!), "type": levelType}),
  );

  print(json.encode({"AppUserID": userID, "GeoUnitID": int.parse(targetGeoUnitID), "type": levelType}));
  log("response ==>  $response");
  // log("response ==>  ${jsonEncode(response.body)}");

  if (response.statusCode == 200) {
    var responseBody = json.decode(response.body);
    Fluttertoast.showToast(msg: "माहिती प्राप्त झाली.", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
    Navigator.of(context, rootNavigator: true).pop();

    return TalukaMandalSampurnaModel.fromJson(responseBody);
  } else {
    log("Error: ${response.statusCode}");
    Navigator.of(context, rootNavigator: true).pop();

    return null;
  }
}

//==========================================================================================================================
Future<NotificationListModel?> getNotificationDataList(String? userID) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(Uri.parse(getofflinenotificationlist), headers: jHeaders, body: json.encode({"SwayamsevakID": userID}));

  print(json.encode({"SwayamsevakID": userID}));

  if (response.statusCode == 200) {
    var responseBody = json.decode(response.body);
    log("getNotificationDataList ==>>  ${responseBody}");
    return NotificationListModel.fromJson(responseBody);
  } else {
    log("Error: ${response.statusCode}");
    return null;
  }
}

//====================================   Vasti Sarvekshan API CALLL ===============================================================================
Future<VastisarvekshanDropDownDataModel?> getVastiSurveyDropDownList(String? userID, {BuildContext? context}) async {
  if (context != null) showLoaderDialog(context);
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(Uri.parse(getVastisarvekshanmasterdata), headers: jHeaders, body: json.encode({"SwayamsevakID": userID}));

  print(json.encode({"SwayamsevakID": userID}));

  if (response.statusCode == 200) {
    var responseBody = json.decode(response.body);
    if (context != null) Navigator.of(context, rootNavigator: true).pop();
    // log("getVastiSurveyDropDownList ==>>  ${responseBody}");
    return VastisarvekshanDropDownDataModel.fromJson(responseBody);
  } else {
    if (context != null) Navigator.of(context, rootNavigator: true).pop();
    log("Error: ${response.statusCode}");
    return null;
  }
}

Future<dynamic> getDashboardDataByGeoUnit(String userID, String targetGeoUnitID) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(Uri.parse(urlRefreshHomeScreenForApp), headers: jHeaders, body: json.encode({"AppUserID": userID, "TargetGeoUnitID": targetGeoUnitID}));
  var responseBody = json.decode(response.body);

  print("request :- ${{"AppUserID": userID, "TargetGeoUnitID": targetGeoUnitID}}");
  log("response body getDashboardDataByGeoUnit:--  ${responseBody}");

  var dataList = responseBody['HomeScreenData'];
  var listShaakhaaCountByVayogat = responseBody['HomeScreenData']['ListShaakhaaCountByVayogat'];
  var listKaaryakartaaCountByGatividhi = responseBody['HomeScreenData']['ListKaaryakartaaCountByGatividhi'];
  var listKaaryakartaaCountByAayaam = responseBody['HomeScreenData']['ListKaaryakartaaCountByAayaam'];
  var listKaaryakartaaCountByPreritSansthaa = responseBody['HomeScreenData']['ListSanghaPreritSansthaaKaaryakartaaCountByAreaOfOperation'];
  var listKaaryakartaaCountBySocialOrg = responseBody['HomeScreenData']['ListSocialOrganizationKaaryakartaaCountByAreaOfOperation'];
  var listStudentCountByCategory = responseBody['HomeScreenData']['ListSwayamsevakCountByStudentCategory'];
  var listVyavasaayeeCountByCategory = responseBody['HomeScreenData']['ListSwayamsevakCountByVyavasaayeeCategory'];
  var listYesterdayVruttaDetail = responseBody['HomeScreenData']['ListYesterdayVrutta'];
  var listYesterdayVruttaSummary = responseBody['HomeScreenData']['ListYesterdayVruttaSummary'];
  var listSankalpByAadhaar = responseBody['HomeScreenData']['ListSankalpByAadhaar'];
  var listBhaugolikVistaar = responseBody['HomeScreenData']['BhaugolikVistaarData'];
  // var listLastMonthBhaugolikVistaar = responseBody['HomeScreenData']['LastMonthBhaugolikVistaarData'];
  var message = responseBody['Message'];

  if (message == "Home Screen Data Returned") {
    tgLstdashboardSadyaSthitiData = [];
    if (listShaakhaaCountByVayogat.length > 0) {
      int shaakhaa = 0, mandali = 0, maasik = 0, saaptaa = 0, sankalpitShaakhaa = 0, sankalpitSaaptaa = 0;
      int shaakhaaTotal = 0, mandaliTotal = 0, maasikTotal = 0, saaptaaTotal = 0, sankalpitMaasikMilanCount = 0, sankalpitSanghaMandaliCount = 0;
      int sankalpitShaakhaaTotal = 0, sankalpitSaaptaaTotal = 0, sankalpitMaasikMilanTotal = 0, sankalpitSanghaMandaliTotal = 0;
      for (var data in listShaakhaaCountByVayogat) {
        shaakhaa = data['ShaakhaaCount'] == null ? 0 : data['ShaakhaaCount'];
        shaakhaaTotal = shaakhaaTotal + shaakhaa;
        mandali = data['SanghaMandaliCount'] == null ? 0 : data['SanghaMandaliCount'];
        mandaliTotal = mandaliTotal + mandali;
        saaptaa = data['SaaptaahikCount'] == null ? 0 : data['SaaptaahikCount'];
        saaptaaTotal = saaptaaTotal + saaptaa;
        maasik = data['MaasikMilanCount'] == null ? 0 : data['MaasikMilanCount'];
        maasikTotal = maasikTotal + maasik;
        sankalpitShaakhaa = data['SankalpitShaakhaaCount'] == null ? 0 : data['SankalpitShaakhaaCount'];
        sankalpitShaakhaaTotal = sankalpitShaakhaaTotal + sankalpitShaakhaa;
        sankalpitSaaptaa = data['SankalpitSaaptaahikCount'] == null ? 0 : data['SankalpitSaaptaahikCount'];
        sankalpitSaaptaaTotal = sankalpitSaaptaaTotal + sankalpitSaaptaa;
        sankalpitMaasikMilanCount = data['SankalpitMaasikMilanCount'] == null ? 0 : data['SankalpitMaasikMilanCount'];
        sankalpitMaasikMilanTotal = sankalpitMaasikMilanTotal + sankalpitMaasikMilanCount;
        sankalpitSanghaMandaliCount = data['SankalpitSanghaMandaliCount'] == null ? 0 : data['SankalpitSanghaMandaliCount'];
        sankalpitSanghaMandaliTotal = sankalpitSanghaMandaliTotal + sankalpitSanghaMandaliCount;
        tgLstdashboardSadyaSthitiData.add(
          new DashboardSadyaSthitiDataBAL(
            data['VayogatID'],
            data['VayogatCode'],
            shaakhaa,
            mandali,
            saaptaa,
            maasik,
            sankalpitShaakhaa,
            sankalpitSaaptaa,
            sankalpitMaasikMilanCount,
            sankalpitSanghaMandaliCount,
          ),
        );
      }
      // Totals row
      tgLstdashboardSadyaSthitiData.add(
        new DashboardSadyaSthitiDataBAL(
          -1,
          getLabel('Total'),
          shaakhaaTotal,
          mandaliTotal,
          saaptaaTotal,
          maasikTotal,
          sankalpitShaakhaaTotal,
          sankalpitSaaptaaTotal,
          sankalpitMaasikMilanTotal,
          sankalpitSanghaMandaliTotal,
        ),
      );
    }

    tgLstGatividhiKaaryakartaa = [];
    if (listKaaryakartaaCountByGatividhi.length > 0) {
      int kartaaCount = 0, totalCount = 0;
      for (var data in listKaaryakartaaCountByGatividhi) {
        kartaaCount = (data['KaaryakartaaCount'] == null ? 0 : data['KaaryakartaaCount']);
        totalCount = totalCount + kartaaCount;
        tgLstGatividhiKaaryakartaa.add(new GatividhiKaaryakartaaCountBAL(data['GatividhiID'], data['GatividhiName'], kartaaCount));
      }
      // Totals row
      tgLstGatividhiKaaryakartaa.add(new GatividhiKaaryakartaaCountBAL(0, getLabel('Total'), totalCount));
    }

    tgLstAayaamKaaryakartaa = [];
    if (listKaaryakartaaCountByAayaam.length > 0) {
      int kartaaCount = 0, totalCount = 0;
      for (var data in listKaaryakartaaCountByAayaam) {
        kartaaCount = (data['KaaryakartaaCount'] == null ? 0 : data['KaaryakartaaCount']);
        totalCount = totalCount + kartaaCount;
        tgLstAayaamKaaryakartaa.add(new AayaamKaaryakartaaCountBAL(data['AayaamID'], data['AayaamName'], kartaaCount));
      }
      //Totals row
      tgLstAayaamKaaryakartaa.add(new AayaamKaaryakartaaCountBAL(0, getLabel('Total'), totalCount));
    }

    tgLstPreritKaaryakartaa = [];
    if (listKaaryakartaaCountByPreritSansthaa.length > 0) {
      int kartaaCount = 0, totalCount = 0;
      for (var data in listKaaryakartaaCountByPreritSansthaa) {
        kartaaCount = (data['KaaryakartaaCount'] == null ? 0 : data['KaaryakartaaCount']);
        totalCount = totalCount + kartaaCount;
        tgLstPreritKaaryakartaa.add(
          new PreritKaaryakartaaCountBAL(
            // data['PreritAOOID'],
            // data['PreritAOOName'],
            data['AreaOfOperationID'],
            data['AreaOfOperation'],
            kartaaCount,
          ),
        );
      }
      // Totals row
      tgLstPreritKaaryakartaa.add(
        new PreritKaaryakartaaCountBAL(
          // data['PreritAOOID'],
          // data['PreritAOOName'],
          0,
          getLabel('Total'),
          totalCount,
        ),
      );
    }

    tgLstSocialOrgKaaryakartaa = [];
    if (listKaaryakartaaCountBySocialOrg.length > 0) {
      int kartaaCount = 0, totalCount = 0;
      for (var data in listKaaryakartaaCountBySocialOrg) {
        kartaaCount = (data['KaaryakartaaCount'] == null ? 0 : data['KaaryakartaaCount']);
        totalCount = totalCount + kartaaCount;
        tgLstSocialOrgKaaryakartaa.add(
          new SocialOrgKaaryakartaaCountBAL(
            // data['MainAOOID'],
            // data['MainAOOName'],
            data['MainAreaOfOperationID'],
            data['AreaOfOperation'],
            kartaaCount,
          ),
        );
      }
      // Totals row
      tgLstSocialOrgKaaryakartaa.add(
        new SocialOrgKaaryakartaaCountBAL(
          // data['MainAOOID'],
          // data['MainAOOName'],
          0,
          getLabel('Total'),
          totalCount,
        ),
      );
    }

    tgLstStudentCategory = [];
    if (listStudentCountByCategory.length > 0) {
      int studentCount = 0, totalStudent = 0;
      for (var data in listStudentCountByCategory) {
        studentCount = (data['CountByStudentCategory'] == null ? 0 : data['CountByStudentCategory']);
        totalStudent = totalStudent + studentCount;
        tgLstStudentCategory.add(new StudentCategoryCountBAL(data['StudentCategoryID'], data['StudentCategoryName'], studentCount));
      }
      // Totals row
      tgLstStudentCategory.add(new StudentCategoryCountBAL(0, getLabel('Total'), totalStudent));
    }

    tgLstVyavasaayeeCategory = [];
    if (listVyavasaayeeCountByCategory.length > 0) {
      int vyavasaayeeCount = 0, totalVyavasaayee = 0;
      for (var data in listVyavasaayeeCountByCategory) {
        vyavasaayeeCount = (data['CountByVyavasaayeeCategory'] == null ? 0 : data['CountByVyavasaayeeCategory']);
        totalVyavasaayee = totalVyavasaayee + vyavasaayeeCount;
        tgLstVyavasaayeeCategory.add(new VyavasaayeeCategoryCountBAL(data['VyavasaayeeCategoryID'], data['VyavasaayeeCategoryName'], vyavasaayeeCount));
      }
      // Totals row
      tgLstVyavasaayeeCategory.add(new VyavasaayeeCategoryCountBAL(0, getLabel('Total'), totalVyavasaayee));
    }

    tgLstYesterdayVruttaSummary = [];
    if (listYesterdayVruttaSummary.length > 0) {
      int shCnt = 0, totalShaakhaa = 0, spCnt = 0, totalSaaptaa = 0, mdCnt = 0, totalMandali = 0;
      for (var data in listYesterdayVruttaSummary) {
        shCnt = (data['ShaakhaaCount'] == null ? 0 : data['ShaakhaaCount']);
        totalShaakhaa = totalShaakhaa + shCnt;
        spCnt = (data['SaaptaahikCount'] == null ? 0 : data['SaaptaahikCount']);
        totalSaaptaa = totalSaaptaa + spCnt;
        mdCnt = (data['MilanMandaliCount'] == null ? 0 : data['MilanMandaliCount']);
        totalMandali = totalMandali + mdCnt;
        tgLstYesterdayVruttaSummary.add(new YesterdayVruttaSummaryBAL(data['GeoUnitID'], data['GeoUnitName'], data['VayogatID'], data['VayogatCode'], shCnt, spCnt, mdCnt));
      }
      // Totals row
      tgLstYesterdayVruttaSummary.add(new YesterdayVruttaSummaryBAL(0, getLabel('Total'), 0, '', totalShaakhaa, totalSaaptaa, totalMandali));
    }

    tgLstYesterdayVruttaDetail = [];
    if (listYesterdayVruttaDetail.length > 0) {
      int baalCnt = 0, totalBaal = 0, tarunVidyaarthiCnt = 0, totalTarunVidyaarthi = 0;
      int tarunVyavasaayeeCnt = 0, totalTarunVyavasaayee = 0, proudhCnt = 0, totalProudh = 0;
      int shishuCnt = 0, totalShishu = 0, abhyaagatCnt = 0, totalAbhyaagat = 0;
      for (var data in listYesterdayVruttaDetail) {
        baalCnt = (data['BaalVidyaarthiCount'] == null ? 0 : data['BaalVidyaarthiCount']);
        totalBaal = totalBaal + baalCnt;
        tarunVidyaarthiCnt = (data['TarunVidyaarthiCount'] == null ? 0 : data['TarunVidyaarthiCount']);
        totalTarunVidyaarthi = totalTarunVidyaarthi + tarunVidyaarthiCnt;
        tarunVyavasaayeeCnt = (data['TarunVyavasaayeeCount'] == null ? 0 : data['TarunVyavasaayeeCount']);
        totalTarunVyavasaayee = totalTarunVyavasaayee + tarunVyavasaayeeCnt;
        proudhCnt = (data['ProudhaVyavasaayeeCount'] == null ? 0 : data['ProudhaVyavasaayeeCount']);
        totalProudh = totalProudh + proudhCnt;
        shishuCnt = (data['ShishuCount'] == null ? 0 : data['ShishuCount']);
        totalShishu = totalShishu + shishuCnt;
        abhyaagatCnt = (data['AbhyaagatCount'] == null ? 0 : data['AbhyaagatCount']);
        totalAbhyaagat = totalAbhyaagat + abhyaagatCnt;
        tgLstYesterdayVruttaDetail.add(
          new YesterdayVruttaDetailBAL(
            data['GeoUnitID'],
            data['ShaakhaaID'],
            data['GeoUnitName'],
            data['FrequencyID'],
            data['FrequencyCode'],
            data['VayogatID'],
            data['VayogatCode'],
            shishuCnt,
            baalCnt,
            tarunVidyaarthiCnt,
            tarunVyavasaayeeCnt,
            proudhCnt,
            abhyaagatCnt,
          ),
        );
      }
      // Totals row
      tgLstYesterdayVruttaDetail.add(
        new YesterdayVruttaDetailBAL(0, 0, getLabel('Total'), 0, '', 0, '', totalShishu, totalBaal, totalTarunVidyaarthi, totalTarunVyavasaayee, totalProudh, totalAbhyaagat),
      );
    }

    tgLstSankalpByAadhaarData = [];
    if (listSankalpByAadhaar.length > 0) {
      int maasikMilanCount = 0,
          sanghaMandaliCount = 0,
          shaakhaa = 0,
          saaptaa = 0,
          totalShaakhaa = 0,
          totalSaaptaa = 0,
          totalmaasikMilanCount = 0,
          totalsanghaMandaliCount = 0,
          totalsankalpitSanghaMandalikCount = 0,
          totalsankalpitMasikMilankCount = 0,
          sankalpitSanghaMandalikCount = 0,
          sankalpitMasikMilankCount = 0;
      for (var data in listSankalpByAadhaar) {
        shaakhaa = (data['SankalpitShaakhaaCount'] == null ? 0 : data['SankalpitShaakhaaCount']);
        totalShaakhaa = totalShaakhaa + shaakhaa;

        saaptaa = (data['SankalpitSaaptaahikCount'] == null ? 0 : data['SankalpitSaaptaahikCount']);
        totalSaaptaa = totalSaaptaa + saaptaa;

        sankalpitMasikMilankCount = (data['SankalpitMasikMilankCount'] == null ? 0 : data['SankalpitMasikMilankCount']);
        totalsankalpitMasikMilankCount = totalsankalpitMasikMilankCount + sankalpitMasikMilankCount;

        sankalpitSanghaMandalikCount = (data['SankalpitSanghaMandalikCount'] == null ? 0 : data['SankalpitSanghaMandalikCount']);
        totalsankalpitSanghaMandalikCount = totalsankalpitSanghaMandalikCount + sankalpitSanghaMandalikCount;

        sanghaMandaliCount = (data['SanghaMandaliCount'] == null ? 0 : data['SanghaMandaliCount']);
        totalsanghaMandaliCount = totalsanghaMandaliCount + sanghaMandaliCount;

        maasikMilanCount = (data['MaasikMilanCount'] == null ? 0 : data['MaasikMilanCount']);
        totalmaasikMilanCount = totalmaasikMilanCount + maasikMilanCount;

        tgLstSankalpByAadhaarData.add(
          new SankalpByAadhaarBAL(data['VayogatID'], data['VayogatCode'], data['SankalpAadhaar'], shaakhaa, saaptaa, sankalpitMasikMilankCount, sankalpitSanghaMandalikCount),
        );
      }
      // Totals row
      tgLstSankalpByAadhaarData.add(new SankalpByAadhaarBAL(0, getLabel('Total'), '', totalShaakhaa, totalSaaptaa, totalsankalpitMasikMilankCount, totalsankalpitSanghaMandalikCount));
    }

    tgLstBhaugolikVistaar = [];
    if (listBhaugolikVistaar.length > 0) {
      if (listBhaugolikVistaar['TotalNagarCount'] != null && listBhaugolikVistaar['TotalNagarCount'] > 0) {
        tgLstBhaugolikVistaar.add(
          new BhaugolikVistaarBAL(
            'Nagar',
            listBhaugolikVistaar['TotalNagarCount'],
            listBhaugolikVistaar['ShaakhaaYuktaNagarCount'],
            listBhaugolikVistaar['SaaptaahikYuktaNagarCount'],
            listBhaugolikVistaar['MandaliYuktaNagarCount'],
            listBhaugolikVistaar['GatividhiYuktaNagarCount'],
          ),
        );
      }
      if (listBhaugolikVistaar['TotalNagarCountGraamin'] != null && listBhaugolikVistaar['TotalNagarCountGraamin'] > 0) {
        tgLstBhaugolikVistaar.add(
          new BhaugolikVistaarBAL(
            'NagarGraamin',
            listBhaugolikVistaar['TotalNagarCountGraamin'],
            listBhaugolikVistaar['ShaakhaaYuktaNagarCountGraamin'],
            listBhaugolikVistaar['SaaptaahikYuktaNagarCountGraamin'],
            listBhaugolikVistaar['MandaliYuktaNagarCountGraamin'],
            listBhaugolikVistaar['GatividhiYuktaNagarCountGraamin'],
          ),
        );
      }
      if (listBhaugolikVistaar['TotalNagarCountShahari'] != null && listBhaugolikVistaar['TotalNagarCountShahari'] > 0) {
        tgLstBhaugolikVistaar.add(
          new BhaugolikVistaarBAL(
            'NagarShahari',
            listBhaugolikVistaar['TotalNagarCountShahari'],
            listBhaugolikVistaar['ShaakhaaYuktaNagarCountShahari'],
            listBhaugolikVistaar['SaaptaahikYuktaNagarCountShahari'],
            listBhaugolikVistaar['MandaliYuktaNagarCountShahari'],
            listBhaugolikVistaar['GatividhiYuktaNagarCountShahari'],
          ),
        );
      }
      // if (listBhaugolikVistaar['TotalShaharCount'] != null && listBhaugolikVistaar['TotalShaharCount'] > 0){
      //   tgLstBhaugolikVistaar.add(new BhaugolikVistaarBAL(
      //     'Shahar',
      //     listBhaugolikVistaar['TotalShaharCount'],
      //     listBhaugolikVistaar['ShaakhaaYuktaShaharCount'],
      //     listBhaugolikVistaar['SaaptaahikYuktaShaharCount'],
      //     listBhaugolikVistaar['MandaliYuktaShaharCount'],
      //     listBhaugolikVistaar['GatividhiYuktaShaharCount']
      //   ));
      // }
      if (listBhaugolikVistaar['TotalMandalCount'] != null && listBhaugolikVistaar['TotalMandalCount'] > 0) {
        tgLstBhaugolikVistaar.add(
          new BhaugolikVistaarBAL(
            'Mandal',
            listBhaugolikVistaar['TotalMandalCount'],
            listBhaugolikVistaar['ShaakhaaYuktaMandalCount'],
            listBhaugolikVistaar['SaaptaahikYuktaMandalCount'],
            listBhaugolikVistaar['MandaliYuktaMandalCount'],
            listBhaugolikVistaar['GatividhiYuktaMandalCount'],
          ),
        );
      }
      if (listBhaugolikVistaar['TotalGraamCount'] != null && listBhaugolikVistaar['TotalGraamCount'] > 0) {
        tgLstBhaugolikVistaar.add(
          new BhaugolikVistaarBAL(
            'Graam',
            listBhaugolikVistaar['TotalGraamCount'],
            listBhaugolikVistaar['ShaakhaaYuktaGraamCount'],
            listBhaugolikVistaar['SaaptaahikYuktaGraamCount'],
            listBhaugolikVistaar['MandaliYuktaGraamCount'],
            listBhaugolikVistaar['GatividhiYuktaGraamCount'],
          ),
        );
      }
      if (listBhaugolikVistaar['TotalVastiCount'] != null && listBhaugolikVistaar['TotalVastiCount'] > 0) {
        tgLstBhaugolikVistaar.add(
          new BhaugolikVistaarBAL(
            'Vasti',
            listBhaugolikVistaar['TotalVastiCount'],
            listBhaugolikVistaar['ShaakhaaYuktaVastiCount'],
            listBhaugolikVistaar['SaaptaahikYuktaVastiCount'],
            listBhaugolikVistaar['MandaliYuktaVastiCount'],
            listBhaugolikVistaar['GatividhiYuktaVastiCount'],
          ),
        );
      }
    }

    // tgLstLastMonthBhaugolikVistaar = [];
    // if (listLastMonthBhaugolikVistaar != null && listLastMonthBhaugolikVistaar.length > 0) {
    //   if (listLastMonthBhaugolikVistaar['TotalNagarCount'] != null && listLastMonthBhaugolikVistaar['TotalNagarCount'] > 0){
    //     tgLstLastMonthBhaugolikVistaar.add(new BhaugolikVistaarBAL(
    //       'Nagar',
    //       listLastMonthBhaugolikVistaar['TotalNagarCount'],
    //       listLastMonthBhaugolikVistaar['ShaakhaaYuktaNagarCount'],
    //       listLastMonthBhaugolikVistaar['SaaptaahikYuktaNagarCount'],
    //       listLastMonthBhaugolikVistaar['MandaliYuktaNagarCount'],
    //       listLastMonthBhaugolikVistaar['GatividhiYuktaNagarCount']
    //     ));
    //   }
    //   if (listLastMonthBhaugolikVistaar['TotalNagarCountGraamin'] != null && listLastMonthBhaugolikVistaar['TotalNagarCountGraamin'] > 0){
    //     tgLstLastMonthBhaugolikVistaar.add(new BhaugolikVistaarBAL(
    //       'NagarGraamin',
    //       listLastMonthBhaugolikVistaar['TotalNagarCountGraamin'],
    //       listLastMonthBhaugolikVistaar['ShaakhaaYuktaNagarCountGraamin'],
    //       listLastMonthBhaugolikVistaar['SaaptaahikYuktaNagarCountGraamin'],
    //       listLastMonthBhaugolikVistaar['MandaliYuktaNagarCountGraamin'],
    //       listLastMonthBhaugolikVistaar['GatividhiYuktaNagarCountGraamin']
    //     ));
    //   }
    //   if (listLastMonthBhaugolikVistaar['TotalNagarCountShahari'] != null && listLastMonthBhaugolikVistaar['TotalNagarCountShahari'] > 0){
    //     tgLstLastMonthBhaugolikVistaar.add(new BhaugolikVistaarBAL(
    //       'NagarShahari',
    //       listLastMonthBhaugolikVistaar['TotalNagarCountShahari'],
    //       listLastMonthBhaugolikVistaar['ShaakhaaYuktaNagarCountShahari'],
    //       listLastMonthBhaugolikVistaar['SaaptaahikYuktaNagarCountShahari'],
    //       listLastMonthBhaugolikVistaar['MandaliYuktaNagarCountShahari'],
    //       listLastMonthBhaugolikVistaar['GatividhiYuktaNagarCountShahari']
    //     ));
    //   }
    //   // if (listLastMonthBhaugolikVistaar['TotalShaharCount'] != null && listLastMonthBhaugolikVistaar['TotalShaharCount'] > 0){
    //   //   tgLstLastMonthBhaugolikVistaar.add(new BhaugolikVistaarBAL(
    //   //     'Shahar',
    //   //     listLastMonthBhaugolikVistaar['TotalShaharCount'],
    //   //     listLastMonthBhaugolikVistaar['ShaakhaaYuktaShaharCount'],
    //   //     listLastMonthBhaugolikVistaar['SaaptaahikYuktaShaharCount'],
    //   //     listLastMonthBhaugolikVistaar['MandaliYuktaShaharCount'],
    //   //     listLastMonthBhaugolikVistaar['GatividhiYuktaShaharCount']
    //   //   ));
    //   // }
    //   if (listLastMonthBhaugolikVistaar['TotalMandalCount'] != null && listLastMonthBhaugolikVistaar['TotalMandalCount'] > 0) {
    //     tgLstLastMonthBhaugolikVistaar.add(new BhaugolikVistaarBAL(
    //       'Mandal',
    //       listLastMonthBhaugolikVistaar['TotalMandalCount'],
    //       listLastMonthBhaugolikVistaar['ShaakhaaYuktaMandalCount'],
    //       listLastMonthBhaugolikVistaar['SaaptaahikYuktaMandalCount'],
    //       listLastMonthBhaugolikVistaar['MandaliYuktaMandalCount'],
    //       listLastMonthBhaugolikVistaar['GatividhiYuktaMandalCount']
    //     ));
    //   }
    //   if (listLastMonthBhaugolikVistaar['TotalGraamCount'] != null && listLastMonthBhaugolikVistaar['TotalGraamCount'] > 0) {
    //     tgLstLastMonthBhaugolikVistaar.add(new BhaugolikVistaarBAL(
    //       'Graam',
    //       listLastMonthBhaugolikVistaar['TotalGraamCount'],
    //       listLastMonthBhaugolikVistaar['ShaakhaaYuktaGraamCount'],
    //       listLastMonthBhaugolikVistaar['SaaptaahikYuktaGraamCount'],
    //       listLastMonthBhaugolikVistaar['MandaliYuktaGraamCount'],
    //       listLastMonthBhaugolikVistaar['GatividhiYuktaGraamCount']
    //     ));
    //   }
    //   if (listLastMonthBhaugolikVistaar['TotalVastiCount'] != null && listLastMonthBhaugolikVistaar['TotalVastiCount'] > 0) {
    //     tgLstLastMonthBhaugolikVistaar.add(new BhaugolikVistaarBAL(
    //       'Vasti',
    //       listLastMonthBhaugolikVistaar['TotalVastiCount'],
    //       listLastMonthBhaugolikVistaar['ShaakhaaYuktaVastiCount'],
    //       listLastMonthBhaugolikVistaar['SaaptaahikYuktaVastiCount'],
    //       listLastMonthBhaugolikVistaar['MandaliYuktaVastiCount'],
    //       listLastMonthBhaugolikVistaar['GatividhiYuktaVastiCount']
    //     ));
    //   }
    // }

    //await DatabaseHelper.reCreate('HomeScreenData', dataList);
  }
  //return "Successfull";
  return responseBody;
}

Future<dynamic> getJoinRSSData(String strInputBody) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  print(Uri.parse(urlGetJoinRSSGridForApp));
  print(strInputBody);
  var response = await http.post(Uri.parse(urlGetJoinRSSGridForApp), headers: jHeaders, body: strInputBody);
  // log(response.body);
  var responseBody = json.decode(response.body);

  return responseBody;
}

Future<List<dynamic>> getJoinRSSList(String strInputBody) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(Uri.parse(urlGetJoinRSSGridForApp), headers: jHeaders, body: strInputBody);

  var responseBody = json.decode(response.body);

  return responseBody['ListJoinRSS'];
}

Future<String> saveJoinRSSForApp(String inputJson) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(Uri.parse(urlSaveJoinRSSForApp), headers: jHeaders, body: inputJson);

  var responseBody = json.decode(response.body);

  return responseBody['OutputJoinRSSID'].toString();
}

Future<void> saveVijayaDashamiUtsavData(BuildContext context, Map<String, dynamic> inputJson, bool showLoader) async {
  if (showLoader) showLoaderDialog(context);
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(
    Uri.parse(saveupdatevijayadashamiutsav),
    headers: jHeaders,
    body: jsonEncode(inputJson), // ✅ Encode here
  );

  print("Response: ${response.body}");
  print("response.statusCode: ${response.statusCode}");

  if (showLoader) Navigator.of(context, rootNavigator: true).pop();

  if (response.statusCode == 200) {
    Statics.showToast(Statics.getLabel('dataSavedSuccessfully'));
  } else {
    print("Error: ${response.statusCode} - ${response.body}");
    Statics.showToast(Statics.getLabel('errorOccurred'));
  }
}

Future<String?> saveVijayaDashamiImageData({required BuildContext context, required Map<String, dynamic> inputJson, bool showLoader = false}) async {
  if (showLoader) showLoaderDialog(context);
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(
    Uri.parse(savevijayadashamiutsavfiles),
    headers: jHeaders,
    body: jsonEncode(inputJson), // ✅ Encode here
  );

  print("Response saveVijayaDashamiImageData >>>>>>>>>>>> ${response.body}");
  print("response.statusCode: ${response.statusCode}");

  if (showLoader) Navigator.of(context, rootNavigator: true).pop();

  if (response.statusCode == 200) {
    // Statics.showToast(Statics.getLabel('dataSavedSuccessfully'));
    final responseData = json.decode(response.body);
    return responseData["Message"].toString();
  } else {
    print("Error: ${response.statusCode} - ${response.body}");
    Statics.showToast(Statics.getLabel('errorOccurred'));
    return null;
  }
}

Future<bool> deleteVijayaDashamiImageData({required BuildContext context, required Map<String, dynamic> inputJson, bool showLoader = false}) async {
  if (showLoader) showLoaderDialog(context);
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(
    Uri.parse(deletevijayadashamiutsavfiles),
    headers: jHeaders,
    body: jsonEncode(inputJson), // ✅ Encode here
  );

  print("Response deleteVijayaDashamiImageData >>>>>>>>>>>> ${response.body}");
  print("response.statusCode: ${response.statusCode}");

  if (showLoader) Navigator.of(context, rootNavigator: true).pop();

  if (response.statusCode == 200) {
    // Statics.showToast(Statics.getLabel('dataSavedSuccessfully'));
    final responseData = json.decode(response.body);
    if (responseData["Status"].toString() == "Success") {
      return true;
    }
    return false;
  } else {
    print("Error: ${response.statusCode} - ${response.body}");
    Statics.showToast(Statics.getLabel('errorOccurred'));
    return false;
  }
}

Future<bool> saveVishishthaAtithiData(BuildContext context, Map<String, dynamic> inputJson) async {
  showLoaderDialog(context);
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(Uri.parse(savesajjanskhatianyapravbhavilok), headers: jHeaders, body: jsonEncode(inputJson));

  print("Response: ${response.body}");
  print("response.statusCode: ${response.statusCode}");

  Navigator.of(context, rootNavigator: true).pop();

  if (response.statusCode == 200) {
    Statics.showToast(Statics.getLabel('dataSavedSuccessfully'));
    return true;
  } else {
    print("Error: ${response.statusCode} - ${response.body}");
    return false;
  }
}

Future<GetVijayadashamiDataByGeoUnitModel?> getVijayaDashamiUtsavDataByGeounit(BuildContext context, Map<String, dynamic> inputJson) async {
  showLoaderDialog(context);
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  try {
    var response = await http.post(Uri.parse(getvijayadashamiutsavbyid), headers: jHeaders, body: jsonEncode(inputJson));

    Navigator.of(context, rootNavigator: true).pop();

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      final responseData = json.decode(response.body);
      log("getvijayadashamiutsavbyid >>>>>>> $responseData");

      GetVijayadashamiDataByGeoUnitModel model = GetVijayadashamiDataByGeoUnitModel.fromJson(data);

      return model; // ✅ return karna zaroori hai
    } else {
      print("Error: ${response.statusCode} - ${response.body}");
      return null; // ✅ error case
    }
  } catch (e) {
    Navigator.of(context, rootNavigator: true).pop();
    print("Exception: $e");
    return null;
  }
}

Future<GetVijayadashamiReportModel?> getVijayaDashamiUtsavReportData(BuildContext context, Map<String, dynamic> inputJson) async {
  showLoaderDialog(context);
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  try {
    var response = await http.post(Uri.parse(getvijayadashamiutsavreport), headers: jHeaders, body: jsonEncode(inputJson));

    Navigator.of(context, rootNavigator: true).pop();

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      GetVijayadashamiReportModel model = GetVijayadashamiReportModel.fromJson(data);
      log("vijayadashamiReport >>>>>>>>>>>>>>>>> ${(jsonEncode(data))}");

      return model; // ✅ return karna zaroori hai
    } else {
      print("Error: ${response.statusCode} - ${response.body}");
      return null; // ✅ error case
    }
  } catch (e) {
    Navigator.of(context, rootNavigator: true).pop();
    print("Exception: $e");
    return null;
  }
}

Future<VijayadashamiExcelRespModel?> getVijayaDashamiUtsavExcelReportData(BuildContext context, Map<String, dynamic> inputJson) async {
  showLoaderDialog(context);
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  log(vijayadashamiReportApi);

  try {
    var response = await http.post(Uri.parse(vijayadashamiReportApi), headers: jHeaders, body: jsonEncode(inputJson));

    Navigator.of(context, rootNavigator: true).pop();

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      VijayadashamiExcelRespModel? model;

      if (data["Status"] == "200" || data["Status"] == "Success") {
        model = VijayadashamiExcelRespModel.fromJson(data);
        log("vijayadashamiExcelReport >>>>>>>>>>>>>>>>> ${(jsonEncode(data))}");
      }

      return model; // ✅ return karna zaroori hai
    } else {
      print("Error: ${response.statusCode} - ${response.body}");
      return null; // ✅ error case
    }
  } catch (e) {
    Navigator.of(context, rootNavigator: true).pop();
    print("Exception: $e");
    return null;
  }
}

Future<GruhAbhiyaanVruttaDataModel?> getDataforGruhAbhiyaan(Map<String, dynamic> inputJson, {BuildContext? context}) async {
  if (context != null) showLoaderDialog(context);
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};
  log(getDataforGruhAbhiyaanApi);

  try {
    var response = await http.post(Uri.parse(getDataforGruhAbhiyaanApi), headers: jHeaders, body: jsonEncode(inputJson));

    if (context != null) Navigator.of(context, rootNavigator: true).pop();

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      if (data["Status"] == "200" || data["Status"] == "Success") {
        GruhAbhiyaanVruttaDataModel model = GruhAbhiyaanVruttaDataModel.fromJson(data);
        log("getDataforGruhAbhiyaan >>>>>>>>>>>>>>>>> ${(jsonEncode(data))}");

        return model; // ✅ return karna zaroori hai
      }
      return null; // ✅ error case
    } else {
      print("Error: ${response.statusCode} - ${response.body}");
      return null; // ✅ error case
    }
  } catch (e) {
    if (context != null) Navigator.of(context, rootNavigator: true).pop();
    print("Exception: $e");
    return null;
  }
}

Future<List<GeoUnitMasterBAL>?> getAbhiyaanGeoUnitMasterData(Map<String, dynamic> inputJson, {BuildContext? context}) async {
  if (context != null) showLoaderDialog(context);
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};
  log(getAbhiyaanGeoUnitListApi);

  try {
    var response = await http.post(Uri.parse(getAbhiyaanGeoUnitListApi), headers: jHeaders, body: jsonEncode(inputJson));

    if (context != null) Navigator.of(context, rootNavigator: true).pop();

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      if (data["Status"] == "200" || data["Status"] == "Success") {
        var abhiyaanGeoUnitMaster = data['GeoUnitListforAbhiyaan'];

        if (abhiyaanGeoUnitMaster.length > 0) {
          log("deleting from AbhiyaanGeoUnitMaster db >>>>>>>>>>>>>> ");
          await DatabaseHelper.executeQuery('DELETE FROM AbhiyaanGeoUnitMaster');

          log("inserting in AbhiyaanGeoUnitMaster db >>>>>>>>>>>>>> ");

          //await dbh.DatabaseHelper.reCreate('GeoUnitMaster', geoUnitData);
          for (var data in abhiyaanGeoUnitMaster) {
            await DatabaseHelper.insertOrUpdateRecord('AbhiyaanGeoUnitMaster', data);
          }
        }

        AbhiyaanGeoUnitListModel model = AbhiyaanGeoUnitListModel.fromJson(data);
        // log("getAbhiyaanGeoUnitMasterData >>>>>>>>>>>>>>>>> ${(jsonEncode(data))}");

        return model.geoUnitListforAbhiyaan; // ✅ return karna zaroori hai
      }
      return null; // ✅ error case
    } else {
      print("Error: ${response.statusCode} - ${response.body}");
      return null; // ✅ error case
    }
  } catch (e) {
    if (context != null) Navigator.of(context, rootNavigator: true).pop();
    print("printing the Exception: $e");
    return null;
  }
}

Future<bool> saveDataforGruhAbhiyaan(Map<String, dynamic> inputJson, {BuildContext? context}) async {
  if (context != null) showLoaderDialog(context);
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};
  log(saveDataforGruhAbhiyaanApi);

  try {
    var response = await http.post(Uri.parse(saveDataforGruhAbhiyaanApi), headers: jHeaders, body: jsonEncode(inputJson));

    if (context != null) Navigator.of(context, rootNavigator: true).pop();

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      log("saveDataforGruhAbhiyaan >>>>>>>>>>>>>>>>> ${(jsonEncode(data))}");

      if (data["Status"] == "200" || data["Status"] == "Success") {
        return true; // ✅ return karna zaroori hai
      }
      return false; // ✅ error case
    } else {
      print("Error: ${response.statusCode} - ${response.body}");
      return false; // ✅ error case
    }
  } catch (e) {
    if (context != null) Navigator.of(context, rootNavigator: true).pop();
    print("Exception: $e");
    return false;
  }
}

Future<GruhAbhiyaanVruttaDataModel?> addToToliListData(Map<String, dynamic> inputJson, {BuildContext? context}) async {
  if (context != null) showLoaderDialog(context);
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};
  log(addToToliListApi);

  try {
    var response = await http.post(Uri.parse(addToToliListApi), headers: jHeaders, body: jsonEncode(inputJson));

    if (context != null) Navigator.of(context, rootNavigator: true).pop();

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      if (data["Status"] == "200" || data["Status"] == "Success") {
        GruhAbhiyaanVruttaDataModel model = GruhAbhiyaanVruttaDataModel.fromJson(data);
        log("getDataforGruhAbhiyaan >>>>>>>>>>>>>>>>> ${(jsonEncode(data))}");

        return model; // ✅ return karna zaroori hai
      }
      return null; // ✅ error case
    } else {
      print("Error: ${response.statusCode} - ${response.body}");
      return null; // ✅ error case
    }
  } catch (e) {
    if (context != null) Navigator.of(context, rootNavigator: true).pop();
    print("Exception: $e");
    return null;
  }
}

Future<SearchAbhiyaanKaryakartaRespModel?> getSwayamsevakForGruhAbhiyaan(Map<String, dynamic> inputJson, {BuildContext? context}) async {
  if (context != null) showLoaderDialog(context);
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};
  log(getSwayamsevakForGruhApi);

  try {
    var response = await http.post(Uri.parse(getSwayamsevakForGruhApi), headers: jHeaders, body: jsonEncode(inputJson));

    if (context != null) Navigator.of(context, rootNavigator: true).pop();

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      if (data["Status"] == "Success") {
        SearchAbhiyaanKaryakartaRespModel model = SearchAbhiyaanKaryakartaRespModel.fromJson(data);
        log("getSwayamsevakForGruhAbhiyaan >>>>>>>>>>>>>>>>> ${(jsonEncode(data))}");

        return model; // ✅ return karna zaroori hai
      }
      return null; // ✅ error case
    } else {
      print("Error: ${response.statusCode} - ${response.body}");
      return null; // ✅ error case
    }
  } catch (e) {
    if (context != null) Navigator.of(context, rootNavigator: true).pop();
    print("Exception: $e");
    return null;
  }
}

Future<List<AbhiyanSwayamsevakList>?> searchPramukhGruhAbhiyaan(Map<String, dynamic> inputJson, {BuildContext? context}) async {
  if (context != null) showLoaderDialog(context);
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};
  log(searchPramukhForGruhApi);

  try {
    var response = await http.post(Uri.parse(searchPramukhForGruhApi), headers: jHeaders, body: jsonEncode(inputJson));

    if (context != null) Navigator.of(context, rootNavigator: true).pop();

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      if (data["Status"] == "Success" || data["Status"] == "200") {
        SearchAbhiyaanKaryakartaRespModel model = SearchAbhiyaanKaryakartaRespModel.fromJson(data);
        log("searchPramukhGruhAbhiyaan >>>>>>>>>>>>>>>>> ${(jsonEncode(data))}");

        return model.swayamsevakList; // ✅ return karna zaroori hai
      }
      return null; // ✅ error case
    } else {
      print("Error: ${response.statusCode} - ${response.body}");
      return null; // ✅ error case
    }
  } catch (e) {
    if (context != null) Navigator.of(context, rootNavigator: true).pop();
    print("Exception: $e");
    return null;
  }
}

Future<bool> saveSwayamsevakForGruhAbhiyaan(Map<String, dynamic> inputJson, {BuildContext? context}) async {
  if (context != null) showLoaderDialog(context);
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};
  log(saveSwayamsevakForGruhApi);

  try {
    var response = await http.post(Uri.parse(saveSwayamsevakForGruhApi), headers: jHeaders, body: jsonEncode(inputJson));

    if (context != null) Navigator.of(context, rootNavigator: true).pop();

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      log("saveSwayamsevakForGruhAbhiyaan >>>>>>>>>>>>>>>>> ${(jsonEncode(data))}");

      if (data["Status"] == "200") {
        return true; // ✅ return karna zaroori hai
      }
      return false; // ✅ error case
    } else {
      print("Error: ${response.statusCode} - ${response.body}");
      return false; // ✅ error case
    }
  } catch (e) {
    if (context != null) Navigator.of(context, rootNavigator: true).pop();
    print("Exception: $e");
    return false;
  }
}

Future<bool> saveAsPramukhForGruhAbhiyaan(Map<String, dynamic> inputJson, {BuildContext? context}) async {
  if (context != null) showLoaderDialog(context);
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};
  log(saveAsPramukhForGruhApi);

  try {
    var response = await http.post(Uri.parse(saveAsPramukhForGruhApi), headers: jHeaders, body: jsonEncode(inputJson));

    if (context != null) Navigator.of(context, rootNavigator: true).pop();

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      log("saveSwayamsevakForGruhAbhiyaan >>>>>>>>>>>>>>>>> ${(jsonEncode(data))}");

      if (data["Status"] == "200") {
        return true; // ✅ return karna zaroori hai
      }
      return false; // ✅ error case
    } else {
      print("Error: ${response.statusCode} - ${response.body}");
      return false; // ✅ error case
    }
  } catch (e) {
    if (context != null) Navigator.of(context, rootNavigator: true).pop();
    print("Exception: $e");
    return false;
  }
}

Future<bool> addSwayamsevakInListForGruhData(Map<String, dynamic> inputJson, {BuildContext? context}) async {
  if (context != null) showLoaderDialog(context);
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};
  log(addSwayamsevakInListForGruhApi);

  try {
    var response = await http.post(Uri.parse(addSwayamsevakInListForGruhApi), headers: jHeaders, body: jsonEncode(inputJson));

    if (context != null) Navigator.of(context, rootNavigator: true).pop();

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      log("addSwayamsevakInListForGruhData >>>>>>>>>>>>>>>>> ${(jsonEncode(data))}");

      if (data["Status"] == "200" || data["Status"] == "Success") {
        return true; // ✅ return karna zaroori hai
      }
      return false; // ✅ error case
    } else {
      print("Error: ${response.statusCode} - ${response.body}");
      return false; // ✅ error case
    }
  } catch (e) {
    if (context != null) Navigator.of(context, rootNavigator: true).pop();
    print("Exception: $e");
    return false;
  }
}

Future<dynamic> getJoinRSSDataByID(String joinRSSID, String type) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var inptuData = json.encode({"AppUserID": userDetails["userID"], "JoinRSSID": int.parse(joinRSSID)});

  var response = await http.post(Uri.parse(urlGetJoinRSSDataForApp), headers: jHeaders, body: inptuData);

  var responseBody = json.decode(response.body);
  log("inptuData --> $inptuData");
  log("responseBody --> $responseBody");
  var data = responseBody['JoinRSSData'];

  return data;
}

Future<Map<String, dynamic>> getSwayamSevakMembersInSoochi(String swayamSevakID) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(Uri.parse(urlGetSwayamsevakSoochisForApp), headers: jHeaders, body: json.encode({"SwayamsevakID": swayamSevakID}));

  var responseBody = json.decode(response.body);

  return responseBody['SwayamsevakSoochis'];
}

Future<List<dynamic>> getShaakhaaPatForApp(String shaakhaaID) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(Uri.parse(urlGetShaakhaaPatForApp), headers: jHeaders, body: json.encode({"ShaakhaaID": shaakhaaID}));
  var responseBody = json.decode(response.body);
  log("{ ShaakhaaID: $shaakhaaID }");
  log("{ responseBody: $responseBody }");
  return responseBody['ShaakhaaPat'];
}

Future<List<dynamic>> getSanghaPreritSanstha(String praantID, String? sanghaPreritSansthaaID, String? sanghaPreritSansthaaName) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(
    Uri.parse(urlGetSanghaPreritSansthaaForApp),
    headers: jHeaders,
    body: json.encode({"AppUserID": userDetails["userID"], "PraantID": praantID, "SanghaPreritSansthaaID": sanghaPreritSansthaaID, "SanghaPreritSansthaaName": sanghaPreritSansthaaName}),
  );

  var responseBody = json.decode(response.body);

  return responseBody['SanghaPreritSansthaaList'];
}

Future<List<dynamic>> getEventList(int? eventID, String? searchPattern, String? fromDate, String? toDate) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(
    Uri.parse(urlGetEventListForApp),
    headers: jHeaders,
    body: json.encode({"EventID": eventID, "AppUserID": userDetails['userID'], "EventName": searchPattern, "FromDateStr": fromDate, "ToDateStr": toDate}),
  );
  print({"EventID": eventID, "AppUserID": userDetails['userID'], "EventName": searchPattern, "FromDateStr": fromDate, "ToDateStr": toDate});
  log(response.body);
  print(Uri.parse(urlGetEventListForApp));
  var responseBody = json.decode(response.body);

  return responseBody['ListEventMaster'];
}

Future<String> saveEventDetails(String inputJson) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};
  print(inputJson);
  print(Uri.parse(urlSaveEventDataForApp));
  var response = await http.post(Uri.parse(urlSaveEventDataForApp), headers: jHeaders, body: inputJson);
  log(response.body);
  var responseBody = json.decode(response.body);

  return responseBody['OutputEventID'].toString();
}

Future<List<dynamic>> getCalenderEventsList(String? swayamsevakCalendarID, String month, String year) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(
    Uri.parse(urlGetSwayamsevakCalendarForApp),
    headers: jHeaders,
    body: json.encode({"SwayamsevakCalendarID": swayamsevakCalendarID, "SwayamsevakID": userDetails['userID'], "CalendarMonth": month, "CalendarYear": year}),
  );

  var responseBody = json.decode(response.body);

  return responseBody['ListSwayamsevakCalendar'];
}

Future<List<dynamic>> getEventMembers(var eventID, var swayamSevakID, var apekshitOrSharing) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(
    Uri.parse(urlGetEventApekshitListForApp),
    headers: jHeaders,
    body: json.encode({"EventID": eventID, "SwayamsevakID": swayamSevakID, "ApekshitOrSharing": apekshitOrSharing}),
  );

  var responseBody = json.decode(response.body);

  return responseBody['ListEventApekshitSwayamsevak'];
}

Future<void> deleteUserToken() async {
  print("started");
  try {
    Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

    var response = await http.post(Uri.parse(deleteUserDeviceToken), headers: jHeaders, body: json.encode({"swayamsevakid": userDetails["userID"]}));

    print(response.request!.url);

    print(response.body);
  } catch (e) {
    print(e);
  }
}

Future<String> saveEventMembers(String inputJson) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(Uri.parse(urlSaveEventApekshitSwayamsevakForApp), headers: jHeaders, body: inputJson);

  var responseBody = json.decode(response.body);

  return responseBody['OutputEventID'].toString();
}

Future<String> deleteEventMembers(String inputJson) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(Uri.parse(urlDeleteEventApekshitSwayamsevakForApp), headers: jHeaders, body: inputJson);

  var responseBody = json.decode(response.body);

  return responseBody['Message'].toString();
}

Future<String> changeEventOwnerForApp(String inputJson) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(Uri.parse(urlChangeEventOwnerForApp), headers: jHeaders, body: inputJson);

  var responseBody = json.decode(response.body);

  return responseBody['Message'].toString();
}

Future<String> saveEventVruttaForApp(String inputJson) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(Uri.parse(urlSaveEventVruttaForApp), headers: jHeaders, body: inputJson);

  var responseBody = json.decode(response.body);

  return responseBody['Message'].toString();
}

Future<List<dynamic>> getEventVruttaList(var eventID, var eventVruttaID) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(Uri.parse(urlGetEventVruttaListForApp), headers: jHeaders, body: json.encode({"EventID": eventID, "EventVruttaID": eventVruttaID}));

  var responseBody = json.decode(response.body);

  return responseBody['ListEventVrutta'];
}

Future<String> deleteEventVrutta(String inputJson) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(Uri.parse(urlDeleteEventVruttaForApp), headers: jHeaders, body: inputJson);

  var responseBody = json.decode(response.body);

  return responseBody['Message'].toString();
}

Future<dynamic> getAnnualBaithakEkatritVruttaForApp(String strInput) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  print(strInput);
  print(Uri.parse(urlGetAnnualBaithakEkatritVruttaForApp));
  var response = await http.post(Uri.parse(urlGetAnnualBaithakEkatritVruttaForApp), headers: jHeaders, body: strInput);

  var responseBody = json.decode(response.body);
  log(responseBody.toString());
  return responseBody['EkatritVrutta'];
}

Future<SankalitBaithakVruttaDataNamesModel?> getSankalitBaithakVruttaDataNames(String strInput) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  try {
    print(strInput);
    print(Uri.parse(getSankalitBaithakVruttaDeatilsNames));
    var response = await http.post(Uri.parse(getSankalitBaithakVruttaDeatilsNames), headers: jHeaders, body: strInput);
    if (response.statusCode == 200) {
      var responseBody = json.decode(response.body);
      log(responseBody.toString());

      return SankalitBaithakVruttaDataNamesModel.fromJson(responseBody);
    } else {
      log("Error: ${response.statusCode}");
      return null;
    }
  } catch (e) {
    log("Exception: $e");
    return null;
  }
}

// Future<dynamic> getTulnatmakBaithakEkatritVruttaForApp(String strInput) async {
//   Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};
//
//   print(strInput);
//   print(Uri.parse(tulnatmakEkatritVruttaForApp));
//   var response = await http.post(Uri.parse(tulnatmakEkatritVruttaForApp), headers: jHeaders, body: strInput);
//
//   var responseBody = json.decode(response.body);
//   log(responseBody.toString());
// }

Future<TulnatmakBaithakResponse?> getTulnatmakBaithakEkatritVruttaForApp(String strInput) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  print(strInput);
  print(Uri.parse(tulnatmakEkatritVruttaForApp));

  var response = await http.post(Uri.parse(tulnatmakEkatritVruttaForApp), headers: jHeaders, body: strInput);

  if (response.statusCode == 200) {
    var responseBody = json.decode(response.body);
    log(responseBody.toString());

    // Parse the response body into the model
    TulnatmakBaithakResponse tulnatmakBaithakResponse = TulnatmakBaithakResponse.fromJson(responseBody);

    return tulnatmakBaithakResponse;
  } else {
    // Handle error
    log("Failed to load data: ${response.statusCode}");
    return null;
  }
}

Future<GetVastiDataByIdModel?> getVastidataByIDForApp(context, String strInput) async {
  showLoaderDialog(context);

  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  print(strInput);
  print(Uri.parse(getvastiSarvekshan));

  var response = await http.post(Uri.parse(getvastiSarvekshan), headers: jHeaders, body: strInput);

  if (response.statusCode == 200) {
    var responseBody = json.decode(response.body);
    log(responseBody.toString());

    // Parse the response body into the model
    GetVastiDataByIdModel vastiDataByIdModel = GetVastiDataByIdModel.fromJson(responseBody);
    Navigator.of(context, rootNavigator: true).pop();

    return vastiDataByIdModel;
  } else {
    // Handle error
    log("Failed to load data: ${response.statusCode}");
    Navigator.of(context, rootNavigator: true).pop();

    return null;
  }
}

Future<dynamic> getAnnualBaithakNagarVruttaForApp(String strInput) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(Uri.parse(urlGetAnnualBaithakNagarVruttaForApp), headers: jHeaders, body: strInput);
  // print(strInput);
  // print(Uri.parse(urlGetAnnualBaithakNagarVruttaForApp));
  var responseBody = json.decode(response.body);

  return responseBody['NagarVrutta'];
}

Future<NIrikshanBiathakVruttaModel?> getNirikshanAnnualBaithakNagarVruttaForApp(String strInput) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(Uri.parse(getnirikshanbhaithakvruttaforapp), headers: jHeaders, body: strInput);
  print("getNirikshanAnnualBaithakNagarVruttaForApp => $strInput");
  print(Uri.parse(getnirikshanbhaithakvruttaforapp));

  if (response.statusCode == 200) {
    var responseBody = json.decode(response.body);
    print("responseBody --> $responseBody");
    return NIrikshanBiathakVruttaModel.fromJson(responseBody);
  } else {
    // Handle error
    print('Failed to load data: ${response.statusCode}');
    return null;
  }
}

Future<String> saveAnnualBaithakNagarVruttaForApp(String inputJson) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(Uri.parse(urlSaveAnnualBaithakNagarVruttaForApp), headers: jHeaders, body: inputJson);

  var responseBody = json.decode(response.body);

  return responseBody['AnnualBaithakNagarVruttaID'].toString();
}

Future<List<dynamic>> getAnnualBaithakShaakhaaVruttaForApp(String strInput) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(Uri.parse(urlGetAnnualBaithakShaakhaaVruttaForApp), headers: jHeaders, body: strInput);

  print(Uri.parse(urlGetAnnualBaithakShaakhaaVruttaForApp));
  print(strInput.toString());
  var responseBody = json.decode(response.body);

  return responseBody['ListShaakhaaVrutta'];
}

Future<List<dynamic>> getAnnualBaithakShaakhaaVruttaForAppById(String strInput) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(Uri.parse(GetAnnualBaithakShaakhaaVruttaForAppbyid), headers: jHeaders, body: strInput);

  print(Uri.parse(GetAnnualBaithakShaakhaaVruttaForAppbyid));
  print(strInput.toString());
  var responseBody = json.decode(response.body);
  print("responseBody getAnnualBaithakShaakhaaVruttaForAppById $responseBody");
  return responseBody['ListShaakhaaVrutta'];
}

Future<String> saveAnnualBaithakShaakhaaVruttaForApp(String inputJson) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(Uri.parse(urlSaveAnnualBaithakShaakhaaVruttaForApp), headers: jHeaders, body: inputJson);

  print(Uri.parse(urlSaveAnnualBaithakShaakhaaVruttaForApp));
  var responseBody = json.decode(response.body);

  return responseBody['AnnualBaithakShaakhaaVruttaID'].toString();
}

Future<List<dynamic>> getAnnualBaithakShaakhaaViheenForApp(String strInput) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(Uri.parse(urlGetAnnualBaithakShaakhaaViheenForApp), headers: jHeaders, body: strInput);
  print(strInput);
  // print(Uri.parse(urlGetAnnualBaithakShaakhaaViheenForApp));
  var responseBody = json.decode(response.body);

  return responseBody['ListShaakhaaViheenVrutta'];
}

Future<String> saveAnnualBaithakShaakhaaViheenForApp(String inputJson) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(Uri.parse(urlSaveAnnualBaithakShaakhaaViheenForApp), headers: jHeaders, body: inputJson);

  var responseBody = json.decode(response.body);

  return responseBody['AnnualBaithakShaakhaaViheenVruttaID'].toString();
}

Future<List<dynamic>> getAnnualBaithakMukhyaMaargForApp(String strInput) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(Uri.parse(urlGetAnnualBaithakMukhyaMaargForApp), headers: jHeaders, body: strInput);
  // print(strInput);
  // print(Uri.parse(urlGetAnnualBaithakMukhyaMaargForApp));
  var responseBody = json.decode(response.body);

  return responseBody['ListMukhyaMaargVrutta'];
}

Future<String> saveAnnualBaithakMukhyaMaargForApp(String inputJson) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(Uri.parse(urlSaveAnnualBaithakMukhyaMaargForApp), headers: jHeaders, body: inputJson);

  var responseBody = json.decode(response.body);

  return responseBody['AnnualBaithakMukhyaMaargVruttaID'].toString();
}

Future<List<dynamic>> getAnnualBaithakGraamVikasForApp(String strInput) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(Uri.parse(urlGetAnnualBaithakGraamVikasForApp), headers: jHeaders, body: strInput);
  // print(strInput);
  // print(Uri.parse(urlGetAnnualBaithakGraamVikasForApp));
  var responseBody = json.decode(response.body);

  return responseBody['ListGraamVikasVrutta'];
}

Future<String> saveAnnualBaithakGraamVikasForApp(String inputJson) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(Uri.parse(urlSaveAnnualBaithakGraamVikasForApp), headers: jHeaders, body: inputJson);

  var responseBody = json.decode(response.body);

  return responseBody['AnnualBaithakGraamVikasVruttaID'].toString();
}

Future<List<dynamic>> getShaakhaaVruttaListForApp(var shaakhaaID, var shaakhaaVruttaID) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(Uri.parse(urlGetShaakhaaVruttaListForApp), headers: jHeaders, body: json.encode({"ShaakhaaID": shaakhaaID, "ShaakhaaVruttaID": shaakhaaVruttaID}));

  var responseBody = json.decode(response.body);

  // lstShaakhaaVrutta= [];
  // if (responseBody.length > 0) {
  //   for (var data in responseBody['ShaakhaaVruttaList']) {
  //     lstShaakhaaVrutta.add(ShaakhaaVruttaBAL.fromMap(data));
  //   }
  // }

  return responseBody['ShaakhaaVruttaList'];
}

Future<String> saveShaakhaaVruttaForApp(String inputJson) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(Uri.parse(urlSaveShaakhaaVruttaForApp), headers: jHeaders, body: inputJson);

  var responseBody = json.decode(response.body);
  print("saveShaakhaaVruttaForApp inputJson -> $inputJson");
  print("saveShaakhaaVruttaForApp responseBody -> $responseBody");
  return responseBody['OutputShaakhaaVruttaID'].toString();
}

Future<GetgeounitNameModel?> getlevelUpdatedata(String inputJson) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(Uri.parse(urlGetgeounitNamebyid), headers: jHeaders, body: inputJson);

  if (response.statusCode == 200) {
    var responseBody = json.decode(response.body);
    GetgeounitNameModel geounitNameModel = GetgeounitNameModel.fromJson(responseBody); // Store response in model
    print("getlevelUpdatedata inputJson -> $inputJson");
    print("getlevelUpdatedata responseBody -> $responseBody");
    return geounitNameModel;
  } else {
    print("Error: ${response.statusCode} - ${response.body}");
    return null;
  }
}

Future<VastiUpDataListModel?> getVastiUpdata(String inputJson) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(Uri.parse(getupnagarmandaldataagainstnagar), headers: jHeaders, body: inputJson);

  if (response.statusCode == 200) {
    var responseBody = json.decode(response.body);
    VastiUpDataListModel vastiUpDataListModel = VastiUpDataListModel.fromJson(responseBody); // Store response in model
    print("vastiUpDataListModel inputJson -> $inputJson");
    log("vastiUpDataListModel responseBody -> $responseBody");
    return vastiUpDataListModel;
  } else {
    print("Error: ${response.statusCode} - ${response.body}");
    return null;
  }
}

Future<void> savelevelUpdatedata(context, String inputJson) async {
  showLoaderDialog(context);

  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(Uri.parse(urlUpdategeounitNamebyid), headers: jHeaders, body: inputJson);

  print("Response: ${response.body}");
  print("response.statusCode: ${response.statusCode}");

  if (response.statusCode == 200) {
    Statics.showToast(Statics.getLabel('dataSavedSuccessfully'));
    Navigator.of(context, rootNavigator: true).pop();
  } else {
    print("Error: ${response.statusCode} - ${response.body}");
    Navigator.of(context, rootNavigator: true).pop();
  }
}

Future<VastiUpDataListModel?> saveUpNagarUpkhandadata(context, String inputJson) async {
  showLoaderDialog(context);

  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(Uri.parse(updatevastimasndalparent), headers: jHeaders, body: inputJson);

  print("Response: ${response.body}");
  print("response.statusCode: ${response.statusCode}");

  if (response.statusCode == 200) {
    Statics.showToast(Statics.getLabel('dataSavedSuccessfully'));
    final data = await getVastiUpdata(inputJson);
    Navigator.of(context, rootNavigator: true).pop();
    return data;
  } else {
    print("Error: ${response.statusCode} - ${response.body}");
    Navigator.of(context, rootNavigator: true).pop();
    return null;
  }
}

Future<String> deleteShaakhaaVrutta(String inputJson) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};
  var response = await http.post(Uri.parse(urlDeleteShaakhaaVruttaForApp), headers: jHeaders, body: inputJson);
  var responseBody = json.decode(response.body);
  return responseBody['Message'].toString();
}

void convertToCsv(List<List<dynamic>> rows, String fileName, BuildContext context) async {
  if (Platform.isIOS) {
    if (await Permission.storage.request().isGranted) {
      try {
        Directory documents = await getApplicationDocumentsDirectory();
        String dir = documents.path;
        var file = "$dir";
        File f = new File(file + fileName + ".csv");
        print(f.path);
        String csv = const ListToCsvConverter().convert(rows);
        f.writeAsString(csv);
        print(f.path);
        await OpenFilex.open(f.path);
        return;
      } catch (e) {
        print(e);
        return;
      }
    } else {
      Statics.showToast("Storage permission is not granted");
      print("no permission");
    }
  }
  final deviceInfo = await DeviceInfoPlugin().androidInfo;

  if (deviceInfo.version.sdkInt > 32) {
    if (!await Permission.photos.isGranted) {
      await Permission.photos.request();
    }
    if (await Permission.photos.request().isGranted) {
      try {
        Directory documents = await getApplicationDocumentsDirectory();
        String dir = Platform.isAndroid
            ? '/storage/emulated/0/Download/'
            : Platform.isIOS
                ? documents.path
                : "";
        var file = "$dir";
        File f = new File(file + fileName + ".csv");

        print(f.path);
        String csv = const ListToCsvConverter().convert(rows);
        f.writeAsString(csv);
        print(f.path);
        await OpenFilex.open(f.path);
      } catch (e) {
        print(e);
      }
    } else {
      Statics.showToast("Storage permission is not granted");
      print("no permission");
    }
  } else {
    if (!await Permission.storage.isGranted) {
      await Permission.photos.request();
    }
    if (await Permission.storage.request().isGranted) {
      try {
        Directory documents = await getApplicationDocumentsDirectory();
        String dir = Platform.isAndroid
            ? '/storage/emulated/0/Download/'
            : Platform.isIOS
                ? documents.path
                : "";
        var file = "$dir";
        File f = new File(file + fileName + ".csv");

        print(f.path);
        // convert rows to String and write as csv file
        String csv = const ListToCsvConverter().convert(rows);
        f.writeAsString(csv);
        print(f.path);
        await OpenFilex.open(f.path);
      } catch (e) {
        print(e);
      }
    } else {
      Statics.showToast("Storage permission is not granted");
      print("no permission");
    }
  }
}

Future<String> saveShaakhaaCoordinatesForApp(String inputJson) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(Uri.parse(urlSaveShaakhaaCoordinatesForApp), headers: jHeaders, body: inputJson);

  var responseBody = json.decode(response.body);

  return responseBody['Message'].toString();
}

Future<List<dynamic>> getUniversity(var universityID, String? strInput, bool isForDistanceLearning) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(
    Uri.parse(urlGetEducationUniversitysForApp),
    headers: jHeaders,
    body: json.encode({"PraantID": 1, "EducationUniversityID": universityID, "UniversityName": strInput, "IsForDistanceLearning": isForDistanceLearning}),
  );

  var responseBody = json.decode(response.body);

  return responseBody['EducationUniversityList'];
}

Future<List<dynamic>> getCollege(var educationInstitutionID, var universityID, String? strInput) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(
    Uri.parse(urlGetEducationInstitutionsForApp),
    headers: jHeaders,
    body: json.encode({"PraantID": 1, "EducationUniversityID": universityID, "EducationInstitutionID": educationInstitutionID, "InstitutionName": strInput}),
  );

  var responseBody = json.decode(response.body);

  return responseBody['EducationInstitutionList'];
}

Future<List<dynamic>> getGetEducationProgramsForApp(var educationProgramID, var universityID, String? strInput) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};
  var response = await http.post(
    Uri.parse(urlGetEducationProgramsForApp),
    headers: jHeaders,
    body: json.encode({"PraantID": 1, "EducationUniversityID": universityID, "EducationProgramID": educationProgramID, "ProgramName": strInput}),
  );
  var responseBody = json.decode(response.body);
  return responseBody['EducationProgramList'];
}

Future<List<dynamic>> getEducationCoursesForApp(var educationCourseID, var universityID, String? strInput) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(
    Uri.parse(urlGetEducationCoursesForApp),
    headers: jHeaders,
    body: json.encode({"PraantID": 1, "EducationUniversityID": universityID, "EducationCourseID": educationCourseID, "CourseName": strInput}),
  );

  var responseBody = json.decode(response.body);
  return responseBody['EducationCourseList'];
}

Future<List<dynamic>> getDistrictForApp(String praantID, String? stateID, String? districtID) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var request = json.encode({"PraantID": 1, "AppUserID": userDetails['userID'], "StateID": stateID == "" || stateID == "null" ? null : stateID, "DistrictID": districtID == "" ? null : districtID});
  try {
    print(Uri.parse(urlGetDistrictsForApp));
    print(request);
    var response = await http.post(Uri.parse(urlGetDistrictsForApp), headers: jHeaders, body: request);
    log(response.body);
    var responseBody = json.decode(response.body);
    return responseBody['DistrictList'];
  } catch (e) {
    print(">>>> " + e.toString());
    return [];
  }
}

Future<dynamic> getSwayamsevakOtherInfoForApp(String swayamsevakID) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  print(Uri.parse(Statics.urlGetSwayamsevakOtherInfoForApp));
  print({"AppUserID": userDetails['userID'], "SwayamsevakID": swayamsevakID});
  var response = await http.post(Uri.parse(Statics.urlGetSwayamsevakOtherInfoForApp), headers: jHeaders, body: json.encode({"AppUserID": userDetails['userID'], "SwayamsevakID": swayamsevakID}));
  log(response.body);
  var responseBody = json.decode(response.body);
  var data = responseBody['SwayamsevakOtherInfo'];
  return data;
}

Future<List<GeoUnitMasterBAL>> getGeoUnitMasterForApp(
  String geoUnitID,
  String praantID,
  String geoUnitName,
  String levelID,
  String parentMahaanagarID,
  String parentVibhaagID,
  String parentBhaagID,
  String parentShaharID,
  String parentNagarID,
  String parentMandalID,
  String parentGraamID,
  String parentVastiID,
) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(
    Uri.parse(urlGetGeoUnitMasterForApp),
    headers: jHeaders,
    body: json.encode({
      "AppUserID": userDetails['userID'],
      "GeoUnitID": geoUnitID == '' ? null : geoUnitID,
      "PraantID": praantID,
      "GeoUnitName": geoUnitName == '' ? null : geoUnitName,
      "LevelID": levelID == '' ? null : levelID,
      "ParentMahaanagarID": parentMahaanagarID == '' ? null : parentMahaanagarID,
      "ParentVibhaagID": parentVibhaagID == '' ? null : parentVibhaagID,
      "ParentBhaagID": parentBhaagID == '' ? null : parentBhaagID,
      "ParentShaharID": parentShaharID == '' ? null : parentShaharID,
      "ParentNagarID": parentNagarID == '' ? null : parentNagarID,
      "ParentMandalID": parentMandalID == '' ? null : parentMandalID,
      "ParentGraamID": parentGraamID == '' ? null : parentGraamID,
      "ParentVastiID": parentVastiID == '' ? null : parentVastiID,
    }),
  );

  var responseBody = json.decode(response.body);
  List<GeoUnitMasterBAL>? geoUnitList = [];

  responseBody["GeoUnitMasterList"].forEach((data) {
    var info = GeoUnitMasterBAL(
      data['GeoUnitID'],
      data['PraantID'],
      data['LevelID'],
      data['GeoUnitName'],
      "",
      data['LevelName'],
      data['GeoUnitName'],
      data['DisplaySequence'],
      null,
      data['ParentKshetraID'],
      data['ParentPraantID'],
      data['ParentMahaanagarID'],
      data['ParentVibhaagID'],
      data['ParentBhaagID'],
      data['ParentNagarID'],
      data['ParentShaharID'],
      data['ParentMandalID'],
      data['ParentVastiID'],
      data['ParentGraamID'],
    );
    geoUnitList.add(info);
  });
  return geoUnitList;
  //return responseBody['GeoUnitMasterList'];
}

Future<List<dynamic>> getShaakhaaSewaVastiLinksForApp(var shaakhaaID) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(Uri.parse(urlGetShaakhaaSewaVastiLinksForApp), headers: jHeaders, body: json.encode({"ShaakhaaID": shaakhaaID}));

  var responseBody = json.decode(response.body);

  return responseBody['ShaakhaaSewaVastiLinkList'];
}

Future<String> saveShaakhaaSewaVastiLinkForApp(String inputJson) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(Uri.parse(urlSaveShaakhaaSewaVastiLinkForApp), headers: jHeaders, body: inputJson);

  var responseBody = json.decode(response.body);

  return responseBody['OutputShaakhaaID'].toString();
}

//==============================================================================================================================================
void showLoaderDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // disables tap outside
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async => false, // disables back button
        child: Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [CircularProgressIndicator(), SizedBox(width: 20), Flexible(child: Text(Statics.getLabel("loadingDialog"), style: TextStyle(fontSize: 16)))],
            ),
          ),
        ),
      );
    },
  );
}

Future<String> vastiSarvekshanStep1FormSubmit(context, String inputJson) async {
  showLoaderDialog(context);
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  try {
    var response = await http.post(Uri.parse(vastiSarvekshanstep1Submit), headers: jHeaders, body: inputJson);
    var responseBody = json.decode(response.body);
    print("responseBody  --=> $responseBody");
    print("responseBody  Status --=> ${responseBody["Status"]}");
    if (responseBody["Status"] == "200") {
      log("response --> $response");
      Fluttertoast.showToast(msg: "माहिती संग्रहित झाली.", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
      Navigator.of(context, rootNavigator: true).pop();
      return "success";
    } else {
      Fluttertoast.showToast(msg: responseBody['msg'] ?? "काहीतरी गडबड आहे.", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
      Navigator.of(context, rootNavigator: true).pop();
      return "failed";
    }
  } catch (e) {
    Fluttertoast.showToast(msg: "Error: ${e.toString()}", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
    Navigator.of(context, rootNavigator: true).pop();
    return "error";
  }
}

Future<String> vastiSarvekshanStep2FormSubmit(context, String inputJson) async {
  showLoaderDialog(context);

  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  try {
    var response = await http.post(Uri.parse(vastiSarvekshanstep2Submit), headers: jHeaders, body: inputJson);
    var responseBody = json.decode(response.body);
    print("responseBody  --=> $responseBody");
    print("responseBody  Status --=> ${responseBody["Status"]}");
    if (responseBody["Status"] == "200") {
      log("response --> $response");
      Fluttertoast.showToast(msg: "माहिती संग्रहित झाली.", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
      Navigator.of(context, rootNavigator: true).pop();

      return "success";
    } else {
      Fluttertoast.showToast(msg: responseBody['msg'] ?? "काहीतरी गडबड आहे.", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
      Navigator.of(context, rootNavigator: true).pop();
      return "failed";
    }
  } catch (e) {
    Fluttertoast.showToast(msg: "Error: ${e.toString()}", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
    Navigator.of(context, rootNavigator: true).pop();
    return "error";
  }
}

Future<String> vastiSarvekshanStep3FormSubmit(context, String inputJson) async {
  showLoaderDialog(context);

  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  try {
    var response = await http.post(Uri.parse(vastiSarvekshanstep3Submit), headers: jHeaders, body: inputJson);

    var responseBody = json.decode(response.body);
    print("responseBody  --=> $responseBody");
    print("responseBody  Status --=> ${responseBody["Status"]}");
    if (responseBody["Status"] == "200") {
      log("response --> $response");
      Fluttertoast.showToast(msg: "माहिती संग्रहित झाली.", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
      Navigator.of(context, rootNavigator: true).pop();

      return "success";
    } else {
      Fluttertoast.showToast(msg: responseBody['msg'] ?? "काहीतरी गडबड आहे.", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
      Navigator.of(context, rootNavigator: true).pop();

      return "failed";
    }
  } catch (e) {
    Fluttertoast.showToast(msg: "Error: ${e.toString()}", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
    Navigator.of(context, rootNavigator: true).pop();

    return "error";
  }
}

Future<String> mandalSarvekshanStep1FormSubmit(String inputJson) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  try {
    var response = await http.post(Uri.parse(mandalSarvekshanstep1Submit), headers: jHeaders, body: inputJson);

    var responseBody = json.decode(response.body);

    if (response.statusCode == 200) {
      Fluttertoast.showToast(msg: "Form submitted successfully", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
      return "success";
    } else {
      Fluttertoast.showToast(msg: responseBody['msg'] ?? "Submission failed", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
      return "failed";
    }
  } catch (e) {
    Fluttertoast.showToast(msg: "Error: ${e.toString()}", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
    return "error";
  }
}

Future<String> mandalSarvekshanStep3FormSubmit(String inputJson) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  try {
    var response = await http.post(Uri.parse(mandalSarvekshanstep3Submit), headers: jHeaders, body: inputJson);

    var responseBody = json.decode(response.body);

    if (response.statusCode == 200) {
      Fluttertoast.showToast(msg: "Form submitted successfully", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
      return "success";
    } else {
      Fluttertoast.showToast(msg: responseBody['msg'] ?? "Submission failed", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
      return "failed";
    }
  } catch (e) {
    Fluttertoast.showToast(msg: "Error: ${e.toString()}", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
    return "error";
  }
}

Future<List<dynamic>> getJoinRSSGridByStatus(int geoUnitID, int statusID, String searchString, String fromDate, String toDate) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(
    Uri.parse(urlGetJoinRSSGridForApp),
    headers: jHeaders,
    body: json.encode({"AppUserID": userDetails["userID"], "SearchCriteria": searchString, "GeoUnitID": geoUnitID, "StatusID": statusID, "JoiningDateFrom": fromDate, "JoiningDateTo": toDate}),
  );

  var responseBody = json.decode(response.body);

  return responseBody['ListJoinRSSByStatus'];
}

Future<List<dynamic>> getSewaVastiForApp(String strInputBody) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(Uri.parse(urlGetSewaVastiForApp), headers: jHeaders, body: strInputBody);

  var responseBody = json.decode(response.body);
  log("strInputBody :--  $strInputBody");
  log("responseBody :--  $responseBody");
  return responseBody['SewaVastiList'];
}

Future<String> saveSewaVastiForApp(String inputJson) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(Uri.parse(urlSaveSewaVastiForApp), headers: jHeaders, body: inputJson);

  var responseBody = json.decode(response.body);
  log("saveSewaVastiForApp inputJson  :- $inputJson");
  log("saveSewaVastiForApp responseBody  :- $responseBody");
  return responseBody['SewaVastiID'].toString();
}

Future<String> deleteSewaVastiForApp(String inputJson) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(Uri.parse(urlDeleteSewaVastiForApp), headers: jHeaders, body: inputJson);

  var responseBody = json.decode(response.body);

  return responseBody['Message'].toString();
}

void openUserManual(String strSection) async {
  //await launch('https://drive.google.com/drive/folders/1K6xxqtv6bz64yfBA-Rxh1ifpKah8QRoA');
  if (userDetails['languagePreference'] == 'Marathi') {
    await canLaunch(urlUserManualMarathi + strSection) ? await launch(urlUserManualMarathi + strSection) : throw 'Could not launch $urlUserManualMarathi' + strSection;
  } else if (userDetails['languagePreference'] == 'Hindi') {
    await canLaunch(urlUserManualHindi + strSection) ? await launch(urlUserManualHindi + strSection) : throw 'Could not launch $urlUserManualHindi' + strSection;
  } else {
    await canLaunch(urlUserManualEnglish + strSection) ? await launch(urlUserManualEnglish + strSection) : throw 'Could not launch $urlUserManualEnglish' + strSection;
  }
}

Future<List<dynamic>> getSwayamsevakTransferList(String strInput) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(Uri.parse(urlGetSwayamsevakTransferForAppGrid), headers: jHeaders, body: strInput);

  var responseBody = json.decode(response.body);

  return responseBody['SwayamsevakTransferList'];
}

Future<dynamic> getSwayamsevakTransferByID(String swayamsevakTransferID, String swayamsevakID) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  print(Uri.parse(urlGetSwayamsevakTransferDetailsForApp));
  print({"AppUserID": userDetails['userID'], "SwayamsevakTransferID": swayamsevakTransferID, "SwayamsevakID": swayamsevakID});
  var response = await http.post(
    Uri.parse(urlGetSwayamsevakTransferDetailsForApp),
    headers: jHeaders,
    body: json.encode({"AppUserID": userDetails['userID'], "SwayamsevakTransferID": swayamsevakTransferID, "SwayamsevakID": swayamsevakID}),
  );

  log(response.body);
  var responseBody = json.decode(response.body);

  return SwayamsevakTransferBAL.fromMap(responseBody['SwayamsevakTransferItem']);
}

Future<String> saveSwayamsevakTransferDetails(String inputJson) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(Uri.parse(urlSaveSwayamsevakTransferForApp), headers: jHeaders, body: inputJson);

  var responseBody = json.decode(response.body);

  return responseBody['OutputSwayamsevakTransferID'].toString();
}

Future<String> deleteSwayamsevakTransferForApp(String inputJson) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(Uri.parse(urlDeleteSwayamsevakTransferForApp), headers: jHeaders, body: inputJson);

  var responseBody = json.decode(response.body);

  return responseBody['Message'].toString();
}

Future<String> deleteVisheshVyaktiForApp(String inputJson) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};
  var response = await http.post(Uri.parse(deleteabhiyangruhasampark), headers: jHeaders, body: inputJson);
  print("response ${response.body}");
  print("inputJson ${inputJson}");
  var responseBody = json.decode(response.body);
  return responseBody['Message'].toString();
}

Future<String> deleteSahbhagiKaryakarta(String inputJson) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(Uri.parse(deleteabhiyanswayamsevak), headers: jHeaders, body: inputJson);

  print("response ${response.body}");
  print("inputJson ${inputJson}");
  var responseBody = json.decode(response.body);
  return responseBody['Message'].toString();
}

Future<String> deleteSwayamsevakDataForApp(String inputJson) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(Uri.parse(urlDeleteSwayamsevakDataForApp), headers: jHeaders, body: inputJson);

  var responseBody = json.decode(response.body);

  return responseBody['Message'].toString();
}

Future<List<dynamic>> getNidhiSankalanVruttaForApp(String strInput) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};
  var response = await http.post(Uri.parse(urlGetNidhiSankalanVruttaForApp), headers: jHeaders, body: strInput);
  log("getNidhiSankalanVruttaForApp :--- ${response.body}");
  var responseBody = json.decode(response.body);
  return responseBody['ListParticipantVisheshVyakti'] ?? [];
}

Future<List<dynamic>> getShaakhaaToliSadasyaForApp(String strInput) async {
  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};
  var response = await http.post(Uri.parse(urlGetShaakhaaToliSadasyaForApp), headers: jHeaders, body: strInput);
  var responseBody = json.decode(response.body);
  return responseBody['ListToliSadasya'];
}

Widget createWidgetFromString(BuildContext context, String label, double width, double height, Alignment alignment, {bool isTotalRow = false}) {
  return Container(
    child: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
    width: width,
    height: 90,
    padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
    alignment: alignment,
    color: (isTotalRow ? Theme.of(context).colorScheme.secondary.withOpacity(0.1) : Colors.white),
  );
}

Widget createWidgetFromIcon(BuildContext context, IconData? iconData, double width, double height, Alignment alignment, {bool isTotalRow = false}) {
  return Container(
    child: Icon(iconData, color: Colors.purple),
    width: width,
    height: height,
    padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
    alignment: alignment,
    color: (isTotalRow ? Theme.of(context).colorScheme.secondary.withOpacity(0.1) : Colors.white),
  );
}

class MenuItem {
  String menuVal;
  IconData iconVal;
  String menuKey;

  MenuItem(this.menuVal, this.iconVal, this.menuKey);
}

class ScreenArguments {
  int itemID;
  String viewType;

  ScreenArguments(this.itemID, this.viewType);
}

class ScreenArgumentsNew {
  final int itemID;
  final String viewType;
  final String? name;
  final String? email;
  final String? mobile;

  ScreenArgumentsNew(this.itemID, this.viewType, {this.name, this.email, this.mobile});
}

class ScreenArgumentsForSoochi {
  String itemID;
  String viewType;

  ScreenArgumentsForSoochi(this.itemID, this.viewType);
}

class ScreenArgumentsSwayamsevakTransfer {
  String swTransferID;
  String swID;
  String viewType;

  ScreenArgumentsSwayamsevakTransfer(this.swTransferID, this.swID, this.viewType);
}

class ScreenArguments2 {
  String? swayamsevakID;
  String? viewType;
  var onSaveDetails;
  String? daayitvaForID;
  String? daayitvaForCode;
  String? dataID;

  ScreenArguments2(this.swayamsevakID, this.viewType, this.onSaveDetails, this.daayitvaForID, this.daayitvaForCode, this.dataID);
}

class ArgIdVal {
  int itemID;
  String itemVal;

  ArgIdVal(this.itemID, this.itemVal);
}

class cLatLong {
  int shaakhaID;
  String shaakhaaName;
  String description;
  LatLng latlng;

  cLatLong(this.shaakhaID, this.shaakhaaName, this.description, this.latlng);
}

List<int> defColors = [
  0xff641E16,
  0xffFF0000,
  0xff154360,
  0xff8670bf,
  0xfff74215,
  0xff0E6251,
  0xff7D6608,
  0xff2d8616,
  0xff6E2C00,
  0xff145A32,
  0xffeaf30b,
  0xff333344,
  0xfffbffa2,
  0xffb31fb9,
  0xff0aff00,
  0xff512E5F,
  0xff5f0000,
  0xff442222,
  0xfff31047,
  0xff109151,
  0xffffd600,
  0xffbf8670,
  0xff808080,
  0xffFF0000,
  0xff808000,
  0xff00FFFF,
  0xff008080,
  0xffFF00FF,
  0xff800080,
  0xff4682B4,
  0xff191970,
  0xffBC8F8F,
  0xffD2691E,
  0xffA0522D,
];
