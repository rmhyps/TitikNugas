import 'package:flutter/material.dart';

import '../spot.dart';

abstract final class AppColors {
  static const blue = Color(0xFF2356DF);
  static const paleBlue = Color(0xFFEAF0FF);
  static const ink = Color(0xFF16223B);
  static const muted = Color(0xFF52627C);
  static const line = Color(0xFFE0E7F0);
  static const background = Color(0xFFF4F7FC);
}

const pageInset = 20.0;
const pageWidth = 560.0;
const sectionTitle = TextStyle(fontSize: 16, fontWeight: FontWeight.w700);

class PageWidth extends StatelessWidget {
  const PageWidth({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: pageWidth),
        child: child,
      ),
    );
  }
}

class SpotCover extends StatelessWidget {
  const SpotCover({super.key, required this.spot});

  final Spot spot;

  @override
  Widget build(BuildContext context) {
    final bytes = spot.coverBytes;
    final asset = spot.coverAsset;
    if (bytes != null) {
      return Image.memory(
        bytes,
        cacheWidth: 1200,
        fit: BoxFit.cover,
        excludeFromSemantics: true,
        errorBuilder: (_, _, _) => const _CoverPlaceholder(),
      );
    }
    if (asset != null) {
      return Image.asset(
        asset,
        fit: BoxFit.cover,
        excludeFromSemantics: true,
        errorBuilder: (_, _, _) => const _CoverPlaceholder(),
      );
    }
    return const _CoverPlaceholder();
  }
}

class _CoverPlaceholder extends StatelessWidget {
  const _CoverPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: AppColors.paleBlue,
      child: Center(
        child: Icon(Icons.image_outlined, color: AppColors.blue, size: 42),
      ),
    );
  }
}

class FacilityTags extends StatelessWidget {
  const FacilityTags({super.key, required this.facilities});

  final List<String> facilities;

  IconData _iconFor(String facility) {
    final name = facility.toLowerCase();
    if (name.contains('wi-fi') || name.contains('wifi')) return Icons.wifi;
    if (name.contains('colokan')) return Icons.electrical_services_outlined;
    if (name.contains('rokok')) return Icons.smoke_free_outlined;
    if (name.contains('ac')) return Icons.ac_unit_rounded;
    if (name.contains('tenang')) return Icons.volume_off_outlined;
    if (name.contains('outdoor')) return Icons.park_outlined;
    if (name.contains('meja')) return Icons.table_restaurant_outlined;
    return Icons.check_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 7,
      runSpacing: 7,
      children: [
        for (final facility in facilities)
          DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.background,
              border: Border.all(color: AppColors.line),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(_iconFor(facility), size: 15, color: AppColors.muted),
                  const SizedBox(width: 5),
                  Flexible(
                    child: Text(
                      facility,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class InfoNote extends StatelessWidget {
  const InfoNote({
    super.key,
    required this.text,
    this.icon = Icons.info_outline_rounded,
  });

  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.paleBlue,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 18, color: AppColors.blue),
            const SizedBox(width: 9),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  color: AppColors.ink,
                  fontSize: 13,
                  height: 1.35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
