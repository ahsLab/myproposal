// demo_home_view.dart

import 'package:flutter/material.dart';
import 'demo_firma_view.dart';
import 'demo_musteri_view.dart';
import 'demo_teklif_view.dart';
import 'demo_teklif_list_view.dart';
import '../main.dart';
import '../utils/localization_helper.dart';

// AuthWrapper'ı main.dart'tan import etmek için
import '../main.dart';

class DemoHomeView extends StatelessWidget {
  const DemoHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocalizationHelper.getString(context, 'demoMode')),
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
              tooltip: LocalizationHelper.getString(context, 'login'),
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
              child: Column(
                children: [
                  const Icon(Icons.info_outline, color: Colors.orange, size: 24),
                  const SizedBox(height: 8),
                  Text(
                    LocalizationHelper.getString(context, 'demoMode'),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    LocalizationHelper.getString(context, 'demoModeDescription'),
                    style: const TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DemoFirmaView())),
              icon: const Icon(Icons.business),
              label: Text(LocalizationHelper.getString(context, 'demoCompanyManagement')),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DemoMusteriView())),
              icon: const Icon(Icons.people),
              label: Text(LocalizationHelper.getString(context, 'demoCustomerManagement')),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DemoTeklifView())),
              icon: const Icon(Icons.description),
              label: Text(LocalizationHelper.getString(context, 'demoCreateProposal')),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DemoTeklifListView())),
              icon: const Icon(Icons.history),
              label: Text(LocalizationHelper.getString(context, 'demoProposalHistory')),
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
                label: Text(LocalizationHelper.getString(context, 'fullFeaturesLogin')),
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
