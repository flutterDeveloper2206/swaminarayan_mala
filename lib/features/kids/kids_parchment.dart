import 'package:flutter/material.dart';

/// Parchment / aged-paper style surfaces matching Kids Jap mockups.
class KidsParchmentBox extends StatelessWidget {
  const KidsParchmentBox({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
    this.width,
    this.borderRadius = 18,
  });

  final Widget child;
  final EdgeInsets padding;
  final double? width;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFF4DC),
            Color(0xFFF5E0B8),
            Color(0xFFE8C98A),
          ],
        ),
        border: Border.all(color: const Color(0xFFC9A35A), width: 2.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
          BoxShadow(
            color: const Color(0xFFFFF8E7).withValues(alpha: 0.7),
            blurRadius: 0,
            spreadRadius: 1,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: child,
    );
  }
}

class KidsRoundIconButton extends StatelessWidget {
  const KidsRoundIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.size = 46,
  });

  final IconData icon;
  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFE8C98A), Color(0xFFC9964A)],
            ),
            border: Border.all(color: const Color(0xFF8B5A2B), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(icon, color: const Color(0xFF5A3418), size: size * 0.48),
        ),
      ),
    );
  }
}

class KidsGoldButton extends StatelessWidget {
  const KidsGoldButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(28),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: const LinearGradient(
                colors: [Color(0xFFF0C96A), Color(0xFFD4A017)],
              ),
              border: Border.all(color: const Color(0xFF8B5A2B), width: 1.4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.18),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF4A2C0A),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class KidsWinScroll extends StatelessWidget {
  const KidsWinScroll({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 28),
      padding: const EdgeInsets.fromLTRB(22, 28, 22, 22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFFF8E7),
            Color(0xFFF3E0B8),
            Color(0xFFE6C98A),
          ],
        ),
        border: Border.all(color: const Color(0xFFC9A35A), width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}
