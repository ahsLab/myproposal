// FirmaView icin tam guncel hali (firma_view.dart)

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/firma.dart';
import '../viewmodels/firma_viewmodel.dart';
import '../services/local_file_service.dart';

class FirmaView extends StatefulWidget {
  const FirmaView({super.key});

  @override
  State<FirmaView> createState() => _FirmaViewState();
}

class _FirmaViewState extends State<FirmaView> {
  final TextEditingController _isimController = TextEditingController();
  final TextEditingController _adresController = TextEditingController();
  final TextEditingController _telefonController = TextEditingController();

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Veriler artık current user ID'si set edildiğinde otomatik olarak yüklenecek
  }

  void _showFirmaDialog({Firma? firma}) {
    if (firma != null) {
      _isimController.text = firma.isim;
      _adresController.text = firma.adres ?? '';
      _telefonController.text = firma.telefon ?? '';
    } else {
      _isimController.clear();
      _adresController.clear();
      _telefonController.clear();
      _selectedImage = null;
    }

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(firma == null ? 'Yeni Firma' : 'Firma Güncelle'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: _isimController, decoration: const InputDecoration(labelText: 'Firma Adı')),
                TextField(controller: _adresController, decoration: const InputDecoration(labelText: 'Adres')),
                TextField(controller: _telefonController, decoration: const InputDecoration(labelText: 'Telefon')),
                const SizedBox(height: 10),
                TextButton.icon(
                  icon: const Icon(Icons.image),
                  label: const Text("Logo Seç"),
                  onPressed: () async {
                    final picked = await _picker.pickImage(source: ImageSource.gallery);
                    if (picked != null) {
                      setState(() {
                        _selectedImage = File(picked.path);
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('İptal')),
            ElevatedButton(
              onPressed: () async {
                final viewModel = Provider.of<FirmaViewModel>(context, listen: false);
                final String id = firma?.id ?? const Uuid().v4();
                String? logoPath;

                if (_selectedImage != null) {
                  logoPath = await LocalFileService().saveFirmaLogo(_selectedImage!, id);
                } else {
                  logoPath = firma?.logoUrl;
                }

                final yeniFirma = Firma(
                  id: id,
                  isim: _isimController.text,
                  adres: _adresController.text,
                  telefon: _telefonController.text,
                  logoUrl: logoPath,
                );

                if (firma == null) {
                  await viewModel.addFirma(yeniFirma.isim, yeniFirma.adres, yeniFirma.telefon, yeniFirma.logoUrl);
                } else {
                  await viewModel.updateFirma(yeniFirma);
                }
                Navigator.pop(context);
              },
              child: const Text('Kaydet'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final firmalar = Provider.of<FirmaViewModel>(context).firmalar;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Firmalar"),
      ),
      body: ListView.builder(
        itemCount: firmalar.length,
        itemBuilder: (context, index) {
          final firma = firmalar[index];
          return ListTile(
            title: Text(firma.isim),
            subtitle: Text("${firma.adres ?? '-'} • ${firma.telefon ?? '-'}"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(icon: const Icon(Icons.edit), onPressed: () => _showFirmaDialog(firma: firma)),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => Provider.of<FirmaViewModel>(context, listen: false).deleteFirma(firma.id),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFirmaDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}