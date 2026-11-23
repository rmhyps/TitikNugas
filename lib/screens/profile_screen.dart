import 'package:flutter/material.dart';

import '../spot.dart';
import '../widgets/ui.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.profile, required this.onSave});

  final ContributorProfile profile;
  final ValueChanged<ContributorProfile> onSave;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _form = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.profile.name);
  late final _program = TextEditingController(
    text: widget.profile.studyProgram,
  );

  @override
  void dispose() {
    _name.dispose();
    _program.dispose();
    super.dispose();
  }

  void _save() {
    if (_form.currentState?.validate() != true) return;
    FocusScope.of(context).unfocus();
    widget.onSave(
      ContributorProfile(
        name: _name.text.trim(),
        studyProgram: _program.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = widget.profile;
    return PageWidth(
      child: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(pageInset, 23, pageInset, 24),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            const Text(
              'Profil',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 17),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppColors.line),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 31,
                    backgroundColor: AppColors.paleBlue,
                    foregroundColor: AppColors.blue,
                    child: profile.initials.isEmpty
                        ? const Icon(Icons.person_outline_rounded, size: 30)
                        : Text(
                            profile.initials,
                            style: const TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                  ),
                  const SizedBox(height: 11),
                  Text(
                    profile.name.isEmpty ? 'Kontributor lokal' : profile.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (profile.studyProgram.isNotEmpty) ...[
                    const SizedBox(height: 5),
                    Text(
                      profile.studyProgram,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.muted),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 18),
            TextFormField(
              controller: _name,
              maxLength: 60,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Nama kontributor',
                hintText: 'Nama yang tampil di rekomendasi',
                counterText: '',
              ),
              validator: (value) =>
                  (value ?? '').trim().isEmpty ? 'Isi nama kontributor.' : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _program,
              maxLength: 100,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _save(),
              decoration: const InputDecoration(
                labelText: 'Program studi / fakultas',
                hintText: 'Contoh: S1 Informatika',
                counterText: '',
              ),
            ),
            const SizedBox(height: 18),
            FilledButton(
              onPressed: _save,
              child: const Text('Perbarui profil'),
            ),
            const SizedBox(height: 14),
            const InfoNote(
              text:
                  'Profil berlaku selama aplikasi terbuka. Rekomendasi bisa ditambahkan tanpa akun.',
            ),
          ],
        ),
      ),
    );
  }
}
