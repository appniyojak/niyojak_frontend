class DataDetailsGroup {
  final String groupType;
  final List<DataDetails> items;

  DataDetailsGroup({required this.groupType, required this.items});
}

class DataDetails {
  String? value;
  int? id;
  String? vdate;
  String? type;
  int? isnew;

  DataDetails({this.value, this.id, this.vdate, this.type, this.isnew});

  DataDetails.fromJson(Map<String, dynamic> json) {
    value = json['Value'];
    id = json['id'];
    vdate = json['vdate'];
    type = json['Type'];
    isnew = json['isnew'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Value'] = this.value;
    data['id'] = this.id;
    data['vdate'] = this.vdate;
    data['Type'] = this.type;
    data['isnew'] = this.isnew;
    return data;
  }
}
