class TulnatmakBaithakResponse {
   String? message;
   String? status;
   int? baithak1a;
   int? baithak1b;
   int? baithak2a;
   int? baithak2b;
   int? baithak3a;
   int? baithak3b;

  TulnatmakBaithakResponse({
     this.message,
     this.status,
     this.baithak1a,
     this.baithak1b,
     this.baithak2a,
     this.baithak2b,
     this.baithak3a,
     this.baithak3b,
  });

  factory TulnatmakBaithakResponse.fromJson(Map<String?, dynamic> json) {
    return TulnatmakBaithakResponse(
      message: json['Message'],
      status: json['Status'],
      baithak1a: json['baithak1a'],
      baithak1b: json['baithak1b'],
      baithak2a: json['baithak2a'],
      baithak2b: json['baithak2b'],
      baithak3a: json['baithak3a'],
      baithak3b: json['baithak3b'],
    );
  }

  Map<String?, dynamic> toJson() {
    return {
      'Message': message,
      'Status': status,
      'baithak1a': baithak1a,
      'baithak1b': baithak1b,
      'baithak2a': baithak2a,
      'baithak2b': baithak2b,
      'baithak3a': baithak3a,
      'baithak3b': baithak3b,
    };
  }
}
