class NotificationListModel {
  String? message;
  String? status;
  int? notificationcount;
  List<NotificationsList>? notificationslist;

  NotificationListModel({this.message, this.status, this.notificationcount, this.notificationslist});

  NotificationListModel.fromJson(Map<String, dynamic> json) {
    message = json['Message'];
    status = json['Status'];
    notificationcount = json['Notificationcount'];
    if (json['list'] != null) {
      notificationslist = [];
      json['list'].forEach((v) {
        notificationslist!.add(NotificationsList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Message'] = message;
    data['Status'] = status;
    data['Notificationcount'] = notificationcount;
    if (notificationslist != null) {
      data['list'] = notificationslist!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NotificationsList {
  String? createdDate;
  int? swayamsevakID;
  String? activity;
  int? isSeen;
  int? msgID;
  String? msgText;
  String? msgTitle;
  int? pkID;
  String? refID;

  NotificationsList({
    this.createdDate,
    this.swayamsevakID,
    this.activity,
    this.isSeen,
    this.msgID,
    this.msgText,
    this.msgTitle,
    this.pkID,
    this.refID,
  });

  NotificationsList.fromJson(Map<String, dynamic> json) {
    createdDate = json['CreatedDate'];
    swayamsevakID = json['SwayamsevakID'];
    activity = json['activity'];
    isSeen = json['isseen'];
    msgID = json['msgid'];
    msgText = json['msgtext'];
    msgTitle = json['msgtitle'];
    pkID = json['pkid'];
    refID = json['refid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CreatedDate'] = createdDate;
    data['SwayamsevakID'] = swayamsevakID;
    data['activity'] = activity;
    data['isseen'] = isSeen;
    data['msgid'] = msgID;
    data['msgtext'] = msgText;
    data['msgtitle'] = msgTitle;
    data['pkid'] = pkID;
    data['refid'] = refID;
    return data;
  }
}
