class EvenMasterRespModel {
  List<EventMaster>? listEventMaster;
  String? message;
  String? status;

  EvenMasterRespModel({this.listEventMaster, this.message, this.status});

  EvenMasterRespModel.fromJson(Map<String, dynamic> json) {
    if (json['ListEventMaster'] != null) {
      listEventMaster = <EventMaster>[];
      json['ListEventMaster'].forEach((v) {
        listEventMaster!.add(new EventMaster.fromJson(v));
      });
    }
    message = json['Message'];
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.listEventMaster != null) {
      data['ListEventMaster'] = this.listEventMaster!.map((v) => v.toJson()).toList();
    }
    data['Message'] = this.message;
    data['Status'] = this.status;
    return data;
  }
}

class EventMaster {
  String? description;
  String? eventDate;
  String? eventDateStr;
  int? eventID;
  String? eventName;
  String? eventTypeCode;
  int? eventTypeID;
  String? fromDate;
  String? fromDateStr;
  String? fromTimeStr;
  int? geoUnitID;
  String? geoUnitName;
  int? ownerSwayamsevakID;
  String? ownerSwayamsevakMobileNumber;
  String? ownerSwayamsevakName;
  int? praantID;
  String? preparationDetail;
  String? toDate;
  String? toDateStr;
  String? toTimeStr;
  String? venue;
  int? apekshitCnt;
  int? presentCnt;
  int? absentCnt;
  int? pStatus;
  int? isfuture;
  int? isSharing;
  String? reason;

  EventMaster(
      {this.description,
      this.eventDate,
      this.eventDateStr,
      this.eventID,
      this.eventName,
      this.eventTypeCode,
      this.eventTypeID,
      this.fromDate,
      this.fromDateStr,
      this.fromTimeStr,
      this.geoUnitID,
      this.geoUnitName,
      this.ownerSwayamsevakID,
      this.ownerSwayamsevakMobileNumber,
      this.ownerSwayamsevakName,
      this.praantID,
      this.preparationDetail,
      this.toDate,
      this.toDateStr,
      this.toTimeStr,
      this.venue,
      this.apekshitCnt,
      this.presentCnt,
      this.absentCnt,
      this.pStatus,
      this.isfuture,
      this.isSharing,
      this.reason});

  EventMaster.fromJson(Map<String, dynamic> json) {
    description = json['Description'];
    eventDate = json['EventDate'];
    eventDateStr = json['EventDateStr'];
    eventID = json['EventID'];
    eventName = json['EventName'];
    eventTypeCode = json['EventTypeCode'];
    eventTypeID = json['EventTypeID'];
    fromDate = json['FromDate'];
    fromDateStr = json['FromDateStr'];
    fromTimeStr = json['FromTimeStr'];
    geoUnitID = json['GeoUnitID'];
    geoUnitName = json['GeoUnitName'];
    ownerSwayamsevakID = json['OwnerSwayamsevakID'];
    ownerSwayamsevakMobileNumber = json['OwnerSwayamsevakMobileNumber'];
    ownerSwayamsevakName = json['OwnerSwayamsevakName'];
    praantID = json['PraantID'];
    preparationDetail = json['PreparationDetail'];
    toDate = json['ToDate'];
    toDateStr = json['ToDateStr'];
    toTimeStr = json['ToTimeStr'];
    venue = json['Venue'];
    apekshitCnt = json['apekshitCnt'];
    presentCnt = json['presentCnt'];
    absentCnt = json['absentCnt'];
    pStatus = json['pStatus'];
    isfuture = json['isfuture'];
    isSharing = json['isSharing'];
    reason = json['reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Description'] = this.description;
    data['EventDate'] = this.eventDate;
    data['EventDateStr'] = this.eventDateStr;
    data['EventID'] = this.eventID;
    data['EventName'] = this.eventName;
    data['EventTypeCode'] = this.eventTypeCode;
    data['EventTypeID'] = this.eventTypeID;
    data['FromDate'] = this.fromDate;
    data['FromDateStr'] = this.fromDateStr;
    data['FromTimeStr'] = this.fromTimeStr;
    data['GeoUnitID'] = this.geoUnitID;
    data['GeoUnitName'] = this.geoUnitName;
    data['OwnerSwayamsevakID'] = this.ownerSwayamsevakID;
    data['OwnerSwayamsevakMobileNumber'] = this.ownerSwayamsevakMobileNumber;
    data['OwnerSwayamsevakName'] = this.ownerSwayamsevakName;
    data['PraantID'] = this.praantID;
    data['PreparationDetail'] = this.preparationDetail;
    data['ToDate'] = this.toDate;
    data['ToDateStr'] = this.toDateStr;
    data['ToTimeStr'] = this.toTimeStr;
    data['Venue'] = this.venue;
    data['apekshitCnt'] = this.apekshitCnt;
    data['presentCnt'] = this.presentCnt;
    data['absentCnt'] = this.absentCnt;
    data['pStatus'] = this.pStatus;
    data['isfuture'] = this.isfuture;
    data['isSharing'] = this.isSharing;
    data['reason'] = this.reason;
    return data;
  }
}
