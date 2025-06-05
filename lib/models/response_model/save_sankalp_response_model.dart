class SaveSankalpDataResponseModel {
  String? message;
  int? outputSankalpID;
  String? status;

  SaveSankalpDataResponseModel({this.message, this.outputSankalpID, this.status});

  SaveSankalpDataResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['Message'];
    outputSankalpID = json['OutputSankalpID'];
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Message'] = this.message;
    data['OutputSankalpID'] = this.outputSankalpID;
    data['Status'] = this.status;
    return data;
  }
}
