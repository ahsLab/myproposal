// demo_home_view.dart

import 'package:flutter/material.dart';
import 'demo_firma_view.dart';
import 'demo_musteri_view.dart';
import 'demo_teklif_view.dart';
import 'demo_teklif_list_view.dart';
import '../main.dart';

// AuthWrapper'ı main.dart'tan import etmek için
import '../main.dart';

class DemoHomeView extends StatelessWidget {
  const DemoHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Demo Modu"),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        actions: [
                      IconButton(
              icon: const Icon(Icons.login),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const AuthWrapper()),
                );
              },
              tooltip: 'Giriş Yap',
            )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: const Column(
                children: [
                  Icon(Icons.info_outline, color: Colors.orange, size: 24),
                  SizedBox(height: 8),
                  Text(
                    'Demo Modu',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Bu modda oluşturduğunuz veriler sadece cihazınızda saklanır ve giriş yaptığınızda kaybolur.',
                    style: TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DemoFirmaView())),
              icon: const Icon(Icons.business),
              label: const Text("Firma Yönetimi (Demo)"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DemoMusteriView())),
              icon: const Icon(Icons.people),
              label: const Text("Müşteri Yönetimi (Demo)"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DemoTeklifView())),
              icon: const Icon(Icons.description),
              label: const Text("Teklif Oluştur (Demo)"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DemoTeklifListView())),
              icon: const Icon(Icons.history),
              label: const Text("Geçmiş Teklifler (Demo)"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const AuthWrapper()),
                  );
                },
                icon: const Icon(Icons.login),
                label: const Text("Tam Özellikler İçin Giriş Yap"),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
