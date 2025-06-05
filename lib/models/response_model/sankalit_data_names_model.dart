class SankalitBaithakVruttaDataNamesModel {
  String? message;
  String? status;
  List<Listname>? listname;

  SankalitBaithakVruttaDataNamesModel(
      {this.message, this.status, this.listname});

  SankalitBaithakVruttaDataNamesModel.fromJson(Map<String, dynamic> json) {
    message = json['Message'];
    status = json['Status'];
    if (json['listname'] != null) {
      listname = <Listname>[];
      json['listname'].forEach((v) {
        listname!.add(new Listname.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Message'] = this.message;
    data['Status'] = this.status;
    if (this.listname != null) {
      data['listname'] = this.listname!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Listname {

  String? qtype;
  String? title;
  String? mahanagar;
  String? vibhag;
  String? bhaag;
  String? nagar;
  String? vasti;
  String? gram;
  String? mandal;
  String? shakha;

  Listname({
    this.bhaag, this.nagar, this.qtype, this.title, this.vibhag, this.mahanagar, this.gram, this.mandal, this.vasti, this.shakha
  });

  Listname.fromJson(Map<String, dynamic> json) {

    qtype = json['qtype'];
    title = json['title'];

    mahanagar = json['mahanagar'];
    vibhag = json['vibhag'];
    bhaag = json['bhaag'];
    nagar = json['nagar'];
    vasti = json['vasti'];
    gram = json['gram'];
    mandal = json['mandal'];
    shakha = json['shakhaa'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['qtype'] = this.qtype;
    data['title'] = this.title;
    data['mahanagar'] = this.mahanagar;
    data['vibhag'] = this.vibhag;
    data['bhaag'] = this.bhaag;
    data['nagar'] = this.nagar;
    data['vasti'] = this.vasti;
    data['gram'] = this.gram;
    data['mandal'] = this.mandal;
    data['shakhaa'] = this.shakha;

    return data;
  }
}
