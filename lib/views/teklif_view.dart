// lib/views/teklif_view.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import '../models/teklif.dart';
import '../models/firma.dart';
import '../models/musteri.dart';
import '../viewmodels/teklif_viewmodel.dart';
import '../viewmodels/firma_viewmodel.dart';
import '../viewmodels/musteri_viewmodel.dart';
import '../utils/pdf_saver.dart';
import '../utils/localization_helper.dart';

class TeklifView extends StatefulWidget {
  const TeklifView({super.key});

  @override
  State<TeklifView> createState() => _TeklifViewState();
}

class _TeklifViewState extends State<TeklifView> {
  Firma? _selectedFirma;
  Musteri? _selectedMusteri;
  final _islemController = TextEditingController();
  final _adetController = TextEditingController();
  final _fiyatController = TextEditingController();
  final _indirimController = TextEditingController();
  final _notController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<FirmaViewModel>(context, listen: false).loadFirmalar();
    Provider.of<MusteriViewModel>(context, listen: false).loadMusteriler();
    Provider.of<TeklifViewModel>(context, listen: false).clearSatirlar();
  }

  @override
  void dispose() {
    _islemController.dispose();
    _adetController.dispose();
    _fiyatController.dispose();
    _indirimController.dispose();
    _notController.dispose();
    super.dispose();
  }

  void _addSatir() {
    final islemAdi = _islemController.text.trim();
    if (islemAdi.isEmpty) return;
    final adet = int.tryParse(_adetController.text) ?? 1;
    final fiyat = double.tryParse(_fiyatController.text) ?? 0;

    Provider.of<TeklifViewModel>(context, listen: false)
        .addSatir(LocalizationHelper.capitalizeWords(islemAdi), adet, fiyat);

    _islemController.clear();
    _adetController.clear();
    _fiyatController.clear();
  }

  Future<pw.Widget?> _buildLogoWidget(String? logoPath) async {
    if (logoPath == null || logoPath.isEmpty) return null;
    try {
      final file = File(logoPath);
      if (!await file.exists()) return null;
      final bytes = await file.readAsBytes();
      final mem = pw.MemoryImage(bytes);
      return pw.Container(
        width: 64,
        height: 64,
        child: pw.FittedBox(
          fit: pw.BoxFit.contain,
          child: pw.Image(mem),
        ),
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> _createPdf(Teklif teklif) async {
    final pdf = pw.Document();
    final firma = _selectedFirma;
    final musteri = _selectedMusteri;

    final pageTheme = pw.PageTheme(
      pageFormat: PdfPageFormat.a4, // TAM SAYFA A4
      margin: const pw.EdgeInsets.symmetric(horizontal: 32, vertical: 36),
      theme: pw.ThemeData.withFont( // default fontlar
        base: await PdfGoogleFonts.nunitoRegular(),
        bold: await PdfGoogleFonts.nunitoBold(),
      ),
    );

    final logoWidget = await _buildLogoWidget(firma?.logoUrl);

    // Başlık ve firma/müşteri bloklarını düzenli yerleşimle verelim
    pdf.addPage(
      pw.MultiPage(
        pageTheme: pageTheme,
        build: (context) => [
          // Üst Başlık
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              if (logoWidget != null) logoWidget,
              if (logoWidget != null) pw.SizedBox(width: 16),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    if (firma != null) ...[
                      pw.Text(
                        firma.isim,
                        style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
                      ),
                      if (firma.adres != null && firma.adres!.trim().isNotEmpty)
                        pw.Text(firma.adres!),
                      if (firma.telefon != null && firma.telefon!.trim().isNotEmpty)
                        pw.Text('Tel: ${firma.telefon}'),
                    ],
                  ],
                ),
              ),
              // Tarih sağ tarafa
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text(
                    'Date: ${DateFormat('dd.MM.yyyy').format(teklif.tarih)}',
                    style: const pw.TextStyle(fontSize: 11),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    'Proposal No: ${teklif.id.substring(0, 6).toUpperCase()}',
                    style: const pw.TextStyle(fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 18),

          // Orta Başlık
          pw.Center(
            child: pw.Text(
              'PROPOSAL',
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.SizedBox(height: 12),

          // Müşteri bilgisi
          if (musteri != null) ...[
            pw.Container(
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey500, width: 0.5),
                borderRadius: pw.BorderRadius.circular(6),
              ),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Customer',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text('${musteri.ad} ${musteri.soyad}'),
                        if ((musteri.adres ?? '').trim().isNotEmpty)
                          pw.Text(musteri.adres!),
                        if ((musteri.telefon ?? '').trim().isNotEmpty)
                          pw.Text('Tel: ${musteri.telefon}'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 16),
          ],

          // Kalemler Tablosu
          _buildItemsTable(teklif),

          // Ara toplam / indirim / toplam
          pw.SizedBox(height: 12),
          _buildTotalsBlock(teklif),

          // Notlar
          if ((teklif.not ?? '').trim().isNotEmpty) ...[
            pw.SizedBox(height: 16),
            pw.Text('Notes', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 6),
            pw.Text(teklif.not!),
          ],
        ],
        footer: (context) => pw.Container(
          alignment: pw.Alignment.centerRight,
          child: pw.Text(
            'Page ${context.pageNumber} of ${context.pagesCount}',
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
          ),
        ),
      ),
    );

    final bytes = await pdf.save();
    final filename = 'teklif_${teklif.id.substring(0, 6)}.pdf';
    await PdfSaver.saveAndOpenPdf(bytes, filename);
  }

  pw.Widget _buildItemsTable(Teklif teklif) {
    final headers = ['Item', 'Quantity', 'Unit Price', 'Total'];
    final data = teklif.satirlar.map((e) {
      return [
        e.islemAdi,
        e.adet.toString(),
        e.birimFiyat.toStringAsFixed(2),
        e.toplam.toStringAsFixed(2),
      ];
    }).toList();

    return pw.TableHelper.fromTextArray(
      headers: headers,
      data: data,
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.blueGrey700),
      cellStyle: const pw.TextStyle(fontSize: 11),
      cellAlignment: pw.Alignment.centerLeft,
      headerAlignment: pw.Alignment.centerLeft,
      rowDecoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(color: PdfColors.grey400, width: 0.3),
        ),
      ),
      cellPadding: const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      headerPadding: const pw.EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      columnWidths: {
        0: const pw.FlexColumnWidth(3),
        1: const pw.FlexColumnWidth(1.1),
        2: const pw.FlexColumnWidth(1.4),
        3: const pw.FlexColumnWidth(1.4),
      },
    );
  }

  pw.Widget _buildTotalsBlock(Teklif teklif) {
    final currencyFmt = NumberFormat.currency(locale: 'en_US', symbol: '\$');

    final subtotal = teklif.toplam;
    final discount = teklif.indirim ?? 0;
    final grandTotal = (subtotal - discount).clamp(0, double.infinity);

    pw.Text _label(String t) =>
        pw.Text(t, style: pw.TextStyle(color: PdfColors.grey800));
    pw.Text _value(String t, {bool bold = false}) => pw.Text(
      t,
      style: pw.TextStyle(
        fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
      ),
    );

    return pw.Align(
      alignment: pw.Alignment.centerRight,
      child: pw.Container(
        width: 260,
        padding: const pw.EdgeInsets.all(10),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: PdfColors.grey500, width: 0.5),
          borderRadius: pw.BorderRadius.circular(6),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                _label('Subtotal'),
                _value(currencyFmt.format(subtotal)),
              ],
            ),
            if (discount > 0) ...[
              pw.SizedBox(height: 6),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  _label('Discount'),
                  _value('- ${currencyFmt.format(discount)}'),
                ],
              ),
            ],
            pw.Divider(color: PdfColors.grey500, height: 14, thickness: 0.5),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('TOTAL', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                _value(currencyFmt.format(grandTotal), bold: true),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final teklifViewModel = Provider.of<TeklifViewModel>(context);
    final firmaList = Provider.of<FirmaViewModel>(context).firmalar;
    final musteriList = Provider.of<MusteriViewModel>(context).musteriler;

    return Scaffold(
      appBar: AppBar(title: Text(LocalizationHelper.getString(context, 'createProposal'))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButton<Firma>(
              value: _selectedFirma,
              hint: Text(LocalizationHelper.getString(context, 'companyName')),
              isExpanded: true,
              items: firmaList
                  .map((f) => DropdownMenuItem(value: f, child: Text(f.isim)))
                  .toList(),
              onChanged: (value) => setState(() => _selectedFirma = value),
            ),
            DropdownButton<Musteri>(
              value: _selectedMusteri,
              hint: Text(LocalizationHelper.getString(context, 'customerName')),
              isExpanded: true,
              items: musteriList
                  .map((m) => DropdownMenuItem(
                value: m,
                child: Text("${m.ad} ${m.soyad}"),
              ))
                  .toList(),
              onChanged: (value) => setState(() => _selectedMusteri = value),
            ),
            const Divider(height: 32),
            TextField(
              controller: _islemController,
              decoration: InputDecoration(labelText: LocalizationHelper.getString(context, 'itemDescription')),
            ),
            TextField(
              controller: _adetController,
              decoration: InputDecoration(labelText: LocalizationHelper.getString(context, 'quantity')),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _fiyatController,
              decoration: InputDecoration(labelText: LocalizationHelper.getString(context, 'unitPrice')),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
            ElevatedButton(onPressed: _addSatir, child: Text(LocalizationHelper.getString(context, 'add'))),
            const Divider(height: 32),
            ...teklifViewModel.satirlar.map(
                  (s) => ListTile(
                title: Text("${s.islemAdi} (${s.adet}x${s.birimFiyat})"),
                trailing: Text("\$${s.toplam.toStringAsFixed(2)}"),
              ),
            ),
            const Divider(),
            TextField(
              controller: _indirimController,
              decoration: const InputDecoration(labelText: "İndirim"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _notController,
              decoration: InputDecoration(labelText: LocalizationHelper.getString(context, 'notes')),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (_selectedFirma == null || _selectedMusteri == null) return;
                final teklif = Provider.of<TeklifViewModel>(context, listen: false)
                    .buildTeklif(
                  firmaId: _selectedFirma!.id,
                  musteriId: _selectedMusteri!.id,
                  indirim: double.tryParse(_indirimController.text),
                  not: _notController.text.trim().isEmpty
                      ? null
                      : LocalizationHelper.capitalizeWords(_notController.text.trim()),
                );

                await Provider.of<TeklifViewModel>(context, listen: false)
                    .saveTeklif(teklif);
                await _createPdf(teklif);

                if (!mounted) return;
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              },
              child: Text(LocalizationHelper.getString(context, 'generatePDF')),
            ),
          ],
        ),
      ),
    );
  }
}
