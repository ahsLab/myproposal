// home_view.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/localization_helper.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'login_view.dart';
import 'firma_view.dart';
import 'musteri_view.dart';
import 'teklif_view.dart';
import 'teklif_list_view.dart';
import 'settings_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("MyProposal"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              auth.logout();
              // Logout sonrası AuthWrapper otomatik olarak LoginView'a yönlendirecek
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FirmaView())),
              child:  Text(LocalizationHelper.getString(context, 'companyManagement')),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MusteriView())),
              child:  Text(LocalizationHelper.getString(context, 'customerManagement')),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TeklifView())),
              child:  Text(LocalizationHelper.getString(context, 'createProposal')),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TeklifListView())),
              child:Text(LocalizationHelper.getString(context, 'proposalHistory')),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsView())),
              child:Text(LocalizationHelper.getString(context, 'profileSettings')),
            ),
          ],
        ),
      ),
    );
  }
}
