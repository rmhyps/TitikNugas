import 'package:flutter/material.dart';

import '../spot.dart';
import '../widgets/ui.dart';

class SpotDetailScreen extends StatelessWidget {
  const SpotDetailScreen({super.key, required this.spot, this.added = false});

  final Spot spot;
  final bool added;

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus rekomendasi?'),
        content: Text(
          '“${spot.name}” akan hilang dari direktori untuk sesi ini.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail spot'),
        actions: [
          if (spot.isOwn)
            IconButton(
              onPressed: () => _confirmDelete(context),
              tooltip: 'Hapus rekomendasi',
              icon: Icon(
                Icons.delete_outline_rounded,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          if (spot.isOwn) const SizedBox(width: 6),
        ],
      ),
      body: SafeArea(
        top: false,
        child: PageWidth(
          child: ListView(
            padding: const EdgeInsets.only(bottom: 22),
            children: [
              AspectRatio(aspectRatio: 1.75, child: SpotCover(spot: spot)),
              Padding(
                padding: const EdgeInsets.fromLTRB(pageInset, 20, pageInset, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (added) ...[
                      const InfoNote(
                        text: 'Rekomendasi ditambahkan untuk sesi ini.',
                        icon: Icons.check_circle_outline_rounded,
                      ),
                      const SizedBox(height: 15),
                    ],
                    Text(
                      spot.name,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        height: 1.14,
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      _contributorLabel(),
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 17),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final width = constraints.maxWidth;
                        final textScale =
                            MediaQuery.textScalerOf(context).scale(14) / 14;
                        final itemWidth = width / textScale < 310
                            ? width
                            : (width - 10) / 2;
                        return Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            SizedBox(
                              width: itemWidth,
                              child: _Fact(
                                icon: Icons.payments_outlined,
                                title: 'Estimasi harga',
                                value: spot.price.description,
                              ),
                            ),
                            SizedBox(
                              width: itemWidth,
                              child: _Fact(
                                icon: Icons.schedule_rounded,
                                title: 'Jam operasional',
                                value: spot.hours.isEmpty
                                    ? 'Belum dicantumkan'
                                    : spot.hours,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text('Lokasi', style: sectionTitle),
                    const SizedBox(height: 7),
                    Text(
                      spot.address,
                      style: const TextStyle(color: AppColors.muted),
                    ),
                    const SizedBox(height: 18),
                    const Text('Fasilitas utama', style: sectionTitle),
                    const SizedBox(height: 8),
                    if (spot.facilities.isEmpty)
                      const Text(
                        'Belum dicantumkan.',
                        style: TextStyle(color: AppColors.muted),
                      )
                    else
                      FacilityTags(facilities: spot.facilities),
                    const SizedBox(height: 18),
                    const Text('Catatan suasana belajar', style: sectionTitle),
                    const SizedBox(height: 7),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(13),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: AppColors.line),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        spot.note.isEmpty ? 'Belum ada catatan.' : spot.note,
                        style: const TextStyle(
                          color: AppColors.muted,
                          height: 1.45,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _contributorLabel() {
    if (!spot.isOwn) return 'Contoh spot fiktif · Dari ${spot.contributor}';
    if (spot.contributor.isEmpty) return 'Rekomendasi kamu';
    return 'Ditambahkan oleh ${spot.contributor}';
  }
}

class _Fact extends StatelessWidget {
  const _Fact({required this.icon, required this.title, required this.value});

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.line),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.blue, size: 20),
          const SizedBox(height: 7),
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: AppColors.muted),
          ),
          const SizedBox(height: 3),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
