class EventVruttaListRespModel {
  List<EventVruttaModel>? listEventVrutta;
  String? message;
  String? status;

  EventVruttaListRespModel({this.listEventVrutta, this.message, this.status});

  EventVruttaListRespModel.fromJson(Map<String, dynamic> json) {
    if (json['ListEventVrutta'] != null) {
      listEventVrutta = <EventVruttaModel>[];
      json['ListEventVrutta'].forEach((v) {
        listEventVrutta!.add(new EventVruttaModel.fromJson(v));
      });
    }
    message = json['Message'];
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.listEventVrutta != null) {
      data['ListEventVrutta'] = this.listEventVrutta!.map((v) => v.toJson()).toList();
    }
    data['Message'] = this.message;
    data['Status'] = this.status;
    return data;
  }
}

class EventVruttaModel {
  String? binduTitle;
  String? eventDateStr;
  int? eventID;
  String? eventName;
  int? eventVruttaID;
  int? praantID;
  String? vruttaDetail;

  EventVruttaModel({this.binduTitle, this.eventDateStr, this.eventID, this.eventName, this.eventVruttaID, this.praantID, this.vruttaDetail});

  EventVruttaModel.fromJson(Map<String, dynamic> json) {
    binduTitle = json['BinduTitle'];
    eventDateStr = json['EventDateStr'];
    eventID = json['EventID'];
    eventName = json['EventName'];
    eventVruttaID = json['EventVruttaID'];
    praantID = json['PraantID'];
    vruttaDetail = json['VruttaDetail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['BinduTitle'] = this.binduTitle;
    data['EventDateStr'] = this.eventDateStr;
    data['EventID'] = this.eventID;
    data['EventName'] = this.eventName;
    data['EventVruttaID'] = this.eventVruttaID;
    data['PraantID'] = this.praantID;
    data['VruttaDetail'] = this.vruttaDetail;
    return data;
  }
}
