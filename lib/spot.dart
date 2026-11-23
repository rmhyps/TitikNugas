import 'dart:typed_data';

enum Price {
  cheap('Murah', 'Di bawah Rp20.000', '< Rp20 rb'),
  medium('Sedang', 'Rp20.000–Rp40.000', 'Rp20–40 rb');

  const Price(this.label, this.description, this.shortLabel);

  final String label;
  final String description;
  final String shortLabel;
}

class Spot {
  const Spot({
    required this.name,
    required this.address,
    required this.price,
    required this.contributor,
    this.hours = '',
    this.facilities = const [],
    this.note = '',
    this.coverAsset,
    this.coverBytes,
    this.isOwn = false,
  });

  final String name;
  final String address;
  final Price price;
  final String hours;
  final List<String> facilities;
  final String note;
  final String contributor;
  final String? coverAsset;
  final Uint8List? coverBytes;
  final bool isOwn;
}

class ContributorProfile {
  const ContributorProfile({this.name = '', this.studyProgram = ''});

  final String name;
  final String studyProgram;

  String get initials {
    final words = name.trim().split(RegExp(r'\s+'));
    if (words.first.isEmpty) return '';
    return words
        .take(2)
        .map((word) => String.fromCharCode(word.runes.first))
        .join()
        .toUpperCase();
  }
}
