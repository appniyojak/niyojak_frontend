import 'package:flutter/material.dart';
import '../helpers/static_data.dart' as Statics;

class HelpButton extends StatelessWidget {
  final hookupLink;
  HelpButton(this.hookupLink);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
            width: 140,
            height: 22,
            child: MaterialButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              color: Theme.of(context).primaryColor,
              textColor: Theme.of(context).primaryTextTheme.button!.color,
              onPressed: () {
                Statics.openUserManual(hookupLink);
              },
              child: Icon(Icons.info, size: 20),
              // label: Text(Statics.getLabel('Information')
            )),
      ],
    );
  }
}
