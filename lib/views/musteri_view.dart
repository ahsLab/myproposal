import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/musteri_viewmodel.dart';
import '../models/musteri.dart';
import '../utils/localization_helper.dart';

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
          title: Text(musteri == null ? LocalizationHelper.getString(context, 'addCustomer') : LocalizationHelper.getString(context, 'edit')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: _adController, decoration: InputDecoration(labelText: LocalizationHelper.getString(context, 'customerName'))),
              TextField(controller: _soyadController, decoration: InputDecoration(labelText: LocalizationHelper.getString(context, 'customerName'))),
              TextField(controller: _adresController, decoration: InputDecoration(labelText: LocalizationHelper.getString(context, 'customerAddress'))),
              TextField(controller: _telefonController, decoration: InputDecoration(labelText: LocalizationHelper.getString(context, 'customerPhone'))),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text(LocalizationHelper.getString(context, 'cancel'))),
            ElevatedButton(
              onPressed: () {
                final viewModel = Provider.of<MusteriViewModel>(context, listen: false);
                if (musteri == null) {
                  viewModel.addMusteri(
                    LocalizationHelper.capitalizeWords(_adController.text),
                    LocalizationHelper.capitalizeWords(_soyadController.text),
                    LocalizationHelper.capitalizeWords(_adresController.text),
                    _telefonController.text,
                  );
                } else {
                  final updated = Musteri(
                    id: musteri.id,
                    ad: LocalizationHelper.capitalizeWords(_adController.text),
                    soyad: LocalizationHelper.capitalizeWords(_soyadController.text),
                    adres: LocalizationHelper.capitalizeWords(_adresController.text),
                    telefon: _telefonController.text,
                  );
                  viewModel.updateMusteri(updated);
                }
                Navigator.pop(context);
              },
              child: Text(LocalizationHelper.getString(context, 'save')),
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
      appBar: AppBar(title: Text(LocalizationHelper.getString(context, 'customerManagement'))),
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
