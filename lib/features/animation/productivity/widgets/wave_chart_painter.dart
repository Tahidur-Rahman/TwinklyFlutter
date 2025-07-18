import 'package:flutter/material.dart';

class WaveChartPainter extends CustomPainter {
  final double animationProgress;
  final Color color;
  
  WaveChartPainter({
    required this.animationProgress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw horizontal grid lines first
    _drawGridLines(canvas, size);
    
    // Create gradient paints
    final gradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color.withOpacity(0.8),
          color.withOpacity(0.2),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    
    final gradientFillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color.withOpacity(0.25),
          color.withOpacity(0.05),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;
    
    // Wave data points - added a new point at the end for a "down grade"
    final points = [
      Offset(0, size.height * 0.85),
      Offset(size.width * 0.12, size.height * 0.75),
      Offset(size.width * 0.25, size.height * 0.45),
      Offset(size.width * 0.38, size.height * 0.35),
      Offset(size.width * 0.52, size.height * 0.65),
      Offset(size.width * 0.65, size.height * 0.55),
      Offset(size.width * 0.78, size.height * 0.45),
      Offset(size.width * 0.92, size.height * 0.25), // Previous last point
      // Offset(size.width * 0.98, size.height * 0.45), // New "down grade" point
    ];
    
    // Create full path
    final fullPath = _createPath(points, size);
    
    // Create animated paths
    final animatedPath = _createAnimatedPath(fullPath);
    final animatedFillPath = _createAnimatedFillPath(points, size);
    
    // Draw paths
    if (animationProgress > 0) {
      canvas.drawPath(animatedFillPath, gradientFillPaint);
      canvas.drawPath(animatedPath, gradientPaint);
    }
    
    // Draw vertical indicator line at the new last point's X-coordinate
    _drawVerticalLine(canvas, size, points.last.dx, points.last.dy);
  }
  
  void _drawGridLines(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    // Draw 4 horizontal grid lines
    for (int i = 0; i <= 3; i++) {
      final y = (size.height / 3) * i;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        gridPaint,
      );
    }
  }
  
  Path _createPath(List<Offset> points, Size size) {
    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);
    
    for (int i = 1; i < points.length; i++) {
      final cp1 = Offset(
        points[i - 1].dx + (points[i].dx - points[i - 1].dx) * 0.4,
        points[i - 1].dy,
      );
      final cp2 = Offset(
        points[i - 1].dx + (points[i].dx - points[i - 1].dx) * 0.6,
        points[i].dy,
      );
      
      path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, points[i].dx, points[i].dy);
    }
    
    return path;
  }
  
  Path _createAnimatedPath(Path fullPath) {
    final pathMetrics = fullPath.computeMetrics();
    final animatedPath = Path();
    
    for (final pathMetric in pathMetrics) {
      final extractedPath = pathMetric.extractPath(
        0.0,
        pathMetric.length * animationProgress,
      );
      animatedPath.addPath(extractedPath, Offset.zero);
    }
    
    return animatedPath;
  }
  
  Path _createAnimatedFillPath(List<Offset> points, Size size) {
  final animatedFillPath = Path();
  
  if (animationProgress > 0) {
    final currentEndX = size.width * animationProgress;
    final maxFillX = points.last.dx; // Stop fill at the X-coordinate of the new last point
    final actualEndX = currentEndX > maxFillX ? maxFillX : currentEndX;
    
    animatedFillPath.moveTo(0, size.height);
    animatedFillPath.lineTo(points[0].dx, points[0].dy);
    
    for (int i = 1; i < points.length; i++) {
      if (points[i].dx <= actualEndX) {
        final cp1 = Offset(
          points[i - 1].dx + (points[i].dx - points[i - 1].dx) * 0.4,
          points[i - 1].dy,
        );
        final cp2 = Offset(
          points[i - 1].dx + (points[i].dx - points[i - 1].dx) * 0.6,
          points[i].dy,
        );
        
        animatedFillPath.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, points[i].dx, points[i].dy);
      } else {
        final prevPoint = points[i - 1];
        final nextPoint = points[i];
        final progress = (actualEndX - prevPoint.dx) / (nextPoint.dx - prevPoint.dx);
        
        if (progress > 0 && progress <= 1) {
          final interpolatedY = prevPoint.dy + (nextPoint.dy - prevPoint.dy) * progress;
          animatedFillPath.lineTo(actualEndX, interpolatedY);
        }
        break;
      }
    }
    
    // Close the fill path at the actual end position, not full width
    animatedFillPath.lineTo(actualEndX, size.height);
    animatedFillPath.lineTo(0, size.height);
    animatedFillPath.close();
  }
  
  return animatedFillPath;
}
  
  void _drawVerticalLine(Canvas canvas, Size size, double lineX, double dotY) {
  if (animationProgress > 0.9) {
    final lineOpacity = (animationProgress - 0.9) / 0.1;
    final linePaint = Paint()
      ..color = Colors.black54.withOpacity(lineOpacity * 0.8)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    
    canvas.drawLine(
      Offset(lineX, 0),
      Offset(lineX, size.height),
      linePaint,
    );
    
    // Add a small dot at the end of the line
    final dotPaint = Paint()
      ..color = color.withOpacity(lineOpacity)
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(
      Offset(lineX, dotY), // Use the Y-coordinate of the last point for the dot
      4,
      dotPaint,
    );
  }
}
  
  @override
  bool shouldRepaint(WaveChartPainter oldDelegate) {
    return oldDelegate.animationProgress != animationProgress;
  }
}
