class TulnatmakVruttaResponseModel {
  String? message;
  String? status;
  int? baithak1a;
  int? baithak1b;
  int? baithak2a;
  int? baithak2b;
  int? baithak3a;
  int? baithak3b;

  TulnatmakVruttaResponseModel(
      {this.message,
        this.status,
        this.baithak1a,
        this.baithak1b,
        this.baithak2a,
        this.baithak2b,
        this.baithak3a,
        this.baithak3b});

  TulnatmakVruttaResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['Message'];
    status = json['Status'];
    baithak1a = json['baithak1a'];
    baithak1b = json['baithak1b'];
    baithak2a = json['baithak2a'];
    baithak2b = json['baithak2b'];
    baithak3a = json['baithak3a'];
    baithak3b = json['baithak3b'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Message'] = this.message;
    data['Status'] = this.status;
    data['baithak1a'] = this.baithak1a;
    data['baithak1b'] = this.baithak1b;
    data['baithak2a'] = this.baithak2a;
    data['baithak2b'] = this.baithak2b;
    data['baithak3a'] = this.baithak3a;
    data['baithak3b'] = this.baithak3b;
    return data;
  }
}
