import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../helper/color.dart';

class MysticCelestialCore extends StatefulWidget {
  final double size;
  const MysticCelestialCore({super.key, this.size = 300});

  @override
  State<MysticCelestialCore> createState() => _MysticCelestialCoreState();
}

class _MysticCelestialCoreState extends State<MysticCelestialCore>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 🏮 Outer Pulsing Aura
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Container(
                width: widget.size * (0.7 + (_pulseController.value * 0.1)),
                height: widget.size * (0.7 + (_pulseController.value * 0.1)),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.goldAccent.withValues(
                        alpha: 0.1 * _pulseController.value,
                      ),
                      blurRadius: 40,
                      spreadRadius: 10,
                    ),
                  ],
                ),
              );
            },
          ),

          // 🌀 Rotating Celestial Halo
          RotationTransition(
            turns: _rotationController,
            child: CustomPaint(
              size: Size(widget.size * 0.8, widget.size * 0.8),
              painter: CelestialHaloPainter(),
            ),
          ),

          // ✨ Layered Inner Glow
          Container(
            width: widget.size * 0.4,
            height: widget.size * 0.4,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Color(0xFFFFDF80),
                  Color(0xFFFFD700),
                  Colors.transparent,
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),

          // 🪐 Zodiac Symbols Shadow
          Opacity(
            opacity: 0.3,
            child: RotationTransition(
              turns: ReverseAnimation(_rotationController),
              child: Icon(
                Icons.brightness_7_outlined,
                size: widget.size * 0.5,
                color: AppColors.goldAccent,
              ),
            ),
          ),

          // ☄️ Central Core
          Container(
            width: widget.size * 0.15,
            height: widget.size * 0.15,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.8),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CelestialHaloPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final paint = Paint()
      ..shader = SweepGradient(
        colors: [
          AppColors.goldAccent.withValues(alpha: 0.0),
          AppColors.goldAccent.withValues(alpha: 0.6),
          AppColors.goldAccent.withValues(alpha: 0.2),
          AppColors.goldAccent.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.4, 0.7, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawCircle(center, radius, paint);

    // Draw some accent dashes
    final dashPaint = Paint()
      ..color = AppColors.goldAccent.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (var i = 0; i < 12; i++) {
      final angle = (i * 30) * (math.pi / 180);
      final innerP =
          center +
          Offset(
            math.cos(angle) * (radius - 10),
            math.sin(angle) * (radius - 10),
          );
      final outerP =
          center +
          Offset(
            math.cos(angle) * (radius + 10),
            math.sin(angle) * (radius + 10),
          );
      canvas.drawLine(innerP, outerP, dashPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
