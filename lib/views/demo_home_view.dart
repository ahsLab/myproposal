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
        title: Text(
          LocalizationHelper.getString(context, 'demoMode'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orange.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.orange.shade600, Colors.orange.shade50],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Demo modu bilgi kartı
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.orange, size: 32),
                    const SizedBox(height: 12),
                    Text(
                      LocalizationHelper.getString(context, 'demoMode'),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      LocalizationHelper.getString(context, 'demoModeDescription'),
                      style: const TextStyle(fontSize: 16, height: 1.4),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Ana işlemler container
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Demo İşlemler',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange.shade600,
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Firma Yönetimi
                    _buildDemoButton(
                      context,
                      Icons.business,
                      LocalizationHelper.getString(context, 'demoCompanyManagement'),
                      Colors.blue.shade600,
                      () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DemoFirmaView())),
                    ),
                    const SizedBox(height: 12),
                    
                    // Müşteri Yönetimi
                    _buildDemoButton(
                      context,
                      Icons.people,
                      LocalizationHelper.getString(context, 'demoCustomerManagement'),
                      Colors.green.shade600,
                      () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DemoMusteriView())),
                    ),
                    const SizedBox(height: 12),
                    
                    // Teklif Oluştur
                    _buildDemoButton(
                      context,
                      Icons.description,
                      LocalizationHelper.getString(context, 'demoCreateProposal'),
                      Colors.purple.shade600,
                      () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DemoTeklifView())),
                    ),
                    const SizedBox(height: 12),
                    
                    // Geçmiş Teklifler
                    _buildDemoButton(
                      context,
                      Icons.history,
                      LocalizationHelper.getString(context, 'demoProposalHistory'),
                      Colors.orange.shade600,
                      () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DemoTeklifListView())),
                    ),
                  ],
                ),
              ),
              
              const Spacer(),
              
              // Tam özellikler için giriş butonu
              Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade400, Colors.blue.shade600],
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const AuthWrapper()),
                    );
                  },
                  icon: const Icon(Icons.login, color: Colors.white, size: 24),
                  label: Text(
                    LocalizationHelper.getString(context, 'fullFeaturesLogin'),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDemoButton(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
    VoidCallback onPressed,
  ) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.8)],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white, size: 24),
        label: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
