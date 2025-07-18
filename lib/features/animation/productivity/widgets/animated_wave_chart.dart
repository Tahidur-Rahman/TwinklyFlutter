import 'package:flutter/material.dart';
import 'package:twinkly_flutter/theme/app_theme.dart';
import 'wave_chart_painter.dart';

class AnimatedWaveChart extends StatefulWidget {
  final double height;
  final Duration animationDuration;
  final Duration delay;

  const AnimatedWaveChart({
    Key? key,
    this.height = 100,
    this.animationDuration = const Duration(milliseconds: 2000),
    this.delay = const Duration(milliseconds: 2000),
  }) : super(key: key);

  @override
  _AnimatedWaveChartState createState() => _AnimatedWaveChartState();
}

class _AnimatedWaveChartState extends State<AnimatedWaveChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    Future.delayed(widget.delay, () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return CustomPaint(
            painter: WaveChartPainter(
              animationProgress: _animation.value,
              color: AppTheme.chartColor,
            ),
            size: Size(double.infinity, widget.height),
          );
        },
      ),
    );
  }
}