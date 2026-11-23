import 'package:flutter/material.dart';

import 'demo_spots.dart';
import 'screens/add_spot_screen.dart';
import 'screens/directory_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/spot_detail_screen.dart';
import 'spot.dart';
import 'widgets/ui.dart';

class TitikNugasApp extends StatelessWidget {
  const TitikNugasApp({super.key});

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
    );
    return MaterialApp(
      title: 'Titik Nugas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Inter',
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.blue).copyWith(
          primary: AppColors.blue,
          onPrimary: Colors.white,
          surface: Colors.white,
          onSurface: AppColors.ink,
          onSurfaceVariant: AppColors.muted,
          outline: AppColors.line,
          outlineVariant: AppColors.line,
        ),
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          foregroundColor: AppColors.ink,
          titleTextStyle: TextStyle(
            fontFamily: 'Inter',
            color: AppColors.ink,
            fontSize: 19,
            fontWeight: FontWeight.w700,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.line),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.line),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            minimumSize: const Size(0, 50),
            shape: shape,
            textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      home: const _HomeScreen(),
    );
  }
}

class _HomeScreen extends StatefulWidget {
  const _HomeScreen();

  @override
  State<_HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<_HomeScreen> {
  final List<Spot> _spots = [...demoSpots];
  ContributorProfile _profile = const ContributorProfile();
  int _tab = 0;

  void _selectTab(int tab) {
    FocusScope.of(context).unfocus();
    setState(() => _tab = tab);
  }

  Future<void> _addSpot() async {
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    final spot = await Navigator.of(context).push<Spot>(
      MaterialPageRoute(
        builder: (_) => AddSpotScreen(contributor: _profile.name),
      ),
    );
    if (!mounted || spot == null) return;
    setState(() {
      _spots.insert(0, spot);
      _tab = 0;
    });
    await _openSpot(spot, added: true);
  }

  Future<void> _openSpot(Spot spot, {bool added = false}) async {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    final deleted = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => SpotDetailScreen(spot: spot, added: added),
      ),
    );
    if (!mounted || deleted != true) return;
    setState(() => _spots.remove(spot));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Rekomendasi dihapus.')));
  }

  void _saveProfile(ContributorProfile profile) {
    setState(() => _profile = profile);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil diperbarui untuk sesi ini.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: IndexedStack(
          index: _tab,
          children: [
            DirectoryScreen(spots: _spots, onOpenSpot: _openSpot),
            ProfileScreen(profile: _profile, onSave: _saveProfile),
          ],
        ),
      ),
      bottomNavigationBar: Material(
        color: Colors.white,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: AppColors.line)),
          ),
          child: SafeArea(
            top: false,
            child: Center(
              heightFactor: 1,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 7,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _TabButton(
                          label: 'Direktori',
                          icon: Icons.explore_outlined,
                          selectedIcon: Icons.explore,
                          selected: _tab == 0,
                          onTap: () => _selectTab(0),
                        ),
                      ),
                      SizedBox(
                        width: 84,
                        child: Center(
                          heightFactor: 1,
                          child: IconButton.filled(
                            onPressed: _addSpot,
                            tooltip: 'Tambah rekomendasi',
                            icon: const Icon(Icons.add_rounded, size: 28),
                            style: IconButton.styleFrom(
                              minimumSize: const Size(49, 49),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: _TabButton(
                          label: 'Profil',
                          icon: Icons.person_outline_rounded,
                          selectedIcon: Icons.person_rounded,
                          selected: _tab == 1,
                          onTap: () => _selectTab(1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.blue : AppColors.muted;
    return Semantics(
      selected: selected,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(
                  horizontal: 17,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: selected ? AppColors.paleBlue : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  selected ? selectedIcon : icon,
                  color: color,
                  size: 22,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
