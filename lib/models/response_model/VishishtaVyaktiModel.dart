class VishishtaVyaktiModel {
  String? name;
  String? address;
  String? mobile;
  String? sanstha;
  String? sanshthaName;
  String? sanshthaPadh;
  String? vishesh;
  String? anyaMahiti;

  VishishtaVyaktiModel({this.name, this.address, this.mobile, this.sanstha, this.sanshthaName, this.sanshthaPadh, this.vishesh, this.anyaMahiti});

  VishishtaVyaktiModel.fromJson(Map<String, dynamic> json) {
    name = json['VisheshVyaktiName'];
    address = json['address'];
    mobile = json['MobileNumber'];
    sanstha = json['SansthaType'];
    sanshthaName = json['SansthaName'];
    sanshthaPadh = json['SansthaPadh'];
    vishesh = json['VisheshNote'];
    anyaMahiti = json['AnyaVishesh'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['VisheshVyaktiName'] = this.name;
    data['address'] = this.address;
    data['MobileNumber'] = this.mobile;
    data['SansthaType'] = this.sanstha;
    data['SansthaName'] = this.sanshthaName;
    data['SansthaPadh'] = this.sanshthaPadh;
    data['VisheshNote'] = this.vishesh;
    data['AnyaVishesh'] = this.anyaMahiti;
    return data;
  }
}
