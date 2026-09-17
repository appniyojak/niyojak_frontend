import 'package:flutter/material.dart';

import '../helpers/static_data.dart' as Statics;

class Legend extends StatelessWidget {
  final legendString;
  final extraString;
  final double? fontsize;
  final void Function()? onPressed;
  final IconData? icon;
  final TextStyle? style;

  Legend({Key? key, this.legendString, this.extraString, this.fontsize, this.onPressed, this.icon, this.style}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          // mainAxisAlignment: onPressed == null ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
          children: [
            if (onPressed != null) SizedBox(width: 24),
            Expanded(
              child: Text(
                (legendString == null || legendString == "" ? "" : Statics.getLabel(legendString, returnKey: true)),
                textAlign: TextAlign.center,
                style: style ?? TextStyle(color: Colors.purple, fontSize: fontsize == 0 ? 18 : fontsize, fontWeight: FontWeight.w600),
              ),
            ),
            if (onPressed != null)
              IconButton(
                  onPressed: onPressed,
                  icon: Icon(
                    icon ?? Icons.list_rounded,
                    color: Colors.purple,
                    size: 18,
                  ))
          ],
        ),
        Divider(
          color: Colors.black,
        ),
        if (extraString != null && extraString != '')
          Wrap(
            children: [
              Text(
                extraString,
                textAlign: TextAlign.left,
                style: TextStyle(color: Colors.purple, fontSize: fontsize == 0 ? 14 : fontsize! - 4, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}

class ExpandableSection extends StatefulWidget {
  final String legendString;
  final String? extraString;
  final double? fontsize;
  final VoidCallback? onIconPressed; // e.g. showNamesList(...)
  final IconData? icon;
  final Widget child;
  final bool initiallyExpanded;

  const ExpandableSection({
    Key? key,
    required this.legendString,
    this.extraString,
    this.fontsize,
    this.onIconPressed,
    this.icon,
    required this.child,
    this.initiallyExpanded = false,
  }) : super(key: key);

  @override
  State<ExpandableSection> createState() => _ExpandableSectionState();
}

class _ExpandableSectionState extends State<ExpandableSection> {
  late bool _expanded = widget.initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  widget.legendString == "" ? "" : Statics.getLabel(widget.legendString, returnKey: true),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.purple,
                    fontSize: widget.fontsize == 0 || widget.fontsize == null ? 18 : widget.fontsize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              // list icon stays visible in header regardless of expand state
              if (widget.onIconPressed != null)
                IconButton(
                  onPressed: widget.onIconPressed, // separate tap target, won't trigger expand/collapse
                  icon: Icon(widget.icon ?? Icons.list_rounded, color: Colors.purple, size: 18),
                ),
              AnimatedRotation(
                turns: _expanded ? 0.5 : 0,
                duration: const Duration(milliseconds: 200),
                child: const Icon(Icons.keyboard_arrow_down, color: Colors.purple),
              ),
            ],
          ),
        ),
        const Divider(color: Colors.black),
        if (widget.extraString != null && widget.extraString != '')
          Wrap(children: [
            Text(
              widget.extraString!,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.purple,
                fontSize: widget.fontsize == 0 || widget.fontsize == null ? 14 : widget.fontsize! - 4,
                fontWeight: FontWeight.w600,
              ),
            ),
          ]),
        AnimatedCrossFade(
          firstChild: const SizedBox(width: double.infinity, height: 0),
          secondChild: widget.child,
          crossFadeState: _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200),
          sizeCurve: Curves.easeInOut,
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
