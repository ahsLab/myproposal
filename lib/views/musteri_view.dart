import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/musteri_viewmodel.dart';
import '../models/musteri.dart';

class MusteriView extends StatefulWidget {
  const MusteriView({super.key});

  @override
  State<MusteriView> createState() => _MusteriViewState();
}

class _MusteriViewState extends State<MusteriView> {
  final _adController = TextEditingController();
  final _soyadController = TextEditingController();
  final _adresController = TextEditingController();
  final _telefonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Veriler artık current user ID'si set edildiğinde otomatik olarak yüklenecek
  }

  void _showMusteriDialog({Musteri? musteri}) {
    if (musteri != null) {
      _adController.text = musteri.ad;
      _soyadController.text = musteri.soyad;
      _adresController.text = musteri.adres ?? '';
      _telefonController.text = musteri.telefon ?? '';
    } else {
      _adController.clear();
      _soyadController.clear();
      _adresController.clear();
      _telefonController.clear();
    }

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(musteri == null ? 'Yeni Müşteri' : 'Müşteri Güncelle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: _adController, decoration: const InputDecoration(labelText: 'Ad')),
              TextField(controller: _soyadController, decoration: const InputDecoration(labelText: 'Soyad')),
              TextField(controller: _adresController, decoration: const InputDecoration(labelText: 'Adres')),
              TextField(controller: _telefonController, decoration: const InputDecoration(labelText: 'Telefon')),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('İptal')),
            ElevatedButton(
              onPressed: () {
                final viewModel = Provider.of<MusteriViewModel>(context, listen: false);
                if (musteri == null) {
                  viewModel.addMusteri(
                    _adController.text,
                    _soyadController.text,
                    _adresController.text,
                    _telefonController.text,
                  );
                } else {
                  final updated = Musteri(
                    id: musteri.id,
                    ad: _adController.text,
                    soyad: _soyadController.text,
                    adres: _adresController.text,
                    telefon: _telefonController.text,
                  );
                  viewModel.updateMusteri(updated);
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
    final musteriler = Provider.of<MusteriViewModel>(context).musteriler;

    return Scaffold(
      appBar: AppBar(title: const Text('Müşteriler')),
      body: ListView.builder(
        itemCount: musteriler.length,
        itemBuilder: (context, index) {
          final m = musteriler[index];
          return ListTile(
            title: Text("${m.ad} ${m.soyad}"),
            subtitle: Text("${m.adres ?? '-'} • ${m.telefon ?? '-'}"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(icon: const Icon(Icons.edit), onPressed: () => _showMusteriDialog(musteri: m)),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => Provider.of<MusteriViewModel>(context, listen: false).deleteMusteri(m.id),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showMusteriDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
