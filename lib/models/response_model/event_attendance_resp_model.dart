import '../../screens/event_attendance_screen.dart';

class EvenAttendanceRespModel {
  String? status;
  String? message;
  int? totalExpected;
  int? totalPresentCnt;
  int? totalHalfpresentCnt;
  int? totalAbsentCnt;
  int? noResponseCnt;
  List<AttendanceSwayamsevak>? noResponse;
  List<AttendanceSwayamsevak>? absent;
  List<AttendanceSwayamsevak>? present;
  List<AttendanceSwayamsevak>? halfpresent;

  EvenAttendanceRespModel(
      {this.status,
      this.message,
      this.totalExpected,
      this.totalPresentCnt,
      this.totalHalfpresentCnt,
      this.totalAbsentCnt,
      this.noResponseCnt,
      this.noResponse,
      this.absent,
      this.present,
      this.halfpresent});

  EvenAttendanceRespModel.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    totalExpected = json['totalExpected'];
    totalPresentCnt = json['totalPresentCnt'];
    totalHalfpresentCnt = json['totalHalfpresentCnt'];
    totalAbsentCnt = json['totalAbsentCnt'];
    noResponseCnt = json['noResponseCnt'];
    if (json['noResponse'] != null) {
      noResponse = <AttendanceSwayamsevak>[];
      json['noResponse'].forEach((v) {
        noResponse!.add(new AttendanceSwayamsevak.fromJson(v, AttendanceStatus.noResponse));
      });
    }
    if (json['Absent'] != null) {
      absent = <AttendanceSwayamsevak>[];
      json['Absent'].forEach((v) {
        absent!.add(new AttendanceSwayamsevak.fromJson(v, AttendanceStatus.absent));
      });
    }
    if (json['Present'] != null) {
      present = <AttendanceSwayamsevak>[];
      json['Present'].forEach((v) {
        present!.add(new AttendanceSwayamsevak.fromJson(v, AttendanceStatus.present));
      });
    }
    if (json['Halfpresent'] != null) {
      halfpresent = <AttendanceSwayamsevak>[];
      json['Halfpresent'].forEach((v) {
        halfpresent!.add(new AttendanceSwayamsevak.fromJson(v, AttendanceStatus.half));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['Message'] = this.message;
    data['totalExpected'] = this.totalExpected;
    data['totalPresentCnt'] = this.totalPresentCnt;
    data['totalHalfpresentCnt'] = this.totalHalfpresentCnt;
    data['totalAbsentCnt'] = this.totalAbsentCnt;
    data['noResponseCnt'] = this.noResponseCnt;
    if (this.noResponse != null) {
      data['noResponse'] = this.noResponse!.map((v) => v.toJson()).toList();
    }
    if (this.absent != null) {
      data['Absent'] = this.absent!.map((v) => v.toJson()).toList();
    }
    if (this.present != null) {
      data['Present'] = this.present!.map((v) => v.toJson()).toList();
    }
    if (this.halfpresent != null) {
      data['Halfpresent'] = this.halfpresent!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AttendanceSwayamsevak {
  int? swayamsevakID;
  String? fullName;
  String? mobileNumber;
  String? dname;
  String? reason;
  final AttendanceStatus status;

  AttendanceSwayamsevak({this.swayamsevakID, this.fullName, this.mobileNumber, this.dname, this.reason, required this.status});

  factory AttendanceSwayamsevak.fromJson(Map<String, dynamic> json, AttendanceStatus status) {
    return AttendanceSwayamsevak(
      swayamsevakID: json['SwayamsevakID'] is int ? json['SwayamsevakID'] : int.tryParse('${json['SwayamsevakID']}') ?? 0,
      fullName: json['FullName'] ?? '--',
      mobileNumber: json['MobileNumber'] ?? '',
      dname: json['dname'] ?? '',
      reason: json['reason'] ?? '',
      status: status,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SwayamsevakID'] = this.swayamsevakID;
    data['FullName'] = this.fullName;
    data['MobileNumber'] = this.mobileNumber;
    data['dname'] = this.dname;
    data['reason'] = this.reason;
    return data;
  }
}
