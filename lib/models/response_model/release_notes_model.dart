class ReleaseNotesRespModel {
  String? status;
  String? message;
  Notes? notes;

  ReleaseNotesRespModel({this.status, this.message, this.notes});

  ReleaseNotesRespModel.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    notes = json['notes'] != null ? new Notes.fromJson(json['notes']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['Message'] = this.message;
    if (this.notes != null) {
      data['notes'] = this.notes!.toJson();
    }
    return data;
  }
}

class Notes {
  String? englishtext;
  String? marathitext;
  String? hinditext;
  String? releasedate;

  Notes({this.englishtext, this.marathitext, this.hinditext, this.releasedate});

  Notes.fromJson(Map<String, dynamic> json) {
    englishtext = json['englishtext'];
    marathitext = json['marathitext'];
    hinditext = json['hinditext'];
    releasedate = json['releasedate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['englishtext'] = this.englishtext;
    data['marathitext'] = this.marathitext;
    data['hinditext'] = this.hinditext;
    data['releasedate'] = this.releasedate;
    return data;
  }
}
