import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/language_service.dart';
import '../utils/localization_helper.dart';
import '../widgets/feedback_dialog.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  Future<void> _showDeleteAccountDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(LocalizationHelper.getString(context, 'deleteAccount')),
          content: Text(
            LocalizationHelper.getString(context, 'deleteAccountConfirmation'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(LocalizationHelper.getString(context, 'cancel')),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _deleteAccount(context);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text(LocalizationHelper.getString(context, 'deleteAccount')),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAccount(BuildContext context) async {
    // Loading göster
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final authService = AuthService();
    final success = await authService.deleteAccount();

    if (!context.mounted) return;
    
    // Loading'i kapat
    Navigator.of(context).pop();

    if (success) {
      // Ana sayfaya yönlendir
      Navigator.of(context).popUntil((route) => route.isFirst);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(LocalizationHelper.getString(context, 'accountDeleted'))),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(LocalizationHelper.getString(context, 'accountDeleteError')),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: Text(LocalizationHelper.getString(context, 'profileSettings'))),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${LocalizationHelper.getString(context, 'email')}: ${user?.email ?? '-'}", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: Text(LocalizationHelper.getString(context, 'logout')),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _showDeleteAccountDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: Text(LocalizationHelper.getString(context, 'deleteAccount')),
              ),
            ),
          
            Text(LocalizationHelper.getString(context, 'languageSettings'), style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 6),
            Consumer<LanguageService>(
              builder: (context, languageService, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocalizationHelper.getString(context, 'defaultLanguage'),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  
                    Text(
                      LocalizationHelper.getString(context, 'defaultPdfLanguage'),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    ...languageService.getLanguageOptions().map((entry) => 
                      RadioListTile<String>(
                        title: Text(entry.value),
                        value: entry.key,
                        groupValue: languageService.pdfLocale.languageCode,
                        onChanged: (value) async {
                          if (value != null) {
                            await languageService.setPdfLanguage(value);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(LocalizationHelper.getString(context, 'pdfLanguageChanged'))),
                              );
                            }
                          }
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
            const Divider(height: 40),
            Text(LocalizationHelper.getString(context, 'suggestions'), style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => const FeedbackDialog(),
                  );
                },
                icon: const Icon(Icons.feedback),
                label: Text(LocalizationHelper.getString(context, 'contactUs')),
                style: ElevatedButton.styleFrom(
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
