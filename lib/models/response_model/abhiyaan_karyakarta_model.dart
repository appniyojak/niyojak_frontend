class AbhiyaanKaryakartaModel {
  int? pkid;
  int? geounitid;
  int? isvasti;
  String? name;
  String? mobileno;
  String? email;
  int? isfemale;
  String? sanstha;
  String? sansthaname;
  String? padh;
  String? daayitva;
  int? isactive;
  int? isdefault;

  AbhiyaanKaryakartaModel({
    this.pkid,
    this.geounitid,
    this.isvasti,
    this.name,
    this.mobileno,
    this.email,
    this.isfemale,
    this.sanstha,
    this.sansthaname,
    this.padh,
    this.daayitva,
    this.isactive,
    this.isdefault,
  });

  AbhiyaanKaryakartaModel.fromJson(Map<String, dynamic> json) {
    pkid = json['pkid'];
    geounitid = json['geounitid'];
    isvasti = json['isvasti'];
    name = json['name'];
    mobileno = json['mobileno'];
    email = json['email'];
    isfemale = json['isfemale'];
    sanstha = json['sanstha'];
    sansthaname = json['sansthaname'];
    padh = json['padh'];
    daayitva = json['daayitva'];
    isactive = json['isactive'];
    isdefault = json['isdefault'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkid'] = this.pkid;
    data['geounitid'] = this.geounitid;
    data['isvasti'] = this.isvasti;
    data['name'] = this.name;
    data['mobileno'] = this.mobileno;
    data['email'] = this.email;
    data['isfemale'] = this.isfemale;
    data['sanstha'] = this.sanstha;
    data['sansthaname'] = this.sansthaname;
    data['padh'] = this.padh;
    data['daayitva'] = this.daayitva;
    data['isactive'] = this.isactive;
    data['isdefault'] = this.isdefault;
    return data;
  }
}
