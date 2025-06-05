  class GetOtpModel {
    String? message;
    String? otp;
    String? status;
    String? swayamsevakID;
    String? mnumber;

    GetOtpModel(
        {this.message, this.otp, this.status, this.swayamsevakID, this.mnumber});

    GetOtpModel.fromJson(Map<String, dynamic> json) {
      message = json['Message'];
      otp = json['Otp'];
      status = json['Status'];
      swayamsevakID = json['SwayamsevakID'];
      mnumber = json['mnumber'];
    }

    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = new Map<String, dynamic>();
      data['Message'] = this.message;
      data['Otp'] = this.otp;
      data['Status'] = this.status;
      data['SwayamsevakID'] = this.swayamsevakID;
      data['mnumber'] = this.mnumber;
      return data;
    }
  }
