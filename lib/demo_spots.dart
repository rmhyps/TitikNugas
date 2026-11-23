import 'spot.dart';

const demoSpots = [
  Spot(
    name: 'Kopi Sela Kampus',
    address: 'Jalan Selatan Kampus, dekat gerbang utama',
    price: Price.cheap,
    hours: '09.00–22.00',
    facilities: ['Wi-Fi', 'Colokan tiap meja', 'Ruang ber-AC'],
    note:
        'Meja panjang di lantai dua cocok untuk tugas kelompok. '
        'Pilih kursi dekat dinding kalau perlu colokan.',
    contributor: 'Dinda',
    coverAsset: 'assets/photos/kopi_sela.jpg',
  ),
  Spot(
    name: 'Ruang Baca Cendekia',
    address: 'Gedung Perpustakaan, lantai 2',
    price: Price.cheap,
    hours: '08.00–18.00 (Senin–Jumat)',
    facilities: ['Wi-Fi', 'Area tenang', 'Bebas rokok'],
    note:
        'Masuk gratis. Meja individual di sisi jendela cocok '
        'untuk baca atau nulis sendiri.',
    contributor: 'Reza',
    coverAsset: 'assets/photos/ruang_baca.jpg',
  ),
  Spot(
    name: 'Teras Temu',
    address: 'Jalan Taman Kampus, seberang lapangan',
    price: Price.medium,
    hours: '10.00–21.00',
    facilities: ['Wi-Fi', 'Area outdoor', 'Meja kelompok'],
    note:
        'Teras teduh pada sore hari. Untuk kerja dengan laptop, '
        'pilih meja dekat pintu masuk karena colokan di teras terbatas.',
    contributor: 'Naya',
    coverAsset: 'assets/photos/teras_temu.jpg',
  ),
];
