import 'package:flutter/material.dart';

import '../spot.dart';
import '../widgets/ui.dart';

class DirectoryScreen extends StatefulWidget {
  const DirectoryScreen({
    super.key,
    required this.spots,
    required this.onOpenSpot,
  });

  final List<Spot> spots;
  final ValueChanged<Spot> onOpenSpot;

  @override
  State<DirectoryScreen> createState() => _DirectoryScreenState();
}

class _DirectoryScreenState extends State<DirectoryScreen> {
  final _search = TextEditingController();
  Price? _price;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _clearFilters() {
    _search.clear();
    setState(() => _price = null);
  }

  @override
  Widget build(BuildContext context) {
    final query = _search.text.trim().toLowerCase();
    final spots = widget.spots.where((spot) {
      return (_price == null || spot.price == _price) &&
          (spot.name.toLowerCase().contains(query) ||
              spot.address.toLowerCase().contains(query));
    }).toList();

    return PageWidth(
      child: CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(pageInset, 23, pageInset, 0),
            sliver: SliverList.list(
              children: [
                const _DirectoryHeader(),
                const SizedBox(height: 22),
                TextField(
                  controller: _search,
                  onChanged: (_) => setState(() {}),
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: 'Cari nama tempat atau lokasi',
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _search.text.isEmpty
                        ? null
                        : IconButton(
                            tooltip: 'Hapus teks pencarian',
                            onPressed: () {
                              _search.clear();
                              setState(() {});
                            },
                            icon: const Icon(Icons.close_rounded),
                          ),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 7,
                  runSpacing: 2,
                  children: [
                    _PriceChip(
                      label: 'Semua',
                      selected: _price == null,
                      onPressed: () => setState(() => _price = null),
                    ),
                    for (final price in Price.values)
                      _PriceChip(
                        label: '${price.label} (${price.shortLabel})',
                        selected: _price == price,
                        onPressed: () => setState(() => _price = price),
                      ),
                  ],
                ),
                const SizedBox(height: 15),
                Text(
                  '${spots.length} rekomendasi',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.muted,
                  ),
                ),
                const SizedBox(height: 11),
              ],
            ),
          ),
          if (spots.isEmpty)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: pageInset),
              sliver: SliverToBoxAdapter(
                child: _EmptyResults(onClear: _clearFilters),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(pageInset, 0, pageInset, 20),
              sliver: SliverList.separated(
                itemCount: spots.length,
                separatorBuilder: (_, _) => const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  final spot = spots[index];
                  return _SpotCard(
                    spot: spot,
                    onTap: () => widget.onOpenSpot(spot),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _DirectoryHeader extends StatelessWidget {
  const _DirectoryHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 45,
          width: 45,
          decoration: BoxDecoration(
            color: AppColors.blue,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.coffee_rounded,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Titik Nugas',
                style: TextStyle(
                  fontSize: 25,
                  height: 1.12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.6,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Tempat nugas ramah kampus',
                style: TextStyle(fontSize: 13, color: AppColors.muted),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PriceChip extends StatelessWidget {
  const _PriceChip({
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onPressed(),
      showCheckmark: false,
      labelPadding: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      backgroundColor: Colors.white,
      selectedColor: AppColors.ink,
      labelStyle: TextStyle(
        color: selected ? Colors.white : AppColors.muted,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      side: BorderSide(color: selected ? AppColors.ink : AppColors.line),
      shape: const StadiumBorder(),
    );
  }
}

class _SpotCard extends StatelessWidget {
  const _SpotCard({required this.spot, required this.onTap});

  final Spot spot;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: AppColors.line),
        borderRadius: BorderRadius.circular(19),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 2.16,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  SpotCover(spot: spot),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: _CoverLabel(
                      text: '${spot.price.label} · ${spot.price.shortLabel}',
                    ),
                  ),
                  if (!spot.isOwn)
                    const Positioned(
                      top: 12,
                      right: 12,
                      child: _CoverLabel(text: 'Contoh'),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 13),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          spot.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right_rounded,
                        size: 22,
                        color: AppColors.muted,
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.place_outlined,
                        size: 16,
                        color: AppColors.muted,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          spot.address,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.muted,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (spot.facilities.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    FacilityTags(facilities: spot.facilities.take(3).toList()),
                  ],
                  const SizedBox(height: 11),
                  const Divider(height: 1, color: AppColors.line),
                  const SizedBox(height: 10),
                  Text(
                    spot.isOwn
                        ? 'Rekomendasi kamu'
                        : 'Dari ${spot.contributor}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.muted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CoverLabel extends StatelessWidget {
  const _CoverLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.ink.withValues(alpha: 0.91),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _EmptyResults extends StatelessWidget {
  const _EmptyResults({required this.onClear});

  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.line),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          const Icon(Icons.search_off_rounded, size: 34, color: AppColors.blue),
          const SizedBox(height: 9),
          const Text('Spot belum ditemukan', style: sectionTitle),
          const SizedBox(height: 5),
          const Text(
            'Coba kata kunci lain atau tampilkan semua harga.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.muted),
          ),
          const SizedBox(height: 7),
          TextButton(
            onPressed: onClear,
            child: const Text('Hapus pencarian dan filter'),
          ),
        ],
      ),
    );
  }
}
