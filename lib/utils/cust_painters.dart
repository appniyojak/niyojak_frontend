import 'package:flutter/material.dart';

class DashedLinePainter extends CustomPainter {
  Color? colour;
  double? thickness;
  double? dashWidth;
  double? dashSpace;

  DashedLinePainter({
    this.colour,
    this.thickness,
    this.dashWidth,
    this.dashSpace,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = colour ?? Colors.purple // Line color
      ..strokeWidth = thickness ?? 1.0 // Line thickness
      ..style = PaintingStyle.stroke; // Stroke style (not filled)

    double _dashWidth = dashWidth ?? 10.0; // Length of each dash
    double _dashSpace = dashSpace ?? 5.0; // Space between dashes

    Path path = Path();
    path.moveTo(0, size.height / 2); // Start at the middle of the canvas

    // Loop to create dashed line
    for (double x = 0; x < size.width; x += _dashWidth + _dashSpace) {
      path.moveTo(x, size.height / 2);
      path.lineTo(x + _dashWidth, size.height / 2); // Draw each dash
    }

    canvas.drawPath(path, paint); // Draw the path on the canvas
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false; // No need to repaint since the dashed line doesn't change
  }
}

class LabelClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width * 0.8, size.height);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width * 0.8, 0);
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(LabelClipper oldClipper) => false;
}
