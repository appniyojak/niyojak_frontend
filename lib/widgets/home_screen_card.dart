import 'package:flutter/material.dart';

class HomeScreenCard extends StatefulWidget {
  final IconData leadingIcon;
  final String cardTitle;

  HomeScreenCard(this.leadingIcon, this.cardTitle);

  @override
  _HomeScreenCardState createState() => _HomeScreenCardState();
}

class _HomeScreenCardState extends State<HomeScreenCard> {
  var _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(widget.leadingIcon),
            title: Text(widget.cardTitle),
            trailing: IconButton(
              icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
            ),
          ),
          if (_isExpanded)
            Container(
              width: double.infinity,
              height: 100,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              child: Text('List of ${widget.cardTitle}'),
            ),
        ],
      ),
    );
  }
}
