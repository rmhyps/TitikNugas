import 'dart:ui' as ui;

import 'package:flutter/foundation.dart' show Uint8List, listEquals;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../spot.dart';
import '../widgets/ui.dart';

class AddSpotScreen extends StatefulWidget {
  const AddSpotScreen({super.key, required this.contributor});

  final String contributor;

  @override
  State<AddSpotScreen> createState() => _AddSpotScreenState();
}

class _AddSpotScreenState extends State<AddSpotScreen> {
  static const _maxPhotoBytes = 5 * 1024 * 1024;

  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _address = TextEditingController();
  final _hours = TextEditingController();
  final _facilities = TextEditingController();
  final _note = TextEditingController();
  Price? _price;
  final _cover = GlobalKey<FormFieldState<Uint8List>>();
  String? _photoError;
  bool _pickingPhoto = false;

  @override
  void dispose() {
    _name.dispose();
    _address.dispose();
    _hours.dispose();
    _facilities.dispose();
    _note.dispose();
    super.dispose();
  }

  bool _isJpegOrPng(Uint8List bytes) {
    const pngHeader = [137, 80, 78, 71, 13, 10, 26, 10];
    if (bytes.length < pngHeader.length) return false;
    final isJpeg = bytes[0] == 255 && bytes[1] == 216 && bytes[2] == 255;
    final isPng = listEquals(bytes.sublist(0, pngHeader.length), pngHeader);
    return isJpeg || isPng;
  }

  Future<void> _pickPhoto(FormFieldState<Uint8List> field) async {
    setState(() {
      _pickingPhoto = true;
      _photoError = null;
    });
    try {
      final file = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        requestFullMetadata: false,
      );
      if (file == null || !mounted) return;
      if (await file.length() > _maxPhotoBytes) {
        if (mounted) setState(() => _photoError = 'Ukuran foto maksimal 5 MB.');
        return;
      }
      final bytes = await file.readAsBytes();
      if (!_isJpegOrPng(bytes)) {
        if (mounted) setState(() => _photoError = 'Pilih foto JPG atau PNG.');
        return;
      }
      final codec = await ui.instantiateImageCodec(bytes, targetWidth: 920);
      try {
        final frame = await codec.getNextFrame();
        frame.image.dispose();
      } finally {
        codec.dispose();
      }
      if (!mounted) return;
      field.didChange(bytes);
    } on PlatformException {
      if (mounted) {
        setState(() => _photoError = 'Galeri belum bisa dibuka. Coba lagi.');
      }
    } on Exception {
      if (mounted) {
        setState(() => _photoError = 'Foto gagal dibaca. Pilih foto lain.');
      }
    } finally {
      if (mounted) setState(() => _pickingPhoto = false);
    }
  }

  String? _required(String? value) {
    return (value ?? '').trim().isEmpty ? 'Kolom ini wajib diisi.' : null;
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    final invalid = _form.currentState!.validateGranularly();
    if (invalid.isNotEmpty) {
      Scrollable.ensureVisible(
        invalid.first.context,
        alignment: 0.12,
        duration: const Duration(milliseconds: 220),
      );
      return;
    }

    final facilities = _facilities.text
        .split(',')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toSet()
        .toList(growable: false);
    Navigator.of(context).pop(
      Spot(
        name: _name.text.trim(),
        address: _address.text.trim(),
        price: _price!,
        hours: _hours.text.trim(),
        facilities: facilities,
        note: _note.text.trim(),
        contributor: widget.contributor.trim(),
        coverBytes: _cover.currentState!.value,
        isOwn: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah rekomendasi')),
      body: SafeArea(
        top: false,
        child: PageWidth(
          child: Form(
            key: _form,
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.fromLTRB(pageInset, 19, pageInset, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const InfoNote(
                    text: 'Rekomendasi tersedia selama aplikasi terbuka.',
                  ),
                  const SizedBox(height: 19),
                  TextFormField(
                    controller: _name,
                    validator: _required,
                    maxLength: 80,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Nama tempat / kafe *',
                      hintText: 'Contoh: Kopi Sela Kampus',
                      counterText: '',
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _address,
                    validator: _required,
                    maxLength: 180,
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Alamat / patokan lokasi *',
                      hintText: 'Contoh: Jalan Selatan Kampus',
                      counterText: '',
                    ),
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<Price>(
                    initialValue: _price,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'Rentang harga *',
                    ),
                    items: [
                      for (final price in Price.values)
                        DropdownMenuItem(
                          value: price,
                          child: Text('${price.label} (${price.shortLabel})'),
                        ),
                    ],
                    onChanged: (value) => _price = value,
                    validator: (value) =>
                        value == null ? 'Pilih rentang harga.' : null,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _hours,
                    maxLength: 70,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Jam operasional',
                      hintText: 'Contoh: 09.00–22.00',
                      counterText: '',
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _facilities,
                    maxLength: 220,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Fasilitas tersedia',
                      hintText: 'Contoh: Wi-Fi, Colokan, AC',
                      helperText: 'Pisahkan fasilitas dengan koma.',
                      counterText: '',
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text('Foto sampul *', style: sectionTitle),
                  const SizedBox(height: 8),
                  FormField<Uint8List>(
                    key: _cover,
                    validator: (value) =>
                        value == null ? 'Pilih foto sampul.' : null,
                    builder: (field) {
                      final photo = field.value;
                      final error = _photoError ?? field.errorText;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (photo != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Image.memory(
                                photo,
                                height: 152,
                                fit: BoxFit.cover,
                                cacheWidth: 840,
                                semanticLabel: 'Pratinjau foto sampul',
                              ),
                            ),
                          OutlinedButton.icon(
                            onPressed: _pickingPhoto
                                ? null
                                : () => _pickPhoto(field),
                            icon: const Icon(Icons.photo_library_outlined),
                            label: Text(
                              photo == null
                                  ? 'Pilih dari galeri'
                                  : 'Ganti foto',
                            ),
                          ),
                          Text(
                            error ?? 'JPG atau PNG, maksimal 5 MB',
                            style: TextStyle(
                              fontSize: 12,
                              color: error == null
                                  ? AppColors.muted
                                  : Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 18),
                  TextFormField(
                    controller: _note,
                    maxLength: 500,
                    minLines: 3,
                    maxLines: 5,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      labelText: 'Catatan suasana belajar',
                      hintText:
                          'Ceritakan suasana, kenyamanan, atau tips memilih tempat duduk.',
                      alignLabelWithHint: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: _pickingPhoto ? null : _submit,
                    child: const Text('Simpan rekomendasi'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
