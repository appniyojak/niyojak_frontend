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

  DataDetails({this.value, this.id, this.vdate, this.type});

  DataDetails.fromJson(Map<String, dynamic> json) {
    value = json['Value'];
    id = json['id'];
    vdate = json['vdate'];
    type = json['Type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Value'] = this.value;
    data['id'] = this.id;
    data['vdate'] = this.vdate;
    data['Type'] = this.type;
    return data;
  }
}
