import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:developer';
import '../helpers/static_data.dart' as Statics;
import '../helpers/static_data.dart';
import '../models/response_model/baithakvrutta_by_id_model.dart';
import '../models/response_model/notification_list_model.dart';
import 'edit_join_rss.dart';

class NotificationListPage extends StatefulWidget {
  final String userId;

  const NotificationListPage({Key? key, required this.userId}) : super(key: key);

  @override
  _NotificationListPageState createState() => _NotificationListPageState();
}

class _NotificationListPageState extends State<NotificationListPage> {
  List<NotificationsList> notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    setState(() {
      isLoading = true;
    });

    final notificationList = await getNotificationDataList(widget.userId);

    if (notificationList != null && notificationList.notificationslist != null) {
      setState(() {
        notifications = notificationList.notificationslist!;
      });
    } else {
      setState(() {
        notifications = [];
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Statics.getLabel('Notifications')),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : notifications.isEmpty
          ? Center(child: Text('No notifications found.'))
          : ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return GestureDetector(
            onTap: () {
              handleCardClick(notification.pkID!,notification.swayamsevakID!,notification.activity!);
            },
            child: Card(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            notification.msgTitle ?? 'No Title',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                        if (notification.isSeen != 1)
                          Text(
                            "New",
                            style: TextStyle(color: Colors.purple),
                          )
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      notification.msgText ?? 'No Description',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          notification.createdDate ?? '',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> handleCardClick(int notificationId,int swjoinRssID,String activity ) async {
    print('Notification ID: $notificationId');

    // try {

      var response = await http.post(
        Uri.parse(changenotificationstatus),
        headers: jHeaders,
        body: json.encode({
          "swayamsevakid": notificationId,
        }),
      );

      print('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('Response body: ${response.body}');
        var decodedResponse = jsonDecode(response.body);
        print('Decoded Response: $decodedResponse');

        setState(() {
          final notification = notifications.firstWhere((notif) => notif.pkID == notificationId);
          notification.isSeen = 1;
        });

          if (activity == "join") {
            var joinResponse = await http.post(
              Uri.parse(getJoinRSSGridForAppbyid),
              headers: jHeaders,
              body: json.encode({
                "AppUserID": Statics.userDetails["userID"],
                "JoinRSSID": swjoinRssID,
              }),
            );

            if (joinResponse.statusCode == 200) {
              print('Join Response: ${joinResponse.body}');
              var joinData = jsonDecode(joinResponse.body);
              JoinRssDetailByIDModel model = JoinRssDetailByIDModel.fromJson(joinData);

              Navigator.of(context).pushNamed(
                EditJoinRss.routeName,
                arguments: Statics.ScreenArguments(model.listJoinRSS!.first.joinRSSID!, ""),
              );
            } else {
              print('Join request failed with status: ${joinResponse.statusCode}');
            }
          }

      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    // } catch (e) {
    //   print('Error: $e');
    // }
  }


}

Future<NotificationListModel?> getNotificationDataList(String? userID) async {

  Map<String, String> jHeaders = {'Content-Type': 'application/json', 'Accept': '*/*'};

  var response = await http.post(
    Uri.parse(getofflinenotificationlist),
    headers: jHeaders,
    body: json.encode({
      "SwayamsevakID": userID,
    }),
  );

  print(json.encode({
    "SwayamsevakID": userID,
  }));

  if (response.statusCode == 200) {
    var responseBody = json.decode(response.body);
    log("getNotificationDataList 22 ==>>  ${responseBody}");
    return NotificationListModel.fromJson(responseBody);
  } else {
    log("Error: ${response.statusCode}");
    return null;
  }
}

