// teklif_list_view.dart (firma/müşteri filtreleme + pdf açma/paylaşma dahil)

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

import '../viewmodels/teklif_viewmodel.dart';
import '../viewmodels/firma_viewmodel.dart';
import '../viewmodels/musteri_viewmodel.dart';
import '../models/firma.dart';
import '../models/musteri.dart';
import '../models/teklif.dart';
import '../utils/pdf_saver.dart';

class TeklifListView extends StatefulWidget {
  const TeklifListView({super.key});

  @override
  State<TeklifListView> createState() => _TeklifListViewState();
}

class _TeklifListViewState extends State<TeklifListView> {
  Firma? _filterFirma;
  Musteri? _filterMusteri;

  @override
  void initState() {
    super.initState();
    // Veriler artık current user ID'si set edildiğinde otomatik olarak yüklenecek
  }

  Future<File> _createPdfFromTeklif(Teklif teklif, List<Firma> firmaList, List<Musteri> musteriList) async {
    final pdf = pw.Document();
    final firma = firmaList.firstWhere((f) => f.id == teklif.firmaId);
    final musteri = musteriList.firstWhere((m) => m.id == teklif.musteriId);

    pw.Widget? logoWidget;
    if (firma.logoUrl != null && firma.logoUrl!.isNotEmpty) {
      try {
        final logoFile = File(firma.logoUrl!);
        if (await logoFile.exists()) {
          final imageBytes = await logoFile.readAsBytes();
          logoWidget = pw.Image(pw.MemoryImage(imageBytes), width: 60, height: 60);
        }
      } catch (e) {
        print('Logo yükleme hatası: $e');
      }
    }

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                if (logoWidget != null) logoWidget,
                pw.SizedBox(width: 20),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(firma.isim, style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                    if (firma.adres != null) pw.Text(firma.adres!),
                    if (firma.telefon != null) pw.Text("Tel: ${firma.telefon}"),
                  ],
                )
              ],
            ),
            pw.SizedBox(height: 20),
            // Tarih sağ üstte
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Expanded(child: pw.Container()),
                pw.Text(
                  'Date: ${DateFormat('dd.MM.yyyy').format(teklif.tarih)}',
                  style: pw.TextStyle(fontSize: 12),
                ),
              ],
            ),
            pw.SizedBox(height: 10),
            // Proposal ortalanmış başlık
            pw.Center(
              child: pw.Text(
                'PROPOSAL',
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.SizedBox(height: 10),
            pw.Text("Customer: ${musteri.ad} ${musteri.soyad}"),
            pw.SizedBox(height: 20),
            pw.Table.fromTextArray(
              headers: ['Item', 'Quantity', 'Unit Price', 'Total'],
              data: teklif.satirlar
                  .map((e) => [e.islemAdi, e.adet.toString(), e.birimFiyat.toStringAsFixed(2), e.toplam.toStringAsFixed(2)])
                  .toList(),
            ),
            pw.SizedBox(height: 10),
            pw.Text("Subtotal: \$${teklif.toplam.toStringAsFixed(2)}"),
            if (teklif.indirim != null)
              pw.Text("Discount: \$${teklif.indirim!.toStringAsFixed(2)}"),
            if (teklif.not != null)
              pw.Text("Note: ${teklif.not!}"),
          ],
        ),
      ),
    );

    final bytes = await pdf.save();
    final filename = "teklif_${teklif.id.substring(0, 6)}.pdf";
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes);
    return file;
  }

  Future<void> _openPdf(Teklif teklif) async {
    final filename = 'teklif_${teklif.id.substring(0, 6)}.pdf';
    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/$filename';
    final file = File(path);

    if (await file.exists()) {
      await OpenFile.open(file.path);
    } else {
      // PDF dosyası bulunamadı, yeniden oluştur
      if (!context.mounted) return;
      
      // Loading göster
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      try {
        final firmaList = Provider.of<FirmaViewModel>(context, listen: false).firmalar;
        final musteriList = Provider.of<MusteriViewModel>(context, listen: false).musteriler;
        
        final newFile = await _createPdfFromTeklif(teklif, firmaList, musteriList);
        
        if (!context.mounted) return;
        Navigator.of(context).pop(); // Loading'i kapat
        
        await OpenFile.open(newFile.path);
      } catch (e) {
        if (!context.mounted) return;
        Navigator.of(context).pop(); // Loading'i kapat
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("PDF oluşturulurken hata: $e")),
        );
      }
    }
  }

  Future<void> _sharePdf(Teklif teklif) async {
    final filename = 'teklif_${teklif.id.substring(0, 6)}.pdf';
    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/$filename';
    final file = File(path);

    if (await file.exists()) {
      await Share.shareXFiles([XFile(file.path)], text: 'Teklif PDF');
    } else {
      // PDF dosyası bulunamadı, yeniden oluştur
      if (!context.mounted) return;
      
      // Loading göster
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      try {
        final firmaList = Provider.of<FirmaViewModel>(context, listen: false).firmalar;
        final musteriList = Provider.of<MusteriViewModel>(context, listen: false).musteriler;
        
        final newFile = await _createPdfFromTeklif(teklif, firmaList, musteriList);
        
        if (!context.mounted) return;
        Navigator.of(context).pop(); // Loading'i kapat
        
        await Share.shareXFiles([XFile(newFile.path)], text: 'Teklif PDF');
      } catch (e) {
        if (!context.mounted) return;
        Navigator.of(context).pop(); // Loading'i kapat
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("PDF oluşturulurken hata: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final teklifler = Provider.of<TeklifViewModel>(context).teklifler;
    final firmaList = Provider.of<FirmaViewModel>(context).firmalar;
    final musteriList = Provider.of<MusteriViewModel>(context).musteriler;

    final filtered = teklifler.where((t) {
      final firmaMatch = _filterFirma == null || t.firmaId == _filterFirma!.id;
      final musteriMatch = _filterMusteri == null || t.musteriId == _filterMusteri!.id;
      return firmaMatch && musteriMatch;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Geçmiş Teklifler")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                DropdownButton<Firma>(
                  value: _filterFirma,
                  hint: const Text("Firma Filtrele"),
                  isExpanded: true,
                  items: firmaList.map((f) => DropdownMenuItem(value: f, child: Text(f.isim))).toList(),
                  onChanged: (value) => setState(() => _filterFirma = value),
                ),
                DropdownButton<Musteri>(
                  value: _filterMusteri,
                  hint: const Text("Müşteri Filtrele"),
                  isExpanded: true,
                  items: musteriList.map((m) => DropdownMenuItem(value: m, child: Text("${m.ad} ${m.soyad}"))).toList(),
                  onChanged: (value) => setState(() => _filterMusteri = value),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final teklif = filtered[index];
                final tarih = DateFormat('yyyy-MM-dd').format(teklif.tarih);
                
                // Müşteri bilgisini bul
                final musteri = musteriList.firstWhere(
                  (m) => m.id == teklif.musteriId,
                  orElse: () => Musteri(id: '', ad: 'Bilinmeyen', soyad: 'Müşteri', telefon: ''),
                );
                
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: const Icon(Icons.picture_as_pdf),
                    title: Text("Teklif #${teklif.id.substring(0, 6)}"),
                    subtitle: Text("Tarih: $tarih\nMüşteri: ${musteri.ad} ${musteri.soyad}\nToplam: \$${teklif.toplam.toStringAsFixed(2)}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(icon: const Icon(Icons.open_in_new), onPressed: () => _openPdf(teklif)),
                        IconButton(icon: const Icon(Icons.share), onPressed: () => _sharePdf(teklif)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
