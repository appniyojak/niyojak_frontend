import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditDialog extends StatefulWidget {
  final String title;
  final String year;
  final String tag;
  final String value;
  const EditDialog({Key? key, required this.title, required this.year, required this.value, required this.tag}) : super(key: key);

  @override
  State<EditDialog> createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  TextEditingController controller = TextEditingController();
  @override
  void initState() {
    controller.text = widget.value;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Center(
      child: Hero(
        tag: widget.tag,
        child: Material(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          // color: Colors.transparent,
          child: Container(
            height: size.width * 0.6,
            width: size.width * 0.9,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: <Widget>[
                Container(
                  height: size.width * 0.15,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCCE7FF),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5),
                    ),
                  ),
                  child: Text(
                    "${widget.title}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: size.width * 0.045,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: size.width * 0.05),
                  child: Container(
                    height: size.width * 0.12,
                    width: size.width * 0.5,
                    child: TextFormField(
                      controller: controller,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      inputFormatters: [FilteringTextInputFormatter(RegExp("[0-9]"), allow: true)],
                      decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                    ),
                  ),
                ),
                Container(
                  width: size.width * 0.25,
                  height: size.height * 0.06,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context, controller.text),
                    child: Text(
                      "OK",
                      style: TextStyle(fontWeight: FontWeight.w400, fontSize: size.width * 0.045, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
