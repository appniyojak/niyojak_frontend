class NIrikshanBiathakVruttaModel {
  String? message;
  String? status;
  List<Getbaithakvarshiklist>? getbaithakvarshiklist;

  NIrikshanBiathakVruttaModel(
      {this.message, this.status, this.getbaithakvarshiklist});

  NIrikshanBiathakVruttaModel.fromJson(Map<String, dynamic> json) {
    message = json['Message'];
    status = json['Status'];
    if (json['getbaithakvarshiklist'] != null) {
      getbaithakvarshiklist = <Getbaithakvarshiklist>[];
      json['getbaithakvarshiklist'].forEach((v) {
        getbaithakvarshiklist!.add(new Getbaithakvarshiklist.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Message'] = this.message;
    data['Status'] = this.status;
    if (this.getbaithakvarshiklist != null) {
      data['getbaithakvarshiklist'] =
          this.getbaithakvarshiklist!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Getbaithakvarshiklist {
  int? full;
  int? half;
  String? naav;
  int? notstarted;
  String? prakar;
  String? vayogat;

  Getbaithakvarshiklist(
      {this.full,
        this.half,
        this.naav,
        this.notstarted,
        this.prakar,
        this.vayogat});

  Getbaithakvarshiklist.fromJson(Map<String, dynamic> json) {
    full = json['full'];
    half = json['half'];
    naav = json['naav'];
    notstarted = json['notstarted'];
    prakar = json['prakar'];
    vayogat = json['vayogat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['full'] = this.full;
    data['half'] = this.half;
    data['naav'] = this.naav;
    data['notstarted'] = this.notstarted;
    data['prakar'] = this.prakar;
    data['vayogat'] = this.vayogat;
    return data;
  }
}
